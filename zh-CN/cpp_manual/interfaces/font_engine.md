---
layout: page
title: 字体引擎接口
parent: cpp_manual/interfaces
grandparent: cpp_manual
next: text_input_handler
---

RmlUi 中使用的默认字体引擎提供了基于 FreeType 库的实现。对于想要使用自己的字体系统渲染文本的用户，可以构造自定义字体引擎接口来替换默认实现。在这种情况下，可以完全移除 FreeType 依赖，详情请参阅 [CMake 选项](../building_with_cmake.html#cmake-options) `RMLUI_FONT_ENGINE`。

字体引擎接口的一些最重要函数如下所示。

```cpp
// Called by RmlUi when it wants to load a font face from file.
// @param[in] file_name The file to load the face from.
// @param[in] face_index The index of the font face within a font collection.
// @param[in] fallback_face True to use this font face for unknown characters in other font faces.
// @param[in] weight The weight to load when the font face contains multiple weights, otherwise the weight to register the font as.
// @return True if the face was loaded successfully, false otherwise.
virtual bool LoadFontFace(const String& file_name, int face_index, bool fallback_face, Style::FontWeight weight);

// Called by RmlUi when it wants to load a font face from file, registered using the provided family, style, and weight.
// @param[in] file_name The file to load the face from.
// @param[in] face_index The index of the font face within a font collection.
// @param[in] family The family to register the font as.
// @param[in] style The style to register the font as.
// @param[in] weight The weight to load when the font face contains multiple weights, otherwise the weight to register the font as.
// @param[in] fallback_face True to use this font face for unknown characters in other font faces.
// @return True if the face was loaded successfully, false otherwise.
virtual bool LoadFontFace(const String& file_name, int face_index, const String& family, Style::FontStyle style, Style::FontWeight weight,
    bool fallback_face);

// Called by RmlUi when a font configuration is resolved for an element. Should return a handle that
// can later be used to resolve properties of the face, and generate string geometry to be rendered.
// @param[in] family The family of the desired font handle.
// @param[in] style The style of the desired font handle.
// @param[in] weight The weight of the desired font handle.
// @param[in] size The size of desired handle, in points.
// @return A valid handle if a matching (or closely matching) font face was found, NULL otherwise.
virtual FontFaceHandle GetFontFaceHandle(const String& family, Style::FontStyle style, Style::FontWeight weight, int size);

// Called by RmlUi when a list of font effects is resolved for an element with a given font face.
// @param[in] handle The font handle.
// @param[in] font_effects The list of font effects to generate the configuration for.
// @return A handle to the prepared font effects which will be used when generating geometry for a string.
virtual FontEffectsHandle PrepareFontEffects(FontFaceHandle handle, const FontEffectList& font_effects);

// Should return the font metrics of the given font face.
// @param[in] handle The font handle.
// @return The face's metrics.
virtual const FontMetrics& GetFontMetrics(FontFaceHandle handle);

// Called by RmlUi when it wants to retrieve the width of a string when rendered with this handle.
// @param[in] handle The font handle.
// @param[in] string The string to measure.
// @param[in] text_shaping_context Additional parameters that provide context for text shaping.
// @param[in] prior_character The optionally-specified character that immediately precedes the string. This may have an impact on the string
// width due to kerning.
// @return The width, in pixels, this string will occupy if rendered with this handle.
virtual int GetStringWidth(FontFaceHandle handle, StringView string, const TextShapingContext& text_shaping_context, Character prior_character = Character::Null);

// Called by RmlUi when it wants to retrieve the meshes required to render a single line of text.
// @param[in] render_manager The render manager responsible for rendering the string.
// @param[in] face_handle The font handle.
// @param[in] font_effects_handle The handle to the prepared font effects for which the geometry should be generated.
// @param[in] string The string to render.
// @param[in] position The position of the baseline of the first character to render.
// @param[in] colour The colour to render the text.
// @param[in] opacity The opacity of the text, should be applied to font effects.
// @param[in] text_shaping_context Additional parameters that provide context for text shaping.
// @param[out] mesh_list A list to place the meshes and textures representing the string to be rendered.
// @return The width, in pixels, of the string mesh.
virtual int GenerateString(RenderManager& render_manager, FontFaceHandle face_handle, FontEffectsHandle font_effects_handle, StringView string,
    Vector2f position, ColourbPremultiplied colour, float opacity, const TextShapingContext& text_shaping_context, TexturedMeshList& mesh_list);
```

当用户想要加载字体时，会调用 `LoadFontFace()` 函数，无论是一通过某个 `Rml::LoadFontFace()` 函数还是 RCSS [`@font-face`](../../rcss/fonts.html#font-face) 规则。第一个重载从字体文件本身确定字族和样式，而第二个重载使用提供的字族和样式注册该字体。第三个重载直接接受字体数据而不是文件名，用于从内存加载的字体。它们各自默认返回 false，因此自定义字体引擎必须实现第二个重载，RCSS `@font-face` 规则才能工作。

当构造一个元素，或其某些与字体相关的属性发生变化时，它会通过 `GetFontFaceHandle()` 获取一个 `FontFaceHandle`。然后字体引擎应为给定的字族、样式、字重和字号返回一个唯一句柄。

如果任何字体效果被应用于给定元素，则通过 `PrepareFontEffects()` 提交这样一个效果的列表。如何处理它们由字体引擎接口决定。应为给定的字体效果列表返回一个句柄，该句柄将在之后调用 `GenerateString()` 期间使用。如果不使用字体效果，则无需实现此函数。

`GetFontMetrics()` 是几个应实现的函数之一，以允许 RmlUi 查询给定字体的属性。

在布局期间，有必要知道给定字符串的宽度而不实际渲染它。然后 RmlUi 会调用 `GetStringWidth()`，期望该接口为给定句柄返回所提供字符串的像素宽度。请注意，字符串以 UTF-8 编码；如果需要，`RmlUi/Core/StringUtilities.h`{:.incl} 中有一些辅助函数用于遍历此类字符串。

最后，调用 `GenerateString()` 来实际生成给定字符串的几何体。提供了先前由接口生成的字体句柄和字体效果句柄。该函数应返回一系列带纹理的网格，以及其像素宽度。

自定义字体引擎接口的示例实现存在于 `bitmap_font` 和 `harfbuzz` 示例中。
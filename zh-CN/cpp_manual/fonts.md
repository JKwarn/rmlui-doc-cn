---
layout: page
title: 加载字体
parent: cpp_manual
next: input
---

TrueType 和 OpenType 字体可以由应用程序加载到 RmlUi 中。RmlUi 没有默认字体，因此在渲染文本之前必须至少加载一种字体。字体可以像下面描述的那样从 C++ 加载，或者使用 RCSS 的 [`@font-face`](../rcss/fonts.html#font-face) at-rule 以声明方式从样式表加载。

要加载字体，请调用下面描述的 `Rml::LoadFontFace()` 函数之一。

### 从文件加载字体字面（font face）

最简单的重载接受一个文件名，以及可选的 fallback、weight 和 face index 参数：

```cpp
// Adds a new font face to the font engine. The face's family, style, and weight will be determined from the face itself.
// @param[in] file_path The path to the file to load the face from.
// @param[in] fallback_face True to use this font face for unknown characters in other font faces.
// @param[in] weight The weight to load when the font face contains multiple weights.
// @param[in] face_index The index of the font face within a font collection.
// @return True if the face was loaded successfully, false otherwise.
bool LoadFontFace(const String& file_path,
                  bool fallback_face = false,
                  Style::FontWeight weight = Style::FontWeight::Auto,
                  int face_index = 0);
```

此函数将加载 `file_path` 指定的字体文件，通过文件接口打开它。路径通常应相对于应用程序的工作目录，或为绝对路径。

字体的字族（你使用 `font-family`{:.prop} RCSS 属性指定字体所用的字符串）、样式（normal 或 italic）以及默认情况下的字重都从字体文件本身获取。RmlUi 将根据应用程序的需要为字体的特定大小生成字体数据。请注意，如果你加载 .ttc 文件，只会注册第一个字体。

如果启用，`fallback_face` 选项将使给定的字体字面用于其他字体中未知的字符。例如，这对于为表情符号提供一个字体字面、为西里尔字母、希腊字母等字符提供另一个字体字面很有用。每当遇到的字符不在文档指定的字体中时，就会使用这些字体。可以使用多个 fallback 字体字面，它们将按照加载顺序优先使用。

当 `weight` 参数为 `Auto`{:.value} 时，字重自动从字体中获取。此外，如果字体包含多个字重变体，则全部加载。`weight` 的任何其他值要么用于覆盖注册的字重，要么在字面中有多个字重时，选择要加载的字重变体。

覆盖默认 `weight` 参数可以通过 `Rml::Style::FontWeight::Normal`{:.value}、`Bold`{:.value} 之一，或通过强制转换任意数值 \[1,1000\] 实现，例如 `(Rml::Style::FontWeight)850`{:.value}。

`face_index` 参数允许在字体集合中选择字体字面。这对于加载包含多个字面的单个字体文件很有用。

### 覆盖字体字族

如果你需要覆盖从文件加载的字体的字族名称或样式，请改用以下重载：

```cpp
// Adds a new font face from file to the font engine. The face's family, style, and weight are given by the parameters.
// @param[in] file_path The path to the file to load the face from.
// @param[in] family The family to register the font as.
// @param[in] style The style to register the font as.
// @param[in] weight The weight to load when the font face contains multiple weights.
// @param[in] fallback_face True to use this font face for unknown characters in other font faces.
// @param[in] face_index The index of the font face within a font collection.
// @return True if the face was loaded successfully, false otherwise.
bool LoadFontFace(const String& file_path,
                  const String& family,
                  Style::FontStyle style,
                  Style::FontWeight weight = Style::FontWeight::Auto,
                  bool fallback_face = false,
                  int face_index = 0);
```

### 从内存加载字体字面

如果你需要从内存而不是文件加载字体字面，请使用以下重载：

```cpp
// Adds a new font face from memory to the font engine. The face's family, style, and weight are given by the parameters.
// @param[in] data The font data.
// @param[in] family The family to register the font as.
// @param[in] style The style to register the font as.
// @param[in] weight The weight to load when the font face contains multiple weights.
// @param[in] fallback_face True to use this font face for unknown characters in other font faces.
// @param[in] face_index The index of the font face within a font collection.
// @return True if the face was loaded successfully, false otherwise.
// @lifetime The pointed to 'data' must remain available until after the call to Rml::Shutdown.
bool LoadFontFace(Span<const byte> data,
                  const String& family,
                  Style::FontStyle style,
                  Style::FontWeight weight = Style::FontWeight::Auto,
                  bool fallback_face = false,
                  int face_index = 0);
```

- 当提供的 `family` 为空时，字体字族和样式自动从字体中获取。
- `style` 是 `Rml::Style::FontStyle::Normal`{:.value} 或 `Italic`{:.value} 之一。
- `weight`、`fallback_face` 和 `face_index` 参数与第一个函数中的完全相同。

字体的 italic 和 bold 版本通过 `font-weight`{:.prop} 和 `font-style`{:.prop} RCSS 属性选择。

### 示例

在以下示例中，`data/trilobyte.ttf`{:.path} 处的字体文件被加载并与 RmlUi 注册，使用文件中指定的字族名称、样式和字重设置。

```cpp
Rml::LoadFontFace("data/trilobyte.ttf");
```

在此示例中，字体文件从内存加载，并覆盖名称、样式和字重。

```cpp
std::vector<unsigned char> trilobyte_b = MyAssetLoader("data/trilobyte_b.ttf");
Rml::LoadFontFace(trilobyte_b, "Trilobyte", Rml::Style::FontStyle::Normal, Rml::Style::FontWeight::Bold);

/* ... */

// Note that the data must stay alive until after the call to Rml::Shutdown.
Rml::Shutdown();
trilobyte_b.clear();
```

这些字体将在 RCSS 中使用以下规则指定（假设 'trilobyte.ttf' 注册了一个字族为 'Trilobyte' 的字体）：

```css
body
{
    font-family: Trilobyte;
}

strong
{
    font-weight: bold;
}
```

如果你不确定加载的字体文件的 font-family 名称，请查看日志输出，因为日志会列出所有已加载字体的名称。
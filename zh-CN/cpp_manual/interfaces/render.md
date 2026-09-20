---
layout: page
title: 渲染接口
parent: cpp_manual/interfaces
grandparent: cpp_manual
next: system
---


渲染接口是 RmlUi 将其生成的几何体发送到应用程序进行渲染的方式。它还使用该接口加载纹理，并可选择用于高级渲染效果。应用程序必须在初始化 RmlUi 之前安装渲染接口。

渲染接口提供在 `<RmlUi/Core/RenderInterface.h>`{:.incl} 中。要开发自定义渲染接口，请创建一个派生自 `Rml::RenderInterface` 的类，并为纯虚函数以及任何你希望提供功能的其它函数提供函数定义。

有关该接口的示例实现，请查看 RmlUi 中的[随附后端](https://github.com/mikke89/RmlUi/tree/master/Backends)及其各自的渲染器（`RmlUi_Renderer_[…].cpp`{:.path}）。还有一个大型的视觉测试集，作为验证渲染器行为是否符合预期的参考可能非常有帮助。将渲染结果与我们的一个内置渲染器进行比较在实现过程中可能非常有价值。详情请参阅 [RmlUi 测试套件](https://github.com/mikke89/RmlUi/tree/master/Tests)，特别是 `rmlui_visual_tests`{:.value} 应用程序，它通过 `BUILD_TESTING`{:.value} [CMake 选项](../building_with_cmake.html)启用。

**目录**

- [功能表](#feature-table)
- [渲染约定](#rendering-conventions)
- [基本渲染](#basic-rendering)
    - [几何体](#geometry)
    - [纹理](#textures)
    - [裁剪区域](#scissor-region)
- [高级渲染](#advanced-rendering)
    - [裁剪遮罩](#clip-mask)
    - [变换](#transforms)
    - [图层](#layers)
    - [渲染纹理](#render-textures)
    - [遮罩图像](#mask-images)
    - [滤镜](#filters)
    - [着色器](#shaders)

### 功能表
{:#feature-table}

下表列出了各种渲染功能，以及需要渲染器实现这些功能才能正常工作的属性。此列表中的每个功能代表一组渲染接口函数。

| 功能 | 描述 | 所需属性 |
| -- | -- | -- |
| [基本渲染](#basic-rendering) | 渲染盒几何体、图像、文本和基本装饰器。 | 始终必需 |
| [裁剪遮罩](#clip-mask) | 正确裁剪变换元素和具有圆角边框的元素。 | `transform`{:.prop} 和 `perspective`{:.prop}、与 `overflow: none`{:.value} 组合的 `border-radius`{:.prop}、`box-shadow`{:.prop} |
| [变换](#transforms) | 应用任意矩阵变换来旋转、缩放、倾斜或平移元素。 | `transform`{:.prop} 和 `perspective`{:.prop} |
| [图层](#layers) | 渲染到图层并进行合成，以便可以单独应用渲染效果。 | `filter`{:.prop}、`backdrop-filter`{:.prop}、`mask-image`{:.prop}、`box-shadow`{:.prop} |
| [渲染纹理](#render-textures) | 允许将图层存储为纹理以供稍后渲染。 | `box-shadow`{:.prop} |
| [遮罩图像](#mask-images) | 允许将图层存储并随后用作遮罩。 | `mask-image`{:.prop} |
| [滤镜](#filters) | 在合成期间应用滤镜。 | `filter`{:.prop}、`backdrop-filter`{:.prop}、应用了模糊的 `box-shadow`{:.prop} |
| [着色器](#shaders) | 使用特殊着色器渲染几何体。 | 以下 `decorator`{:.prop} 类型：`shader`{:.value}、`linear-gradient`{:.value}、`radial-gradient`{:.value}、`conic-gradient`{:.value}，以及它们的 `repeating-`{:.value} 变体。 |

如果未实现对应的功能，列出的属性可能根本无法工作，或以功能减弱的形式工作。如果某个属性不在此处专门列出，那么只实现基本渲染函数就应该完全支持它。

### 渲染约定

在实现 RmlUi 中的渲染 API 之前，用户应理解该库使用的以下渲染约定和假设。

* 顶点位置坐标以 `pixel` 为单位。
* RmlUi 中文档的坐标系将原点放在窗口的左上角。
* 索引按逆时针环绕顺序定义三角形集合。
* RmlUi 中生成的纹理使用原点位于左下角的约定。
* 要正确处理变换，请参阅[变换](#transforms)一节。

其他渲染假设。

* 应启用 Alpha 混合。
* 生成的纹理和顶点颜色以带预乘 alpha 的 sRGB 色彩空间给出。
* 纹理的获取颜色应乘以顶点颜色。

#### 混合

该库使用带预乘 alpha 的颜色，以确保在合成多个带透明度的图层时正确混合。在实现渲染接口时，用户应确保使用适合预乘 alpha 的混合函数。例如[在 OpenGL 中](https://apoorvaj.io/alpha-compositing-opengl-blending-and-premultiplied-alpha/)，可以使用 `glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA)`。当将渲染的 GUI 合成到最终目标缓冲区时，如果目标缓冲区是不透明的，可以使用相同的函数。否则，可能需要在混合前对颜色进行去预乘。

#### 投影矩阵

用户必须自己构建投影矩阵，同时考虑上述约定以及其图形 API 中使用的约定和设置。例如，OpenGL 的约定是将原点放在窗口的左下角。因此，用户在构建投影矩阵时应翻转 y 轴。DirectX 的约定是将原点放在窗口的左上角，因此可以使用遵循此约定的正交投影矩阵。

#### 生成的纹理

RmlUi 中生成的纹理遵循 OpenGL 将纹理原点放在左下角的约定。包括 DirectX 在内的其他图形 API 使用左上角作为原点。因此，纹理可能看起来垂直翻转。在这种情况下，用户可以翻转 RmlUi 提供的纹理 y 坐标。

#### 面剔除

如果启用了面剔除，请确保剔除面的方向正确。否则你将得到一个空白窗口。例如，默认情况下 OpenGL 将正面定义为逆时针环绕方向，并剔除背面。因此，就 RmlUi 提交的几何体而言，可以使用这些默认值。另一方面，DirectX 的约定是正面使用顺时针环绕方向，因此如果启用了背面剔除，你将得到一个空白屏幕。解决方案是禁用面剔除、交换环绕方向，或设置剔除正面而不是背面。

#### 视口

确保在你的图形 API 中正确设置视口。这通常应对应于正在渲染的 `Rml::Context` 上设置的尺寸。

### 基本渲染

所有渲染接口都必须实现基本渲染函数。这些是作为纯虚函数实现的，因此在实例化渲染接口的实现之前，必须先重载它们。

基本渲染允许应用程序显示基本布局，包括文本、边框、纹理和一些装饰器。高级渲染函数，如变换、滤镜和盒阴影，需要额外的高级渲染函数，将在下面进一步记录。

#### 几何体

RmlUi 中的所有几何体首先通过调用 `CompileGeometry()` 提交给应用程序。这使应用程序有机会将几何体数据编译成最适合其渲染系统的格式，或者简单地存储对数据的引用。之后对该几何体的所有使用都通过指向它的句柄来引用，由应用程序决定。

```cpp
// Called by RmlUi when it wants to compile geometry to be rendered later.
virtual Rml::CompiledGeometryHandle CompileGeometry(Rml::Span<const Rml::Vertex> vertices, Rml::Span<const int> indices) = 0;
```

所有几何体都以索引三角形给出。

- `vertices`：构成几何体的顶点数组；每个顶点是一个 `Rml::Vertex` 类型，定义在 `<RmlUi/Core/Vertex.h>`{:.incl} 中。
- `indices`：整数索引数组，每个索引引用顶点数组中的单个顶点。由于所有几何体都以三角形给出，索引的数量总是三的倍数。

当 RmlUi 调用此函数时，应用程序应生成并返回一个 `CompiledGeometryHandle`（一个指针大小的整数），指向任何唯一标识已编译几何体所需的值。RmlUi 将在之后调用其他渲染函数时使用该返回值引用相同的几何体。值 *zero*（0）保留给无效句柄，因此此值只能在指示错误时返回。

*注意：* RmlUi 在其生命周期内保留几何体数据的副本。特别是，该库保证被指向的顶点和索引数据有效且不可变，直到使用相同的几何句柄调用 `ReleaseGeometry()` 为止。因此，如果应用程序需要在几何体的生命周期内稍后引用几何体数据，可以安全地存储对数据的引用（span）。


```cpp
// Called by RmlUi when it wants to render geometry.
virtual void RenderGeometry(Rml::CompiledGeometryHandle geometry, Rml::Vector2f translation, Rml::TextureHandle texture) = 0;
```

当 RmlUi 想要渲染几何体时，它使用先前从编译几何体调用返回的几何句柄调用 `RenderGeometry()`。

- `geometry`：要渲染的几何体的句柄。
- `translation`：要应用于几何体的 2D 平移。
- `texture`：要应用于几何体的纹理句柄，对于无纹理几何体这将为零。

所有物理坐标（顶点位置和几何体平移）都以当前正在渲染的上下文左上角开始的像素偏移给出。几何体按顺序通过渲染接口渲染，因此虽然你不必立即将几何体传递给渲染系统（例如，如果你正在实现某种几何体聚合），但它仍应按传入的顺序渲染。

```cpp
// Called by RmlUi when it wants to release geometry.
virtual void ReleaseGeometry(Rml::CompiledGeometryHandle geometry) = 0;
```

一旦不再需要几何体，RmlUi 将调用 `ReleaseGeometry()` 请求应用程序释放它。

- `geometry`：要释放的几何体的句柄。

调用此函数后，对几何体数据的任何引用都将失效。

#### 纹理

RmlUi 调用渲染接口来加载、生成和释放纹理。由于 RmlUi 需要此功能，所有渲染接口都必须实现这些函数。

```cpp
// Called by RmlUi when a texture is required by the library.
virtual Rml::TextureHandle LoadTexture(Rml::Vector2i& texture_dimensions, const Rml::String& source) = 0;

// Called by RmlUi when a texture is required to be generated from a sequence of pixels in memory.
virtual Rml::TextureHandle GenerateTexture(Rml::Span<const Rml::byte> source, Rml::Vector2i source_dimensions) = 0;

// Called by RmlUi when a loaded or generated texture is no longer required.
virtual void ReleaseTexture(Rml::TextureHandle texture) = 0;
```

当 RmlUi 想要从外部源（通常是文件，但这取决于应用程序）加载纹理时，会调用 `LoadTexture()`。
- `texture_dimensions`：应由应用程序设置为所加载纹理的 x 和 y 尺寸。
- `source`：在 RML（对于图像标签）或 RCSS（对于装饰器图像引用）中指定的源名称，与引用文档的路径连接。

`LoadTexture()` 函数应返回一个 `Rml::TextureHandle` 类型。这是一个 `uintptr_t`，可以设置为你需要的任何唯一标识所加载纹理的值。值 *zero*（0）保留给无效句柄，只应在尝试加载纹理出错时使用。

当 RmlUi 拥有想要转换为纹理的原始像素数据（例如用于字体）时，会调用 `GenerateTexture()`。原始像素数据在 `source` 中给出；这是一个按 RGBA 顺序排列的无符号 8 位值数组。它以紧密排列的行布局，因此大小正好为 `source_dimensions.x * source_dimensions.y * 4` 字节。`source_dimensions` 变量设置为原始纹理数据的尺寸。应用程序应返回一个唯一标识纹理的 `Rml::TextureHandle`，就像在 `LoadTexture()` 中一样。

一旦 RmlUi 不再需要某个纹理，就会用纹理句柄调用 `ReleaseTexture()`。

#### 裁剪区域

RmlUi 依靠裁剪区域来裁剪元素的隐藏内容。因此，所有渲染接口都必须实现这两个函数：

```cpp
// Called by RmlUi when it wants to enable or disable scissoring to clip content.
virtual void EnableScissorRegion(bool enable) = 0;

// Called by RmlUi when it wants to change the scissor region.
virtual void SetScissorRegion(Rml::Rectanglei region) = 0;
```

`EnableScissorRegion()` 被调用来启用和禁用对渲染几何体的裁剪。

当 RmlUi 想要定义当前裁剪区域时，会调用 `SetScissorRegion()`。裁剪区域以像素为单位给出，其原点位于渲染上下文的左上角。裁剪区域总是在窗口坐标中给出，这意味着它不受任何活动变换的影响。在裁剪区域改变之前，所有 RmlUi 几何体都应被裁剪到该区域内。

当文档中使用[需要](#feature-table)裁剪遮罩的属性时，仅靠裁剪区域不足以正确裁剪内容。渲染接口必须实现[裁剪遮罩](#clip-mask)功能来支持此类布局。


### 高级渲染

高级渲染函数都是可选的，允许应用程序访问许多额外的渲染功能。每个功能都实现为一组不同的虚函数，使应用程序能够随时增量实现它们所需的功能集。

#### 裁剪遮罩

裁剪对 RmlUi 布局模型很重要，特别是为了可以隐藏元素的溢出。这通常可以由裁剪区域处理，它与裁剪遮罩的目的类似。然而，裁剪区域只能是轴对齐的矩形形状。应用变换时，裁剪区域可以因旋转或投影而呈现其他形状。此外，应用 border-radius 时，我们希望将溢出裁剪到弯曲的边框。裁剪遮罩允许库使用任意几何体定义裁剪区域，从而裁剪到任何区域。

需要实现以下两个函数以启用此功能。

```cpp
// Called by RmlUi when it wants to enable or disable the clip mask.
virtual void EnableClipMask(bool enable);

// Called by RmlUi when it wants to set or modify the contents of the clip mask.
virtual void RenderToClipMask(Rml::ClipMaskOperation operation, Rml::CompiledGeometryHandle geometry, Rml::Vector2f translation);
```

RmlUi 使用 `EnableClipMask()` 启用或禁用裁剪遮罩。启用后，裁剪遮罩应隐藏遮罩区域之外的任何渲染内容。裁剪遮罩专门应用于所有其他使用几何句柄渲染的函数，以及在其目标上渲染时的图层合成函数。

当 RmlUi 想要设置新的裁剪遮罩时，它会调用一次或多次 `RenderToClipMask()`。此函数接受一个 `geometry` 句柄和一个 `translation` 向量，就像调用 `RenderGeometry()` 一样。然而，裁剪遮罩渲染函数不应像普通几何体那样渲染，而应应用于*裁剪遮罩*。额外的 `operation` 参数描述了几何体应如何应用于裁剪遮罩，可取以下值之一。

```cpp
enum class ClipMaskOperation {
	Set,        // Set the clip mask to the area of the rendered geometry, clearing any existing clip mask.
	SetInverse, // Set the clip mask to the area *outside* the rendered geometry, clearing any existing clip mask.
	Intersect,  // Intersect the clip mask with the area of the rendered geometry.
};
```

裁剪遮罩全局应用，就像所有图层共享单个裁剪遮罩一样。任何活动变换都应应用于几何体，就像正常的几何体渲染调用一样。RmlUi 不定义裁剪遮罩在渲染端如何实现，但一种方法是使用*模板缓冲区*。

#### 变换

变换允许修改任何几何体的渲染位置和大小，并且是支持 `transform`{:.prop} RCSS 属性所必需的。当变换矩阵需要更改时，RmlUi 将调用以下函数。

```cpp
// Called by RmlUi when it wants the renderer to use a new transform matrix.
virtual void SetTransform(const Rml::Matrix4f* transform);
```

`transform` 参数是指向新变换矩阵的指针。当 RmlUi 想要将变换设置回单位矩阵时，将提交一个 `nullptr`{:.value}。如果没有 `transform`{:.prop} 属性存在，则永远不会调用此函数。

实现正确结果的重要考虑因素：

- 设置后，变换应应用于所有使用几何句柄渲染的函数，且仅限于这些函数。特别是，这意味着它不适用于裁剪区域，但适用于渲染到裁剪遮罩时。
- `Matrix4f` 类型是**列主序**排列。如果你选择的图形 API 接受行主序矩阵，则在提交给图形 API 之前必须先转置矩阵。
- 当通过某个 `Render...()` 调用收到绘制调用时，应首先将 `translation` 向量应用于顶点位置。然后，应将生成的 2D 向量扩展为 4D 向量，元素 `z = 0` 和 `w = 1`，以获得变换的平移和透视部分的正确结果。
- 提供的 `transform` 矩阵不包括到用户窗口的投影，因此用户应创建自己的投影矩阵 `project`，并使用 `project * transform` 的乘积来生成顶点位置输出。
- 确保将投影矩阵的 *z*<sub>far</sub> 和 *z*<sub>near</sub> 平面设置在离文档平面（*z*=0）足够远的位置，这样几何体在旋转或沿 *z* 轴平移时不会被裁剪。

顶点位置的伪顶点着色器代码：

```glsl
input Vec2 vertex_pos;
input Vec2 translation;
input Mat4 transform;
input Mat4 project;

output Vec4 frag_pos;

void main() {
	Vec4 pos_document = Vec4(vertex_pos + translation, 0, 1);
	frag_pos = project * transform * pos_document;
}
```

#### 图层

在 RmlUi 中，图层用于几种渲染效果。例如，它们是单独向元素集合应用滤镜的基础，并允许合成构成盒阴影的不同部分。

图层放置在*渲染栈*内。图层总是通过推入栈来构造，通过弹出栈来销毁。栈操作总是以有序的方式进行——即后进先出（LIFO）顺序。

渲染应始终在渲染栈顶部的图层上进行。此外，一个图层可以与另一个图层合成（混合）。需要实现以下函数以支持 RmlUi 中的图层。

```cpp
// Called by RmlUi when it wants to push a new layer onto the render stack, setting it as the new render target.
virtual Rml::LayerHandle PushLayer();

// Composite two layers with the given blend mode and apply filters.
virtual void CompositeLayers(Rml::LayerHandle source,
                             Rml::LayerHandle destination,
                             Rml::BlendMode blend_mode,
                             Rml::Span<const Rml::CompiledFilterHandle> filters);

// Called by RmlUi when it wants to pop the render layer stack, setting the new top layer as the render target.
virtual void PopLayer();
```

当 RmlUi 想要将新图层推入渲染栈时，会调用 `PushLayer()` 函数。在这里，应用程序应返回一个 `LayerHandle`。就像其他接口句柄一样，这是一个指针大小的整数，应用程序应将其设置为唯一标识新图层（即栈顶）的值。该句柄之后在合成期间用于引用该图层。新图层应在当前裁剪区域内初始化为透明黑色。

当 RmlUi 想要合成两个图层时，会调用 `CompositeLayers()` 函数。可以为渲染栈中的任意两个图层调用此函数，而不仅仅是顶层。它接受一个 `source` 和一个 `destination` 图层，它们应根据给定的 `blend_mode` 混合在一起。

```cpp
enum class BlendMode {
	Blend,   // Normal alpha blending.
	Replace, // Replace the destination colors from the source.
};
```

在正常的 `Blend` 模式下，源应被 alpha 合成到目标图层上（即合成术语中的 *source **over** destination* 操作）。请注意，应用程序应使用带预乘 alpha 的合成，以确保与（部分）透明图像正确混合，请参阅上面的[混合约定](#blending)。另一方面，在 `Replace` 模式下，源应简单地按原样写入目标，不进行任何 alpha 混合。

`filters` 参数指定了 RmlUi 希望在合成期间使用的滤镜列表。只有想要支持*滤镜*渲染功能的应用程序才需要处理此参数。如果此列表非空，应用程序应按列出的顺序应用滤镜，就像将滤镜应用于源图层的副本一样。滤镜应在合成之前应用。然后，根据与之前相同的混合规则，将滤镜的结果合成到目标图层上。

请注意，源和目标可以引用同一个图层。在这种情况下，它们应被视为先将源复制到临时缓冲区，然后再将临时缓冲区合成到目标上。例如，这可以用于将滤镜应用到当前图层。

另外，请注意裁剪区域在合成操作期间生效。此操作只应影响裁剪区域内的目标像素。请记住，某些滤镜（如模糊）可能受到裁剪区域外的源像素的影响。裁剪区域只在最终合成期间应用。

最后，当 RmlUi 想要从渲染栈中弹出顶层时，会调用 `PopLayer()`。对该图层的任何先前句柄将不再使用。

#### 渲染纹理
{:#render-textures}

当前图层可以存储为纹理，以便 RmlUi 在之后的渲染操作中重新使用其内容。

```cpp
// Called by RmlUi when it wants to store the current layer as a new texture to be rendered later with geometry.
virtual Rml::TextureHandle SaveLayerAsTexture();
```

RmlUi 调用 `SaveLayerAsTexture()` 函数将当前图层存储到纹理中。它应返回一个应用程序特定的指向新纹理的 `TextureHandle`，就像其他纹理一样。然后 RmlUi 可以在正常的几何体渲染期间使用此纹理。

活动裁剪区域适用于此操作。这意味着应从同一区域提取纹理，以便新纹理的大小与裁剪区域的大小匹配。

当 RmlUi 不再需要此纹理时，将使用其句柄调用 `ReleaseTexture()`，就像其他纹理一样。

#### 遮罩图像
{:#mask-images}

遮罩可用于隐藏元素或其他渲染几何体的部分。与裁剪遮罩不同，遮罩图像可以逐渐淡出内容。此功能主要用于实现 `mask-image`{:.prop} 属性。任何图像都可以用于指定遮罩，允许用户通过淡出内容来创造有趣的效果。

```cpp
// Called by RmlUi when it wants to store the current layer as a mask image, to be applied later as a filter.
virtual Rml::CompiledFilterHandle SaveLayerAsMaskImage();
```

RmlUi 调用 `SaveLayerAsMaskImage()` 函数来存储当前图层，以便图层的内容可以用作遮罩图像。应用程序应返回一个指向新滤镜的句柄，该滤镜表示存储的遮罩图像。当在图层合成期间提供相同的滤镜句柄时，应用程序应使用存储的图像作为遮罩。RmlUi 只使用 alpha 遮罩，这意味着遮罩的 alpha 通道应与源图像的 alpha 通道相乘。

当 RmlUi 不再需要此遮罩图像时，将使用其句柄调用 `ReleaseFilter()`，就像其他滤镜一样。

#### 滤镜

滤镜是一种向几何体集合添加图形效果的方法，如模糊、投影和颜色更改。例如，一个元素（包括其所有子元素）可以应用棕褐色调滤镜。然而，滤镜也在内部用于应用效果，如可以用于盒阴影的模糊。

```cpp
// Called by RmlUi when it wants to compile a new filter.
virtual Rml::CompiledFilterHandle CompileFilter(const Rml::String& name, const Rml::Dictionary& parameters);

// Called by RmlUi when it no longer needs a previously compiled filter.
virtual void ReleaseFilter(Rml::CompiledFilterHandle filter);
```

首先使用 `CompileFilter()` 编译滤镜，以便渲染器可以为其渲染准备管线，也以便 RmlUi 可以轻松地在之后引用相同的滤镜和参数集。应用程序应返回一个唯一表示滤镜及其参数的句柄。滤镜在图层合成期间应用，请参阅上面的 [`CompositeLayers()` 文档](#layers)。滤镜在合成阶段之前应用其描述的效果。

提供的 `name` 指的是特定的滤镜效果类型，每种类型都有一组给定的 `parameters` 可用于调整效果。RmlUi 支持 [CSS 中指定的所有滤镜](https://www.w3.org/TR/filter-effects-1/#supported-filter-functions)，我们参考该规范来了解如何渲染每个特定效果。下表列出了所有滤镜类型及其提供的参数。

| 滤镜 | 参数 |
|---------------|-----------------------------------------------------------------------------------------------|
| `opacity`     | `float value`                                                                                 |
| `blur`        | `float sigma`（像素长度）                                                                  |
| `drop-shadow` | `float sigma`（像素长度）<br>`Rml::Colourb color`<br>`Rml::Vector2f offset`（像素长度） |
| `brightness`  | `float value`                                                                                 |
| `contrast`    | `float value`                                                                                 |
| `invert`      | `float value`                                                                                 |
| `grayscale`   | `float value`                                                                                 |
| `sepia`       | `float value`                                                                                 |
| `hue-rotate`  | `float value`（弧度角）                                                              |
| `saturate`    | `float value`                                                                                 |

除非另有说明，浮点值都是归一化的、无单位的因子，表示效果的强度。请注意，应用程序本身或插件可以提供其他具有自己参数集的滤镜类型。上表列出了 RmlUi 内置的类型。当然，应用程序也可以定义自己的滤镜，详情请参阅 [C++ 滤镜文档](../filters.html)。

作为示例，对于 `brightness`，可以如下获取其 `value` 参数：

```cpp
float brightness = Rml::Get(parameters, "value", 0.f);
```
这里，值为 `1` 时对图像没有影响，更大的值会使图像更亮，而更小的值会使图像更暗。请参阅 CSS 规范了解如何解释这些不同值，或从 RmlUi 内置的 [OpenGL3 渲染器](https://github.com/mikke89/RmlUi/blob/master/Backends/RmlUi_Renderer_GL3.cpp)中获取灵感。

最后，当 RmlUi 不再需要先前编译的滤镜时，将使用指向滤镜的 `handle` 调用 `ReleaseFilter()` 函数。

#### 着色器

在 RmlUi 中，着色器用于以独特的方式渲染几何体以产生某种所需效果。滤镜对图层应用效果，而着色器则允许以不同方式渲染几何体本身。RmlUi 核心库本身不提供任何着色器代码，而是提供描述使用给定着色器渲染应如何表现的抽象。它很灵活，因此用户可以命名自己的着色器，以应用程序认为合适的任何方式使用。

着色器像普通几何体一样编译、渲染和释放。主要区别在于着色器编译过程，以及渲染时额外接受一个指向着色器的句柄。应实现以下函数以支持此功能。

```cpp
// Called by RmlUi when it wants to compile a new shader.
virtual Rml::CompiledShaderHandle CompileShader(const Rml::String& name, const Rml::Dictionary& parameters);

// Called by RmlUi when it wants to render geometry using the given shader.
virtual void RenderShader(Rml::CompiledShaderHandle shader,
                          Rml::CompiledGeometryHandle geometry,
                          Rml::Vector2f translation,
                          Rml::TextureHandle texture);

// Called by RmlUi when it no longer needs a previously compiled shader.
virtual void ReleaseShader(Rml::CompiledShaderHandle shader);
```

着色器就像滤镜一样编译。首先使用 `CompileShader()` 编译着色器，以便渲染器可以为渲染准备管线，也以便 RmlUi 可以轻松地在之后引用相同的着色器和参数集。应用程序应返回一个唯一表示着色器及其参数的句柄。

提供的 `name` 指的是特定的着色器效果类型，每种类型都有一组给定的 `parameters` 可用于调整效果。RmlUi 提供选定的内置着色器来表示某些效果，如渐变。下表列出了所有着色器类型及其提供的参数。

| 着色器 | 参数 |
| --- | --- |
| `linear-gradient` | `bool repeating`{:.value}：True 表示渐变是重复的。<br>`Rml::Vector2f p0`{:.value}：起点（px）。<br>`Rml::Vector2f p1`{:.value}：终点（px）。<br>`float length`{:.value}：渐变线的长度（px）。<br>`Rml::ColorStopList color_stop_list`{:.value}：颜色停止列表。 |
| `radial-gradient` | `bool repeating`{:.value}：True 表示渐变是重复的。<br>`Rml::Vector2f center`{:.value}：中心点（px）。<br>`Rml::Vector2f radius`{:.value}：二维半径（px）。<br>`Rml::ColorStopList color_stop_list`{:.value}：颜色停止列表。 |
| `conic-gradient`  | `bool repeating`{:.value}：True 表示渐变是重复的。<br>`Rml::Vector2f center`{:.value}：中心点（px）。<br>`float angle`{:.value}：渐变的旋转角度（弧度）。<br>`Rml::ColorStopList color_stop_list`{:.value}：颜色停止列表。 |
| `shader`          | `Rml::String value`{:.value}：用户指定的值。<br>`Rml::Vector2f dimensions`{:.value}：绘制区域的尺寸（px）。 |

请注意，应用程序本身或插件可以使用[自定义装饰器](../decorators.html#custom-decorators)提供具有自己参数集的其他着色器类型。上表列出了 RmlUi 内置的类型。

各种 `[...]-gradient` 着色器的参数已经被处理，使得它们处于适合渲染的形式。颜色停止列表已被解析，使得每个颜色停止都作为带有*数字*单位的位置给出，其中零表示渐变线的开始，一表示渐变线的结束。具体来说，`Rml::ColorStopList` 是 `ColorStop` 结构的向量，具有 `color` 和 `position` 成员。后者指定为 `NumericValue` 类型，其单位始终是 `NUMBER`{:.value}。请参阅 CSS 规范以了解如何解释这些参数：[`linear-gradient`{:.prop}](https://www.w3.org/TR/css-images-3/#linear-gradients)、[`radial-gradient`{:.prop}](https://www.w3.org/TR/css-images-3/#radial-gradients) 和 [`conic-gradient`{:.prop}](https://www.w3.org/TR/css-images-4/#conic-gradients)。其他位置和长度以像素坐标给出，与相关几何体的纹理坐标匹配，这些坐标也以像素坐标提供。请随意查看 RmlUi 内置的 [OpenGL3 渲染器](https://github.com/mikke89/RmlUi/blob/master/Backends/RmlUi_Renderer_GL3.cpp)，了解效果在那里是如何实现的。

`shader` 着色器是一个通用着色器，可以由应用程序赋予含义。`shader(<string>)`{:.value} 装饰器直接将提供的字符串作为参数交出，允许应用程序相应地渲染几何体。绘制区域的尺寸作为参数提供，此外，其伴随几何体的纹理坐标被归一化到 `[0, 1]` 装饰器的绘制区域。

当 RmlUi 想要使用给定着色器渲染一些几何体时，它会调用 `RenderShader()`。这与 `RenderGeometry()` 的工作方式相同，只是它还接受一个 `shader` 参数，指示几何体应使用哪个着色器渲染。

最后，当 RmlUi 不再需要先前编译的着色器时，将使用指向着色器的 `handle` 调用 `ReleaseShader()` 函数。
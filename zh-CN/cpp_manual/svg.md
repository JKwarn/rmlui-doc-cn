---
layout: page
title: SVG 插件
parent: cpp_manual
---

RmlUi 集成了用于渲染 SVG 矢量图像的 SVG 插件。该插件使用 [LunaSVG](https://github.com/sammycage/lunasvg) 库来渲染 SVG 文档。

当 RmlUi 使用 SVG 插件构建时，除了 `svg`{:.prop} 装饰器之外，`<svg>`{:.tag} 元素也可作为普通 RML 标签使用。

该插件为 SVG 文档和生成的位图实现了一个缓存。每个 SVG 文档只要在使用中就会被存储在缓存中，否则文档将被释放。对于每个 SVG 文档，我们还根据其分辨率和颜色缓存纹理。如果所有决定其生成位图的属性都匹配，纹理将被重用。

### \<svg\>

`<svg>`{:.tag} 元素用于在文档中包含 SVG 矢量图像。

_属性_

`src`{:.attr} = uri (CT)
: SVG 图像的源位置。如果未指定，则 `<svg>`{:.tag} 元素的内联内容将作为其 SVG 源。

`width`{:.attr} = number (CN)
: 强制元素拥有的宽度，以像素为单位。

`height`{:.attr} = number (CN)
: 强制元素拥有的高度，以像素为单位。

`crop-to-content`{:.attr} (CI)
: 设置后，SVG 视图框将被裁剪到 SVG 的内容，即内容将被缩放以移除其边缘的任何空白。

![SVG 示例](../../assets/gallery/svg_plugin.png)

#### 示例

`<svg>`{:.tag} 元素可以如下使用：

```html
<svg src="tiger.svg"></svg>
```

以下内容演示了内联 SVG 文档的使用：

```html
<svg width="50" height="50" xmlns="http://www.w3.org/2000/svg">
    <circle cx="25" cy="25" r="20" stroke="black" stroke-width="3" fill="red" />
</svg>
```

请注意，`<svg>`{:.tag} 元素的内部部分不是 DOM 的一部分，即不能用 `Rml::Element` API 操纵其子元素。然而，SVG 源可以使用 `Rml::Element::SetInnerRML` 更新，甚至可以使用[数据绑定](../data_bindings.html)（特别是 `data-rml` 视图）自动更新。详情请参阅 `svg` 示例。

### 装饰器 `svg`
{:#decorator}

`svg`{:.prop} 装饰器可用于在元素的背景中包含 SVG 图像。

```css
decorator: svg( <svg-src> <crop>? ) <paint-area>?;
```

#### 属性

`svg-src`{:.prop}

值: | \<string\>
初始值: | N/A
百分比: | N/A

要显示的 SVG 文件的路径。

`crop`{:.prop}

值: | crop-none \| crop-to-content
初始值: | crop-none
百分比: | N/A

决定 SVG 图像如何被裁剪。

`crop-none`{:.value}
: SVG 图像将不会被裁剪。

`crop-to-content`{:.value}
: SVG 视图框将被裁剪到 SVG 的内容，即内容将被缩放以移除其边缘的任何空白。

`paint-area`{:.prop}

值: | border-box \| padding-box \| content-box
初始值: | padding-box
百分比: | N/A

声明渲染装饰器的盒区域。

请注意，SVG 装饰器将始终填满绘制区域的大小。要保持宽高比，请确保元素大小适当。

#### 示例

`svg`{:.prop} 装饰器可以如下应用：

```css
.tiger {
	decorator: svg("tiger.svg");
}
```

在以下内容中，我们将绘制区域设置为元素的内容盒以手动控制内边距，同时跳过 SVG 文件中任何已有的内边距：

```css
.tiger {
	decorator: svg("tiger.svg" crop-to-content) content-box;
	padding: 10px 20px;
}
```

### 使用 SVG 插件构建

SVG 插件一旦启用，就会与 RmlUi 核心库集成并一起构建。然后，插件在调用 `Rml::Initialise()` 期间自动加载。

#### 构建 LunaSVG

首先，我们演示如何下载和构建所需的 [LunaSVG](https://github.com/sammycage/lunasvg) 依赖。如果你使用 vcpkg，可以用 `vcpkg install lunasvg` 安装该库，然后直接转到下面的[配置 RmlUi](#configuring-rmlui) 步骤。否则，你可以按如下所示手动构建它。

打开终端并导航到 `RmlUi/Dependencies`{:.path}。然后执行以下命令。

```cmd
git clone --recurse-submodules --branch v3.2.1 https://github.com/sammycage/lunasvg
cd lunasvg
cmake -B build -S . -DBUILD_SHARED_LIBS=OFF -DLUNASVG_BUILD_EXAMPLES=OFF
cmake --build build --target lunasvg --config Debug
cmake --build build --target lunasvg --config Release
```

你可能需要根据你的生成器和环境调整 CMake 参数。该插件在给定版本的 LunaSVG 下经过测试，但其他版本也可能有效。

#### 配置 RmlUi

接下来，在 RmlUi 的 [CMake 配置](building_with_cmake.html)期间，设置选项 `RMLUI_SVG_PLUGIN=ON`。这将确保 SVG 插件与 RmlUi 核心库集成并一起构建。例如，在 `RmlUi`{:.path} 目录中执行以下命令：

```cmd
cmake -B Build -S . --preset samples -DBUILD_SHARED_LIBS=OFF -DRMLUI_SVG_PLUGIN=ON
```

如果你使用上述过程构建了 LunaSVG，你可能需要另外在 CMake 配置命令中添加 `-Dlunasvg_ROOT="Dependencies/lunasvg/build"`。在某些情况下，你可能还需要提供 LunaSVG 的 PlutoVG 依赖的路径，例如：`-Dplutovg_ROOT="Dependencies/lunasvg/build/plutovg"`。

一旦配置成功，你现在可以尝试该插件的示例。像构建和运行任何其他示例一样构建和运行随附的 `rmlui_sample_svg` 目标。

### 包含 SVG 插件

要在你自己的项目中包含 SVG 插件，请确保你按照上述说明以启用的 CMake 选项 `RMLUI_SVG_PLUGIN` 构建 RmlUi，并像往常一样[将 RmlUi 集成到你的项目中](integrating.html)。此外，你将需要链接 `lunasvg` 库。对于 CMake 项目，RmlUi 应自动声明对 LunaSVG 的依赖并链接它。确保 CMake 可以找到 LunaSVG，例如通过将 `lunasvg_ROOT` 变量设置为其构建文件夹。

然后，插件在调用 `Rml::Initialise()` 期间自动加载。如果一切都正确完成，日志将输出一条关于 SVG 插件已初始化的简短消息。`<svg>`{:.tag} 元素应该就可以用于显示矢量图像了。
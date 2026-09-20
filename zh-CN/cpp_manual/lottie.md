---
layout: page
title: Lottie 插件
parent: cpp_manual
next: svg
---

Lottie 是一种流行的用于渲染基于矢量的动画的格式。

RmlUi 集成了用于绘制 Lottie 动画的 Lottie 插件。该插件使用 [rlottie](https://github.com/Samsung/rlottie) 库来渲染动画。

当 RmlUi 使用 Lottie 插件构建时，`<lottie>`{:.tag} 元素可作为普通 RML 标签使用。


### \<lottie\>

`<lottie>`{:.tag} 元素用于在文档中包含动画。

_属性_

`src`{:.attr} = uri (CT)
: 描述 Lottie 动画的 JSON 文件的源位置。

![Lottie 示例](../../assets/gallery/lottie.gif)


### 使用 Lottie 插件构建

Lottie 插件一旦启用，就会与 RmlUi 核心库集成并一起构建。然后，插件在调用 `Rml::Initialise()` 期间自动加载。

#### 构建 rlottie

首先，我们演示如何下载和构建所需的 [rlottie](https://github.com/Samsung/rlottie) 依赖。如果你使用 vcpkg，可以用 `vcpkg install rlottie` 安装该库，然后直接转到下面的[配置 RmlUi](#configuring-rmlui) 步骤。否则，你可以按如下所示手动构建它。

打开终端并导航到 `RmlUi/Dependecies`{:.path}。然后执行以下命令。

```cmd
git clone https://github.com/Samsung/rlottie.git
cd rlottie
cmake -B build -S . -DBUILD_SHARED_LIBS=OFF
cmake --build build --target rlottie --config Debug
cmake --build build --target rlottie --config Release
```

你可能需要根据你的生成器和环境调整 CMake 参数。

#### 配置 RmlUi

接下来，在 RmlUi 的 [CMake 配置](building_with_cmake.html)期间，设置选项 `RMLUI_LOTTIE_PLUGIN=ON`。这将确保 Lottie 插件与 RmlUi 核心库集成并一起构建。例如，在 `RmlUi/Build`{:.path} 目录中执行以下命令：

```cmd
cmake -B Build -S . --preset samples -DBUILD_SHARED_LIBS=OFF -DRMLUI_LOTTIE_PLUGIN=ON
```

这应该会自动定位 `rlottie` 库。你现在可以像构建和运行任何其他示例一样构建和运行 `rmlui_sample_lottie` 目标来试用该插件。


### 包含 Lottie 插件

要在你自己的项目中包含 Lottie 插件，请确保你按照上述说明以启用的 CMake 选项 `RMLUI_LOTTIE_PLUGIN` 构建 RmlUi，并像往常一样[将 RmlUi 集成到你的项目中](integrating.html)。此外，你将需要链接 `rlottie` 库。对于 CMake 项目，RmlUi 应自动声明对 rlottie 的依赖并链接它。确保 CMake 可以找到 rlottie，例如通过将 `rlottie_ROOT` 变量设置为其构建文件夹。

然后，插件在调用 `Rml::Initialise()` 期间自动加载。如果一切都正确完成，日志将输出一条关于 Lottie 插件已初始化的简短消息。`<lottie>`{:.tag} 元素应该就可以用于显示动画了。
---
layout: page
title: 使用 CMake 构建 RmlUi
parent: cpp_manual
next: integrating
---

以下内容将引导你完成构建 RmlUi 的整个过程。在将其集成到你自己的应用程序之前，这是必须完成的一步。如果你是初学者，推荐使用包管理器来处理构建与集成。我们也鼓励你构建随附的示例并查看它们。

**目录**

- [先决条件](#prerequisites)
- [使用 vcpkg 构建](#vcpkg)
- [使用 Conan 构建](#conan)
- [使用 Devbox 构建](#devbox)
- [在 Windows 上构建](#windows)
- [在 macOS 和 Linux 上构建](#macos-and-linux)
- [使用 Emscripten 构建](#emscripten)
- [CMake 预设](#cmake-presets)
- [CMake 选项](#cmake-options)


### 先决条件
{:#prerequisites}

- [RmlUi](https://github.com/mikke89/RmlUi)
- [CMake](http://cmake.org)
- [FreeType](https://www.freetype.org)


*或*

- [vcpkg](#vcpkg)

*或*

- [Conan 包管理器](#conan)

*或*

- [Devbox 包管理器](#devbox)

对于新用户，推荐使用 vcpkg 或 Conan 之类的包管理器来处理库的构建与集成。这些工具负责处理依赖关系及所有集成细节，让你轻松完成配置。

要完全访问所有构建选项，可以使用 CMake 手动构建库。你首先需要下载 CMake，或通过你选择的包管理器安装它。CMake 本身并不是一个构建系统，它的用途是生成 Makefile、Xcode 项目、Visual Studio 项目以及其他格式。接下来，按照下面针对你所在平台的说明进行操作。

如果尚未完成，请下载一份 RmlUi。你可以将库下载并解压为 zip 文件，或者在终端中使用 git：

```
git clone https://github.com/mikke89/RmlUi.git
```

### 使用 vcpkg 构建
{:#vcpkg}

[vcpkg](https://vcpkg.io) 是一个用于获取和管理库的跨平台 C/C++ 包管理器。请阅读 [vcpkg 入门](https://learn.microsoft.com/en-us/vcpkg/get_started/overview) 指南来下载并安装该包管理器。

然后，只需使用以下命令即可安装 RmlUi：
```
vcpkg install rmlui
```
现在你已经准备好集成 RmlUi 了，只需将头文件包含到你的源代码中即可。

vcpkg port 支持由下面 [CMake 选项](#cmake-options) 派生的某些特性。

| vcpkg 特性 | 默认特性 | 相关 CMake 选项 | 说明                                           |
|---------------|-----------------|----------------------|-------------------------------------------------------|
| freetype      | 是             | `RMLUI_FONT_ENGINE`  | 包含基于 FreeType 的集成字体引擎。 |
| lottie        | 否              | `RMLUI_LOTTIE_PLUGIN`| 包含 [Lottie 插件](lottie.html)。             |
| lua           | 否              | `RMLUI_LUA_BINDINGS` | 包含 Lua 绑定。                             |
| svg           | 否              | `RMLUI_SVG_PLUGIN`   | 包含 [SVG 插件](svg.html)。                   |

请注意，vcpkg 不会安装示例，而我们建议在将库集成到你自己的项目之前先查看这些示例。为此，我们需要手动下载并构建 RmlUi，但幸运的是，vcpkg 可以通过处理依赖来简化这一过程。

首先安装必要的依赖。这里我们选择使用 [GLFW](https://www.glfw.org/) 作为后端，并继续安装该依赖。其他后端可参见[仓库自述文件](https://github.com/mikke89/RmlUi?tab=readme-ov-file#rmlui-backends)。
```
vcpkg install freetype glfw
```

然后你可以运行以下命令来下载并构建带示例的 RmlUi。请确保替换 vcpkg 的路径。
```
git clone https://github.com/mikke89/RmlUi.git
cd RmlUi
cmake -B Build -S . --preset samples -DRMLUI_BACKEND=GLFW_GL3 -DCMAKE_TOOLCHAIN_FILE=<vcpkg-path>/scripts/buildsystems/vcpkg.cmake
cmake --build Build
```
现在请试试刚构建好的 `invader` 示例（`rmlui_sample_invaders` 目标）以及其余所有示例，尽情享受吧！可执行文件应位于 `Build` 目录中的某处。

如果你想查看其余示例，还可以安装 `lua lunasvg rlottie harfbuzz`，并在 CMake 配置期间使用 `samples-all` 预设。此外还有一个全面的测试框架可用，可以通过额外传递 `-DBUILD_TESTING=ON` 选项来构建，或使用 CMake 预设 `dev` 或 `dev-all`。

如果 vcpkg 提供的 RmlUi 版本已过时或无法满足某些需求，欢迎向 [vcpkg 仓库](https://github.com/microsoft/vcpkg) 贡献。


### 使用 Conan 构建
{:#conan}

[Conan](https://conan.io) 是一个 C/C++ 包管理器，可用于以轻松的方式集成与构建库，并管理其依赖。如果你不熟悉 Conan，那么值得浏览一下 [Conan 教程](https://docs.conan.io/2/tutorial.html)。关于 RmlUi 包本身的信息可在 [ConanCenter: RmlUi](https://conan.io/center/recipes/rmlui) 获取。

生成环境特定包的 Conan recipe 支持由下面 [CMake 选项](#cmake-options) 派生的某些选项。下表说明了 recipe 中可用的、RmlUi 专属的选项。请记住，通常 Conan 社区不鼓励因选项名称中包含否定词而产生的双重否定（例如 `RMLUI_THIRDPARTY_CONTAINERS`）；这就是为什么某些 recipe 选项与其 CMake 对应项的语义相反。

| Conan 选项               | 可能的值               | 默认值  | 相关 CMake 选项          | 说明                                                             |
|----------------------------|-------------------------------|----------------|-------------------------------|-------------------------------------------------------------------------|
| enable_rtti_and_exceptions | [True, False]                 | True           | `RMLUI_CUSTOM_RTTI`           | --                                                                      |
| font_interface             | ["freetype", None]            | "freetype"     | `RMLUI_FONT_ENGINE`           | 当 Conan 选项设置为 `None` 时定义该 CMake 选项      |
| matrix_mode                | ["column_major", "row_major"] | "column_major" | `RMLUI_MATRIX_ROW_MAJOR`      | 当 Conan 选项设置为 `row_major` 时定义该 CMake 选项 |
| with_lua_bindings          | [True, False]                 | False          | `RMLUI_LUA_BINDINGS`          | --                                                                      |
| with_thirdparty_containers | [True, False]                 | True           | `RMLUI_THIRDPARTY_CONTAINERS` | --                                                                      |

上述选项可以根据个人偏好写在 [conanfile.py](https://docs.conan.io/2/reference/conanfile.html) 或 [conanfile.txt](https://docs.conan.io/2/reference/conanfile_txt.html) 中。

不受支持的 CMake 选项及其原因如下：
- `RMLUI_SAMPLES` 会构建库的示例用法，这将显著增加 Conan 生成的预构建二进制包的大小。为避免这种情况，该选项不被提供且始终禁用。不过，可以随时在本地编辑 recipe 来试用它们。
- `RMLUI_PRECOMPILED_HEADERS` 要求的最低 CMake 版本 Conan 总是可以提供，并且它能在没有明显缺点的情况下缩短构建时间，因此始终启用它是合理的。
- `RMLUI_TRACY_PROFILING` 需要一个截至撰写本文时无法从 Conan 中央仓库获取的依赖，因此无法支持。

`RMLUI_CUSTOM_CONFIGURATION` CMake 选项及与其相关的其他选项（`RMLUI_CUSTOM_CONFIGURATION_FILE`、`RMLUI_CUSTOM_INCLUDE_DIRS` 和 `RMLUI_CUSTOM_LINK_LIBRARIES`）使得内嵌的 [robin-hood-hashing](https://conan.io/center/recipes/robin-hood-hashing) 库可以被升级。

如果 recipe 已过时或无法满足某些需求，欢迎向 [conan-center-index](https://github.com/conan-io/conan-center-index) 贡献。


### 使用 Devbox 构建
{:#devbox}

[Devbox](https://www.jetify.com/docs/devbox) 是一个基于 Nix 的包管理器，提供超过 120,000 个包，涵盖许多不同的编程语言，而不仅仅是 C/C++。它的设计目标是让使用 Nix 包变得简单，并且不要求用户了解 Nix 语言。你可以在 [nixos.org](https://search.nixos.org/packages) 或 [nixhub.io](https://www.nixhub.io/) 上搜索包。下面介绍如何使用 Devbox 构建 RmlUi：

1. 安装 [Devbox 包管理器](https://www.jetify.com/docs/devbox/installing-devbox)
2. `git clone https://github.com/mikke89/RmlUi.git`
3. `cd RmlUi`
4. `devbox init`
5. 可选：全局添加 CMake 包：`devbox global add cmake`
6. `devbox add freetype freetype.dev glfw3`
7. `devbox shell`
8. 构建项目：
```
cmake -B Build -S . --preset samples \
      -DRMLUI_BACKEND=GLFW_GL3 \
      -DCMAKE_C_COMPILER=clang \
      -DCMAKE_CXX_COMPILER=clang++ \
      -DCMAKE_PREFIX_PATH="$DEVBOX_PACKAGES_DIR"
cmake --build Build
```


### 在 Windows 上构建
{:#windows}

本节面向 Visual Studio 用户，但该过程也应当可以移植到其他环境。

除 CMake 之外，你还需要一份 FreeType 库，官方支持版本 2.13.3，不过较新的版本通常向后兼容。你可以从[这里](https://github.com/ubawurinna/freetype-windows-binaries)找到预构建的 Windows 动态二进制文件。如果目录 `RmlUi/Dependencies/freetype`{:.path} 不存在，请创建它，并将 FreeType 文件复制到这里。将 FreeType 库文件 `RmlUi/Dependencies/freetype/release dll/win64/freetype.lib`{:.path} 移动到新位置 `RmlUi/Dependencies/lib/freetype.lib`{:.path}，并将包含目录 `RmlUi/Dependencies/freetype/include`{:.path} 移动到父目录 `RmlUi/Dependencies/include`{:.path}。

接下来，启动 `cmake-gui` 并在这里浏览到你的 RmlUi 源码。选择在 `RmlUi/Build`{:.path} 下构建二进制文件。点击 configure 并选择你的 Visual Studio 版本。现在会出现一些选项。有关其中一些选项的说明，请参阅下面章节中的 CMake 选项。如果你想查看随附的示例，请启用 `RMLUI_SAMPLES` 选项并将 `RMLUI_BACKEND` 设置为 `Win32_GL2`。你可能稍后想为[附加功能](https://github.com/mikke89/RmlUi#rmlui-backends)选择其他后端，但从这个入手很容易。最后，点击 `Generate`。如果成功，你的 Visual Studio 解决方案文件应该位于 `RmlUi/Build/RmlUi.sln`{:.path}。

![cmake-gui](../../assets/images/cmake-gui.png)

如果你使用 FreeType 的动态二进制版本，请将 `RmlUi/Dependencies/freetype/release dll/win64/freetype.dll`{:.path} 文件复制到 RmlUi 应用程序可以找到它的位置，例如 `RmlUi/Build`{:.path}。默认情况下，从 Visual Studio 启动应用程序时，这里就是工作目录。

打开生成的 Visual Studio 解决方案文件。现在除了 `rmlui_core` 和 `rmlui_debugger` 项目之外，应该还有几个示例可用。如果你设置了构建示例的 CMake 选项，现在可以右键点击 `rmlui_samples_invaders`，然后点击 `Set as Startup Project`。最后，按 `F5` 开始构建，并在完成后打开 invaders 演示。尽情享受吧！


### 在 macOS 和 Linux 上构建
{:#macos-and-linux}

打开终端窗口，导航到 RmlUi 文件夹，并运行以下命令：

```
cmake -B Build -S . -DRMLUI_SAMPLES=ON
cmake --build Build -j
```

这将连同所有示例一起构建 RmlUi，请参阅下面的所有可用 [CMake 选项](#cmake-options) 列表。假设一切顺利，示例将位于 `Build`{:.path} 文件夹下。例如，要查看 `invaders` 示例，请运行以下命令：

```
Build/rmlui_sample_invaders
```

尽情享受吧！

或者，`ccmake` 工具可提供更具交互性的体验，它允许你列出并设置所有可用的 CMake 选项。同样，在终端窗口中导航到 RmlUi 文件夹，然后执行以下命令：

```
ccmake -B Build -S .
```

*注意*：`-B` 参数设置目标构建目录，而 `-S` 表示 `CMakeLists.txt`{:.path} 所在的源目录。

这将打开一个文本模式应用程序，让你选择要构建 RmlUi 的哪些部分以及如何构建。在你能更改任何选项之前，需要按 `C` 以便 CMake 扫描你的系统配置。完成后你将看到一个选项列表。如果你想查看随附的示例，请启用 `RMLUI_SAMPLES` 选项。

做出选择后，再次按 `C`，以便 CMake 根据你的选择重新计算构建设置。一旦 CMake 满意，你将能够按 `G` 生成构建配置，然后退出。

此时你应该回到终端，`Makefile`{:.path} 已经创建。现在你可以通过执行 make 来构建 RmlUi。

```
cmake --build Build -j
```

*注意*：`-j` 参数告诉构建工具使用并行构建。

构建完成后，你可能想要查看一下示例。


### 使用 Emscripten 构建
{:#emscripten}

RmlUi 可以使用 [Emscripten](https://emscripten.org/) 编译为 WebAssembly，这使得库可以在 Web 上或其他 wasm 运行时中运行。按照 Emscripten 网站上的说明开始操作，确保你已为你的平台下载并安装了该软件。如果你在 Windows 上，我们建议按照下面的说明使用 [WSL](https://learn.microsoft.com/en-us/windows/wsl/install)。通过在终端中运行 `emcc -v`（应输出版本信息）来验证一切正常。

RmlUi 中的 CMake 配置使随附的示例能够以 Emscripten 为目标。要构建示例，首先在终端中找到 RmlUi 源目录，创建一个子目录并进入。
```
mkdir Build
cd Build
```
然后输入以下命令来配置 CMake 并为每个示例构建 WebAssembly 目标。
```
emcmake cmake .. -DRMLUI_SAMPLES=ON -DBUILD_SHARED_LIBS=OFF
emmake make -j8
```
现在每个目标都应该被编译成其生成的 WebAssembly `.wasm` 文件，以及一个包含所有相关资源的 `.data` 文件，还有允许在 Web 浏览器中启动示例的 `.html` 和 `.js` 文件。请注意，直接打开其 html 文件时 web assembly 程序不会运行，而是必须像 [Emscripten 教程](https://emscripten.org/docs/getting_started/Tutorial.html#generating-html) 中描述的那样通过本地 web 服务器提供。

要启动编译好的示例，首先在同一目录中启动一个 web 服务器，例如 Python 3 自带的那个。
```
python3 -m http.server
```
之后，你可以打开 Web 浏览器并导航到任意示例。例如 `demo` 示例应位于 `http://localhost:8000/demo.html`，`invaders` 示例位于 `http://localhost:8000/invaders.html`。

所有示例都使用 [`SDL_GL3`](https://github.com/mikke89/RmlUi/blob/master/Backends/RmlUi_Backend_SDL_GL3.cpp) 后端来面向 Emscripten。欢迎查看其源代码，了解如何为你的应用程序做同样的事情。


### CMake 预设
{:#cmake-presets}

RmlUi 为一些常见工作流提供了 [CMake 预设](https://cmake.org/cmake/help/latest/manual/cmake-presets.7.html)：

- `samples` 启用示例，但仅限那些没有额外依赖的示例。
- `samples-all` 启用所有示例，包括需要额外依赖的示例。
- `standalone` 不依赖任何库构建，以 `bitmap_font` 示例为特色。
- `dev` 在示例之外启用测试。
- `dev-all` 在示例之外启用测试，包括需要额外依赖的测试。

这些可以在 CMake 配置期间使用，例如 `cmake -B Build --preset <preset> ...`。预设应与工具链所需的任何选项组合使用，例如在使用单配置生成器时通过 `CMAKE_BUILD_TYPE` 选择所需的构建类型。你也可以在 `CMakeUserPresets.json` 文件中指定自己的预设，可能继承提供的预设。


### CMake 选项
{:#cmake-options}

本节列出可以在 CMake 配置期间传递的 RmlUi 选项及其默认值。每个选项都可以在命令行上配置、在 [CMake 用户预设](https://cmake.org/cmake/help/latest/manual/cmake-presets.7.html) 文件中定义，或在父级 CMake 项目中设置。例如，以下命令将配置库以构建示例，使用 GLFW 配合 OpenGL 3 后端，调试模式：

```
cmake -B Build -S . -DRMLUI_SAMPLES=ON -DRMLUI_BACKEND=GLFW_GL3 -DCMAKE_BUILD_TYPE=DEBUG
```

以下列表还列出了导出的宏，当更改某些默认选项时，必须在消费项目中定义这些宏。使用生成的 CMake 目标时，这些通常在导入库时自动处理，否则需要手动定义。


#### CMake 标准选项

`BUILD_SHARED_LIBS` `ON`{:.value}
: 构建共享库（动态库，.dll/.so/.dylib），而非静态库（.lib/.a）。<br>
    *导出宏：* 当为 `OFF`{:.value} 时 `RMLUI_STATIC_LIB`

`BUILD_TESTING` `OFF`{:.value}
: 构建随附的测试和基准测试。这会启用三个独立的可执行文件，详情参见 [测试套件 readme](https://github.com/mikke89/RmlUi/tree/master/Tests)。
    - `rmlui_benchmarks`{:.value}。对库的各个组件进行基准测试，以发现性能热点并跟踪任何回归。
    - `rmlui_unit_tests`{:.value}。测试库的较小单元以确保正确性。
    - `rmlui_visual_tests`{:.value}。一个全面的测试套件，特别用于可视化测试布局引擎，并带有自动截图和比较。

`CMAKE_BUILD_TYPE`
: CMake 标准选项，用于为单配置生成器选择构建类型。可选值之一：Debug、Release、RelWithDebInfo、MinSizeRel。

#### 常见选项

`RMLUI_BACKEND` `auto`{:.value}
: 根据[受支持的组合](https://github.com/mikke89/RmlUi#rmlui-backends)选择用于示例的后端，该组合由平台和渲染器组成（例如 `GLFW_GL3`{:.value}），或 `auto`{:.value}，或 `native`{:.value}。

`RMLUI_SAMPLES` `OFF`{:.value}
: 启用以构建随附的示例。

#### 插件与依赖

`RMLUI_FONT_ENGINE` `freetype`{:.value}
: 从以下选项中选择默认字体引擎：
    - `freetype`。使用 FreeType 生成文本。
    - `none`。不使用默认字体引擎，从而允许用户完全移除 FreeType 依赖。如果设置，则必须在初始化之前通过 `Rml::SetFontEngineInterface` 创建并设置自定义字体引擎。有关自定义字体引擎的示例实现，请参阅 `bitmapfont` 示例。

`RMLUI_HARFBUZZ_SAMPLE` `OFF`{:.value}
: 启用 `harfbuzz` 示例。需要 [HarfBuzz](https://github.com/harfbuzz/harfbuzz) 依赖。

`RMLUI_LOTTIE_PLUGIN` `OFF`{:.value}
: 启用 [Lottie 插件](lottie.html) 和示例。需要 [rlottie](https://github.com/Samsung/rlottie) 依赖。

`RMLUI_LUA_BINDINGS` `OFF`{:.value}
: 构建 Lua 支持所需的绑定。你需要安装 Lua。启用以下选项：
    - `RMLUI_LUA_BINDINGS_LIBRARY` `lua`{:.value}<br>
    选择用于 Lua 绑定的 Lua 库，选项之一：
        - `lua`。链接到 Lua。
        - `lua_as_cxx`。链接到以 C++ 编译的 Lua，禁用 `extern C` 头文件包装器。*导出宏：* `RMLUI_LUA_AS_CXX`。
        - `luajit`。链接到 LuaJIT。

`RMLUI_SVG_PLUGIN` `OFF`{:.value}
: 启用 [SVG 插件](svg.html) 和示例，需要 [LunaSVG](https://github.com/sammycage/lunasvg) 依赖。

`RMLUI_TRACY_PROFILING` `OFF`{:.value}
: RmlUi 在库的部分位置使用标记标注了 [Tracy Profiler](https://github.com/wolfpld/tracy) 的分析标记。这样可以直观地检查单个帧上的瓶颈和卡顿。要使用分析支持编译库，请确保 Tracy Profiler 对 CMake 可用，例如通过包管理器安装库，或将其添加到 RmlUi 目录中的 `/Dependencies/tracy/`{:.path}。然后，启用此选项并编译。按照 Tracy Profiler 的说明构建并连接单独的查看器。启用以下选项：
    - `RMLUI_TRACY_CONFIGURATION` `ON`{:.value}<br>
    CMake 设置将尝试添加一个名为 'Tracy' 的新配置，可以在例如 Visual Studio 中 'Debug' 和 'Release' 配置旁边选择，否则分析器将在整个项目上启用。
    - `RMLUI_TRACY_MEMORY_PROFILING` `ON`{:.value}<br>
    默认情况下，启用 Tracy profiling 时，RmlUi 将覆盖 C++ 中的全局 new 和 delete 运算符，以提供分配统计信息。将其关闭为 `OFF`{:.value} 以禁用对全局运算符的覆盖。

    *导出宏：* 当为 `ON`{:.value} 时，为启用的配置导出 `RMLUI_TRACY_PROFILING`。

#### 后端选项

`RMLUI_BACKEND_SIMULATE_TOUCH` `OFF`{:.value}
: 在后端中从鼠标事件模拟触摸事件。这对于在没有触摸支持的平台上测试触摸输入很有用。仅在选定的后端中实现，如果当前配置不支持，将发出 CMake 警告。

#### 构建与安装选项

`RMLUI_COMPILER_OPTIONS` `ON`{:.value}
: 让 RmlUi 在提供的目标上设置某些编译器特定的选项，例如受支持的警告标志和多进程构建。

`RMLUI_INSTALL_RUNTIME_DEPENDENCIES` `ON`{:.value}
: 在受支持的平台上自动安装运行时依赖（例如 DLL）。

`RMLUI_PRECOMPILED_HEADERS` `ON`{:.value}
: 在受支持的编译器上启用预编译头文件的使用，以加快编译时间。这需要 CMake 3.16 或更高版本。

#### 示例特定选项

`RMLUI_IME_SAMPLE_USE_NOTO_FONTS` `OFF`{:.value}
: 启用后可在构建时下载 Noto 字体，用于 `ime` 示例。使用 SDL 后端启用该示例时需要此项。

#### 高级自定义

`RMLUI_CUSTOM_CONFIGURATION` `OFF`{:.value}
: RmlUi 的默认配置 `<RmlUi/Config/Config.h>`{:.incl} 可以通过启用此选项来覆盖。通过这种方式，可以将包括容器在内的若干类型替换为其他 STL 兼容容器（例如 [EASTL](https://github.com/electronicarts/EASTL)），或替换为带有自定义分配器的 STL 容器。启用此选项后，可以设置三个新变量：
    - `RMLUI_CUSTOM_CONFIGURATION_FILE`<br>
        设置新配置文件的路径，默认配置可以作为创建该文件的模板。例如 `MyRmlUiConfig.h`{:.path}。<br>
        *导出宏：* `RMLUI_CUSTOM_CONFIGURATION_FILE`。
    - `RMLUI_CUSTOM_INCLUDE_DIRS`<br>
        可选地设置新配置文件可能需要的附加包含目录。例如 `C:\MyProject\`{:.path}。
    - `RMLUI_CUSTOM_LINK_LIBRARIES`<br>
        可选地设置要链接的附加库。

`RMLUI_MATRIX_ROW_MAJOR` `OFF`{:.value}
: 默认情况下，RmlUi 使用列主序矩阵实现。启用此选项后，矩阵类型将更改为行主序表示。<br>
    *导出宏：* 当为 `ON`{:.value} 时 `RMLUI_MATRIX_ROW_MAJOR`。

`RMLUI_THIRDPARTY_CONTAINERS` `ON`{:.value}
: RmlUi 附带了一些第三方容器库以提高性能。对于希望使用 `std` 对应物的用户，可以关闭此选项。选定的容器通过预处理器定义引入。<br>
    *导出宏：* 当为 `OFF`{:.value} 时 `RMLUI_NO_THIRDPARTY_CONTAINERS`。
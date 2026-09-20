---
layout: page
title: 将 RmlUi 集成到你的应用程序中
parent: cpp_manual
next: core_overview
---

本指南将帮助你在准备好将 RmlUi 集成到自己的应用程序中时快速上手。这里假设你已经按照上一步[构建或安装了该库](building_with_cmake.html)，或者已下载了预构建的包二进制文件。

如果你还没有这样做，请查看 [`/Samples/`{:.path}](https://github.com/mikke89/RmlUi/tree/master/Samples) 中的示例应用程序。在那里你可以找到大量关于如何使用乃至"滥用"RmlUi 的有用示例。此外，请务必查看一个或多个随附的后端（位于 [`/Backends/`{:.path}](https://github.com/mikke89/RmlUi/tree/master/Backends)），因为它们为让一个基本应用程序与 RmlUi 一起运行提供了良好的起点。


### 设置构建环境

RmlUi 按照 C++17 标准和跨平台架构进行开发。

大多数支持 C++17 的编译器应该都能受支持。我们的测试套件涵盖多个平台上的多个版本的 Visual Studio、GCC、Clang。详情请参阅[最新的持续集成检查](https://github.com/mikke89/RmlUi/commits/master/)。

#### Conan 与 vcpkg

如果你使用 Conan 或 vcpkg 获取 RmlUi，那么库和包含路径应该已经为你设置好了。剩下唯一要做的事：

- 在源文件或头文件中添加 `#include <RmlUi/Core.h>` 以开始使用 RmlUi。

#### CMake 客户端项目
{:#cmake-project}

在你的项目的 `CMakeLists.txt` 中添加以下内容：

```cmake
find_package(RmlUi REQUIRED)
target_link_libraries(my_application PRIVATE RmlUi::RmlUi)
```

你可以通过定义 CMake 变量 `RmlUi_ROOT`，在命令行或 CMake preset 中传入 RmlUi 的构建或安装路径。例如，在你的应用程序目录中运行以下命令：

```cmd
cmake -B Build -S . -DRmlUi_ROOT="<path-to-rmlui>"
```

RmlUi 为源码内构建和安装都会生成 CMake 配置文件，因此无论哪种情况这应该都能正常工作。使用预构建的包二进制文件时，请解压文件，并根据你的项目所需的链接类型，将 RmlUi 路径指向 `Bin-Dynamic` 或 `Bin-Static` 文件夹之一。

也可以针对库的各个组件，例如 `RmlUi::Core` 或 `RmlUi::Debugger`。`RmlUi::RmlUi` 目标链接到所有可用的组件。

然后，在你的应用程序中的源文件或头文件中添加 `#include <RmlUi/Core.h>` 以开始使用 RmlUi。

#### Visual Studio

- 将 RmlUi 包含路径 `RmlUi/Include/`{:.path} 添加到项目的包含路径中。
    - 请参阅 `Project → Properties → C/C++ → General → Additional Include Directories`{:.path}。
- 将 RmlUi 库路径（`RmlUi/Build`{:.path} 目录下相应的 `Debug/`{:.path} 和 `Release/`{:.path}）以及 FreeType 库路径添加到库路径中。
    - 请参阅 `Project → Properties → Linker → General → Additional Library Directories`{:.path}。
- 链接 `rmlui.lib`{:.path} 和 `freetype.lib`{:.path}。
    - 请参阅 `Project → Properties → Linker → Input → Additional Dependencies`{:.path}。
- 如果你将 RmlUi 构建为静态库，请添加以下预处理器定义：`RMLUI_STATIC_LIB`。
    - 请参阅 `Project → Properties → C/C++ → Preprocessor → Preprocessor Definitions`{:.path}。
- 如果你将 RmlUi 构建为共享/动态库，请将相应的 DLL 复制到你的可执行文件将运行的目录中。
    - 即从 `RmlUi/Build`{:.path} 文件夹或发布包中的 `Bin-Dynamic`{:.path} 文件夹中，为调试构建复制 `Debug/rmlui.dll`{:.path}，为发布构建复制 `Release/rmlui.dll`{:.path}。
- 如果你将 FreeType 构建为共享/动态库，请将 `freetype.dll` 文件复制到你运行可执行文件的目录中。
- 在源文件或头文件中添加 `#include <RmlUi/Core.h>` 以开始使用 RmlUi。

#### Linux 与 MacOS

- 将 RmlUi 包含路径 `RmlUi/Include/`{:.path} 和库路径 `RmlUi/Build`{:.path} 添加到构建系统的路径中。
- 链接 `rmlui` 和 `freetype`。
- 要么将 RmlUi 库复制到应用程序的工作目录中，要么设置一个 `LD_LIBRARY_PATH`（MacOS 为 `DYLD_LIBRARY_PATH`）环境变量。
- 当库构建为静态库时，在你的项目中添加 `RMLUI_STATIC_LIB` 作为预处理器定义。
- 在源文件或头文件中添加 `#include <RmlUi/Core.h>` 以开始使用 RmlUi。


### 初始化 RmlUi

在你可以初始化 RmlUi 之前，你需要设置该库用于与你的应用程序交互的[接口](interfaces.html)。有一个必需的接口，即渲染接口。此外，一些应用程序可能希望定义自定义系统接口以获得额外功能。

#### 渲染接口

渲染接口在 `<RmlUi/Core/RenderInterface.h>`{:.incl} 中定义。它为 RmlUi 提供了一种将其几何体发送到你的应用程序渲染管线的方式。如果你想尽快让 RmlUi 运行起来，请看下面描述的随附后端。

一旦你为你的应用程序有了渲染接口，通过调用 `Rml::SetRenderInterface()` 将其安装到 RmlUi 中。请注意，你必须保持渲染接口存活到调用 `Rml::Shutdown()` 之后，然后销毁它。RmlUi 不会释放你的接口。

如果你想深入了解如何设置自己的渲染接口，请参阅[渲染接口文档](interfaces/render.html)。

#### 系统接口

系统接口在 `<RmlUi/Core/SystemInterface.h>`{:.incl} 中定义。它提供了一些实用工具来执行常见任务，如记录消息、翻译字符串或设置鼠标光标。

为了创建系统接口，你需要创建一个继承自 `Rml::SystemInterface` 的类。根据你的应用程序的需求覆盖任何所需函数。通过用指向接口的指针调用 `Rml::SetSystemInterface()` 来安装系统接口。请注意，你必须保持系统接口存活到调用 `Rml::Shutdown()` 之后，然后销毁它。RmlUi 不会释放你的接口。

有关系统接口的更多用途，请参阅[文档](interfaces/system.html)。

#### 后端集成
{:#backends}

为简化上述接口的编写，RmlUi 附带多个*后端*，它们为各种渲染器和平台提供渲染和系统接口。所有可用的后端都列在[仓库 README](https://github.com/mikke89/RmlUi#rmlui-backends) 中，并位于 [`/Backends/`{:.path}](https://github.com/mikke89/RmlUi/tree/master/Backends) 目录中。

一个后端通常由三个源文件及其各自的头文件组成：

- 一个集成渲染接口的*渲染器*（renderer），
- 一个集成系统接口并提交输入事件的*平台*（platform），
- 以及最后的*后端*本身 —— 将前两者结合在一起。

如果你找到一个匹配你设置的后端，建议直接使用底层的渲染器和平台，并在你的应用程序中编译它们。它们也被设计为可扩展的，例如添加加载其他纹理格式的能力。后端本身用作如何为该平台和渲染器的组合打开窗口、处理事件以及与 RmlUi 交互的示例。

下表列出了平台或渲染器特定的编译定义：

| Platform or renderer                           | Define                    | Allowed values | Default value | Explanation  |
|------------------------------------------------|---------------------------|----------------|---------------|------------- |
| SDL&nbsp;platform&nbsp;&amp; SDL&nbsp;renderer | `RMLUI_SDL_VERSION_MAJOR` | `2` or `3`     | *not defined* | Specify the SDL major version to be used. If not defined, a compile error will occur. |
| OpenGL 3                                       | `RMLUI_NUM_MSAA_SAMPLES`  | Integer        | `2`           | Number of MSAA samples to use for framebuffers constructed by RmlUi for anti-aliasing. Set to `0` to disable MSAA. |
| OpenGL 3                                       | `RMLUI_GL3_CUSTOM_LOADER` | Include path   | *not defined* | Specify the include path to the header of a custom OpenGL loader. When not defined, the built-in [glad-based loader](https://github.com/premake-libs/glad) will be used. Users are themselves responsible for initializing and shutting down any custom loader, on the other hand, the built-in loader will automatically be initialized and shutdown during the calls to `RmlGL3::Initialize` and `RmlGL3::Shutdown`, respectively. |

##### 示例

如果你将 SDL 与 OpenGL 3 一起使用，可以在你的项目中直接添加以下源文件作为依赖：

- [`/Backends/RmlUi_Platform_SDL.cpp`{:.path}](https://github.com/mikke89/RmlUi/blob/master/Backends/RmlUi_Platform_SDL.cpp)。
- [`/Backends/RmlUi_Renderer_GL3.cpp`{:.path}](https://github.com/mikke89/RmlUi/blob/master/Backends/RmlUi_Renderer_GL3.cpp)。

然后，你可以使用 `SDL_GL3` 后端（[`/Backends/RmlUi_Backend_SDL_GL3.cpp`{:.path}](https://github.com/mikke89/RmlUi/blob/master/Backends/RmlUi_Backend_SDL_GL3.cpp)）作为起点或示例参考。这个特定的后端还演示了如何扩展渲染器以加载其他纹理格式。

以下内容演示了在使用 CMake 构建脚本时，如何在你的应用程序中包含 `SDL_GL3` 后端。这里，SDL 3 与自定义 OpenGL 加载器一起使用，并提高了 MSAA 质量。记得另外将 [`/Backends/RmlUi_Backend_SDL_GL3.cpp`{:.path}](https://github.com/mikke89/RmlUi/blob/master/Backends/RmlUi_Backend_SDL_GL3.cpp) 的内容复制到你的项目中，并按需修改。

```cmake
set(RMLUI_BACKEND_PATH ${RmlUi_SOURCE_DIR}/Backends)
add_library(rmlui_backend_SDL_GL3 INTERFACE)
target_sources(rmlui_backend_SDL_GL3 INTERFACE
	${RMLUI_BACKEND_PATH}/RmlUi_Platform_SDL.cpp
	${RMLUI_BACKEND_PATH}/RmlUi_Renderer_GL3.cpp
)
target_include_directories(rmlui_backend_SDL_GL3 INTERFACE ${RMLUI_BACKEND_PATH})
target_compile_definitions(rmlui_backend_SDL_GL3 INTERFACE
	RMLUI_SDL_VERSION_MAJOR=3
	RMLUI_NUM_MSAA_SAMPLES=4
	RMLUI_GL3_CUSTOM_LOADER=<glad/gl.h>
)
target_link_libraries(my_application PRIVATE
	RmlUi::RmlUi
	SDL3::SDL3
	SDL3_image::SDL3_image
	rmlui_backend_SDL_GL3
)
```

#### 初始化库

一旦你安装了系统和渲染接口，调用全局函数 `Rml::Initialise()`，RmlUi 就会启动。


### 创建上下文

RmlUi 中的所有元素都是一个上下文的一部分。你必须至少有一个上下文才能加载、操作和渲染界面元素。要创建上下文，请使用 `Rml::CreateContext()` 函数，像这样传入新上下文的名称及其初始尺寸：

```cpp
Rml::Context* context = Rml::CreateContext("default", Rml::Vector2i(myScreenWidth, myScreenHeight));
```

当你使用完上下文后，可以通过调用 `Rml::RemoveContext(context->GetName())` 释放它。所有上下文在关闭时都会自动销毁。

#### 更新与渲染

你的应用程序将需要适当地更新和渲染它维护的每个上下文。在必要的时候在每个上下文上调用 `Context::Update()` 函数来更新上下文（通常是在帧的输入注入之后），并在应用程序渲染循环中的适当位置调用 `Context::Render()`。


### 加载字体

RmlUi 没有附带集成任何字体（调试器插件除外），它们必须由用户提供。字体可以通过 [`Rml::LoadFontFace()`](fonts.html) 函数加载，或通过样式表中的 [`@font-face`](../rcss/fonts.html#font-face) 规则加载。

```cpp
bool success = Rml::LoadFontFace("assets/my_font_face.ttf");
```


### 加载文档

一旦你有一个有效的上下文，你可以使用 `LoadDocument()` 函数将文档加载到上下文中。`LoadDocument()` 接受一个参数，即文档文件名字符串。如果加载成功，你将得到一个 `Rml::ElementDocument` 的指针；在文档上调用 `Show()` 使其可见。

```cpp
Rml::ElementDocument* document = context->LoadDocument("../../assets/demo.rml");
if (document)
	document->Show();
```

通过调用 `Close()` 卸载文档。

```cpp
document->Close();
```

**注意**：附加到文档或其任何子元素的事件监听器不得被销毁，直到下一次调用 `Context::Update()` 或 `Rml::Shutdown()` 为止。


### 注入输入

一旦你有了文档在加载和渲染，下一步就是将你的输入注入 RmlUi。上下文对象有一系列函数用于向系统发送鼠标、键盘、文本和触摸输入：

```cpp
// Sends a key down event into this context.
bool ProcessKeyDown(Rml::Input::KeyIdentifier key_identifier, int key_modifier_state);
// Sends a key up event into this context.
bool ProcessKeyUp(Rml::Input::KeyIdentifier key_identifier, int key_modifier_state);

// Sends a single unicode character (code point) as text input into this context.
bool ProcessTextInput(Rml::Character character);
// Sends a string of UTF-8 text input into this context.
bool ProcessTextInput(const Rml::String& string);

// Sends a mouse movement event into this context.
bool ProcessMouseMove(int x, int y, int key_modifier_state);
// Sends a mouse-button down event into this context.
bool ProcessMouseButtonDown(int button_index, int key_modifier_state);
// Sends a mouse-button up event into this context.
bool ProcessMouseButtonUp(int button_index, int key_modifier_state);
// Sends a mouse-wheel movement event into this context.
bool ProcessMouseWheel(float wheel_delta, int key_modifier_state);

// Process touch movements for this context.
bool ProcessTouchMove(const TouchList& touches, int key_modifier_state);
// Process touch start (press) for this context.
bool ProcessTouchStart(const TouchList& touches, int key_modifier_state);
// Process touch end (release) for this context.
bool ProcessTouchEnd(const TouchList& touches, int key_modifier_state);
// Process touch cancel for this context.
bool ProcessTouchCancel(const TouchList& touches);
```

在调用 `Update()` 之前，调用适当的输入函数在每帧注入所有相关的用户输入到你的 RmlUi 上下文中。请注意，RmlUi 不会将按键转换为文本；这由应用程序负责。请务必查看随附的后端，因为它们为不同平台提供按键转换和事件处理。有关每个函数的更多信息，请参阅[用户输入手册](input.html)。


### 调试器

`RmlDebugger`{:.incl} 插件是 RmlUi 元素的可视化调试器，其灵感来自于 Web 浏览器的类似调试器。我们强烈建议你在开发期间在应用程序中使用它！

要使用 RmlDebugger，在你的应用程序中包含 `<RmlUi/Debugger.h>`{:.incl} 并链接 `RmlDebugger`{:.incl}。有关用法详情，请参阅[调试器插件](debugger.html)的文档。


### 下一步去哪里？

既然你已经对 RmlUi 有了（非常！）简短的介绍，建议你阅读[核心概览](core_overview.html)以了解 RmlUi 的组成。从那里开始，要么逐步阅读文档，要么深入代码并在必要时查阅。
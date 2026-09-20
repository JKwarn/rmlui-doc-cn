---
layout: page
title: 入门
parent: lua_manual
next: embedding_script
---

RmlUi 的 Lua 插件可用于扩展或嵌入 Lua 的应用程序中。您的应用程序仍然需要初始化 RmlUi 核心库并提供必要的 System 与 Render 接口，有关如何初始化 RmlUi 的详细信息，请参阅 [C++ 手册](../cpp_manual.html)。

有关完整的类型和方法列表，请参阅 RmlUi Lua [API 参考](api_reference.html)。

### 要求

- [Lua 5.1+](https://www.lua.org/)

已使用推荐的 Lua 5.3 版本进行测试，但我们的目标是兼容 Lua 5.1 及更新版本，包括对 LuaJIT 的支持。此外还有一个非官方的 Lua 插件 [RmlSolLua](https://github.com/LoneBoco/RmlSolLua)，它基于 sol3，兼容 Lua 5.1。

### Lua 插件集成

执行以下步骤即可将 Lua 插件与 RmlUi 集成。

1. 安装或构建 Lua 库，您可以使用官方的 [Lua.org](https://www.lua.org) 实现或 [LuaJIT](http://luajit.org/luajit.html)。
    - 对于官方实现，我们建议以 C++ 而非 C 的方式构建库，以便在出错时能够正确展开堆栈。以 C 方式构建时，Lua 解释器在出错时会调用 longjmp，这会导致任何当前正在执行的 C++ 扩展函数中的局部变量析构函数被跳过。软件包管理器通常只提供以 C 方式编译的 Lua，因此要获得此功能，您需要自行以 C++ 方式构建。

2. 启用 Lua 插件构建 RmlUi。详细信息请参阅 C++ 手册中的[使用 CMake 构建](../cpp_manual/building_with_cmake.html)。
    - 在 CMake 配置期间启用 `RMLUI_LUA_BINDINGS` 选项。
    - 将 `RML_LUA_BINDINGS_LIBRARY` 选项设置为合适的解释器类型：`lua_as_cxx`、`lua` \[以 C 方式]，或 `luajit`。
    - 您可能还需要通过将 `LUA_DIR` 设置为 Lua 目录，来引导 CMake 找到 Lua 库。
    - 我们还建议您同时启用 `RMLUI_SAMPLES` 选项来启用示例，并尝试构建 `rmlui_sample_luainvaders` 目标，以测试一切是否正常工作。

3. 以链接核心 RmlUi 库的相同方式，链接 `rmlui_lua` 库或 `RmlUi::Lua` CMake 导入目标。

4. 在您的应用程序内部，照常设置并初始化 RmlUi，请参阅 C++ 手册中的[集成 RmlUi](../cpp_manual/integrating.html)。

5. 在您的 C++ 源文件中包含 Lua 插件头文件：`#include <RmlUi/Lua.h>`。

6. 最后，通过一次调用 `Rml::Lua::Initialise();` 初始化 Lua 库。
    - 此调用应在调用 `Rml::Initialise();` 之后立即进行。
    - 也可以通过调用 `Rml::Lua::Initialise(lua_State* L);` 来提供您自己的 Lua 状态（lua state）。

完成 Lua 插件集成后，您就可以开始在 RML 文档中[嵌入 Lua 脚本](embedding_script.html)了。
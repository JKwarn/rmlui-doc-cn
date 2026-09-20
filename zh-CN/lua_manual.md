---
layout: page
title: Lua 手册
---

RmlUi 的 Lua 接口在设计上尽可能贴近 Javascript。由于语言本身的特性，这一点在 Lua 中比在 C++ 中更有可能做到。

RmlUi 的功能在 [C++ 手册](cpp_manual.html)中有完整描述；本手册定义的是 Lua 接口，对应其中描述的 {{page.lib_name}} 对象。并非 RmlUi 的所有方面都可以从 Lua 访问；例如，自定义装饰器只能在 C++ 中创建。不过绝大多数功能都是可访问的，使您能够轻松高效地开发文档的功能。

一个很好的入门途径是随库附带的 `luainvaders` 示例，它演示了 Lua 插件的许多功能。

### 集成 Lua

1. [入门](lua_manual/getting_started.html)
2. [嵌入脚本](lua_manual/embedding_script.html)
3. [加载字体](lua_manual/fonts.html)
4. [绑定事件](lua_manual/attaching_to_events.html)

### 接口

1. [元素](lua_manual/elements.html)
2. [文档](lua_manual/documents.html)
3. [上下文](lua_manual/contexts.html)
4. [事件](lua_manual/events.html)

### 附录

1. [API 参考](lua_manual/api_reference.html)
---
layout: page
title: 事件
parent: lua_manual
---

### 接口

- [Event Lua API 参考](api_reference.html#Event)
- [Event C++ 手册](../cpp_manual/events.html)

事件可用的所有属性与方法都在 API 参考中有详细描述。事件特有的接口与 C++ 接口类似，完整文档请参阅该手册。


### 全局变量

当事件被触发并被 Lua 脚本捕获时，会在被调用函数的上下文中设置三个全局变量。

- `element` 事件触发的元素上下文。
- `document` 事件触发的文档。
- `event` 事件对象。

有关用法详细信息，请参阅 Lua 文档中的[绑定事件](attaching_to_events.html)。
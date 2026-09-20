---
layout: page
title: 上下文
parent: lua_manual
next: events
---

### 接口

- [Context Lua API 参考](api_reference.html#Context)
- [Context C++ 手册](../cpp_manual/contexts.html)

上下文可用的所有属性与方法都在 API 参考中有详细描述。上下文特有的接口包含 C++ 接口的一个子集，完整文档请参阅该手册。

#### 检索文档

上下文上的 `documents` 属性是一个可以迭代的代理元素（Lua 表）。

```lua
for i,document in ipairs(context.documents) do
	print('Document ' .. i .. ': ' .. document.title)
end
```

或者，它也可以用作字典，通过文档的 ID 进行查询：

```lua
document = context.documents['highscores']
```

或者将文档作为 `documents` 属性本身的属性来访问：

```lua
document = context.documents.highscores
```

#### 创建上下文

在 Lua 中，可以通过 `rmlui` 全局变量上的 `CreateContext()` 函数创建上下文。该函数接受字符串形式的上下文名称和 `Vector2i` 类型的尺寸。

```lua
new_context = rmlui:CreateContext('hud', Vector2i.new(1024, 768))
```

#### 访问上下文

现有上下文可以通过 `rmlui` 全局变量上的 contexts 成员在 Lua 中访问，随后可以通过名称或索引访问。

```lua
context = rmlui.contexts['hud']
```

列出所有上下文：

```lua
for i,context in ipairs(rmlui.contexts) do
	print('Context ' .. i .. ': ' .. context.name)
end
```
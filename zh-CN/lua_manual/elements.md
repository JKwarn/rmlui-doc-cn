---
layout: page
title: 元素
parent: lua_manual
next: documents
---

### 接口

- [元素 Lua API 参考](api_reference.html#Element)
- [元素 C++ 手册](../cpp_manual/elements.html)

元素可用的所有属性与方法都在 API 参考中有详细描述。元素特有的接口与 C++ 接口类似，完整文档请参阅该手册。

RmlUi 元素的 Lua 接口与 Web 的 [DOM 元素接口](https://developer.mozilla.org/en-US/docs/Web/API/element) 非常相似，这一点与 C++ 元素接口也是一致的。

#### 代理属性

在内部实现中，某些属性返回代理（proxy），这些代理通常可以像数组或映射（Lua 表）一样使用。尤其以下所描述的属性。

`child_nodes` 返回一个类数组的代理，用于访问子元素。该数组仅包含可见元素，Lua 插件无法查询[隐藏元素](../cpp_manual/hidden_elements.html)。下面的示例遍历元素的所有子元素，打印它们的标签名、id 和类名。该示例需要 Lua `string` 标准库。

```lua
for i,child in ipairs(element.child_nodes) do
	address = child.tag_name

	if child.id ~= '' then
		address = address .. '#' .. child.id
	end

	for token in string.gmatch(child.class_name, '[%w]+') do
	   address = address .. '.' .. token
	end

	print(address)
end
```

该代理对象可以通过索引访问。请注意，在 Lua 中索引从 1 开始，这与 C++ API 中从 0 开始不同。

```lua
element.child_nodes[2].inner_rml = 'Hello world!'
```

`attributes` 可以像映射一样通过名称和值的键值对来访问。下面的示例打印元素的 `value`{:.attr} 属性。

```lua
print(element.attributes.value)
```

`style` 是一个属性，其行为与 Javascript 中的对应属性完全相同。属性按名称作为 style 属性的成员来访问，并且可以读取或写入。在此上下文中，属性的值始终是未解析的字符串；即 `200px`{:.value}、`center`{:.value}、`rgb(255,0,0)`{:.value} 等。

下面的示例演示了 style 属性的用法：

```lua
element.style.width = '150px'
if element.style.float ~= 'none' then
	element.style.clear = 'left'
end
```

### 派发事件

可以在 Lua 内部使用 `DispatchEvent()` 函数在元素上生成事件。调用此函数时，参数以键值对的 Lua 表形式给出。

```lua
element:DispatchEvent('open', {object = 'trapdoor', priority = 11})
```

参数键必须是字符串，值必须是字符串、布尔值或数字。

### 创建元素

可以在 Lua 中使用文档的 `CreateElement()` 或 `CreateTextNode()` 方法动态创建元素。下面的代码示例使用 `CreateElement()` 动态创建一个表单控件。

```lua
input_element = document:CreateElement('input')
input_element = document:AppendChild(input_element)
input_element:SetAttribute('type', 'radio')
input_element:SetAttribute('name', 'graphics')
input_element:SetAttribute('value', 'ok')
```
***Note:*** 新创建的元素不能立即修改，因为 `CreateElement` 返回 `ElementPtr`，而 `ElementPtr` 无法使用 `SetAttribute`。我们可以通过使用 `AppendChild` 的返回值来解决这个问题。更多信息请参阅[此问题](https://github.com/mikke89/RmlUi/issues/390)。
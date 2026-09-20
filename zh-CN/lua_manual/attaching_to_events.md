---
layout: page
title: 绑定事件
parent: lua_manual
next: elements
---

### 在 RML 中静态绑定

使用 Lua 绑定事件的最简单方法是通过 `on*`{:.attr} 属性将代码直接写入 RML 文件。事件触发时会设置三个全局变量：`document`、`event` 和 `element`。

[element](elements.html)  | 当前正在处理的元素。
[document](documents.html) | 当前正在处理的元素所属的文档。
[event](events.html) | 当前正在处理的事件。

示例：

```html
<button onclick="print('Clicked!')"/>
```

与普通 Lua 一样，可以调用多条语句。

示例：

```html
<button onclick="print('Line 1') print('Line 2')"/>
```

### 从 Lua 代码动态绑定

Lua 版本的 `AddEventListener` 直接以 Javascript 为蓝本。这使您可以将任何可调用的 Lua 函数或字符串绑定到事件。

方法 1：

```lua
function Init(document)			
	element = document:GetElementById('button')
	element:AddEventListener('click', "print('Line 1') print('Line 2')", true)
end
```

方法 2：

```lua
function OnClick()
	for i=1,10 do print('Line ' .. i) end
end

function Init(document)			
	element = document:GetElementById('button')
	element:AddEventListener('click', OnClick, true)
end
```
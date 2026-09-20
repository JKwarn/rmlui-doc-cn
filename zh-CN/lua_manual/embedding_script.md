---
layout: page
title: 嵌入 Lua 脚本
parent: lua_manual
next: fonts
---

使用 Lua 插件时，可以将 Lua 代码嵌入到 RML 文件中。事件的内联响应会作为 Lua 代码执行。函数、结构和变量可以通过 `<script>`{:.tag} 标签声明或包含，然后从内联代码中引用。

### 内联事件响应

Lua 插件安装了一个事件监听器实例化器（instancer），用于将内联事件响应作为 Lua 代码执行。例如，在下面的示例中，元素在被点击时会执行 print 命令：

```html
<button onclick="print('Hello world!')" />
```

同样可以执行多条语句。

```html
<button onclick="print('Hello') print('world!')" />
```
内联事件处理器可以访问三个全局变量，它们是：

* `event`：当前正在处理的事件（即触发处理器的事件）。
* `element`：当前正在响应事件的元素。
* `document`：当前元素所属的文档。

```html
<button onclick="print(element.tag_name)" />
<button onclick="print(event.parameters.mouse_x .. ', ' .. event.parameters.mouse_y)" />
```

有关它们的完整 Lua 接口，请参阅[元素](elements.html)、[文档](documents.html)和[事件](events.html)文档。

### 将 Lua 嵌入 RML

可以使用 `<script>`{:.tag} 标签将 Lua 代码嵌入到 RML 文档中。与 Javascript 类似，脚本可以通过 `src`{:.attr} 属性从单独的文件中包含，也可以作为 `<script>`{:.tag} 标签内的松散内容以内联方式声明。以这种方式嵌入的任何代码都会随文档一起编译，并可供 RML 中的内联事件处理器使用。例如，以下文档在 `<script>`{:.tag} 标签中声明了一个 Lua 函数，并从元素的 `click`{:.evt} 处理器中调用它。

```html
<rml>
	<head>
		<script>
function Test()
	print('Hello world!')
end
		</script>
	</head>
	<body>
		<button onclick="Test()">Continue</button>
	</body>
</rml>
```

下面的示例导入 `test.lua`{:.path} 文件，而不是以内联方式声明脚本（假定该 Lua 文件声明了一个 `Test()` 函数）。

```html
<rml>
	<head>
		<script src="test.lua"></script>
	</head>
	<body>
		<button onclick="Test()">Continue</button>
	</body>
</rml>
```

一个文档可以包含多个 `<script>`{:.tag} 标签。
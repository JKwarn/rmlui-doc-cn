---
layout: page
title: RML 文档结构
parent: rml
next: style_sheets
---

### \<rml\>

所有 RmlUi 文档都以 `<rml>`{:.tag} 元素开头。该元素应包含两个子元素 `<head>`{:.tag} 和 `<body>`{:.tag}，如下面的文档基本结构所示。

```html
<rml>
	<head>
		<title>...</title>
		<link type="text/rcss" href="style.rcss"/>
		...
	</head>
	<body>
		...
	</body>
</rml>
```

### \<head\>

`<head>`{:.tag} 元素包含有关当前文档的信息，例如其标题、样式以及所引用的模板信息。头部中的任何信息都不会被渲染。

### \<title\>

`<title>`{:.tag} 元素包含文档的标题。这通常用于指定游戏窗口标题栏的内容。

### \<link\>

`<link>`{:.tag} 元素用于指定文档所需的附加资源。

_属性_

`type`{:.attr} = cdata (CI)
: 链接的类型，应为以下之一：
* text/rcss - [RmlUi 样式表规范](../rcss.html)
* text/template - [RmlUi 模板](templates.html)

`href`{:.attr} = cdata (CS)
: 指定源 URI，相对于正在解析的文档。

### \<script\>

`<script>`{:.tag} 元素可用于集成脚本功能。需要插件来处理脚本，例如 [Lua 插件](../lua_manual.html)。

_属性_

`src`{:.attr} = cdata (CS)
: 指定源 URI，相对于正在解析的文档。

如果不存在 `src`{:.attr} 属性，则该元素为内联脚本，其内容表示要运行的脚本。

### \<body\>

`<body>`{:.tag} 元素包含文档的内容。`<body>`{:.tag} 标签内的所有元素都会成为文档树的一部分，并在布局期间按照活动样式表的规则进行处理。
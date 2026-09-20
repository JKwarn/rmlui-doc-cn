---
layout: page
title: RML 模板
parent: rml
next: syntax
---

### \<template\>

`<template>`{:.tag} 元素有两个用途：定义模板，以及将模板内联注入现有的 RML 文档。

定义模板时，应使用 `<template>`{:.tag} 代替 `<rml>`{:.tag}。

_属性_

`name`{:.attr} = cdata (CI)
: 模板的名称。必须唯一。其他 RML 文档使用它来引用该模板。

`content`{:.attr} = idref (CI)
: 内容将被放入的元素的 id。

注入模板时，`<template>`{:.tag} 标签内的所有元素都将被放入模板的内容元素中。

`src`{:.attr} = cdata (CS)
: 对于内联模板，是要注入的模板的名称。

### \<body\>

`<body>`{:.tag} 元素具有一个 `template`{:.attr} 属性，该属性是在 body 标签周围注入模板的简写形式。

_属性_

`template`{:.attr} = cdata (CS)
: 要使用的模板的名称。`<body>`{:.tag} 元素下的所有子元素都将被加载到模板中。


### 示例

首先定义一个模板文件 `basic.rml`：

```html
<template name="basic" content="content">
<head>
	<link type="text/rcss" href="style.rcss"/>
</head>
<body class="window">
	<h1>Header</h1>
	<p id="content"></p>
</body>
</template>
```

#### 正文模板

然后可以在文档中按如下方式将该模板用作正文模板。


```html
<rml>
	<head>
		<title>Basic document</title>
		<link type="text/template" href="basic.rml" />
	</head>
	<body template="basic">
		A paragraph.
	</body>
</rml>
```

然后，将模板注入，文档正文内容被插入到模板中定义的 `#content` 元素内。最终的文档结构如下：

```
body.window
  h1         "Header"
  p#content  "A paragraph."
```

#### 内联模板

也可以使用 `<template src="[name]">` 元素将模板内联插入到文档中。

```html
<rml>
	<head>
		<title>Basic document</title>
		<link type="text/template" href="basic.rml" />
	</head>
	<body>
		<img src="header.png"/>
		<div id="template_parent">
			<template src="basic">
				Another paragraph.
			</template>
		</div>
	</body>
</rml>
```

得到的文档结构如下：

```
body
  img
  div#template_parent
    h1         "Header"
    p#content  "Another paragraph."
```

请注意，在这种情况下，模板中的 body 类不会被插入。不过，头部（包括样式）会正常插入。
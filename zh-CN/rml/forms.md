---
layout: page
title: RML 表单
parent: rml
next: controls
---

表单是 `<form>`{:.tag} 元素内的一组输入元素 —— 当表单被“提交”时，存储在每个子输入元素中的信息都会被发送给监听进程。

另请参阅[表单控件 C++ 文档]({{"pages/cpp_manual/element_packages/form.html"|relative_url}})。

### \<form\>

_属性_

`onsubmit`{:.attr} = cdata (CI)
: 表单被提交时触发的事件的名称。所有表单子元素的值都会作为参数传递给事件。

#### \<form\> 子元素

以下元素可作为 `<form>`{:.tag} 元素的子元素：`<input>`{:.tag}、`<textarea>`{:.tag} 和 `<select>`{:.tag} 元素。它们有许多共同的属性，如下所列。任何特定属性随后会在各自的标题下列出。

_属性_

`name`{:.attr} = cdata (CI)
: 输入元素的名称。表单提交时用于查找元素的值。对于 radio 类型，它用于对单选按钮进行分组，使得具有相同名称的按钮中只能有一个同时被选中。

`value`{:.attr} = cdata (CN)
: 对于 `text`{:.value}、`password`{:.value} 和 `range`{:.value} 类型，用作元素的初始值。对于 `radio`{:.value} 和 `checkbox`{:.value} 类型，如果输入被选中，则用作提交的值。对于 `<option>`{:.tag} 元素，如果它是被选中的选项，则这是父级 `<select>`{:.tag} 提交的值。

`disabled`{:.attr} (CI)
: 如果设置了该属性，则输入元素将无法接收焦点，也无法被用户输入更改。

`autofocus`{:.attr} (CI)
: 当文档以默认参数显示时，第一个设置了该属性的可见控件元素将获得焦点。详细信息请参见[文档可见性](../cpp_manual/documents.html#visibility)。

#### \<input\>

_属性_

`type`{:.attr} = cdata (CI)
: 输入字段的类型。必须为以下之一：
* `text`{:.value} - 单行文本输入字段。
* `password`{:.value} - 与 text 类似，但输入的文本会用星号替换。
* `radio`{:.value} - 单选按钮。
* `checkbox`{:.value} - 复选框。
* `range`{:.value} - 滑块条。
* `button`{:.value} - 按钮。
* `submit`{:.value} - 用于提交表单的按钮。

##### text 与 password 类型

`size`{:.attr} = number (CN)
: 对于 text 和 password 类型，定义元素的长度（以字符为单位）。

`maxlength`{:.attr} = number (CN)
: 对于 text 和 password 类型，定义元素可接受的最大长度（以字符为单位）。

`placeholder`{:.attr} = cdata (CN)
: 对于 text 和 password 类型，定义当元素值为空时显示的占位文本。可以使用 `:placeholder-shown`{:.cls} [伪类](../rcss/selectors.html#pseudo-selectors)进行样式化。

##### radio 与 checkbox 类型

`checked`{:.attr} (CI)
: 对于 radio 和 checkbox 类型，如果设置了该属性，则元素为“开”。

##### range 类型

`min`{:.attr} = number (CN)
: 对于 range 类型，定义滑块最低端（左侧或顶部）的值。

`max`{:.attr} = number (CN)
: 对于 range 类型，定义滑块最高端（右侧或底部）的值。

`step`{:.attr} = number (CN)
: 对于 range 类型，定义滑块移动的增量。

`orientation`{:.attr} = cdata (CI)
: 对于 range 类型，指定它是垂直滑块还是水平滑块。值可以为 `horizontal`{:.value} 或 `vertical`{:.value}。

#### \<textarea\>

_属性_

`cols`{:.attr} = number (CN)
: 文本域可见区域的宽度，以文本列数表示。

`rows`{:.attr} = number (CN)
: 文本域可见区域的高度，以文本行数表示。

`wrap`{:.attr} = cdata (CI)
: 如果设置为 `nowrap`{:.value}，文本域将不会把未断行的文本换到新行。

`maxlength`{:.attr} = number (CN)
: 元素可接受的最大长度（以字符为单位）。

`placeholder`{:.attr} = cdata (CN)
: 定义当文本域值为空时显示的占位文本。可以使用 `:placeholder-shown`{:.cls} [伪类](../rcss/selectors.html#pseudo-selectors)进行样式化。

#### \<select\>

`<select>`{:.tag} 没有额外的参数。

##### \<option\>

_属性_

`selected`{:.attr} (CI)
: 如果设置，则 `<select>`{:.tag} 元素首次加载时该选项将被选中。

**注意**：可以使用 `disabled`{:.attr} 属性使选项无法被用户选择。这对于标记选项组很有用。

#### \<label\>

标签将表单输入字段与说明文字关联起来。当用户将鼠标悬停在标签上或点击标签时，该操作将被转发给目标元素。

可以通过在 `for`{:.attr} 属性中提供 ID 来指定目标元素。否则，当省略时，标签将把第一个具有以下标签之一的子元素作为目标：`<button>`{:.tag}、`<input>`{:.tag}、`<textarea>`{:.tag}、`<progress>`{:.tag} 或 `<select>`{:.tag}。

_属性_

`for`{:.attr} = idref (CI)
: 如果设置，标签元素将以具有给定 ID 的元素为目标。否则，标签将把第一个具有有效标签（见上文）的子元素作为目标。

```html
<label><input type="checkbox" value="pizza"/> Pizza</label>

<div class="left">
	<input type="checkbox" value="pasta" id="pasta"/>
</div>
<div class="right">
	<label for="pasta">Pasta</label>
</div>
```
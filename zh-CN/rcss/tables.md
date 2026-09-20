---
layout: page
title: 表格
parent: rcss
next: user_interface
---

RCSS 中的表格支持与 [CSS 表格规范](https://www.w3.org/TR/2011/REC-CSS2-20110607/tables.html)类似。有一些增强和差异，主要如下。

##### 增强

- 列的宽度和行的高度支持灵活伸缩，分别使用 `<percentage ≥ 100%>`{:.value} 作为宽度或高度（就像在网格布局中使用 CSS `fr` 单位一样）。
- 列宽和行高会遵循最小和最大尺寸约束。
- 行之间和列之间的间距可以使用外边距、边框和内边距单独控制。

##### 差异

- 列宽的计算方式与设置 CSS 属性 `table-layout: fixed`{:.prop} 相同，并带有上述增强。
- 边框和背景分别应用于表格中存在的每个单独元素。
    - 行元素必须存在，才能为行生成所指定的边框。
    - 表格单元格不会从它们所属的列元素继承任何属性，宽度调整除外。
- RmlUi 不会生成匿名元素，也不会尝试清理无效的表格。
- 百分比相对值基于表格元素的初始块大小计算，如果表格大小在格式化期间发生变化，不会重新调整。
- 表格不支持收缩适配宽度，例如在具有 auto 宽度的行内块或浮动元素中使用时，或在自动宽度缩放的 flexbox 布局中使用时。在这种情况下，请设置明确的（非 auto）表格宽度，否则表格将被调整为零宽度。

### RCSS 表格模型

RCSS 表格模型遵循 CSS 表格的结构。这意味着表格由表格行组成，行可选地包裹在行组中，行组包含单独的单元格。表格列和列组可以可选地指定用于视觉效果（主要是背景、边框和装饰器）以及定义列的宽度。列永远不会直接包含单元格。表格列和列组必须位于任何行或行组之前。表格单元格可以作为表格的直接子元素放置，然后连续的单元格会形成一个新行。

`display`{:.prop} 属性用于定义表格的格式化，相关取值如下。

`display`{:.prop} 取值        | 说明                     | 属性 | 有效的子元素
----------------------------- | ------------------------- | ---- | --------------
`table`{:.value}              | 指定一个块级表格。        | | `table-row`{:.value}、`table-row-group`{:.value}、<br>`table-column`{:.value}、`table-column-group`{:.value}、<br>`table-cell`{:.value}
`inline-table`{:.value}       | 指定一个行内级表格。      | | *同上*
`table-row`{:.value}          | 指定一个表格行。          | | `table-cell`{:.value}
`table-row-group`{:.value}    | 指定一个表格行组。        | | `table-row`{:.value}
`table-column`{:.value}       | 指定一个表格列。          | `span`{:.value} |
`table-column-group`{:.value} | 指定一个表格列组。        | `span`{:.value}（当没有子元素时） | `table-column`{:.value}
`table-cell`{:.value}         | 指定一个表格单元格。      | `colspan`{:.value}、`rowspan`{:.value} |

特别地，以下 CSS `display`{:.prop} 模式*不*受支持：`table-header-group`{:.value}、`table-footer-group`{:.value}、`table-caption`{:.value}。在 RCSS 中，`inline-table`{:.value} 的宽度必须设置为明确的（非 auto）值。


#### 示例

以下示例演示了一个带行组和列组的表格，使用了所有表格显示模式。

```html
<table>
	<col/>
	<colgroup>
		<col span="2"/>
		<col/>
	</colgroup>
	<thead>
		<tr>
			<td>Name</td>
			<td colspan="2">Items</td>
			<td>Age</td>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>Gimli</td>
			<td>Helmet</td>
			<td>Axe</td>
			<td>139 years</td>
		</tr>
	</tbody>
	<tfoot>
		<tr>
			<td colspan="4">Footnote</td>
		</tr>
	</tfoot>
</table>
```

此示例假定应用了下面推荐的样式表。


#### 推荐样式表

与 HTML 不同，`table`{:.tag} 元素或任何其他表格标签在 RmlUi 中没有任何特殊含义。相反，它们完全由其 RCSS 属性派生而来。此外，RmlUi 不包含默认样式表，因此必须首先声明表格的 RCSS 属性。以下 RCSS 属性是使用 HTML 中的已知标签声明表格时的推荐写法。


```css
table {
	box-sizing: border-box;
	display: table;
}
tr {
	box-sizing: border-box;
	display: table-row;
}
td {
	box-sizing: border-box;
	display: table-cell;
}
col {
	box-sizing: border-box;
	display: table-column;
}
colgroup {
	display: table-column-group;
}
thead, tbody, tfoot {
	display: table-row-group;
}
```

### 表格的视觉布局

表格元素按以下顺序渲染，从底层到顶层：

1. 表格
2. 列组
3. 列
4. 行组
5. 行
6. 单元格

列组和列元素的大小被设置为覆盖它们所跨越的表格列。行组的大小被设置为覆盖它们所跨越的行。这样，背景、边框和装饰器就可以用于这些元素，并且如果单元格和行具有透明背景，它们将可见。


#### 表格宽度算法

表格宽度是所有表格列与水平表格间距之和，包括 `column-gap`{:.prop}、列外边距和表格内边距。

表格列的宽度完全由列元素和/或第一行单元格上指定的宽度定义。在下文中，*列*指上述任一元素。

- `width: auto`{:.prop} 的列平均分布以填满表格宽度。
- `width: <length> | <percentage < 100%>`{:.prop} 的列使用指定值。
- `width: <percentage ≥ 100%>`{:.prop} 的列相对于其他灵活列调整其灵活宽度（就像网格布局中的 CSS `fr` 单位一样）。
- 列可以指定 `min-width`{:.prop} 和 `max-width`{:.prop} 来约束其大小。

与 CSS 不同，列组和列可以使用水平 `padding`{:.prop}、`border`{:.prop} 和 `margin`{:.prop}。这会被添加到表格的水平间距中。列组和列也可以使用垂直 `border`{:.prop} 和 `margin`{:.prop} 来添加边框并将其从表格边缘偏移，但不会影响单元格的位置。


#### 表格高度算法

表格高度由所有行的高度之和加上垂直间距确定，包括 `row-gap`{:.prop}、行外边距和表格内边距。

每行的高度按如下方式确定：

- `height: auto`{:.prop} 的行通过该行中最高的已格式化单元格确定其高度。
- `height: <length> | <percentage < 100%>`{:.prop} 的行使用指定值。
- `height: <percentage ≥ 100%>`{:.prop} 的行相对于其他灵活行调整其灵活高度（就像网格布局中的 CSS `fr` 单位一样）。
- 行可以指定 `min-height`{:.prop} 和 `max-height`{:.prop} 来约束其大小。

如果各行没有填满表格上指定的高度，则所有行将按比例放大，同时遵循任何 `max-height`{:.prop} 约束。如果仍有可用空间，则表格底部会留下空白。

所有百分比值都使用表格的初始块高度来解析。因此，如果表格高度指定为 `auto`{:.value}，它们将解析为零。此时，应将表格高度设置为特定的长度。如果父元素的高度已指定，也可以使用百分比高度。

与 CSS 不同，行组和行可以使用垂直 `padding`{:.prop}、`border`{:.prop} 和 `margin`{:.prop}。这会被添加到表格的垂直间距中。行组和行也可以使用水平 `border`{:.prop} 和 `margin`{:.prop} 来添加边框并将其从表格边缘偏移，但不会影响单元格的位置。

`vertical-align`{:.prop}

当用于表格单元格时，此属性具有以下含义。

`top`{:.value}（*默认值*）
: 将表格单元格与其跨越的第一行的顶部对齐。

`bottom`{:.value}
: 将表格单元格与其跨越的最后一行的底部对齐。

`middle`{:.value}
: 将表格单元格与其跨越的行的中间对齐。

*其他*{:.value}
: 其他值在此上下文中没有含义，并默认为 `top`{:.value}。

对齐是通过向单元格元素添加顶部或底部内边距来完成的。与 CSS 不同，目前不支持 `baseline`{:.value}。


### 边框

在 RCSS 中为表格设置边框的模型类似于 CSS 中的分离边框模型（`border-collapse: separate`{:.value}）。也就是说，每个单元格元素分别控制自己的边框。然而，与 CSS 不同，边框仍然可以添加到行、行组、列和列组上。它们会与单元格边框分离，就像扩展其内部元素的边框一样。


#### 单元格间距
{:#gap}

`row-gap`{:.prop}、`column-gap`{:.prop}

取值： | \<length\> \| \<percentage\>
初始值： | 0px
适用于： | `table`{:.value} 元素
继承： | 否
百分比： | 分别相对于初始 flex 容器或表格块大小的高度和宽度

在 RCSS 中，这些属性除了适用于 [flexboxes](flexboxes.html#gap) 之外，也适用于表格。对于表格，它们指定表格单元格*之间*的间距。与 CSS 属性 `border-spacing`{:.prop} 类似，区别在于间距不会分别应用于第一个单元格之前和最后一个单元格之后。此时，请在表格元素上使用 `padding`{:.prop} 来在表格边框与其单元格之间添加间距。

`gap`{:.prop}

一个用于按顺序设置 `row-gap`{:.prop} 和 `column-gap`{:.prop} 属性的简写属性。如果只指定一个值，则两个间距属性都被设置为该值。
---
layout: page
title: Flexbox 布局
parent: rcss
next: animations_transitions_transforms
---

弹性盒子（flexbox）布局专为沿单一方向放置项目而设计。它允许对项目进行灵活伸缩，既可以收缩以避免溢出，也可以增长以填充容器。水平和垂直对齐都可以控制。综合起来，这些属性使这种布局方案对许多类型的用户界面都非常强大。

RmlUi 大体上遵循 [CSS 弹性盒子规范](https://www.w3.org/TR/css-flexbox-1/)，但存在一些较小的差异。网上有很多关于如何在 CSS 中编写 flexbox 布局的资源，例如 MDN 上的 [flexbox 简介](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Flexible_Box_Layout) 以及 CSS-Tricks 上关于 [flexbox 属性](https://css-tricks.com/snippets/css/a-guide-to-flexbox/) 的图解概述。

通过将元素的 [`display`{:.prop} 属性](visual_formatting_model.html#display)设置为 `display: flex`{:.value} 或 `display: inline-flex`{:.value} 来初始化 flexbox 布局。这会为该元素生成一个 flex 容器，其所有子元素都在此容器内被格式化为 flex 项目。在 RCSS 中，`inline-flex`{:.value} 盒子的宽度必须设置为明确的（非 auto）值。


### 基本示例

```css
.flex {
	display: flex;
	background: #66806a;
	padding: 3px;
}
.flex > div {
	background-color: #fff1af;
	padding: 10px;
	margin: 3px;
	flex: 1;
}
.flex > .double-width {
	flex: 2;
}
h2 {
	text-align: center;
	font-size: 1.3em;
	color: #243434;
	border-bottom: 1px #666;
}
```

```html
<div class="flex">
	<div>
		<h2>First column</h2>
		<p>Etiam libero lorem.</p>
	</div>
	<div>
		<h2>Second column</h2>
		<p>Ut volutpat, odio et facilisis molestie, lacus elit euismod enim.</p>
	</div>
	<div class="double-width">
		<h2>Third column</h2>
		<p>Lorem ipsum dolor sit amet.</p>
	</div>
</div>
```
##### 输出

渲染输出如下所示。请注意，所有列都具有相同的高度。这在弹性布局中很容易实现，但在任何其他布局模式下，当高度取决于内容时都很难做到。此外，最后一列的宽度始终恰好是前两列中每一列宽度的两倍。

<img alt="flexbox example" src="../../assets/images/flexbox-example.png" style="margin: 0 auto; display: block;">


### 与 CSS 的差异

##### 行为

- 不会从未换行的文本构造匿名 flex 项目。
- [自动最小尺寸](https://drafts.csswg.org/css-flexbox/#min-size-auto)仅在 flex 项目没有明确尺寸时才应用，并且仅在 column 模式下。
- 基线对齐只是近似的。
- 被拉伸的项目不会被[重新格式化](https://www.w3.org/TR/css-flexbox-1/#algo-stretch)。

##### 属性和取值

- 不支持 `order`{:.prop} 属性。
- 不支持 `flex-basis: content`{:.value} 属性值。
- 不支持 `visibility: collapse`{:.value} 属性值。


### 性能

为了获得最佳性能，请避免基于内容的尺寸计算，以防止多次格式化相同的 flex 项目：

- 使用 `flex: <number ≥ 1> `{:.value} 简写。
- 在 flex 项目上设置明确的高度（长度或百分比）——或在 column 布局中设置宽度。

当 flex 项目的格式化较复杂时，这一点越来越重要；在为较大的布局结构使用 flexbox 时则至关重要。上述规则也可以只用于给定 flex 容器中最苛刻的 flex 项目，而其他项目根据情况使用基于内容的尺寸计算。


### 方向

`flex-direction`{:.prop}
{:#flex-direction}

取值： | row \| row-reverse \| column \| column-reverse
初始值： | row
适用于： | flex 容器
继承： | 否
百分比： | 不适用

决定 flex 项目的布局方向——即*主轴（main axis）*。使用 `row`{:.value} 或 `row-reverse`{:.value} 时，主轴是水平的，而对于 `column`{:.value} 或 `column-reverse`{:.value}，主轴是垂直的。`-reverse`{:.value} 后缀使项目沿主轴按相反顺序排列。


`flex-wrap`{:.prop}
{:#flex-wrap}

取值： | nowrap \| wrap \| wrap-reverse
初始值： | nowrap
适用于： | flex 容器
继承： | 否
百分比： | 不适用

当沿主轴没有更多空间放置项目时，`wrap`{:.value} 和 `wrap-reverse`{:.value} 值使项目沿*交叉轴（cross axis）*换行到新的 flex 行。交叉轴定义为垂直于主轴。`wrap-reverse`{:.value} 值使各行按相反顺序排列。


`flex-flow`{:.prop}
{:#flex-flow}

一个用于按顺序设置 `flex-direction`{:.prop} 和 `flex-wrap`{:.prop} 属性的简写。


### 伸缩性

#### 'flex' 简写
{:#flex}

`flex`{:.prop}

取值： | auto \| none \| \<flex-grow\> \<flex-shrink\>? \<flex-basis\>? \| \<flex-basis\>
初始值： | 0 1 auto
适用于： | flex 项目
继承： | 否
百分比： | 不适用

一个用于设置 flex 项目灵活伸缩行为的简写属性。通常，以下简写形式应涵盖大多数用例：

`flex: *default*`{:.value}
: 等价于 `flex: 0 1 auto`{:.value}。项目将根据其内容大小确定尺寸，但如果容器太小，则允许按比例收缩以避免溢出。

`flex: auto`{:.value}
: 等价于 `flex: 1 1 auto`{:.value}。项目最初根据其内容大小确定尺寸，然后按比例收缩或增长以填满容器。

`flex: none`{:.value}
: 等价于 `flex: 0 0 auto`{:.value}。项目根据其内容大小确定尺寸，既不收缩也不增长。

`flex: <number ≥ 1> `{:.value}
: 等价于 `flex: <number> 1 0`{:.value}。项目按其给定的 `<number>`{:.value} 按比例确定尺寸并填满容器。这可以实现最佳性能。

从 `flex`{:.prop} 简写中省略时，`flex-grow`{:.prop} 和 `flex-shrink`{:.prop} 默认为 1，而 `flex-basis`{:.prop} 默认为 0。请注意，这与它们的初始值不同。

flexbox 尺寸计算算法也会遵循项目上给出的最小和最大尺寸约束。


#### 单独的伸缩属性

灵活尺寸属性也可以单独控制。

`flex-grow`{:.prop}
{:#flex-grow}

取值： | \<number\>
初始值： | 0
适用于： | flex 项目
继承： | 否
百分比： | 不适用

设置增长因子，允许项目从初始大小增长以匹配容器大小，从而填满容器。flex 项目将按其给定因子按比例增长。

`flex-shrink`{:.prop}
{:#flex-shrink}

取值： | \<number\>
初始值： | 1
适用于： | flex 项目
继承： | 否
百分比： | 不适用

设置收缩因子，允许项目从初始大小收缩以匹配容器大小，从而避免溢出。flex 项目将按其给定因子按比例收缩。

`flex-basis`{:.prop}
{:#flex-basis}

取值： | \<length\> \| \<percentage\> \| auto
初始值： | auto
适用于： | flex 项目
继承： | 否
百分比： | 相对于 flex 容器的内部主轴大小

设置 flex 项目的基础大小。也就是说，这给出项目在使用上述因子被增长或收缩之前的初始大小。指定为 `auto`{:.value} 时，将使用项目的收缩适配宽度——或者在 column 布局中使用自动块高度。否则，单位的解析方式与 [`width`{:.prop} 属性](visual_formatting_model_details.html#width) 相同。请注意，收缩适配宽度未对表格实现，因此当 `flex-basis`{:.prop} 为 `auto`{:.value} 时，它们将被视为零宽度盒子；此时，请设置明确的（非 auto）宽度或 flex 基础大小以确保正确的尺寸。


### 对齐

对齐发生在所有 flex 项目完成尺寸计算之后，决定任何可用空间如何在项目之间、flex 行内以及 flex 行之间分配。

#### 'margin' auto 对齐

当主轴或交叉轴方向有可用空间时，可以通过在所需方向上使用 `margin: auto`{:.value} 填充该空间来对齐 flex 项目。当单个轴上存在多个 auto 外边距时，它们将各自获得可用空间的相等比例。

请注意，由 auto 外边距填充的任何可用空间将不再留下空间来在该轴上使用 `justify-content`{:.prop} 或 `align-self`{:.prop} 进行对齐。

#### 主轴对齐

`justify-content`{:.prop}
{:#justify-content}

取值： | flex-start \| flex-end \| center \| space-between \| space-around \| space-evenly
初始值： | flex-start
适用于： | flex 容器
继承： | 否
百分比： | 不适用

决定项目沿主轴的对齐方式，即在 row 布局中的水平对齐。

#### 交叉轴对齐

`align-items`{:.prop}
{:#align-items}

取值： | flex-start \| flex-end \| center \| baseline \| space-around \| stretch
初始值： | stretch
适用于： | flex 容器
继承： | 否
百分比： | 不适用

决定项目沿交叉轴的对齐方式，即在 row 布局中的垂直对齐。

`align-self`{:.prop}
{:#align-self}

取值： | auto \| flex-start \| flex-end \| center \| baseline \| space-around \| stretch
初始值： | auto
适用于： | flex 项目
继承： | 否
百分比： | 不适用

仅为此项目覆盖父容器上指定的交叉轴对齐方式。

#### 打包 flex 行

`align-content`{:.prop}
{:#align-content}

取值： | flex-start \| flex-end \| center \| space-between \| space-around \| space-evenly \| stretch
初始值： | stretch
适用于： | 多行 flex 容器
继承： | 否
百分比： | 不适用

决定 flex 容器中的任何可用空间如何在多个 flex 行之间分配。

#### flex 项目之间的间距
{:#gap}

`row-gap`{:.prop}、`column-gap`{:.prop}

取值： | \<length\> \| \<percentage\>
初始值： | 0px
适用于： | flex 容器和 `table`{:.value} 元素
继承： | 否
百分比： | 分别相对于初始 flex 容器或表格块大小的高度和宽度

指定 flex 项目*之间*的间距，就像在相邻 flex 项目之间添加固定大小的外边距一样。在 RCSS 中，这些属性也可以用于[表格](tables.html#gap)。

`gap`{:.prop}

一个用于按顺序设置 `row-gap`{:.prop} 和 `column-gap`{:.prop} 属性的简写属性。如果只指定一个值，则两个间距属性都被设置为该值。
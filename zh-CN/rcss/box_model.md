---
layout: page
title: 盒模型
parent: rcss
next: visual_formatting_model
---

RCSS 盒模型描述了 RML 元素树中的每个元素在布局期间生成的盒子。它与 [CSS 盒模型](http://www.w3.org/TR/REC-CSS2/box.html)相同。请注意，RCSS 按规范实现了 CSS2 盒模型（有一个很小的例外），而不是旧的 IE 盒模型。关于盒模型需要注意的重要事项：

* `width`{:.prop} 和 `height`{:.prop} 属性设置内容区域的大小。任何边框和内边距都在内容区域之外计算，不像 IE 盒模型那样属于内容区域的一部分。
* 对于可替换元素（任何具有固有尺寸的元素，如输入框、图像、下拉列表等），边框和内边距被计算为内容区域的一部分；即它们使用 IE 盒模型。这样可以更方便地放置其内部元素。

元素生成的每个盒子都由四个区域组成：

* **内容区域（content area）**，包含元素的内容。
* **内边距（padding）**，环绕内容区域。
* **边框（border）**，环绕内边距区域。
* **外边距（margin）**，环绕边框区域。

内边距用于将元素的内部内容与元素边框隔开。边框可以用作元素的装饰性轮廓。外边距用于将元素与页面上的其他元素分隔开。

内容区域的大小由多种因素决定，例如生成盒子的元素类型、盒子的内容以及 `width`{:.prop} 和 `height`{:.prop} 属性的取值。内边距、边框和外边距的大小可以针对盒子的上、右、下、左四条边分别指定。

盒子的背景（以及 RmlUi 默认的[装饰器](decorators.html)）将渲染在元素的内边距区域内（即内容区域下方以及内边距边界之内）。边框仅沿边框边缘渲染。外边距始终是透明的（尽管自定义装饰器理论上可以渲染到这里）。

### 外边距属性
{:#margin}

`margin-top`{:.prop}、`margin-right`{:.prop}、`margin-bottom`{:.prop}、`margin-left`{:.prop}

取值： | \<length\> \| \<percentage\> \| auto
初始值： | 0px
适用于： | 所有元素
继承： | 否
百分比： | 相对于包含块的宽度

```css
/* 为所有 H1 元素设置 1em 的底部外边距。 */
h1
{
	margin-bottom: 1em;
}
```

这些属性设置盒子的上、右、下、左外边距。允许负值，这将使盒子的内容区域超出其正常边界。

设置为 `auto`{:.value} 的外边距根据生成盒子来计算；该算法在 CSS 规范中有完整说明，简单概括如下：对于块级元素，将计算方程 `margin-left + padding-left + width + padding-right + margin-right = 包含块宽度`，任何设置为 `auto`{:.value} 的外边距都会被均等设置以平衡方程。如果 `width`{:.value} 为 `auto`{:.value}，则任何 `auto`{:.value} 外边距都会被计算为 0。因此，将左右外边距都设置为 `auto`{:.value} 将产生使元素居中的效果。将左边距设置为 `auto`{:.value}、右边距设置为 `0`{:.value} 将使盒子右对齐，以此类推。顶部和底部外边距以类似的方式计算。对于行内元素，`auto`{:.value} 将计算为 0。

请注意，百分比外边距总是相对于包含块的宽度计算，即使对于顶部和底部外边距也是如此。

`margin`{:.prop}

一个用于一次性设置全部四个外边距属性的简写属性。如果只有一个值，则应用于所有边。如果有两个值，第一个应用于顶部和底部，第二个应用于左右。如果有三个值，第一个应用于顶部，第二个应用于左右，第三个应用于底部。如果有四个值，则分别应用于上、右、下、左。

```css
/* 在所有 div 元素上设置 1em 的顶部外边距、10px 的底部外边距以及 0px 的左右外边距。 */
div
{
	margin: 1em 0px 10px;
}
```

#### 外边距折叠

在 RmlUi 中，兄弟块级盒子之间的外边距按 CSS 的规定折叠，但嵌套外边距目前不会折叠。

### 内边距属性
{:#padding}

`padding-top`{:.prop}、`padding-right`{:.prop}、`padding-bottom`{:.prop}、`padding-left`{:.prop}

取值： | \<length\> \| \<percentage\>
初始值： | 0px
适用于： | 所有元素
继承： | 否
百分比： | 相对于包含块的宽度

这些属性设置盒子的上、右、下、左内边距。不允许负值。

请注意，与外边距一样，百分比内边距值总是相对于包含块的宽度计算，即使对于顶部和底部也是如此。

```css
/* 为缩进一级标题指定左内边距。 */
h1, h2
{
	padding-left: 0.5em;
}
```

`padding`{:.prop}

一个用于一次性设置全部四个内边距属性的简写属性。如果只有一个值，则应用于所有边。如果有两个值，第一个应用于顶部和底部，第二个应用于左右。如果有三个值，第一个应用于顶部，第二个应用于左右，第三个应用于底部。如果有四个值，则分别应用于上、右、下、左。

```css
/* 为 textarea 指定统一的内边距。 */
textarea
{
	padding: 15px;
}
```

### 边框属性

_注意_：不支持 `border-style`{:.prop} 属性。所有边框都渲染为实线。

#### 边框宽度
{:#border-width}

`border-top-width`{:.prop}、`border-right-width`{:.prop}、`border-bottom-width`{:.prop}、`border-left-width`{:.prop}

取值： | \<length\> \| \<percentage\>
初始值： | 0px
适用于： | 所有元素
继承： | 否
百分比： | 相对于包含块的宽度

这些属性设置盒子的边框宽度。请注意，不支持 CSS 的 `thin`{:.value}、`medium`{:.value} 和 `thick`{:.value} 值，但支持百分比。

`border-width`{:.prop}

一个用于一次性设置全部四个边框宽度属性的简写属性。如果只有一个值，则应用于所有边。如果有两个值，第一个应用于顶部和底部，第二个应用于左右。如果有三个值，第一个应用于顶部，第二个应用于左右，第三个应用于底部。如果有四个值，则分别应用于上、右、下、左。

```css
/* 在所有一级标题下方设置一条细边框。 */
h1
{
	border-bottom-width: 1px;
}
```

#### 边框颜色
{:#border-color}

`border-top-color`{:.prop}、`border-right-color`{:.prop}、`border-bottom-color`{:.prop}、`border-left-color`{:.prop}

取值： | \<color\>
初始值： | black
适用于： | 所有元素
继承： | 否
百分比： | 不适用

这些属性指定盒子各边框边的颜色。

`border-color`{:.prop}

一个用于一次性设置全部四个边框颜色属性的简写属性。如果只有一个值，则应用于所有边。如果有两个值，第一个应用于顶部和底部，第二个应用于左右。如果有三个值，第一个应用于顶部，第二个应用于左右，第三个应用于底部。如果有四个值，则分别应用于上、右、下、左。
边框简写属性

#### 边框简写
{:#border}

`border-top`{:.prop}、`border-right`{:.prop}、`border-bottom`{:.prop}、`border-left`{:.prop}

用于设置一条边框边的宽度和颜色的简写属性。

```css
h1
{
	border-bottom: 2px rgb(0%, 23%, 80%);
}
```

`border`{:.prop}

用于设置元素边框的简写属性。它设置 `border-width`{:.prop} 和 `border-color`{:.prop} 的值。

```css
h1
{
	border: 4px #e99;
}
```
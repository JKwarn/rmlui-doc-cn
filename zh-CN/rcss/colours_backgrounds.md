---
layout: page
title: 颜色、背景与圆角
parent: rcss
next: fonts
---

### 前景色：'color' 属性
{:#color}

`color`{:.prop}

取值： | \<colour\>
初始值： | black
适用于： | 所有元素
继承： | 是
百分比： | 不适用

此属性设置所渲染文本和文本装饰的颜色。

### 背景颜色
{:#background-color}

在 RCSS 中，元素的背景可以设置为纯色，但不能设置为图像。此功能（以及更多功能！）由[装饰器](decorators.html)提供。

`background-color`{:.prop}

取值： | \<colour\>
初始值： | transparent
适用于： | 所有元素
继承： | 否
百分比： | 不适用

此属性设置元素生成的盒子的颜色。背景颜色渲染在盒子的内边距区域下方。

`background`{:.prop}

`background-color`{:.prop} 的别名。

### 盒阴影
{:#box-shadow}

盒阴影在元素盒子的周围或内部产生阴影效果。阴影被放置在元素的背景上。

要使用盒阴影，后端渲染器必须支持高级渲染功能，详见[渲染接口功能表](../cpp_manual/interfaces/render.html#feature-table)。

`box-shadow`{:.prop}

取值： | none \| \[ \<color\>? \<offset-x\> \<offset-y\> \<blur-radius\>? \<spread-radius\>? inset? \]<span class="prop-def-symbol" title="One or more comma-separated occurrences">#+</span>
初始值： | none
适用于： | 所有元素
继承： | 否
百分比： | 不适用

取值含义如下。

\<color\>
: 阴影的颜色。

\<offset-x\> \<offset-y\> = \<length\> \<length\>
: 这两个值设置阴影相对于元素的偏移。正值会将阴影放置在元素右下方。

\<blur-radius\> = \<length\>
: 决定模糊效果的大小。默认为零，即没有模糊效果。

*注意*：模糊和投影 [滤镜](filters.html) 使用*标准差*而非模糊半径来指定应用的模糊量。标准差相当于模糊半径的一半。这一差异源于 CSS 规范。

\<spread-radius\> = \<length\>
: 决定阴影*扩散（spread）*的大小。本质上，它使阴影在全方位上变大。允许负值使其变小。默认为零，使阴影与元素本身大小相同。

inset
: 通过指定此关键字，阴影将被放置在盒子内部而不是外部。

<img alt="border-radius" src="../../assets/images/box-shadow.png" style="max-width: 70%">

下面展示了一些盒阴影示例。

```css
/* 单个盒阴影 */
box-shadow: #000a 5px 5px 5px;

/* 多个盒阴影 */
box-shadow: #f008 40px 30px 0px 0px, #00f8 -40px -30px 0px 0px;

/* 内阴影 */
box-shadow: #000a 5px 5px 5px inset;

/* 堆叠的盒阴影 */
box-shadow:
    #f66 30px 30px 0 0,
    #c88 60px 60px 0 0,
    #baa 90px 90px 0 0;

/* 彩色盒阴影 */
box-shadow:
    #f00f  40px  30px 25px 0px,
    #00ff -40px -30px 45px 0px,
    #0f08 -60px  70px 60px 0px,
    #333a  0px  0px 30px 15px inset;
```

### 圆角
{:#border-radius}

<img alt="border-radius" src="../../assets/images/border-radius.png" style="max-width: 50%">

边界半径属性可用于绘制圆角背景和边框。

`border-top-left-radius`{:.prop}、`border-top-right-radius`{:.prop}、`border-bottom-right-radius`{:.prop}、`border-bottom-left-radius`{:.prop}

取值： | \<length\>
初始值： | 0px
适用于： | 所有元素
继承： | 否
百分比： | 不适用

这些属性为给定的角设置外边框边缘的半径。背景和边框将相应地被塑形。装饰器并不总是遵循此属性，目前只有[渐变装饰器](decorators/gradient.html)会正确地裁剪到圆角。请注意，与 CSS 不同，RmlUi 不支持百分比或椭圆值（每个角两个值）。

*注意*：为了获得美观的效果，渲染器在绘制此属性生成的几何体时应启用抗锯齿。

`border-radius`{:.prop}

一个用于一次性设置全部四个边界半径属性的简写属性。如果只有一个值，则应用于所有角。如果有两个值，第一个应用于左上角和右下角，第二个应用于左下角和右上角。如果有三个值，第一个应用于左上角，第二个应用于左下角和右上角，第三个应用于右下角。如果有四个值，则分别应用于左上、右上、右下、左下。

### 不透明度
{:#opacity}

可以在任何元素上设置不透明度。然后，为该元素生成的几何体会将顶点颜色的 alpha 通道乘以该不透明度。

`opacity`{:.prop}

取值： | \<number\>
初始值： | 1
适用于： | 所有元素
继承： | 是
百分比： | 不适用

### 图像颜色：'image-color' 属性
{:#image-color}

`image-color`{:.prop}

取值： | \<colour\>
初始值： | white
适用于： | \<img\> 元素和[装饰器](decorators.html)
继承： | 否
百分比： | 不适用

RCSS 对 CSS 的扩展，它将一种颜色与 `<img>`{:.tag} 标签和图像装饰器中的图像相乘。可用于 `:hover`{:.cls} 伪类和应用透明度。

示例：
```css
image-color: rgba(255, 160, 160, 200);
decorator: image( background.png );
```
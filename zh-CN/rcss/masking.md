---
layout: page
title: 遮罩
parent: rcss
next: filters
---

遮罩（masking）是一种通过使用另一个图形对象来定义要遮挡的部分，从而隐藏元素部分内容的方式。在 RmlUi 中，遮罩图像可以使用装饰器生成，生成的遮罩图像的 alpha 通道将用于完全或部分遮挡元素及其子元素。

要使用遮罩，后端渲染器必须支持高级渲染功能，详见[渲染接口功能表](../cpp_manual/interfaces/render.html#feature-table)。

![Filters from the `effects` sample](../../assets/images/mask-image.png)

### 遮罩图像
{:#mask-image}

遮罩图像属性提供了一种使用装饰器（包括图像和渐变）定义遮罩的方式。它的指定方式与 [`decorator`{:.prop} 属性](decorators.html#decorator) 相同，并且可以与相同的装饰器一起使用。生成的遮罩图像的 alpha 通道定义遮罩，并将用于确定元素上的遮挡。

`mask-image`{:.prop}

取值： | none \| \[ \<type\>( \<properties\> ) \<paint-area\>? \| \<name\> \<paint-area\>? \]<span class="prop-def-symbol" title="One or more comma-separated occurrences">#+</span>
初始值： | none
继承： | 否
百分比： | 不适用

\<type\>
: 声明装饰器类型，参见[内置装饰器](decorators.html#decorators)列表。

\<properties\>
: 声明给定装饰器类型特有的属性。

\<name\>
: 声明由 [@decorator 规则](decorators.html#decorator-at-rule) 定义的装饰器名称。

\<paint-area\>
: 可选地，指定装饰器应应用于元素的哪个区域，即 `border-box`{:.value}、`padding-box`{:.value} 或 `content-box`{:.value} 之一。对于遮罩图像，此值默认为 `border-box`{:.value}，与 `decorator`{:.prop} 属性的 `padding-box`{:.value} 不同。

为便于说明，可以像下面这样使用单个装饰器。

```css
mask-image: <type>( <properties> );
```

也可以像下面这样使用多个装饰器。它们将按声明的顺序从顶层到底层渲染。

```css
mask-image: <type>( <properties> ), <type>( <properties> ), ... ;
```

#### 示例

```css
/* 声明一个遮罩，图像在元素上重复 */
mask-image: image("star.png" repeat);

/* 声明一个线性渐变遮罩，向右淡入 */
mask-image: horizontal-gradient(transparent black);

/* 声明一个锥形渐变遮罩，渲染在图像之上 */
mask-image: conic-gradient(from 45deg, black, transparent, black), image("star.png" cover);
```
---
layout: page
title: 滤镜
parent: rcss
next: font_effects
---

滤镜允许对元素应用各种视觉效果，例如颜色调整、模糊和阴影。滤镜可以在样式表中声明和配置。这样，滤镜可以应用于整个元素，或应用于元素的背景（backdrop）。此外，滤镜在内部用于应用某些效果，例如用于[盒阴影](colours_backgrounds.html#box-shadow)的模糊效果。RmlUi 支持 [CSS 中指定的所有滤镜](https://www.w3.org/TR/filter-effects-1/#supported-filter-functions)。

要使用滤镜，后端渲染器必须支持高级渲染功能，详见[渲染接口功能表](../cpp_manual/interfaces/render.html#feature-table)。关于如何定义自定义滤镜，另请参阅相关的 [C++ 文档](../cpp_manual/filters.html)。


### RmlUi 滤镜
{:#filters}

RmlUi 附带了几种内置滤镜函数，用于对元素和其他输入应用视觉效果。

| 滤镜函数             | 说明                                  |
|-----------------------------|----------------------------------------------|
| [blur](#blur)               | 对输入应用高斯模糊效果。 |
| [brightness](#brightness)   | 调整输入的亮度。         |
| [contrast](#contrast)       | 调整输入的对比度。           |
| [drop-shadow](#drop-shadow) | 对输入应用投影效果。   |
| [grayscale](#grayscale)     | 将输入颜色转换为灰度。      |
| [hue-rotate](#hue-rotate)   | 旋转输入的色相。                |
| [invert](#invert)           | 反转输入的颜色。             |
| [opacity](#opacity)         | 调整输入的不透明度。            |
| [saturate](#saturate)       | 调整输入的颜色饱和度。   |
| [sepia](#sepia)             | 对输入应用棕褐色调。           |


### 图形滤镜：'filter' 属性
{:#filter}

滤镜属性按如下方式指定。

`filter`{:.prop}

取值： | none \| \[ \<filter-function\>( \<properties\> ) \]<span class="prop-def-symbol" title="One or more space-separated occurrences">+</span>
初始值： | none
继承： | 否
百分比： | 不适用

\<filter-function\>
: [受支持的滤镜函数](#filter-functions) 之一

\<properties\>
: 决定滤镜函数特有的属性。

为便于说明，可以像下面这样使用单个滤镜。

```css
filter: sepia(1.5);
```

可以使用空格分隔的列表指定多个滤镜。滤镜按指定顺序应用。

```css
filter: brightness(1.2) contrast(150%) hue-rotate(90deg);
```

### 背景滤镜：'backdrop-filter' 属性
{:#backdrop-filter}

背景滤镜将滤镜效果应用于元素*后面*的区域。这允许你对背景应用滤镜，而不会影响元素本身的内容。背景是元素背景后面的区域，这意味着任何 `background-color`{:.prop} 都可能会遮挡背景。

`backdrop-filter`{:.prop}

取值： | none \| \[ \<filter-function\>( \<properties\> ) \]<span class="prop-def-symbol" title="One or more space-separated occurrences">+</span>
初始值： | none
继承： | 否
百分比： | 不适用

`backdrop-filter`{:.prop} 属性使用与 `filter`{:.prop} 属性相同的滤镜函数。可以使用空格分隔的列表指定多个背景滤镜。

### 示例

下面演示了如何声明各种滤镜。

```css
/* 应用灰度滤镜 */
filter: grayscale(0.5);

/* 对整个元素应用透明度，包括其子元素 */
filter: opacity(0.5);

/* 添加带模糊效果的红色投影 */
filter: drop-shadow(#f33f 30px 20px 5px);

/* 应用多个滤镜 */
filter: blur(20px) hue-rotate(45deg) brightness(130%);
```

下一个示例通过对元素后面的区域应用模糊和轻微变暗来创建磨砂玻璃效果。

```css
.frosted-glass {
    background-color: #fffa;
    backdrop-filter: blur(10px) brightness(90%);
}
```

下面展示了一个圆形球体，模糊背景和自身，并在其边缘周围渲染出黄色色调。

```css
.blur_orb {
    width: 350px;
    height: 350px;
    border-radius: 200px;
    background: #fff0;
    filter: drop-shadow(#ff7 0 0 30px) blur(40px);
    backdrop-filter: blur(50px);
    border: 2px black;
}
```

滤镜也可以设置动画，如下所示。

```css
@keyframes animate-filter {
    from { filter: drop-shadow(#f00) opacity(1.0) sepia(1.0); }
    to   { filter: drop-shadow(#000 30px 20px 5px) opacity(0.2) sepia(0.2); }
}
.animate {
    animation: animate-filter 1.5s cubic-in-out infinite alternate;
}
```

### 示例

一定要看看 RmlUi 中的 `effects` 示例，它展示了所有内置滤镜。

<a href="../../assets/images/effects-sample-filters.png"><img src="../../assets/images/effects-sample-filters.png" alt="Filters from the `effects` sample" style="max-width: 60%"></a>


### 滤镜函数
{:#filter-functions}

#### blur

对输入应用高斯模糊。

```css
filter: blur( <sigma> );
```

`<sigma>`{:.prop}

取值： | \<length\>
初始值： | 0px

指定模糊效果的标准差。值为零表示不模糊。

*注意*：[`box-shadow`{:.prop}](colours_backgrounds.html#box-shadow) 属性使用*模糊半径*而非标准差来指定应用的模糊量。模糊半径相当于 `2 * sigma`{:.value}。这一差异源于 CSS 规范。

#### brightness

调整输入的亮度。

```css
filter: brightness( <amount> );
```

`<amount>`{:.prop}

取值： | \<number\> \| \<percentage\>
初始值： | 1

指定亮度级别。值为 0% 将创建一个完全黑色的元素，而高于 100% 的值将提供更亮的结果。

#### contrast

调整输入的对比度。

```css
filter: contrast( <amount> );
```

`<amount>`{:.prop}

取值： | \<number\> \| \<percentage\>
初始值： | 1

指定对比度级别。值为 0% 将创建一个完全灰色的元素，而高于 100% 的值将提供更高的对比度。

#### drop-shadow

对输入应用投影效果。

```css
filter: drop-shadow( <color>? <offset-x> <offset-y> <sigma>? );
```

值的解释与 [`box-shadow`{:.prop} 属性](colours_backgrounds.html#box-shadow) 相同，区别在于第三个长度参数指定标准差（sigma）而不是模糊半径。

`<color>`{:.prop}

取值： | \<color\>
初始值： | black

指定阴影的颜色。

`<offset-x>`{:.prop}

取值： | \<length\>
初始值： | 0px

指定阴影的水平偏移。

`<offset-y>`{:.prop}

取值： | \<length\>
初始值： | 0px

指定阴影的垂直偏移。

`<sigma>`{:.prop}

取值： | \<length\>
初始值： | 0px

指定应用于阴影的模糊效果的标准差。值为零表示不模糊。

*注意*：[`box-shadow`{:.prop}](colours_backgrounds.html#box-shadow) 属性使用*模糊半径*而非标准差来指定应用的模糊量。模糊半径相当于 `2 * sigma`{:.value}。这一差异源于 CSS 规范。

#### grayscale

将颜色转换为灰度。

```css
filter: grayscale( <amount> );
```

`<amount>`{:.prop}

取值： | \<number\> \| \<percentage\>
初始值： | 0

指定效果的量。值为 100% 时为完全灰色。

#### hue-rotate

旋转输入颜色的色相。

```css
filter: hue-rotate( <angle> );
```

`<angle>`{:.prop}

取值： | \<angle\>
初始值： | 0deg

指定要应用的色相旋转。值为 0deg 时色相保持不变。

#### invert

反转输入的颜色。

```css
filter: invert( <amount> );
```

`<amount>`{:.prop}

取值： | \<number\> \| \<percentage\>
初始值： | 0

指定反转的量。值为 100% 将完全反转输入颜色。

#### opacity

调整输入的不透明度。

```css
filter: opacity( <amount> );
```

`<amount>`{:.prop}

取值： | \<number\> \| \<percentage\>
初始值： | 1

指定不透明度级别。值为 0% 使元素完全透明，而 100% 使其保持不变。

#### saturate

调整输入的颜色饱和度。

```css
filter: saturate( <amount> );
```

`<amount>`{:.prop}

取值： | \<number\> \| \<percentage\>
初始值： | 100%

指定饱和度。值为 0% 时完全不饱和（灰色），而高于 100% 的值提供过饱和的结果。

#### sepia

对输入应用棕褐色调。

```css
filter: sepia( <amount> );
```

`<amount>`{:.prop}

取值： | \<number\> \| \<percentage\>
初始值： | 0%

指定效果的量。值为 100% 时完全为棕褐色调。
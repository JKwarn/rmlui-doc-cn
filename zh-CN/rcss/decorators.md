---
layout: page
title: 装饰器
parent: rcss
next: masking
---

装饰器（decorator）是 RCSS 对 CSS 的扩展。装饰器可以在样式表中声明，并使用装饰器特有的属性进行配置。可以开发自定义装饰器类型以满足用户的需求，这样可以将任何类型的装饰应用于元素。

关于装饰器的更多细节以及如何定义自己的装饰器，另请参阅 [C++ 文档](../cpp_manual/decorators.html)。

### RmlUi 装饰器
{:#decorators}

RmlUi 附带了几种内置装饰器，用于在元素后面显示图像和平铺图像。

| 装饰器                                            | 类型                                                            | 说明                                   | 需要着色器支持 |
|------------------------------------------------------|----------------------------------------------------------------|------------------------------------------|:-----------------------:|
| [图像](decorators/image.html)                       | `image`{:.prop}                                                | 单个图像。                          |                         |
| [水平平铺](decorators/tiled_horizontal.html) | `tiled-horizontal`{:.prop}                                     | 水平平铺图像。               |                         |
| [垂直平铺](decorators/tiled_vertical.html)     | `tiled-vertical`{:.prop}                                       | 垂直平铺图像。                 |                         |
| [盒状平铺](decorators/tiled_box.html)               | `tiled-box`{:.prop}                                            | 跨盒子平铺图像。               |                         |
| [九宫格](decorators/ninepatch.html)               | `ninepatch`{:.prop}                                            | 跨盒子高效平铺图像。   |                         |
| [直线渐变](decorators/gradient.html)       | `horizontal-gradient`{:.prop}、`vertical-gradient`{:.prop}     | 水平和垂直颜色渐变。 |                         |
| [线性渐变](decorators/linear_gradient.html)  | `linear-gradient`{:.prop}、`repeating-linear-gradient`{:.prop} | 线性颜色渐变。                  |           ✔️            |
| [径向渐变](decorators/radial_gradient.html)  | `radial-gradient`{:.prop}、`repeating-radial-gradient`{:.prop} | 径向颜色渐变。                  |           ✔️            |
| [锥形渐变](decorators/conic_gradient.html)    | `conic-gradient`{:.prop}、`repeating-conic-gradient`{:.prop}   | 锥形颜色渐变。                   |           ✔️            |
| [着色器](decorators/shader.html)                     | `shader`{:.prop}                                               | 自定义着色器。                          |           ✔️            |
| [文本](decorators/text.html)                         | `text`{:.prop}                                                 | 背景文本和字体图标。          |                         |

某些装饰器需要后端渲染器支持高级渲染功能，详见[渲染接口功能表](../cpp_manual/interfaces/render.html#feature-table)。

### 装饰：'decorator' 属性
{:#decorator}

装饰器属性按如下方式指定。

`decorator`{:.prop}

取值： | none \| \[ \<type\>( \<properties\> ) \<paint-area\>? \| \<name\> \<paint-area\>? \]<span class="prop-def-symbol" title="One or more comma-separated occurrences">#+</span>
初始值： | none
继承： | 否
百分比： | 不适用

\<type\>
: 声明装饰器类型，参见上面的[内置装饰器](#decorators)列表。

\<properties\>
: 声明给定装饰器类型特有的属性。

\<name\>
: 声明由 [@decorator 规则](#decorator-at-rule) 定义的装饰器名称。

\<paint-area\>
: 可选地，指定装饰器应应用于元素的哪个区域，即 `border-box`{:.value}、`padding-box`{:.value} 或 `content-box`{:.value} 之一。省略时，此值默认为 `padding-box`{:.value}。

为便于说明，可以像下面这样使用单个装饰器。

```css
decorator: <type>( <properties> );
```

也可以像下面这样使用多个装饰器。它们将按声明的顺序从顶层到底层渲染。

```css
decorator: <type>( <properties> ), <type>( <properties> ), ... ;
```

出于性能原因，建议在样式表中声明装饰器，而不是在元素的内联样式（style）中声明。

在创建[自定义装饰器](../cpp_manual/decorators.html#custom-decorators)时，你可以提供一个名为 `decorator` 的简写属性，它将被用来解析属性声明括号内的文本。这样，就可以像提供的示例中那样使用内联属性来指定装饰器。

#### 示例

```css
/* 通过精灵名称声明图像装饰器 */
decorator: image( icon-invader );

/* 通过多个精灵声明盒状平铺装饰器 */
decorator: tiled-box(
	window-tl, window-t, window-tr,
	window-l, window-c, window-r,
	window-bl, window-b, window-br
);

/* 通过图像的 URL 声明图像装饰器，
   显示在元素的内容盒上 */
decorator: image( invader.tga ) content-box;
```

对于支持图像和精灵的内置装饰器，指定的 'src' 会首先查找具有相同名称的[精灵](sprite_sheets.html)。如果不存在，则将其视为图像的文件名。

装饰器可以像任何其他属性一样被覆盖。因此，在示例中：

```css
h1 {
	decorator: image( cat.png );
}

h1:hover {
	decorator: none;
}
```

所有 `h1`{:.tag} 标签都会附加一个图像装饰器，但当它们被悬停时除外，此时它们将不会被渲染。


### 装饰器 at-rule

当上面给出的简写语法不够用时，RCSS 中的 `@decorator` at-rule 可用于声明装饰器。最好用一个示例来说明，我们使用 invaders 示例中的自定义 `starfield` 装饰器类型。在样式表中，我们可以用如下方式用属性填充它。

```css
@decorator stars : starfield {
	num-layers: 5;
	top-colour: #fffc;
	bottom-colour: #fff3;
	top-speed: 80.0;
	bottom-speed: 20.0;
	top-density: 8;
	bottom-density: 20;
}
```
然后在装饰器中使用它。
```css
decorator: stars;
```
请注意缺少括号，这意味着它是一个装饰器名称，而不是声明了简写属性的类型。
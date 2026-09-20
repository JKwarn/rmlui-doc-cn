---
layout: page
title: 字体
parent: rcss
next: text
---

在文本渲染方面，RCSS 实现了 [CSS2 字体模型](http://www.w3.org/TR/REC-CSS2/fonts.html) 的简化版本。原因有二：

* 文档渲染器完全由作者控制，因此（例如）可以假定特定字体存在。
* 性能更好。

字体的指定方式与 CSS 类似。但是，字体在使用前必须先加载到字体引擎中。这可以通过 RCSS 中的 [`@font-face`](#font-face) at-rule 完成，也可以通过 C++ 中的 [`Rml::LoadFontFace()`](../cpp_manual/fonts.html) 完成。


### 字体面声明：'@font-face' at-rule
{:#font-face}

`@font-face`{:.prop} at-rule 加载一个或多个字体文件，并以给定的族名将它们注册到字体引擎中，以便可以通过 `font-family`{:.prop} 属性使用它们。它相当于在 C++ 中调用 [`Rml::LoadFontFace()`](../cpp_manual/fonts.html) 的 RCSS 方式。

```css
@font-face {
	font-family: "Roboto Mono";
	src: "assets/RobotoMono-Regular.ttf", "assets/RobotoMono-Bold.ttf";
}

@font-face {
	font-family: "Roboto Mono";
	src: "assets/RobotoMono-Italic.ttf", "assets/RobotoMono-BoldItalic.ttf";
	font-style: italic;
}

body {
	font-family: "Roboto Mono";
}
```

`font-family`{:.prop} 和 `src`{:.prop} 都是必需的，所有其他描述符都是可选的。缺少其中任何一个的块都会被忽略，并向日志发出警告。

该 at-rule 在样式表被解析时立即处理，生成的字体面会全局注册在字体引擎中。这意味着它们不会限定在声明它们的样式表或文档范围内。多次声明相同的字体面是无害的，任何重复都会被检测为重复项并跳过。

#### 描述符

`font-family`{:.prop#font-face-font-family}

取值： | \<string\>
初始值： | 未定义
适用于： | `@font-face`{:.prop} 块
继承： | 不适用
百分比： | 不适用

注册加载的字体面所用的族名。必需。

`src`{:.prop#font-face-src}

取值： | \<string\> \[, \<string\>\]\*
初始值： | 未定义
适用于： | `@font-face`{:.prop} 块
继承： | 不适用
百分比： | 不适用

要加载的字体文件的逗号分隔列表。文件名相对于当前样式表的路径进行解析。必需。

`font-style`{:.prop#font-face-font-style}

取值： | normal \| italic
初始值： | normal
适用于： | `@font-face`{:.prop} 块
继承： | 不适用
百分比： | 不适用
必需： | 否

将加载的字体面注册为的样式。这总是覆盖字体文件内部声明的样式，因此斜体字体文件必须声明 `font-style: italic`{:.prop}，才能被 `font-style`{:.prop} 属性选中。

`font-weight`{:.prop#font-face-font-weight}

取值： | all \| normal \| bold \| \<number \[1,1000\]\>
初始值： | all
适用于： | `@font-face`{:.prop} 块
继承： | 不适用
百分比： | 不适用

取值含义如下：

`all`{:.value}
: 字重从字体文件中获取。如果文件包含多个字重变体，则全部加载。

`normal`{:.value}
`bold`{:.value}
`<number>`{:.value}
: 将字体注册为的字重。当字体文件包含多个字重变体时，此值选择要加载的变体。

`-rmlui-fallback-face`{:.prop#font-face-fallback-face}

取值： | false \| true
初始值： | false
适用于： | `@font-face`{:.prop} 块
继承： | 不适用
百分比： | 不适用

当为 `true`{:.value} 时，加载的字体面用于任何在文档指定的字体中找不到的字符。可以声明多个回退字体面，它们按加载顺序确定优先级。详见[加载字体](../cpp_manual/fonts.html)。

`-rmlui-face-index`{:.prop#font-face-face-index}

取值： | \<number\>
初始值： | 0
适用于： | `@font-face`{:.prop} 块
继承： | 不适用
百分比： | 不适用

在字体集合（如 `.ttc`{:.path} 文件）中要加载的字体面索引。


### 字体指定属性

#### 字体族：'font-family' 属性
{:#font-family}

`font-family`{:.prop}

取值： | \<string\>
初始值： | 未定义
适用于： | 所有元素
继承： | 是
百分比： | 不适用

此属性指定用于渲染从该元素派生的文本部分的字体族名称。请注意，与 CSS 不同，此属性只能指定单个字体族，而不是逗号分隔的字体集。

#### 字体样式：'font-style' 和 'font-weight' 属性
{:#font-style}

`font-style`{:.prop}

取值： | normal \| italic
初始值： | normal
适用于： | 所有元素
继承： | 是
百分比： | 不适用

此属性可用于在字体族内请求字体的常规或斜体版本。请注意，RCSS 尚不支持 oblique 字体样式。

`font-weight`{:.prop}
{:#font-weight}

取值： | normal \| bold \| \<number \[1,1000\]\>
初始值： | normal
适用于： | 所有元素
继承： | 是
百分比： | 不适用

此属性可用于在字体族内请求字体的常规或粗体版本。对于受支持的字体，可以指定数值以获得更细的粒度。该范围基于常用的 OpenType 规范：100（Thin）、200（Extra Light）、300（Light）、400（Normal）、500（Medium）、600（Semi Bold）、700（Bold）、800（Extra Bold）、900（Black）。

#### 字体大小：'font-size' 属性
{:#font-size}

`font-size`{:.prop}

取值： | \<length\> \| \<percentage\>
初始值： | 12px
适用于： | 所有元素
继承： | 是
百分比： | 父元素的字体大小

取值含义如下：

`<length>`{:.value}
: 以请求的字号生成字体。对于字体相对单位（如 `em`{:.value}），字体大小相对于父元素的字体大小。

`<percentage>`{:.value}
: 以元素父字体的大小乘以该百分比生成字体大小。


#### 字体简写
{:#font}

`font`{:.prop}

取值： | `font-style`{:.prop} `font-weight`{:.prop} `font-size`{:.prop} `font-family`{:.prop}
初始值： | 参见各个属性
适用于： | 所有元素
继承： | 是
百分比： | 不适用

一个用于一次性设置所有字体属性的简写属性。


#### 字体字距调整：'font-kerning' 属性
{:#font-kerning}

`font-kerning`{:.prop}

取值： | auto \| normal \| none
初始值： | auto
适用于： | 所有元素
继承： | 是
百分比： | 不适用

取值含义如下：

`auto`{:.value}
: 如果默认可用，则启用字体字距调整，但对于小号字体会禁用，以提高文本的可读性。

`normal`{:.value}
: 如果可用，始终启用字体字距调整。

`none`{:.value}
: 禁用字体字距调整。

字体字距调整影响相邻字符的间距方式。大多数字体都有字距调整信息，通过使字符之间的光学间距更均匀来提高可读性。
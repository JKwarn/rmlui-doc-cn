---
layout: page
title: 文本
parent: rcss
next: tables
---

### 对齐：'text-align' 属性
{:#text-align}

`text-align`{:.prop}

取值： | left \| right \| center
初始值： | left
适用于： | 块级元素
继承： | 是
百分比： | 不适用

此属性影响行盒内行内盒子的对齐方式。取值含义如下：

`left`{:.value}
: 行内盒子行与行盒的左边缘对齐。

`right`{:.value}
: 行内盒子行与行盒的右边缘对齐。

`center`{:.value}
: 行内盒子行在行盒的中间对齐。

请注意，RCSS 尚不支持 'justify' 值。

### 装饰

#### 文本装饰：'text-decoration' 属性
{:#text-decoration}

`text-decoration`{:.prop}

取值： | none \| underline \| overline \| line-through
初始值： | none
适用于： | 所有元素
继承： | 是
百分比： | 不适用

取值含义如下：

`none`{:.value}
: 该元素生成的任何文本都没有额外的装饰。

`underline`{:.value}
: 该元素生成的任何文本都有下划线，其厚度和位置由字体指定。

`overline`{:.value}
: 该元素生成的任何文本都有上划线，其厚度和位置由字体度量确定。

`line-through`{:.value}
: 该元素生成的任何文本都有删除线，其厚度和位置由字体度量确定。

任何装饰的颜色都与字体颜色相同。

#### 文本阴影：'shadow' 字体效果

文本阴影不是使用 CSS 标准的 `text-shadow`{:.prop} 属性，而是在 RmlUi 中使用更通用的[字体效果系统](font_effects.html)实现。下面是如何为一段文本指定阴影的示例。

```css
/* 在一级标题上指定灰色文本阴影。 */
h1
{
	font-effect: shadow( 2px 2px grey );
}
```

### 空白：'white-space' 属性
{:#white-space}

`white-space`{:.prop}

取值： | normal \| pre \| nowrap \| pre-wrap \| pre-line
初始值： | normal
适用于： | 所有元素
继承： | 是
百分比： | 不适用

此属性定义空白（任何空格、换行、回车和制表符）在文本部分中的处理方式。取值含义如下：

`normal`{:.value}
: 空白序列被折叠为单个空格。行根据需要换行以适合行盒。源代码中的换行被忽略。

`pre`{:.value}
: 空白序列被保留。行只在源代码中存在换行的地方断开。

`nowrap`{:.value}
: 空白序列被折叠。行不断开。

`pre-wrap`{:.value}
: 空白序列不被折叠。行为了适合行盒而断开，或在源代码中存在换行的地方断开。

`pre-line`{:.value}
: 空白序列被折叠。行为了适合行盒而断开，或在源代码中存在换行的地方断开。

### 文本的断行规则：'word-break' 属性
{:#word-break}

`word-break`{:.prop}

取值： | normal \| break-all \| break-word
初始值： | normal
适用于： | 所有元素
继承： | 是
百分比： | 不适用

此属性定义文本在原本会溢出的情况下如何断成新行。取值含义如下：

`normal`{:.value}
: 文本只在单词边界（空白处）断开。

`break-all`{:.value}
: 可以在任意位置插入断点以避免溢出。

`break-word`{:.value}
: 文本通常在单词边界断开，但当行中的单个单词会导致溢出时，可以在任意位置插入断点。

这些属性只有在 `white-space`{:.prop} 属性允许换行时才会生效。


### 字符间距：'letter-spacing' 属性
{:#letter-spacing}

`letter-spacing`{:.prop}

取值： | normal \| \<length\>
初始值： | normal
适用于： | 所有元素
继承： | 是
百分比： | 不适用

允许调整文本字符之间的水平间距。

`normal`{:.value}
: 根据当前字体使用正常的字距。

`<length>`{:.value}
: 在字符之间使用*额外*的间距，可以为负值以使间距更窄。


### 文本变换：'text-transform' 属性
{:#text-transform}

`text-transform`{:.prop}

取值： | none \| capitalize \| uppercase \| lowercase
初始值： | none
适用于： | 所有元素
继承： | 是
百分比： | 不适用

变换该元素生成的文本。取值含义如下：

`none`{:.value}
: 没有效果。

`capitalize`{:.value}
: 该元素生成的任何文本都被首字母大写。

`uppercase`{:.value}
: 该元素生成的任何文本都被转换为大写。

`lowercase`{:.value}
: 该元素生成的任何文本都被转换为小写。


### 文本溢出：'text-overflow' 属性
{:#text-overflow}

`text-overflow`{:.prop}

取值： | clip \| ellipsis \| \<string\>
初始值： | clip
适用于： | 所有元素
继承： | 否
百分比： | 不适用

当文本溢出其行时，可以启用渲染省略号或其他字符串。此属性不影响布局，只影响文本渲染。只有在 `overflow`{:.prop} 属性取非可见值时才会生效。目前只直接应用于文本，不适用于行内级原子盒子。

取值含义如下：

`clip`{:.value}
: 溢出的文本像平常一样在元素的内边距区域周围被裁剪。

`ellipsis`{:.value}
: 对于溢出的文本，在文本即将被裁剪前，在其末尾插入省略号。

`<string>`{:.value}
: 对于溢出的文本，在文本即将被裁剪前，在其末尾插入指定的字符串。

_注意_：要在字符之间而不是在内边距区域处裁剪，可以在 RCSS 中指定空字符串，即 `""`。

```css
p { overflow: hidden; }
p.ellipsis           { text-overflow: ellipsis; }
p.custom-string      { text-overflow: "_O_"; }
p.clip-at-characters { text-overflow: ""; }
```
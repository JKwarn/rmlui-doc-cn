---
layout: page
title: 视觉格式化模型细节
parent: rcss
next: visual_effects
---

### '包含块' 的定义

在布局期间，当元素在文档树中被遇到时，其包含块即被固定。其尺寸确定如下：

1. 对于文档的根元素（`body`{:.tag} 元素），包含块是文档上下文的尺寸。
2. 对于其他元素（绝对定位元素除外），包含块是最近的块级容器的内容区域尺寸。
3. 如果元素是绝对定位的（`position`{:.prop} 值设置为 `absolute`{:.value} 或 `fixed`{:.value}），则其包含块由最近的已定位元素（`position`{:.prop} 值非 `static`{:.value}）的内边距区域给出；如果不存在这样的元素，则由根元素给出。

### 内容宽度：'width' 属性
{:#width}

`width`{:.prop}

取值： | \<length\> \| \<percentage\> \| auto
初始值： | auto
适用于： | 块级元素和可替换行内元素
继承： | 否
百分比： | 相对于包含块的宽度

此属性仅适用于块级盒子和具有固有宽度的行内盒子。其他行内盒子由其内容决定大小。

取值含义如下：

`<length>`{:.value}
: 指定一个固定的宽度。

`<percentage>`{:.value}
: 指定相对于盒子包含块宽度的宽度。

`auto`{:.value}
: 宽度取决于其他属性的值。见下文。

```css
/* 将类为 'text' 的输入元素的宽度固定为其行高的 12 倍。 */
input.text
{
	width: 12em;
}
```

### 计算宽度和外边距

如果盒子的 `width`{:.prop}、`margin-left`{:.prop} 或 `margin-right`{:.prop} 中有任何一项设置为 `auto`{:.value}，则会在盒子确定大小时进行计算。根据盒子类型，其设置方式如下：

- 对于行内非替换盒子，任何 `auto`{:.value} 外边距都被设置为 '0'。忽略 `width`{:.prop}。
- 对于行内可替换盒子，`auto`{:.value} 外边距被设置为 '0'。`width`{:.prop} 为 `auto`{:.value} 时设置为元素的固有宽度。
- 对于块级盒子，以下方程

  ```
  margin-left + border-left-width + padding-left + width + padding-right + border-right-width + margin-right
  = 包含块宽度
  ```

  必须成立。如果 `width`{:.prop} 为 `auto`{:.value}，则任何 `auto`{:.value} 外边距都被设置为 '0'，盒子宽度被设置为适当的值。否则，方程中的差额在 auto 外边距之间均分。
- 对于绝对定位的盒子，`left`{:.prop} 和 `right`{:.prop} 额外加在上述方程的左侧。
- 如果上述方程欠约束，则行内块级盒子、绝对定位盒子和浮动盒子的任何 `auto`{:.value} 宽度都由其"收缩适配（shrink-to-fit）"宽度决定。

### 最小和最大宽度：'min-width' 和 'max-width'
{:#min-width}

`min-width`{:.prop}

取值： | \<length\> \| \<percentage\>
初始值： | 0px
适用于： | 块级元素和可替换行内元素
继承： | 否
百分比： | 相对于包含块的宽度

`max-width`{:.prop}
{:#max-width}

取值： | \<length\> \| \<percentage\> \| none
初始值： | none
适用于： | 块级元素和可替换行内元素
继承： | 否
百分比： | 相对于包含块的宽度

取值含义如下：

`<length>`{:.value}
: 指定一个固定的最小或最大宽度。

`<percentage>`{:.value}
: 指定相对于包含块宽度的最小或最大宽度。

`none`{:.value}
: 指定没有最大宽度。

在计算 `width`{:.prop} 时，如果计算出的宽度大于 `max-width`{:.prop}，则重新计算宽度，此时用 `max-width`{:.prop} 代替 `width`{:.prop}。如果计算出的值小于 `min-width`{:.prop}，则重新计算宽度，此时用 `min-width`{:.prop} 代替 `width`{:.prop}。

### 内容高度：'height' 属性
{:#height}

`height`{:.prop}

取值： | \<length\> \| \<percentage\> \| auto
初始值： | auto
适用于： | 块级元素和可替换行内元素
继承： | 否
百分比： | 相对于包含块的高度

此属性仅适用于块级盒子和具有固有高度的行内盒子。其他行内盒子由其内容决定大小。

取值含义如下：

`<length>`{:.value}
: 指定一个固定的高度。

`<percentage>`{:.value}
: 指定相对于盒子包含块高度的百分比高度。

`auto`{:.value}
: 高度取决于其他属性的值。见下文。

```css
/* 将背景 div 的高度固定为其包含块的 100%。 */
div#background
{
	height : 100%;
}
```

### 计算高度和外边距

如果盒子的 `height`{:.prop}、`margin-top`{:.prop} 或 `margin-bottom`{:.prop} 中有任何一项设置为 `auto`{:.value}，则会在盒子确定大小时进行计算。根据盒子类型，其设置方式如下：

- 对于行内非替换盒子，任何 `auto`{:.value} 外边距都被设置为 '0'。忽略 `height`{:.prop}。
- 对于行内可替换盒子，`auto`{:.value} 外边距被设置为 '0'。`height`{:.prop} 为 `auto`{:.value} 时设置为元素的固有宽度。
- 对于具有固定高度的块级盒子，以下方程

  ```
  margin-top + border-top-width + padding-top + height + padding-bottom + border-bottom-width + margin-bottom
  = 包含块高度
  ```

  必须成立。方程中的差额在 auto 外边距之间均分。
- 对于 `height`{:.prop} 为 `auto`{:.value} 的块级盒子，任何 `auto`{:.value} 外边距都被设置为 '0'，高度将被设置为恰好适合其内容。
- 对于绝对定位的盒子，`top`{:.prop} 和 `bottom`{:.prop} 额外加在上述方程的左侧。

在 RCSS 中，具有固定高度的块级盒子会像水平外边距一样解析 `auto`{:.value} 垂直外边距。

### 最小和最大高度：'min-height' 和 'max-height'
{:#min-height}

`min-height`{:.prop}

取值： | \<length\> \| \<percentage\>
初始值： | 0px
适用于： | 块级元素和可替换行内元素
继承： | 否
百分比： | 相对于包含块的高度

`max-height`{:.prop}
{:#max-height}

取值： | \<length\> \| \<percentage\> \| none
初始值： | none
适用于： | 块级元素和可替换行内元素
继承： | 否
百分比： | 相对于包含块的高度

取值含义如下：

`<length>`{:.value}
: 指定一个固定的最小或最大高度。

`<percentage>`{:.value}
: 指定相对于包含块高度的最小或最大高度。

`none`{:.value}
: 指定没有最大高度。

在计算 `height`{:.prop} 时，如果计算出的高度大于 `max-height`{:.prop}，则重新计算高度，此时用 `max-height`{:.prop} 代替 `height`{:.prop}。如果计算出的值小于 `min-height`{:.prop}，则重新计算高度，此时用 `min-height`{:.prop} 代替 `height`{:.prop}。`height`{:.prop} 为 `auto`{:.value} 的块级盒子绝不会将其高度设置到 `min-height`{:.prop} 以下或 `max-height`{:.prop} 以上；这可能导致溢出。

### 行高计算：'line-height' 和 'vertical-align' 属性
{:#line-height}

行盒的高度按如下方式确定：

1. 计算每个行内元素的高度。
2. 行内盒子垂直对齐（通过其 `vertical-align`{:.prop} 属性）。
3. 行盒高度由最高盒子的顶边与最低盒子的底边之间的距离给出。

请注意，确定行盒高度时不会考虑行内盒子的垂直内边距、外边距和边框，尽管它们会被渲染。

`line-height`{:.prop}

取值： | \<number\> \| \<length\> \| \<percentage\>
初始值： | 1.2
适用于： | 所有元素
继承： | 是
百分比： | 相对于元素自身的字体大小

此属性确定元素内行盒的*最小*高度。

该属性取值含义如下：

`<number>`{:.value}
: 行高设置为元素的字体高度乘以该数字。

`<length>`{:.value}
: 行高设置为该固定值。

`<percentage>`{:.value}
: 行高设置为元素的字体高度乘以该百分比。

```css
/* 设置相同 line-height 的三种方式。 */
div
{
	line-height: 1.3;
	line-height: 1.3em;
	line-height: 130%;
}
```

`vertical-align`{:.prop}
{:#vertical-align}

取值： | baseline \| sub \| super \| text-top \| text-bottom \| middle \| top \| center \| bottom \| \<percentage\> \| \<length\>
初始值： | baseline
适用于： | 行内级元素
继承： | 否
百分比： | 相对于元素的 line-height

此属性影响行内盒子在行盒内的垂直定位。

取值含义如下：

`baseline`{:.value}
: 将行内盒子的基线与其父盒子的基线对齐。

`sub`{:.value}
: 将行内盒子的基线设置为适合渲染下标的高度。

`super`{:.value}
: 将行内盒子的基线设置为适合渲染上标的高度。

`text-top`{:.value}
: 将行内盒子的顶部与父盒子字体的顶部对齐。

`text-bottom`{:.value}
: 将行内盒子的底部与父盒子字体的底部对齐。

`middle`{:.value}
: 将盒子的中点与父盒子的基线加上其半个 ex 高度对齐。

`top`{:.value}
: 将行内盒子的顶部与行盒的顶部对齐。

`center`{:.value}
: 将行内盒子的中心与行盒的中心对齐。

`bottom`{:.value}
: 将行内盒子的底部与行盒的底部对齐。

`<percentage>`{:.value}
: 将元素从基线向上或向下移动该百分比乘以行高的距离。

`<length>`{:.value}
: 将元素从基线向上或向下移动固定的距离。

```css
/* 定义上标标签的示例 RCSS。 */
super
{
	vertical-align: super;
}
```

```html
<!-- 演示渲染上标的示例 RML。 -->
<p>
	Better than ever before!<super>*</super>
</p>
```
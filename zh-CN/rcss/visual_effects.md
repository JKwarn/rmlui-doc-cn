---
layout: page
title: 视觉效果
parent: rcss
next: colours_backgrounds
---

### 溢出与裁剪

块级盒子的内容可能会延伸到盒子自身的内容区域之外，例如在以下场景中：

* 宽度大于其包含块盒子的行内盒子的内容无法断开。
* 块级盒子的宽度大于其包含块盒子。
* 块级盒子设置了明确的高度，而其内容超过了该高度。

当发生溢出时，'overflow-x' 和 'overflow-y' 属性决定如何处理溢出。

#### 溢出：'overflow' 属性
{:#overflow}

`overflow-x`{:.prop}、`overflow-y`{:.prop}

取值： | visible \| hidden \| auto \| scroll
初始值： | visible
适用于： | 块级元素
继承： | 否
百分比： | 不适用

取值含义如下：

`visible`{:.value}
: 溢出的内容沿此轴可见。

`hidden`{:.value}
: 溢出的内容沿此轴被隐藏。

`auto`{:.value}
: 如果沿此轴发生溢出，溢出的内容会被隐藏，并沿该轴生成并放置一个滚动条，以便将隐藏的内容滚动到视图中。

`scroll`{:.value}
: 沿该轴始终显示一个滚动条，允许将隐藏的内容滚动到视图中。如果内容突然溢出并出现滚动条，这可以消除'跳动'现象。

如果 `overflow-x`{:.prop} 或 `overflow-y`{:.prop} 中的任何一个设置为 'visible' 以外的值，两个轴都会发生裁剪。

请注意，与 CSS 不同，[已定位元素](visual_formatting_model.html#position)和[已变换元素](animations_transitions_transforms.html#transform)不会影响裁剪何时应用于该元素。因此，此类元素即使溢出也可能不会被裁剪或产生滚动条。此时，可以使用 [`clip: always`{:.value} 属性](#clip) 配合隐藏溢出（hidden overflow）来强制发生裁剪。

`overflow`{:.prop}

`overflow-x overflow-y`{:.prop} 的简写。如果指定两个值，第一个用于指定 `overflow-x`{:.prop}，第二个用于指定 `overflow-y`{:.prop}。如果指定一个值，则同时用于指定两者。

```css
/* 隐藏水平溢出的内容，并沿垂直轴生成滚动条（如果需要）。 */
div#content
{
	overflow: hidden auto;
}
```

#### 裁剪：'clip' 属性
{:#clip}

此属性定义元素如何与其祖先的裁剪区域交互。

该属性与 CSS 的 `clip`{:.prop} 属性完全不同，后者定义元素的裁剪区域。在 RCSS 中，裁剪区域始终是"客户区"。客户区通常是元素的内边距区域，但对于某些元素而言可能是内容区域。

`clip`{:.prop}

取值： | auto \| none \| always \| \<number\>
初始值： | auto
适用于： | 所有元素
继承： | 否
百分比： | 不适用

取值含义如下：

`auto`{:.value}
: 元素受其祖先设置的所有裁剪区域约束。

`none`{:.value}
: 元素永远不会被裁剪（上下文除外）。

`always`{:.value}
: 元素始终裁剪，强制所有后代元素裁剪到该元素的客户区。在某些元素即使设置为例如 `overflow: hidden`{:.prop} 也不会被自动裁剪的情况下（例如绝对定位或已变换的子元素），这可能很有用。

`<number>`{:.value}
: 元素受其祖先裁剪区域的约束，但会跳过最接近的 `<number>`{:.value} 个可能设置了裁剪区域的祖先（即那些 `overflow-x`{:.prop} 或 `overflow-y`{:.prop} 不是 `visible`{:.value} 的祖先）。该数字必须在 `[1, 127]`{:.value} 范围内。

### 可见性：'visibility' 属性
{:#visibility}

`visibility`{:.prop}

取值： | visible \| hidden
初始值： | visible
适用于： | 所有元素
继承： | 否
百分比： | 不适用

取值含义如下：

`visible`{:.value}
: 生成的盒子可见。

`hidden`{:.value}
: 生成的盒子及其所有后代都被隐藏。请注意，该盒子仍然会影响布局，只是不会被渲染。

*动画行为*：在 `visible`{:.value} 和 `hidden`{:.value} 之间插值时，整个插值期间都会应用 `visible`{:.value} 关键字。这在显示或隐藏元素时想要应用淡入或淡出效果的动画和过渡中很有帮助。此行为确保元素在整个淡入淡出过程中保持可见。
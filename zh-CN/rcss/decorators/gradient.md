---
layout: page
title: 直线渐变装饰器
grandparent: rcss
parent: rcss/decorators
next: linear_gradient
---

直线渐变由 `horizontal-gradient`{:.prop} 和 `vertical-gradient`{:.prop} 装饰器支持。它们在所应用元素的区域内沿水平或垂直方向渲染线性颜色渐变。

```css
decorator: horizontal-gradient( <start-color> <stop-color> ) <paint-area>?;
decorator: vertical-gradient( <start-color> <stop-color> ) <paint-area>?;
```

直线渐变可以描述为[线性渐变](linear_gradient.html)的子集。直线渐变的主要动机是，即使渲染器不支持着色器，它们也可以被渲染。直线渐变只使用顶点颜色，这使得它们渲染起来更简单、更轻量。因此，在可能的情况下应优先使用它们。

### 属性

`start-color`{:.prop}

取值： | \<color\>
初始值： | white
百分比： | 不适用

声明起始颜色，即在左边缘或上边缘的颜色。

`stop-color`{:.prop}

取值： | \<color\>
初始值： | white
百分比： | 不适用

声明结束颜色，即在右边缘或下边缘的颜色。

`paint-area`{:.prop}

取值： | border-box \| padding-box \| content-box
初始值： | padding-box
百分比： | 不适用

声明渲染装饰器的盒区域。

### 示例

以下 RCSS 声明了两个按钮，一个带垂直渐变，另一个带水平渐变。

```css
button.vertical {
	decorator: vertical-gradient( #415857 #5990a3 );
	border: 3px #415857;
	border-radius: 8px;
}

button.horizontal {
	decorator: horizontal-gradient( #db6565 #f1b58a );
	border: 3px #db6565;
	border-radius: 8px;
}
```

渲染结果：

![Vertical and horizontal gradients](../../../assets/images/decorators/vertical-horizontal-gradient.png)
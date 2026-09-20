---
layout: page
title: 模糊字体效果
parent: rcss/font_effects
grandparent: rcss
---

模糊字体效果渲染文本的高斯模糊副本。

![模糊示例](blur.png)

请注意，模糊效果不会替换原始文本。若只想显示文本的模糊版本，请将原始文本的 `color`{:.prop} 属性设置为 `transparent`{:.value}。

效果声明如下：

```css
font-effect: blur( <width> <color> );
```

其属性由以下内容指定。

`width`{:.prop}

取值： | \<length\>
初始值： | 1px
百分比： | 不适用

决定模糊效果的半径。

`color`{:.prop}

取值： | \<color\>
初始值： | white
百分比： | 不适用

该颜色以乘法方式应用于整个效果。


```css
/* Renders a blurred version of the text, hides the original text. */
h1
{
	color: transparent;
	font-effect: blur(3px #ed5);
}
```
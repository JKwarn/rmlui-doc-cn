---
layout: page
title: 描边字体效果
parent: rcss/font_effects
grandparent: rcss
next: shadow
---

描边字体效果在文本周围渲染彩色描边。

![outline_1.jpg](outline_1.jpg)

效果声明如下：

```css
font-effect: outline( <width> <color> );
```

其属性由以下内容指定。

`width`{:.prop}

取值： | \<length\>
初始值： | 0px
百分比： | 不适用

该宽度定义字体描边的最大像素宽度。

`color`{:.prop}

取值： | \<color\>
初始值： | white
百分比： | 不适用

该颜色以乘法方式应用于整个效果。

#### 示例

```css
/* Declares an outline font effect. */
h1
{
	font-effect: outline(2px black);
}
```
---
layout: page
title: 文本装饰器
parent: rcss/decorators
grandparent: rcss
---

`text`{:.prop} 装饰器可以在元素的背景中渲染文本。这在使用图标字体时特别有用，甚至允许将此类字体用于生成元素。

```css
decorator: text( <text> <color>? <align-x>? <align-y>? ) <paint-area>?;
```
取值必须按给定的顺序指定，但对齐关键字可以按任意顺序给出。任何未指定的属性将保持其默认值。

字体会从它被应用到的元素继承。因此，应在元素本身上设置适当的字体族和字体大小。但是，装饰器可以独立着色。此外，文本可以在元素内自由对齐。

### 属性

`text`{:.prop}

取值： | \<string\>
初始值： | 不适用
百分比： | 不适用

此属性定义要渲染的文本。此装饰器只支持单行文本。任何 [RML 字符实体](../../rml/syntax.html) 都会被解码，因此可以通过例如 `&#x1F30E;` 来引用 Unicode 字符。

`color`{:.prop}

取值： | \<color\> \| inherit-color
初始值： | inherit-color
百分比： | 不适用

指定文本应渲染的颜色。默认情况下，它继承装饰器所应用元素的颜色。

`align-x`{:.prop}

取值： | left \| center \| right \| \<length-percentage\>
初始值： | center
百分比： | 相对于指定的绘制区域

水平对齐或偏移文本。

`align-y`{:.prop}

取值： | top \| center \| bottom \| \<length-percentage\>
初始值： | center
百分比： | 相对于指定的绘制区域

垂直对齐或偏移文本。


`paint-area`{:.prop}

取值： | border-box \| padding-box \| content-box
初始值： | padding-box
百分比： | 不适用

声明渲染装饰器的盒区域。

### 示例

下面演示了使用 `text`{:.prop} 装饰器的一些示例。

```css
.decorator1 {
    decorator: text("Hello 🌎 world!" #333);
}
.decorator2 {
    decorator: text("Hello &#x1F30E; world!" top left);
}
.decorator3 {
    decorator: text("Hello 🌎 world!" 50% 30dp);
}
.decorator4 {
    decorator: text("Hello 🌎 world!" red right bottom) content-box;
    padding: 10px;
}

sliderarrowdec, slidearrowinc {
	width: 32dp;
	height: 32dp;
	font-family: my-icon-font;
	font-size: 20dp;
}
sliderarrowdec { decorator: text("🔼"); }
sliderarrowinc { decorator: text("🔽"); }
```

示例输出：

{:.center}
![text decorator](../../../assets/images/decorators/text.png)
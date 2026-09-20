---
layout: page
title: 水平平铺装饰器
parent: rcss/decorators
grandparent: rcss
next: tiled_vertical
---

`tiled-horizontal`{:.prop} 装饰器可以横跨元素渲染三个精灵或图像。一个图像放置在左边缘，另一个放置在右边缘，最后一个横跨中间拉伸。

```css
decorator: tiled-horizontal(
	<left-image-src> <left-image-orientation>?,
	<center-image-src> <center-image-orientation>?,
	<right-image-src> <right-image-orientation>?
) <paint-area>?;
```


### 属性

`*x*-image-src`{:.prop}

取值： | \<string\>
初始值： | 不适用
百分比： | 不适用

此属性定义[精灵名称](../sprite_sheets.html)或图像文件的相对路径。

`*x*-image-orientation`{:.prop}

取值： | none \| flip-horizontal \| flip-vertical \| rotate-180
初始值： | none
百分比： | 不适用

翻转或旋转图像。

`paint-area`{:.prop}

取值： | border-box \| padding-box \| content-box
初始值： | padding-box
百分比： | 不适用

声明渲染装饰器的盒区域。


### 示例

在下面的每个示例中，图像首先以自然大小显示，然后对其应用 `tiled-horizontal`{:.prop} 装饰器，并将其元素水平拉伸。

![Horizontally tiled image](../../../assets/images/decorators/tiled-horizontal.png)

以下 RCSS 用于生成上述结果。

```css
@spritesheet demo-sheet
{
	src: /assets/invader.tga;

	title-bar-l: 147px 0px 82px 85px;
	title-bar-c: 229px 0px  1px 85px;
	title-bar-r: 231px 0px 15px 85px;

	demo-radio-l: 407px 0px 14px 30px;
	demo-radio-m: 421px 0px  2px 30px;
	demo-radio-r: 423px 0px 14px 30px;

	demo-checkbox-l: 407px 60px 14px 30px;
	demo-checkbox-m: 421px 60px  2px 30px;
	demo-checkbox-r: 423px 60px 14px 30px;
}

.radio {
    decorator: tiled-horizontal( demo-radio-l, demo-radio-m, demo-radio-r );
}
.checkbox {
    decorator: tiled-horizontal( demo-checkbox-l, demo-checkbox-m, demo-checkbox-r );
}
.title-bar {
    decorator: tiled-horizontal( title-bar-l, title-bar-c, title-bar-r );
}
```


#### 方向

使用 `*x*-image-orientation`{:.prop} 属性的结果如下所示，可以单独应用于每个平铺块。

![image-orientation.png](../../../assets/images/decorators/image-orientation.png)
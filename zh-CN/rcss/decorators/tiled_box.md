---
layout: page
title: 盒状平铺装饰器
grandparent: rcss
parent: rcss/decorators
next: ninepatch
---

`tiled-box`{:.prop} 装饰器可以跨元素渲染九个精灵或图像。一个图像以固定大小放置在元素的每个角，一个图像沿每条边拉伸，最后一个图像在两个方向上拉伸以覆盖元素的中心区域。

```css
decorator: tiled-box(
	<top-left-image-src> <top-left-image-orientation>?,
	<top-image-src> <top-image-orientation>?,
	<top-right-image-src> <top-right-image-orientation>?,

	<left-image-src> <left-image-orientation>?,
	<center-image-src> <center-image-orientation>?,
	<right-image-src> <right-image-orientation>?,

	<bottom-left-image-src> <bottom-left-image-orientation>?,
	<bottom-image-src> <bottom-image-orientation>?,
	<bottom-right-image-src> <bottom-right-image-orientation>?
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

以下图像用于定义窗口背景。

![Tiled box window](../../../assets/images/decorators/tiled-box-window.png)

`tiled-box`{:.prop} 装饰器首先将图像划分为九个区域（见下文）。然后，使用此装饰器的元素可以在任何方向上优雅地调整大小，同时保持角落和边缘的大小合适。

![Tiled box window](../../../assets/images/decorators/tiled-box.png)

以下 RCSS 用于生成上述结果。

```css
@spritesheet demo-sheet
{
	src: /assets/invader.tga;

	window-tl: 0px 0px 133px 140px;
	window-t:  134px 0px 1px 140px;
	window-tr: 136px 0px 10px 140px;
	window-l:  0px 139px 10px 1px;
	window-c:  11px 139px 1px 1px;
	window-r:  10px 139px -10px 1px; /* mirrored left */
	window-bl: 0px 140px 11px 11px;
	window-b:  11px 140px 1px 11px;
	window-br: 136px 140px 10px 11px;
}

.tiled-box {
	decorator: tiled-box(
		window-tl, window-t, window-tr,
		window-l, window-c, window-r,
		window-bl, window-b, window-br
	);
}
```


#### 方向

使用 `*x*-image-orientation`{:.prop} 属性的结果如下所示，可以单独应用于每个平铺块。

![image-orientation.png](../../../assets/images/decorators/image-orientation.png)
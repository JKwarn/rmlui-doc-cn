---
layout: page
title: 垂直平铺装饰器
parent: rcss/decorators
grandparent: rcss
next: tiled_box
---

`tiled-vertical`{:.prop} 装饰器可以纵跨元素渲染三个精灵或图像。一个图像放置在顶部边缘，另一个放置在底部边缘，最后一个跨越中间拉伸。

```css
decorator: tiled-vertical(
	<top-image-src> <top-image-orientation>?,
	<center-image-src> <center-image-orientation>?,
	<bottom-image-src> <bottom-image-orientation>?
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

在下面的每个示例中，图像首先以自然大小显示，然后对其应用 `tiled-vertical`{:.prop} 装饰器，并将其元素垂直拉伸。

![Vertically tiled image](../../../assets/images/decorators/tiled-vertical.png)

显然，并非所有图像都设计为这样拉伸。然而，人们当然可以设想前两个示例的用途。

以下 RCSS 用于生成上述结果。

```css
@spritesheet demo-sheet
{
	src: /assets/invader.tga;

	demo-radio-t: 407px  0px 30px 14px;
	demo-radio-c: 407px 14px 30px  2px;
	demo-radio-b: 407px 16px 30px 14px;

	demo-checkbox-t: 407px 60px 30px 14px;
	demo-checkbox-c: 407px 74px 30px  2px;
	demo-checkbox-b: 407px 76px 30px 14px;

	demo-checked-t: 407px  90px 30px  8px;
	demo-checked-c: 407px  98px 30px 14px;
	demo-checked-b: 407px 112px 30px  8px;

	demo-help-t:    128px 152px 51px  6px;
	demo-help-c:    128px 158px 51px 21px;
	demo-help-b:    128px 179px 51px 12px;
}

.radio {
    decorator: tiled-vertical( demo-radio-t, demo-radio-c, demo-radio-b );
}
.checkbox {
    decorator: tiled-vertical( demo-checkbox-t, demo-checkbox-c, demo-checkbox-b );
}
.checked {
    decorator: tiled-vertical( demo-checked-t, demo-checked-c, demo-checked-b );
}
.help {
    decorator: tiled-vertical( demo-help-t, demo-help-c, demo-help-b );
}
```


#### 方向

使用 `*x*-image-orientation`{:.prop} 属性的结果如下所示，可以单独应用于每个平铺块。

![image-orientation.png](../../../assets/images/decorators/image-orientation.png)
---
layout: page
title: 九宫格装饰器
grandparent: rcss
parent: rcss/decorators
next: gradient
---

`ninepatch`{:.prop} 装饰器通过声明另一个内部精灵，将一个精灵分割成 3x3 的补丁网格。九宫格的角落默认以自然大小渲染，而内部补丁被拉伸，以便整个元素被填满。从某种意义上说，它可以被视为 `tiled-box`{:.prop} 装饰器的简化且更高性能的版本。

```css
decorator: ninepatch( <outer>, <inner>, <edge>? ) <paint-area>?;
```


### 属性

`outer`{:.prop}

取值： | \<string\>
初始值： | 不适用
百分比： | 不适用

此属性定义[精灵名称](../sprite_sheets.html)。该精灵声明装饰器的外矩形。此装饰器不能使用图像 URL。

`inner`{:.prop}

取值： | \<string\>
初始值： | 不适用
百分比： | 不适用

此属性定义[精灵名称](../sprite_sheets.html)，并且必须与 `outer`{:.prop} 位于同一精灵表中。内部精灵声明装饰器的内矩形。

内矩形和外矩形之间的区域定义装饰器的角落和边缘。角落大小固定，边缘只沿一个方向缩放，而中心被拉伸以覆盖元素边界的剩余区域。

`edge`{:.prop}

取值： | \<number-length-percentage-box\>
初始值： | 0px 0px 0px 0px
百分比： | 相对于边缘的大小和当前 dp 比例

edge 属性以常见的 `top-right-bottom-left`{:.value} 盒子顺序指定。如果指定了该属性（并非全为 0px），则每个边缘的渲染大小可以指定为长度，或者指定为数字/百分比以相对图像边缘的自然大小进行缩放。自然大小由精灵关联的 [`resolution`{:.prop} 属性](../sprite_sheets.html#resolution)和当前的 [dp 比例](../syntax.html#dp-unit)决定。可以使用常见的盒子简写，例如，单个值将复制到所有边缘。

`paint-area`{:.prop}

取值： | border-box \| padding-box \| content-box
初始值： | padding-box
百分比： | 不适用

声明渲染装饰器的盒区域。


### 示例

在此示例中，为文本区域定义了一个九宫格装饰器。该装饰器由两个精灵指定，分别定义一个外矩形和一个内矩形。

```css
@spritesheet textarea {
	src: textarea.png;
	textarea: 0px 0px 145px 31px;
	textarea-inner: 11px 13px 127px 10px;
}
```

精灵在下面的图像中说明，其中外部精灵覆盖整个图像，而内部精灵位于显示的边框内。

![Sprites of the ninepatch decorator](../../../assets/images/decorators/ninepatch-sprites.png)

内矩形定义元素调整大小时将被拉伸的精灵部分。

`ninepatch`{:.prop} 装饰器按如下方式应用：

```css
.ninepatch {
	decorator: ninepatch(textarea, textarea-inner);
}
```

当九宫格装饰器被应用且元素被拉伸时，会渲染出以下效果。请注意，角落保持固定，内部精灵被拉伸。

![A stretched ninepatch decorator](../../../assets/images/decorators/ninepatch.png)

此外，九宫格装饰器的边缘可以手动指定渲染大小。

```css
decorator: ninepatch(textarea, textarea-inner, 19px 12px 25px 12px);
```

也可以使用百分比和数字，它们将相对给定边缘的自然大小进行缩放。因此，以下内容将使所有边缘的大小加倍。

```css
decorator: ninepatch(textarea, textarea-inner, 2.0);
```
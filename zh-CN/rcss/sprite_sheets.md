---
layout: page
title: 精灵表
parent: rcss
next: decorators
---

RCSS 的 at-rule `@spritesheet` 可用于声明精灵表（sprite sheet）。精灵表由单个图像和多个精灵组成，每个精灵指定图像的一个区域。精灵可以反过来用于装饰器和 `<img>`{:.tag} 元素中。

可以像下面的示例一样在 RCSS 中声明精灵表。

```css
@spritesheet theme
{
	src: invader.tga;
	resolution: 1x;

	title-bar-l: 147px 0px 82px 85px;
	title-bar-c: 229px 0px  1px 85px;
	title-bar-r: 231px 0px 15px 85px;

	icon-invader: 179px 152px 51px 39px;
	icon-game:    230px 152px 51px 39px;
	icon-score:   434px 152px 51px 39px;
	icon-help:    128px 152px 51px 39px;
}
```

精灵表名称（此处为 `theme`）是可选的。所有精灵名称（例如 `icon-invader`）都是全局的，可以被后面定义的精灵表覆盖。

### 属性


`src`{:.prop#src}

取值： | \<string\>
初始值： | 未定义
适用于： | `@spritesheet`{:.prop} 块
继承： | 不适用
百分比： | 不适用

提供精灵表源图像的文件名。


`resolution`{:.prop#resolution}

取值： | \<resolution\>
初始值： | 1x
适用于： | `@spritesheet`{:.prop} 块
继承： | 不适用
百分比： | 不适用

决定源图像设计用于显示的缩放比例。例如，如果它是为 200% DPI 显示而制作的，则将其设置为 `2x`{:.value}。此属性可选，默认值为 `1x`{:.value}。

该值与当前上下文的 [dp 比例](syntax.html#dp-unit) 一起，决定此精灵表中精灵的自然大小。

例如，如果我们将 `resolution`{:.prop} 属性设置为 `2x`{:.value} 并将上下文的 dp 比例设置为 `2.0`{:.value}，则使用此精灵的 `<img>` 元素将以 1:1 的纹素对像素比例显示。如果对于同一精灵，当前 dp 比例是 `1.0`{:.value}，则图像元素将被缩放为一半。当然，可以使用 RCSS 样式覆盖图像元素的这种自然大小。

#### 精灵

`[sprite-name]`{:.prop}
（除 `src`{:.prop} 和 `resolution`{:.prop} 之外的任何名称）

取值： | \<rectangle\>
初始值： | 未定义
适用于： | `@spritesheet`{:.prop} 块
继承： | 不适用
百分比： | 不适用

每个其他属性都以 `<sprite-name>: <rectangle>`{:.prop} 的形式指定一个精灵。精灵的名称全局应用于给定文档中包含的所有样式表。如果多个精灵以相同名称定义，则使用最后一个。

\<rectangle\> 声明为 `x y width height`，其中每一项都必须使用 `px`{:.unit} 单位。此处，`x` 和 `y` 指图像中的位置，原点位于左上角，`width` 和 `height` 向右和向下延伸矩形。


### 用法

精灵名称可以在装饰器中使用，例如：
```css
decorator: tiled-horizontal( title-bar-l, title-bar-c, title-bar-r );
```
这会创建一个平铺装饰器，其中 `title-bar-l`{:.value} 和 `title-bar-r`{:.value} 精灵以自然大小占据元素的左右部分，而 `title-bar-c`{:.value} 占据中心部分，并随着元素的拉伸而水平延伸。

精灵也可以使用 `sprite`{:.attr} 属性用在 `<img>` 元素中。

```css
<img sprite="icon-invader"/>
```

### 高 DPI

将精灵表与媒体查询结合使用，可以轻松地根据上下文当前的 dp 比例自动在低分辨率和高分辨率图像之间切换。

要覆盖上面的 `theme` 精灵表，请在紧挨着它的下方定义一个高分辨率版本，并将其放在媒体查询中。

```css
@media (min-resolution: 2x)
{
	@spritesheet theme2x
	{
		src: invader2x.tga;
		resolution: 2x;

		title-bar-l: 147px 0px 164px 170px;
		title-bar-c: 429px 0px   1px 170px;
		title-bar-r: 631px 0px  30px 170px;

		icon-invader: 179px 152px 102px 78px;
		icon-game:    330px 152px 102px 78px;
		icon-score:   534px 152px 102px 78px;
		icon-help:    728px 152px 102px 78px;
	}
}
```

由于精灵名称是全局的，当此媒体规则被激活时，高分辨率精灵将覆盖并替换低分辨率精灵，为你的用户提供清晰的渲染图标。
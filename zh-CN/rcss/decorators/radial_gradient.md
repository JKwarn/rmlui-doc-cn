---
layout: page
title: 径向渐变装饰器
grandparent: rcss
parent: rcss/decorators
next: conic_gradient
---

`radial-gradient`{:.prop} 和 `repeating-radial-gradient`{:.prop} 装饰器以给定的大小和位置在元素上渲染径向颜色渐变。RCSS 支持 [CSS 径向渐变](https://drafts.csswg.org/css-images-3/#radial-gradients) 的大部分特性，包括一些[第 4 级](https://drafts.csswg.org/css-images-4/#radial-gradients)特性，*颜色提示（color hints）*除外。

```css
decorator: radial-gradient( <radial-geometry>?, <color-stop-list> ) <paint-area>?;
decorator: repeating-radial-gradient( <radial-geometry>?, <color-stop-list> ) <paint-area>?;
```

每个径向渐变由一个*渐变线（gradient line）*定义，这是一条放置颜色停止点的虚拟线。颜色在颜色停止点之间插值。对于径向渐变，渐变线从中心点开始，向围绕中心的椭圆延伸。因此，颜色从中心向外变化，但沿着围绕中心的虚拟椭圆保持不变。

径向渐变的重复变体会在第一个颜色停止点之前和最后一个颜色停止点之后重复停止点。

为了显示径向渐变，后端渲染器必须支持高级效果。特别是，此装饰器需要[径向渐变着色器](../../cpp_manual/interfaces/render.html#shaders)支持。有关内置后端，请参阅[支持的渲染器特性](https://github.com/mikke89/RmlUi?tab=readme-ov-file#renderers)。


### 属性

`radial-geometry`{:.prop}

取值： | \[\<radial-shape\> <span class="prop-def-symbol" title="one or more options must occur">\|\|</span> \<radial-size\>\]? \[at \<position\>\]?
初始值： | circle farthest-corner at center
百分比： | 不适用

指定径向渐变在其盒子内的形状、大小和位置。

各个参数定义如下：

> \<radial-shape\> = circle \| ellipse

决定结束形状是圆形还是椭圆形。如果省略，当 `radial-size`{:.value} 是单个长度时视为圆形，否则视为椭圆形。

> \<radial-size\> = closest-side \| farthest-side \| closest-corner \| farthest-corner \| \<length\> \| \<length-percentage\><span class="prop-def-symbol" title="two space-separated occurrences">{2}</span>

决定结束形状的大小。关键字决定大小，使形状在指定的边或角处结束。单个长度指定该半径的圆形。两个长度或百分比指定具有给定二维半径的椭圆形，百分比分别相对于盒子沿每个维度的大小解析。

> \<position\> = \[left \| center \| right \| \<length-percentage\> \] <span class="prop-def-symbol" title="one or more options must occur">\|\|</span> \[top \| center \| bottom \| \<length-percentage\>\]

决定渐变的中心。百分比相对于盒子的大小解析。

`color-stop-list`{:.prop}

取值： | \<color-stop-list\>
初始值： | 不适用
百分比： | 不适用

声明定义渐变颜色的颜色停止点列表，以逗号分隔。每个颜色停止点指定一个颜色和沿渐变线的长度。颜色停止点列表的形式化定义如下：

> \<color-stop-list\> = \<color-stop\><span class="prop-def-symbol" title="Two or more comma-separated occurrences">#{2,}</span>
>
> \<color-stop\> = \<color\> \<length-percentage\><span class="prop-def-symbol" title="zero to two space-separated occurrences">{0,2}</span>

颜色停止点长度指定停止点沿渐变线的位置。如果未提供长度，停止点会在其他停止点之间自动均匀放置。如果提供一个长度，停止点会被添加到此位置。如果提供两个长度，则每个长度都会添加一个停止点，颜色相同。百分比相对于渐变线的长度解析。

请注意，RCSS 中的颜色停止点不支持 CSS 的*颜色提示*。

`paint-area`{:.prop}

取值： | border-box \| padding-box \| content-box
初始值： | padding-box
百分比： | 不适用

声明渲染装饰器的盒区域。


### 示例

以下 RCSS 声明了一个带径向渐变装饰器的按钮。

```css
button {
    decorator: radial-gradient(circle farthest-side at center, #ff6b6b, #fec84d, #4ecdc4);
    border-radius: 50px;
    border: 4px #fff;
    box-shadow: #000a 0 4px 12px, #000a 0 1px 3px;
}
```

![Radial gradient button example](../../../assets/images/decorators/radial-gradient-button.png)

其他示例，演示各种选项。

```css
.gradient1 {
    decorator: radial-gradient(circle closest-side at 100px 30px, red, yellow, green);
}
.gradient2 {
    decorator: radial-gradient(30% 60%, red 50%, yellow 50%, green);
}
.gradient3 {
    background-color: yellow;
    decorator: radial-gradient(40px, #4ecdc4, white 40% 60%, #ff6b6b) content-box;
}
.gradient4 {
    decorator: repeating-radial-gradient(50px 80px, #f00, #ff0, #f00);
}
.gradient5 {
    decorator: repeating-radial-gradient(circle closest-side, yellow, red 2px, yellow);
}
```

![Radial gradient examples](../../../assets/images/decorators/radial-gradient.png)
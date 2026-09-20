---
layout: page
title: 锥形渐变装饰器
grandparent: rcss
parent: rcss/decorators
next: shader
---

`conic-gradient`{:.prop} 和 `repeating-conic-gradient`{:.prop} 装饰器在元素上以给定的角度和位置渲染锥形颜色渐变。RCSS 支持 [CSS 锥形渐变](https://drafts.csswg.org/css-images-4/#conic-gradients) 的大部分特性，*颜色提示（color hints）*除外。

```css
decorator: conic-gradient( <conic-geometry>?, <color-stop-list> ) <paint-area>?;
decorator: repeating-conic-gradient( <conic-geometry>?, <color-stop-list> ) <paint-area>?;
```

每个锥形渐变由一个*渐变线（gradient line）*定义，这是一条放置颜色停止点的虚拟线。颜色在颜色停止点之间插值。对于锥形渐变，渐变线是围绕中心点的椭圆。颜色沿此椭圆变化，而从中心到椭圆的射线具有恒定颜色。

锥形渐变的重复变体会在第一个颜色停止点之前和最后一个颜色停止点之后重复停止点。

为了显示锥形渐变，后端渲染器必须支持高级效果。特别是，此装饰器需要[锥形渐变着色器](../../cpp_manual/interfaces/render.html#shaders)支持。有关内置后端，请参阅[支持的渲染器特性](https://github.com/mikke89/RmlUi?tab=readme-ov-file#renderers)。


### 属性

`conic-geometry`{:.prop}

取值： | \[from \<angle\>\]? \[at \<position\>\]?
初始值： | from 0deg at center
百分比： | 不适用

指定锥形渐变的角度和位置。

各个参数定义如下：

> \<angle\>

决定渐变开始的角度，`0deg`{:.value} 从顶部开始。

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

以下 RCSS 声明了一个带重复锥形渐变装饰器的按钮。

```css
button {
    decorator: repeating-conic-gradient(from 90deg, #ffd700, #f06, #ffd700 180deg);
    box-sizing: border-box;
    width: 200px;
    height: 100px;
    line-height: 100px;
    border-radius: 15px;
    border: 3px #ffd700;
    padding: 10px 35px;
    font-size: 30px;
    color: white;
    font-weight: bold;
    letter-spacing: 1px;
    font-effect: glow(3px #ff6a), outline(2px #0003);
}
```

![Conic gradient button example](../../../assets/images/decorators/conic-gradient-button.png)

其他示例，演示各种选项。

```css
.gradient1 {
    decorator: conic-gradient(red, yellow);
}
.gradient2 {
    decorator: conic-gradient(from 90deg at 75% 50%, red, yellow);
}
.gradient3 {
    decorator: conic-gradient(from 45deg, white, black, white);
}
.checkerboard {
    background-color: #b3e6b3;
    decorator: conic-gradient(black 25%, white 0 50%, black 0 75%, white 0) content-box;
}
```

![Conic gradient rectangular examples](../../../assets/images/decorators/conic-gradient-rectangular.png)

通过添加边界半径，我们可以制作具有一些有趣渐变的圆形元素。这里的最后一个圆形示例将使用旋转效果进行动画。

```css
div {
  	border-radius: 100px;
}
.color_wheel {
    decorator: radial-gradient(white, #fff3 65%, transparent), conic-gradient(red, yellow, lime, aqua, blue, #f0f, red);
}
.pie_chart {
    decorator: conic-gradient(#9acd32 40%, #ffd700 0 75%, #f06 0);
 }
.repeating {
    decorator: repeating-conic-gradient(#ffd700, #f06 20deg);
}
@keyframes spinner {
    from { decorator: repeating-conic-gradient(from   0deg, #fff3 0 15deg, #fff0 0 30deg); }
    to   { decorator: repeating-conic-gradient(from 360deg, #fff3 0 15deg, #fff0 0 30deg); }
}
.repeating_spinning {
    background-color: #0ac;
    animation: 5s spinner infinite;
}
```

![Conic gradient circular examples](../../../assets/images/decorators/conic-gradient-circular.png)
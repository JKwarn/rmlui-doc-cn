---
layout: page
title: 线性渐变装饰器
grandparent: rcss
parent: rcss/decorators
next: radial_gradient
---

`linear-gradient`{:.prop} 和 `repeating-linear-gradient`{:.prop} 装饰器沿任意指定方向在元素上渲染线性颜色渐变。RCSS 支持 [CSS 线性渐变](https://drafts.csswg.org/css-images-3/#linear-gradients) 的大部分特性，包括一些[第 4 级](https://drafts.csswg.org/css-images-4/#linear-gradients)特性，*颜色提示（color hints）*除外。

```css
decorator: linear-gradient( <direction>?, <color-stop-list> ) <paint-area>?;
decorator: repeating-linear-gradient( <direction>?, <color-stop-list> ) <paint-area>?;
```

每个线性渐变由一个*渐变线（gradient line）*定义，这是一条放置颜色停止点的虚拟线。颜色在颜色停止点之间插值。对于线性渐变，渐变线是直的，每条垂直于这条线的线都具有相同的颜色。

线性渐变的重复变体会在第一个颜色停止点之前和最后一个颜色停止点之后重复停止点。

为了显示线性渐变，后端渲染器必须支持高级效果。特别是，此装饰器需要[线性渐变着色器](../../cpp_manual/interfaces/render.html#shaders)支持。有关内置后端，请参阅[支持的渲染器特性](https://github.com/mikke89/RmlUi?tab=readme-ov-file#renderers)。


### 属性

`direction`{:.prop}

取值： | \<angle\> \| to \[left \| right <span class="prop-def-symbol" title="one or more options must occur">\|\|</span> top \| bottom\]
初始值： | to bottom
百分比： | 不适用

指定渐变的方向，其中 `0deg` 表示向上，`90deg` 表示向右。也可以使用关键字，例如 `to top left` 指定一个角，或 `to right` 指定一条边。

当指定 `to <corner>` 时，渐变的起始点和结束点将被放置，使得渐变线的法线恰好穿过所选角和相对的角。这确保了 `0%` 和 `100%` 颜色停止点位置恰好放置在这两个角上。

`color-stop-list`{:.prop}

取值： | \<color-stop-list\>
初始值： | 不适用
百分比： | 不适用

声明定义渐变颜色的颜色停止点列表，以逗号分隔。每个颜色停止点指定一个颜色和沿渐变线的长度。颜色停止点列表的形式化定义如下：

> \<color-stop-list\> = \<color-stop\><span class="prop-def-symbol" title="Two or more comma-separated occurrences">#{2,}</span>
>
> \<color-stop\> = \<color\> \<length-percentage\><span class="prop-def-symbol" title="Zero to two space-separated occurrences">{0,2}</span>

颜色停止点长度指定停止点沿渐变线的位置。如果未提供长度，停止点会在其他停止点之间自动均匀放置。如果提供一个长度，停止点会被添加到此位置。如果提供两个长度，则每个长度都会添加一个停止点，颜色相同。百分比相对于渐变线的长度解析。

请注意，RCSS 中的颜色停止点不支持 CSS 的*颜色提示*。

`paint-area`{:.prop}

取值： | border-box \| padding-box \| content-box
初始值： | padding-box
百分比： | 不适用

声明渲染装饰器的盒区域。


### 示例

以下 RCSS 声明了一个带对角线方向线性渐变的按钮。

```css
button {
    decorator: linear-gradient(to top right, red, white, blue);
    border-radius: 20px 8px;
    border-width: 2px 1px;
    border-color: #666;
}
```

![Linear gradient button example](../../../assets/images/decorators/linear-gradient-button.png)

其他示例，演示各种选项。

```css
.gradient1 {
    decorator: linear-gradient(to bottom, #00f3, #0001, #00f3), linear-gradient(to top right, red, blue);
}
.gradient2 {
    decorator: linear-gradient(45deg, red 40%, white, blue 60%);
}
.gradient3 {
    background-color: #69dcff;
    decorator: linear-gradient(90deg, #ff4500 40%, white 40% 60%, #008cff 60%) content-box;
}
.gradient4 {
    decorator: repeating-linear-gradient(red, white, blue 20%);
}
.gradient5 {
    decorator: repeating-linear-gradient(to bottom, red, #ff3 20px, red 40px);
}
```

![Linear gradient examples](../../../assets/images/decorators/linear-gradient.png)
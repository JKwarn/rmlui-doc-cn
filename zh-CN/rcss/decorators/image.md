---
layout: page
title: 图像装饰器
parent: rcss/decorators
grandparent: rcss
next: tiled_horizontal
---

`image`{:.prop} 装饰器可以渲染单个精灵或图像。

```css
decorator: image( <image-src> <image-orientation>? <image-fit>? <image-align-x>? <image-align-y>? ) <paint-area>?;
```
取值必须按给定的顺序指定，任何未指定的属性将保持其默认值。用法示例请参阅 'demo' 示例。

### 属性

`image-src`{:.prop}

取值： | \<string\>
初始值： | 不适用
百分比： | 不适用

此属性定义[精灵名称](../sprite_sheets.html)或图像文件的相对路径。

`image-orientation`{:.prop}

取值： | none \| flip-horizontal \| flip-vertical \| rotate-180
初始值： | none
百分比： | 不适用

翻转或旋转图像。

`image-fit`{:.prop}

取值： | fill \| contain \| cover \| scale-none \| scale-down \| repeat \| repeat-x \| repeat-y
初始值： | fill
百分比： | 不适用

`fill`{:.value}
: 图像被拉伸到边界。

`contain`{:.value}
: 图像被拉伸到边界，保持宽高比固定，'letter-boxed'（留边）。

`cover`{:.value}
: 图像被拉伸以覆盖边界，保持宽高比固定。

`scale-none`{:.value}
: 图像从不缩放。

`scale-down`{:.value}
: 如果图像小于边界，则表现为 'scale-none'；否则表现为 'contain'。

`repeat`{:.value}
: 图像被平铺，在水平和垂直方向上都重复。不适用于精灵图像。

`repeat-x`{:.value}
: 图像沿 X 轴水平平铺。不适用于精灵图像。

`repeat-y`{:.value}
: 图像沿 Y 轴垂直平铺。不适用于精灵图像。


`image-align-x`{:.prop}

取值： | left \| center \| right \| \<length-percentage\>
初始值： | center
百分比： | 相对于元素的内边距宽度

水平对齐或偏移图像。

`image-align-y`{:.prop}

取值： | top \| center \| bottom \| \<length-percentage\>
初始值： | center
百分比： | 相对于元素的内边距高度

垂直对齐或偏移图像。


`paint-area`{:.prop}

取值： | border-box \| padding-box \| content-box
初始值： | padding-box
百分比： | 不适用

声明渲染装饰器的盒区域。

### 示例

下面演示了使用 `image`{:.prop} 装饰器的一些示例。

```css
.star {
    decorator: image("star.png" cover);
}
.top-right-aligned-sprite {
    decorator: image(icon-invader scale-none 70% 30%);
}
.repeat {
    decorator: image("/assets/alien_small.tga" repeat);
}
.custom-border {
    border-width: 20px 10px;
    border-color: transparent;
    decorator: image("my-custom-border.png") border-box;
}
```

### 修饰符

图像可以根据上述修饰符属性进行定位、缩放和变换。本节演示使用这些修饰符的结果。其中许多修饰符操作以下图像：

{:.center}
![image-invader.png](../../../assets/images/decorators/image-invader.png)

#### 适配模式

`image-fit`{:.prop} 属性。

![image-fit-modes.png](../../../assets/images/decorators/image-fit-modes.png)

#### 对齐模式

`image-align-x`{:.prop} 和 `image-align-y`{:.prop} 属性。这里使用 `image-fit: scale-none`{:.value}。

![image-alignment-modes.png](../../../assets/images/decorators/image-alignment-modes.png)

#### 方向

`image-orientation`{:.prop} 属性。

![image-orientation.png](../../../assets/images/decorators/image-orientation.png)
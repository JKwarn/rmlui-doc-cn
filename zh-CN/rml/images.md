---
layout: page
title: RML 图像
parent: rml
next: forms
---

### \<img\>

`<img>`{:.tag} 元素用于在文档中包含图像或[精灵图（sprites）](../rcss/sprite_sheets.html)。

_属性_

`src`{:.attr} = uri (CT)
: 图像的源位置。

`sprite`{:.attr} = sprite (CS)
: 当前文档中精灵图表（sprite sheet）内某个精灵的名称。如果设置了该属性，则 `src`{:.attr} 和 `rect`{:.attr} 属性将被忽略。

`width`{:.attr} = number (CN)
: 强制元素具有的宽度，单位为像素。如果未指定，将按顺序默认为精灵、矩形或图像的宽度。

`height`{:.attr} = number (CN)
: 强制元素具有的高度，单位为像素。如果未指定，将按顺序默认为精灵、矩形或图像的高度。

`rect`{:.attr} = four numbers (CN)
: 将图像裁剪为图像文件内的一个子矩形。以四个（无单位）值 `x y width height` 的空格分隔列表指定，其中隐含像素单位。对精灵无效。
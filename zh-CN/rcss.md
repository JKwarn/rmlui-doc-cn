---
layout: page
title: RCSS 层叠样式表
short_title: RCSS
---

本文档定义了 *RCSS 层叠样式表（RCSS Cascading Style Sheets）*语言。RCSS 基于 [CSS2 规范](http://www.w3.org/TR/REC-CSS2/)，移除或更改了部分元素以适应 RmlUi 的需求。在某些情况下，也采用了 [CSS3 工作草案](http://www.w3.org/Style/CSS/current-work) 中的元素。本文档概述了 RCSS 及其与 CSS 之间的差异，阅读时应结合 CSS2 规范。

RCSS 与 RML 的交互方式与 CSS 和 HTML 完全相同。在 RCSS 中声明的样式属性会被选择性地附加到 RML 中定义的元素上，从而影响其布局、定位和其他样式属性（如字体、颜色、文本装饰等）。

如果你熟悉 CSS，可以从[属性索引](rcss/property_index.html)开始，其中列出了 RCSS 支持的属性、取值以及包含的新功能。接下来，阅读[装饰器](rcss/decorators.html)——一种全新的、灵活的元素皮肤方案。

如果你不熟悉 CSS，请结合 CSS2 规范阅读本文档以获取详细示例和技术细节，或者暂时跳过所有内容，直接动手体验示例！

### 目录

0. [语法和基本数据类型](rcss/syntax.html)
0. [选择器](rcss/selectors.html)
0. [属性值赋值、层叠与继承](rcss/cascade.html)
0. [盒模型](rcss/box_model.html)
0. [视觉格式化模型](rcss/visual_formatting_model.html)
0. [视觉格式化模型细节](rcss/visual_formatting_model_details.html)
0. [视觉效果](rcss/visual_effects.html)
0. [颜色、背景与圆角](rcss/colours_backgrounds.html)
0. [字体](rcss/fonts.html)
0. [文本](rcss/text.html)
0. [表格](rcss/tables.html)
0. [用户界面](rcss/user_interface.html)
0. [Flexbox 布局](rcss/flexboxes.html)
0. [动画、过渡与变换](rcss/animations_transitions_transforms.html)
0. [自定义属性与变量](rcss/custom_properties.html)
0. [媒体查询](rcss/media_queries.html)
0. [精灵表](rcss/sprite_sheets.html)
0. [装饰器](rcss/decorators.html)
    * [图像](rcss/decorators/image.html)
    * [水平平铺](rcss/decorators/tiled_horizontal.html)
    * [垂直平铺](rcss/decorators/tiled_vertical.html)
    * [盒状平铺](rcss/decorators/tiled_box.html)
    * [九宫格](rcss/decorators/ninepatch.html)
    * [直线渐变](rcss/decorators/gradient.html)
    * [线性渐变](rcss/decorators/linear_gradient.html)
    * [径向渐变](rcss/decorators/radial_gradient.html)
    * [锥形渐变](rcss/decorators/conic_gradient.html)
    * [着色器](rcss/decorators/shader.html)
    * [文本](rcss/decorators/text.html)
0. [遮罩](rcss/masking.html)
0. [滤镜](rcss/filters.html)
0. [字体效果](rcss/font_effects.html)
    * [glow](rcss/font_effects/glow.html)
    * [outline](rcss/font_effects/outline.html)
    * [shadow](rcss/font_effects/shadow.html)
    * [blur](rcss/font_effects/blur.html)

### 附录

* [属性索引](rcss/property_index.html)
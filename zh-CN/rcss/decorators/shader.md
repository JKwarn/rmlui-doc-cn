---
layout: page
title: 着色器装饰器
grandparent: rcss
parent: rcss/decorators
next: text
---

`shader`{:.prop} 装饰器作为 RCSS 样式表中的自定义点，供用户渲染自己的效果。装饰器将其指定的值传递给渲染接口，以便用户进行解释并按自己喜欢的方式渲染。

```css
decorator: shader( <value> ) <paint-area>?;
```

此装饰器可能有用的示例包括：动画背景、小地图、发光效果、创造性绘制的边框、流体模拟，以及任何其他你可能受到启发而创建的内容。

为了显示着色器装饰器，后端渲染器必须支持高级效果。特别是，此装饰器需要[着色器支持](../../cpp_manual/interfaces/render.html#shaders)，并且用户需要自己实现其所需的效果。


### 属性

`value`{:.prop}

取值： | \<string\>
初始值： | *空*
百分比： | 不适用

指定要传递给渲染器的值。内置的 [OpenGL3 渲染器](https://github.com/mikke89/RmlUi/blob/master/Backends/RmlUi_Renderer_GL3.cpp) 出于演示目的实现了一个着色器（`creation`{:.value}），可以在 `rmlui_sample_effects` 示例中看到。

`paint-area`{:.prop}

取值： | border-box \| padding-box \| content-box
初始值： | padding-box
百分比： | 不适用

声明渲染装饰器的盒区域。


### 示例

以下 RCSS 声明了一个着色器效果。

```css
.creation {
    decorator: shader("creation");
    border-radius: 20px;
    border: 3px #ddd;
}
```

其他示例。

```css
.shader1 {
    decorator: shader("my_shader") border-box;
}
.shader2 {
    decorator: shader("snake and rabbit");
}
```
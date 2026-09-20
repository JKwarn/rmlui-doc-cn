---
layout: page
title: 字体效果
parent: rcss
next: property_index
---

字体效果是 RCSS 对 CSS 的扩展，用于对文本应用效果，例如描边或阴影。与[装饰器](decorators.html)类似，字体效果在样式表中像属性一样被声明和命名，并使用字体效果特有的属性进行配置。可以开发自定义字体效果，将任意效果应用到文本上。

### RmlUi 字体效果

RmlUi 附带以下内置字体效果：

| 字体效果                              | 类型             | 说明                          |
|--------------------------------------|-------------------|--------------------------------|
| [发光](font_effects/glow.html)       | `glow`{:.prop}    | 发光文本与投影。 |
| [描边](font_effects/outline.html) | `outline`{:.prop} | 为文本描边。                |
| [阴影](font_effects/shadow.html)   | `shadow`{:.prop}  | 渲染阴影。             |
| [模糊](font_effects/blur.html)       | `blur`{:.prop}    | 模糊文本。                 |


### 属性
{:#font-effect}

字体效果在样式表内的声明和配置方式与装饰器类似。

`font-effect`{:.prop}

取值： | none \| \[\<type\>( \<properties\> )\]<span class="prop-def-symbol" title="One or more comma-separated occurrences">#+</span>
初始值： | none
继承： | 是
百分比： | 不适用

`<type>`{:.prop} 是字体效果类型，`<properties>`{:.prop} 指定给定装饰器类型的属性。

也可以指定多个字体效果，例如：
```css
font-effect: <type>( <properties> ), <type>( <properties> ), ... ;
```
多个字体效果按相反顺序应用。

请注意，字体效果没有像装饰器那样的 RCSS at-rule。因此，`font-effect`{:.prop} 属性不能使用名称。

#### 继承

与装饰器不同，字体效果会从父元素继承。例如，以下声明：

```css
h1
{
	font-effect: outline(2px black);
}
```

将为所有 `h1`{:.tag} 元素及其后代中的文本添加描边。要阻止继承，请用 `none`{:.value} 覆盖该效果。例如，要阻止 `h1`{:.tag} 的描边效果影响 `span`{:.tag} 元素，可以指定以下内容：

```css
h1 span
{
	font-effect: none;
}
```
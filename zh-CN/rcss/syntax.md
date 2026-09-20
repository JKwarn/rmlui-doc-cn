---
layout: page
title: 语法
parent: rcss
next: selectors
---

样式表由若干规则组成。每条规则包含多个选择器，用于界定规则适用的元素，以及应用于这些元素的属性。

规则的基本语法如下：

```css
selector1,
selector2,
selector3
{
	property1: value1;
	property2: value2;
	property3: value3;
}
```

选择器以逗号分隔，后面是花括号定义的规则块。规则块内部是由分号分隔的属性声明列表；每条属性声明由要设置的属性、一个冒号以及以空格分隔的待赋值列表组成。每个属性接受的值以及所需的数量，由该属性自身决定。

### 注释

样式表中可以使用 C 风格的 /* 和 */ 字符来包含注释。

### 取值

每个属性接受的取值在其定义中给出。取值可以是关键字（以特定字符串形式设置，如 `auto`、`left` 等）、通用字符串（如字体名称或文件路径），或下述类型之一。

#### 数字

在属性的取值列表中写作 `<number>`。数字可以是整数或实数。

```css
z-index: 16;
```

#### 长度

在属性的取值列表中写作 `<length>`。长度是由一个数字和一个单位组成的水平或垂直度量。RCSS 支持以下单位：

- `px`{:.value}：一个 px 等于输出介质上的一个像素。
- `dp`{:.value}：一个 dp 等于一个像素乘以一个全局定义的比例，[见下文](#dp-unit)。
- `em`{:.value}：在 `font-size`{:.prop} 属性中指定时，一个 em 等于父元素的字体大小；对于其他属性，则等于元素自身的字体大小。
- `rem`{:.value}：一个 rem 等于根（body）元素的字体大小。
- `ex`{:.value}：一个 ex 等于当前字体小写字母 x 的高度。
- `vw`{:.value}：一个 vw 等于上下文宽度的 1%。
- `vh`{:.value}：一个 vh 等于上下文高度的 1%。

此外，还支持基于每英寸像素数（PPI）的单位。PPI 单位的定义如下：

- `in`{:.value}：一英寸等于 `96dp`{:.value}。
- `cm`{:.value}：一厘米等于 `1/2.54 inch`{:.value}。
- `mm`{:.value}：一毫米等于 `1/25.4 inch`{:.value}。
- `pt`{:.value}：一点等于 `1/72 inch`{:.value}。
- `pc`{:.value}：一派卡等于 `1/6 inch`{:.value}。

```css
width: 125px;
```

##### 密度无关像素（dp）
{:#dp-unit}

`dp`{:.value} 单位的行为与 `px`{:.value} 类似，区别在于其大小可以全局设置，以相对于像素进行缩放。这样便于实现可缩放的用户界面。通过以下调用在上下文上全局设置该比例：

```c++
float dp_ratio = 1.5f;
context->SetDensityIndependentPixelRatio(dp_ratio);
```

RCSS 中的用法示例：
```css
div#header
{
	width: 800dp;
	height: 50dp;
	font-size: 20dp;
}
```

#### 百分比

在属性的取值列表中写作 `<percentage>`{:.value}。百分比值相对于某个其他值进行计算，该值在每个支持百分比的属性中都有说明。例如，宽度可以用百分比表示，相对于元素包含块的宽度进行计算。

```css
min-height: 50%;
```

#### 颜色

在属性的取值列表中写作 `<colour>`{:.value}。颜色可以通过多种方式声明，如下所示。

\<colour name\> —— 具名颜色
: HTML 4.0 规范中定义的 16 种颜色之一：aqua、black、blue、fuchsia、gray、green、lime、maroon、navy、olive、purple、red、silver、teal、white 和 yellow。另外还有 grey（gray 的别名）、orange 和 transparent。

`#RGB`{:.value}、`#RGBA`{:.value}、`#RRGGBB`{:.value}、`#RRGGBBAA`{:.value} —— 十六进制
: 以 `#` 开头，后跟 3、4、6 或 8 位十六进制数字。3 位和 6 位形式为不透明的 RGB。4 位和 8 位形式包含用于半透明的 alpha 通道。3 位和 4 位形式会展开每个分量，例如 `#FE0` → `#FFEE00`。

`rgb(r, g, b)`{:.value}、`rgba(r, g, b, a)`{:.value} —— [sRGB](https://en.wikipedia.org/wiki/SRGB)
: - `r`、`g`、`b`：分别为红、绿、蓝通道。取值范围 0 到 255（0% 到 100%）。
  - `a`：Alpha 通道。取值范围 0 到 255（0% 到 100%）。\
  **重要提示**：使用 `rgba` 关键字声明 alpha 通道的方式与 HTML5 规范不同。

`hsl(h, s, l)`{:.value}、`hsla(h, s, l, a)`{:.value} —— 圆柱形 [sRGB](https://en.wikipedia.org/wiki/SRGB)
: - `h`：以度为单位表示的色相（输入时不带单位）。
  - `s`：饱和度。百分比值，范围为 0% 到 100%。
  - `l`：亮度。百分比值，范围为 0% 到 100%。
  - `a`：Alpha 值。取值范围 0 到 1。

`lab(L a b)`{:.value}、`lab(L a b / A)`{:.value} —— [CIELAB](https://en.wikipedia.org/wiki/CIELAB_color_space)
: - `L`：整体亮度。取值范围 0 到 100（0% 到 100%）。
  - `a`：沿绿到红轴的距离。通常为 -125 到 +125（-100% 到 +100%），但可以超出。
  - `b`：沿蓝到黄轴的距离。通常为 -125 到 +125（-100% 到 +100%），但可以超出。
  - `A`：可选的 alpha 值。取值范围 0 到 1（0% 到 100%）。

  所有参数都可以取 `none`，其等价于 0。

`lch(L C H)`{:.value}、`lch(L C H / A)`{:.value} —— 圆柱形 [CIELAB](https://en.wikipedia.org/wiki/CIELAB_color_space)
: - `L`：整体亮度。取值范围 0 到 100（0% 到 100%）。
  - `C`：色度（色彩量）。通常为 0 到 150（0% 到 100%），但可以超出。
  - `H`：以度为单位表示的色相角（输入时不带单位）。
  - `A`：可选的 alpha 值。取值范围 0 到 1（0% 到 100%）。

  所有参数都可以取 `none`，其等价于 0。

`oklab(L a b)`{:.value}、`oklab(L a b / A)`{:.value} —— [Oklab](https://en.wikipedia.org/wiki/Oklab_color_space)
: - `L`：整体亮度。取值范围 0 到 1（0% 到 100%）。
  - `a`：沿绿到红轴的距离。通常为 -0.4 到 +0.4（-100% 到 +100%），但可以超出。
  - `b`：沿蓝到黄轴的距离。通常为 -0.4 到 +0.4（-100% 到 +100%），但可以超出。
  - `A`：可选的 alpha 值。取值范围 0 到 1（0% 到 100%）。

  所有参数都可以取 `none`，其等价于 0。

`oklch(L C H)`{:.value}、`oklch(L C H / A)`{:.value} —— 圆柱形 [Oklab](https://en.wikipedia.org/wiki/Oklab_color_space)
: - `L`：整体亮度。取值范围 0 到 1（0% 到 100%）。
  - `C`：色度（色彩量）。通常为 0 到 0.4（0% 到 100%），但可以超出。
  - `H`：以度为单位表示的色相角（输入时不带单位）。
  - `A`：可选的 alpha 值。取值范围 0 到 1（0% 到 100%）。

  所有参数都可以取 `none`，其等价于 0。

因此，例如以下颜色声明是等效的：

```css
color: red;

color: #F00;
color: #FF0000FF;

color: rgb(100%, 0%, 0%);
color: rgba(100%, 0%, 0%, 100%);
color: rgba(255, 0, 0, 255);

color: hsl(0, 100%, 50%);
color: hsla(0, 100%, 50%, 1.0);

color: lab(53% 80 67);
color: lab(53% 80 67 / 1.0);
color: lch(53% 105 40);
color: lch(53% 105 40 / 1.0);

color: oklab(63% 0.25 0.125);
color: oklab(63% 0.25 0.125 / 1.0);
color: oklch(63% 0.25 30);
color: oklch(63% 0.25 30 / 1.0);
```

#### 分辨率

在属性的取值列表中写作 `<resolution>`{:.value}。分辨率描述高 DPI 显示器的缩放比例，可用于媒体查询和精灵表中。

在 RCSS 中，分辨率总是用一个数字（缩放因子）后跟 `x`{:.value} 单位来指定。

```css
@media (min-resolution: 1.2x) { /* ... */ }
```

在这种情况下，指定的数字将与上下文的 [dp 比例](#dp-unit) 进行比较。

#### 比率

在属性的取值列表中写作 `<ratio>`{:.value}。比率使用 `<integer> / <integer>`{:.value} 的语法指定。

```css
@media (min-aspect-ratio: 16 / 9) { /* ... */ }
```

#### 变量

使用 `var()` 函数可以将[自定义属性](custom_properties.html)的值替换到声明中，还可以附带一个回退值。

```css
color: var(--brand, black);
```

### 从 RML 引用 RCSS

样式表既可以存储在外部文件中（扩展名通常为 .rcss）并从 RML 文件中引用，也可以声明在 RML 文件内部。使用 `<link>`{:.tag} 标签以如下方式引用外部 RCSS 文件：

```html
<rml>
	<head>
		<link type="text/css" href="sample.rcss" />

	...
```

文件路径相对于引用文档。

使用 `<style>`{:.tag} 标签声明内联样式表，同样位于 <head> 标签内：

```html
<rml>
	<head>
		<style>
			body
			{
				margin: 0px;
			}
		</style>

	...
```

单个文档中可以包含多个样式表，并与内联样式声明组合使用。样式声明的顺序很重要，因为它们可用于解决样式表规则冲突的优先级。

此外，样式表属性也可以直接声明在元素上。做法是将以分号分隔的样式表属性声明插入元素的 `style`{:.attr} 属性。例如，以下 RML 片段：

```html
<div style="width: 25%; min-width: 55px;">
</div>
```

在 `div`{:.tag} 元素上设置 `width`{:.prop} 属性为 '25%'、`min-width`{:.prop} 属性为 '55px'。
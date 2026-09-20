---
layout: page
title: 自定义属性与变量
parent: rcss
next: media_queries
---

RCSS 支持自定义属性以及用于引用它们的 `var()` 函数，通常称为 CSS 变量（参见 [CSS 自定义属性规范](https://www.w3.org/TR/css-variables-1/)）。它们允许你存储一个值并在许多声明中重复使用。

```css
body {
	--main-color: #b73a2a;
	--gap: 16px;
}
h1 {
	color: var(--main-color);
	margin-bottom: var(--gap);
}
```

### 与 CSS 的差异

在大多数情况下，其行为与 CSS 一致。下面列出一些较小的差异：

- 自定义属性本身不能设置动画。但是，使用 `var()` 的常规属性和简写可以。
- 回退值只在引用的变量缺失时使用。检测到依赖循环时*不*使用回退值。

### 声明自定义属性

自定义属性是其名称以两个连字符（`--`）开头的任何属性。值按原样存储，只有在通过 `var()` 替换到另一个属性中时才被解释。

```css
body {
	--brand: #b73a2a;
	--rgb-accent: 211, 84, 0;
	--gap: 16px;
	--title-size: 24px;
}
```

### 使用变量：'var()' 函数

使用 `var()` 函数引用自定义属性。它可以用于任何常规属性、另一个自定义属性或简写中。该函数可以构成更大值的一部分，一条声明可以包含任意数量的引用。

```css
h1 {
	color: var(--brand);
	font-size: var(--title-size);
}
#panel {
	/* 变量被替换到函数中。 */
	background-color: rgba(var(--rgb-accent), 200);
}
.swatch {
	/* 由另一个自定义属性构建的自定义属性。 */
	--brand-faded: var(--brand);
}
```

变量在计算时被替换，并针对其所在的属性进行解析。因此，解析过程中的任何语法错误都会在计算时被记录到日志中。

### 回退值

`var()` 接受一个可选的回退值，在引用的自定义属性未定义时使用。

```css
color: var(--brand, black);
```

回退值本身可以包含 `var()` 或其他函数，也可以由多个值组成。

```css
color:   var(--accent, var(--brand, black));
padding: var(--inset, 10px 5px);
```

### 层叠与继承

自定义属性像常规属性一样参与[层叠](cascade.html)，并且会被继承。在元素上定义的自定义属性对该元素及其所有后代可见，并且可以在树的更深层被覆盖。

```css
body     { --color-bg: #ffffff; }
#sidebar { --color-bg: #eeeeee; }
.panel   { background-color: var(--color-bg); }
```

每当变量发生变化时，所有引用它的属性都会自动重新计算。

结合[媒体查询](media_queries.html)，变量提供了一种实现主题的简洁方式。声明一次标记，在 `@media` 块内覆盖它们，并在整个样式表中引用它们：

```css
body {
	--bg: #f0ebd8;
	--fg: #1d1d1d;
}
@media (theme: dark) {
	body {
		--bg: #18181b;
		--fg: #f4f4f5;
	}
}
body {
	background-color: var(--bg);
	color: var(--fg);
}
```

然后可以在 C++ 中使用 [`Context::ActivateTheme()`](../cpp_manual/contexts.html#themes) 切换主题，所有基于变量的声明都会相应更新。

### 简写中的变量

`var()` 可用于简写属性，每个分量独立解析。单个变量也可以展开为多个值。

```css
body { --inset: 20px 5px; }

div {
	padding: var(--inset);
	margin: 0 var(--gap);
}
```

当简写与其某个长写分量同时声明时，适用正常的层叠规则。后声明的声明胜出。例如，`padding: var(--inset)`{:.value} 后跟 `padding-top: 0px`{:.value} 会保留显式的顶部内边距，而其余边缘来自变量。

### 动画与过渡

引用变量的常规属性和简写可以像往常一样被[动画和过渡](animations_transitions_transforms.html)。变量在构建动画时被解析为具体值。这包括在 `@keyframes` 块内部使用的变量。

自定义属性本身不能设置动画或过渡。

### 从 C++ 读写变量

自定义属性通过 `Element`{:.cls} 上的常规属性函数访问，传入包含 `--` 前缀的完整名称。

```cpp
// 设置或更改自定义属性。
element->SetProperty("--brand", "#b73a2a");

// 在检索解析后的属性之前，应先更新上下文，
context->Update();

// 读取所有变量已完全解析的值。
if (const Rml::Property* property = element->GetProperty("--brand"))
	Rml::String value = property->ToString();

// 移除局部覆盖。
element->RemoveProperty("--brand");
```

`Element::GetProperty()` 返回层叠和继承之后的值，并且 `var()` 引用已完全解析。另一方面，`Element::GetLocalProperty()` 检索*指定值（specified value）*，其中任何变量都未解析，并且仅当直接在当前元素上设置时才有值。与其他计算值一样，解析后的变量只有在[上下文更新](../cpp_manual/elements.html#validity-of-retrieved-values)之后才保证是最新的。返回的指针仅在下次调用 RmlUi 之前有效，因此如果需要保留该属性，请按值复制。

### 示例

有关使用设计令牌和可切换主题的完整示例，请参阅 `variables` 示例（`Samples/basic/variables`{:.path}）。
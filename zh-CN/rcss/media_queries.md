---
layout: page
title: 媒体查询
parent: rcss
next: sprite_sheets
---

RCSS 的 at-rule `@media` 可用于根据给定的一组条件动态激活和停用样式规则。RCSS 媒体查询遵循 [CSS 语法](https://developer.mozilla.org/en-US/docs/Web/CSS/@media)，并带一些扩展和[限制](#limitations)。

```css
@media (orientation: landscape) and (min-width: 640px)
{
	#menu {
		float: left;
		width: 320px;
	}
}

@media (min-resolution: 2x)
{
	@spritesheet theme2x
	{
		src: invader2x.tga;
		resolution: 2x;

		icon-invader: 179px 152px 102px 78px;
		icon-game:    330px 152px 102px 78px;
		icon-score:   534px 152px 102px 78px;
		icon-help:    728px 152px 102px 78px;
	}
}

@media (theme: blue)
{
	body {
		color: blue;
	}
	#header {
		background-color: #33e;
	}
}

@media not (theme: blue)
{
	body {
		color: red;
	}
	#header {
		background-color: #e33;
	}
}
```

### 媒体特性

下表列出了所有受支持的媒体特性。

名称 | 范围 | 取值 | 说明
---- | ----- | ----- | -----------
`width`{:.prop}         | 是 | \<length\>            | 上下文的宽度。
`height`{:.prop}        | 是 | \<length\>            | 上下文的高度。
`aspect-ratio`{:.prop}  | 是 | \<ratio\>             | 上下文的宽高比（宽度 / 高度）。
`resolution`{:.prop}    | 是 | \<resolution\>        | 上下文的 [dp 比例](syntax.html#dp-unit)。请注意，在 RCSS 中 [\<resolution\>](syntax.html#resolution) 总是采用 `x`{:.value} 单位。
`orientation`{:.prop}   | 否  | landscape \| portrait | 基于上下文宽度和高度的方向。
`theme`{:.prop}         | 否  | \<string\>            | 自定义 RCSS 特性。可以在上下文上[激活和停用](../cpp_manual/contexts.html#themes)。

由于 RmlUi 设计用于在屏幕和受控环境中显示，因此实现所有 [CSS 媒体特性](https://developer.mozilla.org/en-US/docs/Web/CSS/@media#media_features) 没有意义。

所有范围媒体特性都可以加上 `min-` 和 `max-` 前缀，分别指定最小和最大约束。所有其他约束都按相等性比较。

### 逻辑运算符

以下逻辑运算符可用于组合媒体特性。

运算符 | 说明
-------- | -----------
`and`     | 所有条件都为真时匹配。
`not`     | 匹配条件的相反结果。

CSS 中找到的其他运算符目前不受支持。

### 限制

目前，与 CSS 相比，RCSS 存在一些限制。

- `@media` 规则不能嵌套。
- 条件不能在媒体查询内嵌套，例如使用括号。
- 单个媒体查询中只能指定给定特性的单个出现。
    - 例外：同一范围特性的 `min-` 和 `max-` 都可以指定。
- 不支持使用 `<=` 运算符等的 CSS Level 4 语法。
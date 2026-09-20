---
layout: page
title: 元素索引
parent: rml
next: html4_style_sheet
comment: Please run '_tools/generate_elements_and_properties_index.py' whenever elements or their URLs are added or changed.
---

以下是 RML 支持的元素列表：

- [`<rml>`{:.tag}](documents.html#rml)
- [`<head>`{:.tag}](documents.html#head)
- [`<title>`{:.tag}](documents.html#title)
- [`<link>`{:.tag}](documents.html#link)
- [`<style>`{:.tag}](style_sheets.html#style)
- [`<body>`{:.tag}](documents.html#body)
- `<br>`{:.tag}
- [`<handle>`{:.tag}](controls.html#handle)
- [`<img>`{:.tag}](images.html#img)
- [`<form>`{:.tag}](forms.html#form)
- [`<input>`{:.tag}](forms.html#input)
- [`<textarea>`{:.tag}](forms.html#textarea)
- [`<select>`{:.tag}](forms.html#select)
- [`<option>`{:.tag}](forms.html#option)
- [`<label>`{:.tag}](forms.html#label)
- [`<tabset>`{:.tag}](controls.html#tabset)
- [`<tab>`{:.tag}](controls.html#tab)
- [`<panel>`{:.tag}](controls.html#panel)
- [`<progress>`{:.tag}](data_display.html#progress)

另请参阅 C++ 手册中的[元素包]({{"pages/cpp_manual/element_packages.html"|relative_url}})，了解如何控制其中多个元素的行为。

RmlUi 不提供默认样式表，因此，那些在 HTML 中仅代表特定样式规则的标签在 RmlUi 中并无特殊含义，例如 `<div>`{:.tag}、`<span>`{:.tag} 和 `<table>`{:.tag}。用户可以包含[推荐样式表](html4_style_sheet.html)来为这些标签启用通用规则。

在包含相应插件时，以下元素也会被启用：

- [`<script>`{:.tag}](documents.html#script)
- [`<lottie>`{:.tag}](../cpp_manual/lottie.html)
- [`<svg>`{:.tag}](../cpp_manual/svg.html)
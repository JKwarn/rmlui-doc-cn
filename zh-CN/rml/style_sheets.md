---
layout: page
title: RML 样式表
parent: rml
next: templates
---

样式可以通过三种方式包含在 RML 文档中：从外部样式表包含、在头部声明、或在特定标签内以内联方式声明。

### 外部样式表 {#link}

样式表通过 `<link>`{:.tag} 标签从外部来源包含。参见[链接元素](documents.html#link)。

### 头部样式信息 {#style}

RCSS 可以通过 `<style>`{:.tag} 标签直接包含在头部内。

*无属性*

### 内联样式声明

RCSS 可以通过 style 属性直接在元素内声明。

_属性_

`style`{:.attr} = style (CN)
: 该属性指定要应用于当前元素的 RCSS 属性列表。
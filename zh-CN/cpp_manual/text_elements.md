---
layout: page
title: 文本元素
parent: cpp_manual
next: custom_elements
---

RmlUi 使用文本元素（`Rml::ElementText`，派生自 `Rml::Element`）来存储和渲染零散文本。文本元素为 RML 文档中的文本自动生成，可以通过使用 '#text' 元素实例化器（instancer）经由 RmlUi factory 动态创建，或通过文档上的 `CreateTextNode()` 函数创建。

### 文本编码

RmlUi 中通篇使用的字符串类型 `Rml::String` 是 `std::string` 的别名。它总是被假定为 UTF-8 编码。这允许高效地存储任何 Unicode 字符，并与标准 ASCII 字符兼容。在 `RmlUi/Core/StringUtilities.h`{:.path} 中有一些用于遍历 UTF-8 编码字符串的辅助函数。

### HTML 字符

RmlUi 文本节点支持完整 HTML 编码的一个子集，用于特殊字符，以允许 XML 字符出现在零散文本中。支持的字符有：

* `&lt;`{:.value} 小于符号 '<'。
* `&gt;`{:.value} 大于符号 '>'。
* `&amp;`{:.value} 与符号 '&'。
* `&nbsp;`{:.value} 不换行空格。

当把它们放入 RML 时，你应该使用这些符号而不是它们的字面等价形式。例如，以下 RML 片段很可能会生成解析错误：

```html
<p>You shouldn't use < or > characters in loose text.</p>
```

以下片段正确地放置了这些字符：

```html
<p>You shouldn't use &lt; or &gt; characters in loose text.</p>
```

### 设置元素的文本

`Rml::ElementText` 上的 `SetText()` 函数将把文本元素上的文本更改为新字符串。

```cpp
// Sets the raw string this text element contains.
// @param[in] text The new string to set on this element.
void SetText(const Rml::String& text);
```

请注意，这设置的是元素上的原始文本；实际渲染的文本可能因空白处理而有所不同。

### 检索元素的文本

`GetText()` 函数将返回元素的原始文本。

```cpp
// Returns the raw string this text element contains.
// @return This element's raw text.
const Rml::String& GetText() const;
```

### 字符串生成

文本元素能够生成其内容的格式化子部分。这通常只有将文本放置在内部的自定义元素才需要；更多信息请参阅隐藏元素一节。
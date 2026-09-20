---
layout: page
title: 隐藏元素
parent: cpp_manual
next: element_packages
---

RmlUi 区分作为 DOM 一部分、对所有子系统可见的普通元素，以及（默认情况下）只有被显式请求才能找到的隐藏（或非 DOM）元素。隐藏元素通常由自定义元素使用；例如，[下拉选择元素](element_packages/form.html#drop-down-select-box)为其箭头按钮、值字段和选择框创建隐藏元素。

### 隐藏元素的差异

RmlUi 中忽略隐藏元素的子系统有：

* 自动布局。
* RML 序列化；即 `GetInnerRML()` 不会为隐藏元素生成 RML。

仍然识别隐藏元素的重要子系统有：

* 输入事件。
* 更新与渲染。
* RCSS 属性。

因此，使用隐藏元素的自定义元素可以精确控制其大小和定位，同时仍然获得 RCSS 属性系统的全部灵活性。还提供了用于布局的辅助方法。

### 添加隐藏元素

隐藏元素与其他元素一样创建，要么通过 [RmlUi factory](elements.html#dynamically-creating-elements)，要么通过[文档](documents.html#creating-new-elements)上的 `CreateElement()`。

要将元素作为隐藏元素挂接到另一个元素，照常调用 `AppendChild()`，但将第二个参数设置为 `false`。

```cpp
// Append a child to this element.
// @param[in] element The element to append as a child.
// @param[in] dom_element True if the element is to be part of the DOM, false otherwise.
void AppendChild(Element* element, bool dom_element = true);
```

如果你使用 `InsertBefore()` 而不是 `AppendChild()` 来挂接元素，那么如果与插入位置相邻的元素是隐藏的，新元素也将是隐藏的。

### 访问隐藏元素

元素按隐藏状态对其子元素进行分隔。可见子元素总是排在前面，因此索引低于隐藏子元素。默认情况下，元素的 `GetNumChildren()` 函数将返回可见元素的数量。要查找包括隐藏元素在内的元素总数，请将布尔值 `true` 传入该函数。

```cpp
// Get the current number of children in this element
// @param[in] include_non_dom_elements True if the caller wants to include the non-DOM children.
// @return The number of children.
int GetNumChildren(bool include_non_dom_elements = false) const;
```

以下代码将遍历元素的所有隐藏子元素：

```cpp
for (int index = element->GetNumChildren(); index < element->GetNumChildren(true); ++index)
	hidden_element = element->GetChild(index);
```

### 格式化隐藏元素

自定义元素通常在收到 "resize" 事件时在内部调整其隐藏元素的大小和位置。

#### 调整大小

可以通过调用 `SetBox()` 函数调整隐藏元素的大小。`SetBox()` 接受一个 `Rml::Box` 结构，其中包含二维内容区域的大小以及每条边的内边距、边框和外边距（有关[盒模型]({{"pages/rcss/box_model.html"|relative_url}})的更多信息，请参阅 RCSS 文档）。

```cpp
// Sets the box describing the size of the element, and removes all others.
// @param[in] box The new dimensions box for the element.
void SetBox(const Rml::Box& box);
```

你可以自己构造盒，或者使用 `Rml::ElementUtilities` 上的静态 `BuildBox()` 函数：

```cpp
// Generates the box for an element.
// @param[out] box The box to be built.
// @param[in] containing_block The dimensions of the content area of the block containing the element.
// @param[in] element The element to build the box for.
// @param[in] inline_element True if the element is placed in an inline context, false if not.
static void BuildBox(Box& box, Rml::Vector2f containing_block, Element* element, bool inline_element = false);
```

`BuildBox()` 将根据元素上设置的 `width`{:.prop}、`max-width`{:.prop}、`min-width`{:.prop} 以及 `height`{:.prop}、`max-height`{:.prop} 和 `min-height`{:.prop} 属性生成 `Rml::Box` 的值。参数是：

* `box`：要生成的盒。
* `containing_block`：元素的包含块。这通常是包含元素内容区域的大小，但不一定。
* `element`：要为其生成盒的元素。
* `inline_element`：如果元素是内联的则为 true，否则为 false。一般来说，你希望将其保留为 false。

以下代码将在其父元素内部生成并设置隐藏元素的盒：

```cpp
Rml::Box box;
Rml::ElementUtilities::BuildBox(box, GetBox().GetContentArea(), hidden_element);
hidden_element->SetBox(box);
```

但如果你想强制隐藏元素为某个特定大小，你可能会这样做：

```cpp
Rml::Box box;
box.SetContent(Rml::Vector2f(100, 150));
box.SetEdge(Rml::Box::BORDER, Rml::Box::TOP, 1);
hidden_element->SetBox(box);
```

#### 定位

要设置隐藏元素的位置，请使用 `SetOffset()` 函数。这设置了元素左上边框边相对于另一个元素左上边框边的二维偏移。通常，自定义元素会将内部隐藏元素相对于自身定位，但这不是必需的。

```cpp
// Sets the position of this element, as a two-dimensional offset from another element.
// @param[in] offset The offset (in pixels) of our primary box's top-left border corner from our offset parent's top-left border corner.
// @param[in] offset_parent The element this element is being positioned relative to.
// @param[in] offset_fixed True if the element is fixed in place (and will not scroll), false if not.
void SetOffset(Rml::Vector2f offset,
               Rml::Element* offset_parent,
               bool offset_fixed = false);
```

然而，`Rml::ElementUtilities` 有许多函数可以帮助定位隐藏元素。`PositionElement()` 调整元素大小（使用 `BuildBox()`）并将其定位在其父元素内。由于边框角到边框角的定位可能相当令人困惑，此函数将偏移视为元素内容区域之间的偏移。

```cpp
// Sizes an element, and positions it within its parent offset from the borders of its content area.
// @param element[in] The element to size and position.
// @param offset[in] The offset from the parent's borders.
// @param anchor[in] Defines which corner or edge the border is to be positioned relative to.
static bool PositionElement(Rml::Element* element,
                            Rml::Vector2f offset,
                            Rml::ElementUtilities::PositionAnchor anchor);
```

`PositionElement()` 还有一个重载，用于将元素定位为相对于其父元素的特定角或边偏移，而不只是左上角。第三个参数 `anchor` 可以是 `PositionAnchor` 枚举中的一个或多个进行 OR 组合：

```cpp
enum PositionAnchor
{
	TOP = 1 << 0,
	BOTTOM = 1 << 1,
	LEFT = 1 << 2,
	RIGHT = 1 << 3,

	TOP_LEFT = TOP | LEFT,
	TOP_RIGHT = TOP | RIGHT,
	BOTTOM_LEFT = BOTTOM | LEFT,
	BOTTOM_RIGHT = BOTTOM | RIGHT
};
```

#### 调用布局引擎

RmlUi 的内部布局引擎可以在隐藏元素上运行，以格式化该元素的可见后代。为此，请调用 `Rml::ElementUtilities` 上的静态 `FormatElement()` 函数。

```cpp
// Formats the contents of an element.
// @param[in] element The element to lay out.
// @param[in] containing_block The size of the element's containing block.
static bool FormatElement(Rml::Element* element,
                          const Rml::Vector2f& containing_block);
```

### 格式化隐藏文本元素

可以将文本元素作为隐藏元素追加。在这种情况下，你将需要使用 `Rml::ElementText` API 让元素生成并定位字符字符串。

#### 生成文本行

一旦文本元素被设置了原始文本（通过 `SetText()` 函数），你可以调用 `GenerateString()` 生成用于在单行上渲染的字符序列。根据原始文本的长度和可用宽度，你可能需要多次调用 `GenerateString()` 来生成渲染元素内容所需的所有行。

```cpp
// Generates a line of text rendered from this element.
// @param[out] line The characters making up the line, with white-space characters collapsed and endlines processed appropriately.
// @param[out] line_length The number of characters from the source string consumed making up this string.
// @param[out] line_width The width (in pixels) of the generated line.
// @param[in] line_begin The index of the first character to be rendered in the line.
// @param[in] maximum_line_width The width (in pixels) of space allowed for the line, or -1 for unlimited space.
// @param[in] right_spacing_width The width (in pixels) of the spacing that must be remaining on the right of the line if this is the final line.
// @param[in] trim_whitespace_prefix If we're collapsing whitespace, whether or not to remove all prefixing whitespace or collapse it down to a single space.
// @return True if the line reached the end of the element's text, false if not.
bool GenerateLine(Rml::String& line,
                  int& line_length,
                  float& line_width,
                  int line_begin,
                  float maximum_line_width,
                  float right_spacing_width,
                  bool trim_whitespace_prefix);
```

此函数的参数是：

* `line`：生成的行的内容将被写入的字符串。
* `line_length`：用于存储源字符串生成此行所消耗字符数的整数。由于空白处理，此值可能大于生成行的长度。
* `line_width`：用于存储生成字符串宽度（以像素为单位）的浮点值。
* `line_begin`：源字符串中开始生成行的第一个字符的索引。
* `maximum_line_width`：行可以具有的最大长度（以像素为单位）。
* `right_spacing_width`：如果生成的行是文本节点所需的最后一行，则此空间（以像素为单位）必须在该行右侧可用。自定义文本布局通常不需要。
* `trim_whitespace_prefix`：如果设置为 true，折叠后的空白将从行首修剪。第一行通常设置为 false，第二行及后续行为 true。

如果生成的行是渲染元素内容所需的最后一行，该函数将返回 true，如果需要更多行则返回 false。

以下代码示例将生成文本节点所需的全部行，每行允许最大宽度为 200 像素：

```cpp
Rml::ElementText* text_element = document->CreateTextNode("sample text");

int line_begin = 0;
bool last_line = false;

while (!last_line)
{
	Rml::String line;
	int line_length = 0;
	float line_width = 0;

	last_line = text_element->GenerateString(line, line_length, line_width, line_begin, 200, 0, line_begin > 0);
	line_begin += line_length;
}
```

`GenerateString()` 将根据元素上 `white-space`{:.prop} RCSS 属性的值适当地格式化空白和换行。要更改其处理空白的方式，请更改 `white-space`{:.prop} 属性。

然而，仅从元素生成文本行还不会定位它们或渲染它们。

### 渲染文本

文本元素存储生成的行的列表，每行有一个相对于文本元素左上角的二维偏移。要开始定位行，请调用 `ClearLines()` 清除所有先前生成的行。

```cpp
// Clears all lines of generated text and prepares the element for generating new lines.
void ClearLines();
```

然后为每个生成的行调用 `AddLines()`。

```cpp
// Adds a new line into the text element.
// @param[in] line_position The position of this line, as an offset from element.
// @param[in] line The contents of the line.
void AddLine(Rml::Vector2f line_position, const Rml::String& line) = 0;
```

以下代码示例在前一个示例的基础上，在生成每行文本时放置它：

```cpp
Rml::ElementText* text_element = document->CreateTextNode("sample text");

int line_begin = 0;
bool last_line = false;
float position = 0;

while (!last_line)
{
	Rml::String line;
	int line_length = 0;
	float line_width = 0;

	last_line = text_element->GenerateString(line, line_length, line_width, line_begin, 200, 0, line_begin > 0);
	line_begin += line_length;

	text_element->AddLine(line, Rml::Vector2f(position, 0));
	position += (float) Rml::ElementUtilities::GetLineHeight(text_element);
}
```

### 示例

你可以在[元素包](element_packages.html)中看到大量使用隐藏元素的示例，特别是在 select 表单控件（`ElementFormControlSelect.cpp`{:.path} 和 `WidgetDropDown.cpp`{:.path}）中，或者对于文本布局，在文本区域控件（`ElementFormControlText.cpp`{:.path} 和 `WidgetTextInput.cpp`{:.path}）中。
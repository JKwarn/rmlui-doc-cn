---
layout: page
title: 文档
parent: cpp_manual
next: contexts
---

文档是容器[元素](elements.html)。它们被设计用来表示应用程序界面中的一个 `window'`。文档本身就是元素，它们直接包含的元素以它们为父元素。

### 标识

文档有一个标题，在 RML 中由文档头中 `<title>`{:.tag} 标签的内容定义。默认情况下，标题不做任何事情，但可以用来填充标题栏的内容（如在 _Rocket Invaders from Mars_ 演示中）。`GetTitle()` 函数将返回文档的标题，`SetTitle()` 将设置它。

```cpp
// Sets the document's title.
// @param[in] title The new title of the document.
void SetTitle(Rml::String& title);

// Returns the title of this document.
// @return The document's title.
const Rml::String& GetTitle() const;
```

如果文档是从 RML 文件加载的，`GetSourceURL()` 函数将返回源 RML 的路径。

```cpp
// Returns the source address of this document.
// @return The source of this document, usually a file name.
const Rml::String& GetSourceURL() const;
```

### 文档与上下文

每个文档都是单个上下文的一部分。上下文中的文档像桌面上的窗口一样分层。文档分层可以通过用户输入（即，当文档被点击时，默认会将其提升到顶部）、以编程方式或通过 `z-index`{:.prop} 属性来控制。

`GetContext()` 函数将返回文档的上下文。

```cpp
// Returns the document's context.
// @return The context this document exists within.
Rml::Context* GetContext();
```

#### 分层

文档的 `z-index`{:.prop} 属性与元素一样控制渲染顺序。具有较高 `z-index`{:.prop} 的文档将始终渲染在具有较低 `z-index`{:.prop} 的文档之上。文档默认从 `z-index`{:.prop} 为 `0`{:.value} 开始。

`PullToFront()` 和 `PushToBack()` 函数将在具有相似 `z-index`{:.prop} 的文档之间将文档移动到文档栈的前面或后面。例如，对 `z-index`{:.prop} 为 `1`{:.value} 的文档调用 `PullToFront()` 将强制所有 `z-index`{:.prop} 低于 `1`{:.value} 的文档，以及所有其他 `z-index`{:.prop} 为 `1`{:.value} 的文档在它之前渲染。但是，具有更高 `z-index`{:.prop} 的文档仍将在它之后渲染。

```cpp
// Brings the document to the front of the document stack.
void PullToFront();

// Sends the document to the back of the document stack.
void PushToBack();
```

拉前和推后文档只影响调用时刻的文档栈。如果加载更多文档，或其他文档被推前和拉后，文档栈将发生变化。

#### 分层与鼠标

默认情况下，如果在悬停于文档上时按下主鼠标按钮，该文档将被带到文档栈的前面（类似于 `PullToFront()` 调用）。如果文档具有除默认值 `auto`{:.value} 之外的任何 `z-index`{:.prop} 值，则不会发生此行为。

### 可见性

当文档加载到上下文中时，它开始时是隐藏的（其 `visibility`{:.prop} 值为 `hidden`{:.value}）。要显示文档，请使用 `Show()` 函数：

```cpp
// Show the document.
// @param[in] modal_flag Flags controlling the modal state of the document, see the 'ModalFlag' description for details.
// @param[in] focus_flag Flags controlling the focus, see the 'FocusFlag' description for details.
// @param[in] scroll_flag Flag controlling scrolling, see the 'ScrollFlag' description for details.
void Show(ModalFlag modal_flag = ModalFlag::None, FocusFlag focus_flag = FocusFlag::Auto, ScrollFlag scroll_flag = ScrollFlag::Auto);
```

默认情况下，`Show()` 函数将使文档可见，并将键盘焦点切换到文档，如果可能的话切换到第一个设置了 `autofocus`{:.attr} 标记属性的控件元素。焦点行为以及模态状态可以用两个独立的标志控制。标志指定如下：

```cpp
/** ModalFlag controls the modal state of the document. */
enum class ModalFlag {
	None,  // Remove modal state.
	Modal, // Set modal state, other documents cannot receive focus.
	Keep,  // Modal state unchanged.
};
/** FocusFlag controls the focus when showing the document. */
enum class FocusFlag {
	None,     // No focus.
	Document, // Focus the document.
	Keep,     // Focus the element in the document which last had focus.
	Auto,     // Focus the first tab element with the 'autofocus' attribute or else the document.
};
/** ScrollFlag controls whether an element is scrolled into view when showing the document. */
enum class ScrollFlag {
	None, // Never scroll.
	Auto, // Scroll the focused element into view, if applicable.
};
```

要隐藏文档，请调用 `Hide()`。

```cpp
// Hide the document.
void Hide();
```

要检查文档是否为模态，请使用 `IsModal()`。

```cpp
// Does the document have modal display set.
// @return True if the document is hogging focus.
bool IsModal() const;
```

### Tab 元素

通常，`tab` 键可用于在*可 tab 切换*的元素之间导航。这主要适用于输入元素，但可以根据需要通过 [`tab-index`{:.prop} 属性](../rcss/user_interface.html#tab-index) 在任何其他元素上启用。

虽然 tab 切换行为在文档中基于收到的按键事件自动执行，但有时手动控制此行为的某些方面可能很有用。在这方面一个有用的工具是 `FindNextTabElement()` 方法，它可用于从文档树中的任何其他元素找到下一个可 tab 切换的元素。

```cpp
// Finds the next tabbable element in the document tree, starting at the given element, possibly wrapping around the document.
// @param[in] current_element The element to start from.
// @param[in] forward True to search forward, false to search backward.
// @return The next tabbable element, or nullptr if none could be found.
Element* FindNextTabElement(Element* current_element, bool forward);
```

### 手动更新文档

文档在调用 `Context::Update()` 期间[始终被更新](contexts.html#update-and-rendering)。然而，有时可能还需要手动更新文档，以便可以查询元素的布局后大小或位置，特别是在元素被修改或添加到文档之后。

```cpp
// Updates the document, including its layout. Users must call this manually before requesting information such as
// size or position of an element if any element in the document was recently changed, unless Context::Update has
// already been called after the change. This has a perfomance penalty, only call when necessary.
void ElementDocument::UpdateDocument();
```

更多内容请参阅[检索元素值的有效性](elements.html#validity-of-retrieved-values)。

### 关闭

对文档调用 `Close()` 将把文档从其上下文中移除，并销毁它及其所有元素。

```cpp
// Close the document.
void Close();
```

文档实际上直到下一次调用 `Context::Update()` 或 `Rml::Shutdown()` 时才会被销毁，因此附加到文档或其任何子元素的事件监听器必须保持存活到那时。

### 创建新元素

与 HTML 文档类似，RmlUi 文档能够创建新元素和文本节点。你可以使用 `CreateElement()` 函数创建某种类型的新元素：

```cpp
// Creates the named element.
// @param[in] name The tag name of the element.
Rml::ElementPtr CreateElement(const Rml::String& name);
```

name 参数是新元素所需的标签名。请注意，由于你无法指定独立的 instancer 名称或要传递给 instancer 的 RML 标记属性（attribute），此方法不如通过 factory 创建元素灵活，但对于轻松创建简单元素很有用。

调用 `CreateTextNode()` 以使用给定的文本字符串创建新的文本元素：

```cpp
// Create a text element with the given text content.
// @param[in] text The text content of the text element.
Rml::ElementPtr CreateTextNode(const Rml::String& text);
```

text 参数将被解释为 UTF-8 编码的字符串。返回的元素将派生自 `Rml::ElementText`。

请注意，这两个函数都不会以任何方式将新元素实际附加到文档。有关如何执行此操作的细节，请参阅[元素](elements.html#using-a-document)的说明。

### 自定义文档

所有文档都像普通元素一样从 'body' 标签实例化。创建自定义文档类型的过程与[创建自定义元素](custom_elements.html)相同，只不过你应该派生自 `Rml::ElementDocument` 而不是 `Rml::Element`，并且只针对 `<body>`{:.tag} 标签注册元素 instancer。

如果你为 `<body>`{:.tag} 标签注册的 instancer 返回的元素不是派生自 `Rml::ElementDocument`，文档将加载失败。

`Rml::ElementDocument` 中有两个相关的虚函数：

```cpp
// Loads an inline script into the document. Note that the base implementation does nothing, scripting language addons
// hook this method.
// @param[in] content The script content.
// @param[in] source_path Path of the script the source comes from, useful for debug information.
// @param[in] source_line Line of the script the source comes from, useful for debug information.
virtual void LoadInlineScript(const String& content, const String& source_path, int source_line);

// Loads an external script into the document. Note that the base implementation does nothing, scripting language addons
// hook this method.
// @param[in] source_path The script file path.
virtual void LoadExternalScript(const String& source_path);
```

`LoadInlineScript()` 和 `LoadExternalScript()` 通常仅用于将脚本语言集成到 RmlUi 中。对于每个 `<script>`{:.tag} 标签，它们分别在文档上被调用，并带有脚本内容或 `src`{:.attr} 标记属性。默认实现不做任何事情；自定义文档可以在这里做任何需要的事情，以加载、编译和绑定其元素的脚本。
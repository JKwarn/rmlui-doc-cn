---
layout: page
title: 系统接口
parent: cpp_manual/interfaces
grandparent: cpp_manual
next: file
---

系统接口是 RmlUi 报时所需要的，并允许应用程序执行常见任务，例如记录来自 RmlUi 的消息、翻译字符串和设置鼠标光标。系统接口为所有函数提供默认实现，但是，用户可能希望用自己的自定义行为覆盖默认行为。

系统接口提供在 `<RmlUi/Core/SystemInterface.h>`{:.incl} 中。要开发自定义系统接口，请创建一个派生自 `Rml::SystemInterface` 的类，并为你希望覆盖的虚函数提供函数定义。

#### 已用时间

```cpp
// Get the number of seconds elapsed since the start of the application.
virtual double GetElapsedTime();
```
`GetElapsedTime()` 函数应简单地返回自应用程序启动以来经过的秒数。默认实现使用标准 C++ chrono 工具。

#### 字符串翻译

```cpp
// Translate the input string into the translated string.
virtual int TranslateString(Rml::String& translated, const Rml::String& input);
```
当从 RML 流构造文本元素时，会调用 `TranslateString()`。这允许应用程序通过其字符串表发送所有从文件读取的文本。参数 `input` 是从 RML 读取的原始文本，而 `translated` 应设置为最终要交给文本元素渲染的文本。应返回对原始文本所做的更改总数。如果该数字大于 0，RmlUi 将递归调用你的翻译函数来处理添加到流中的任何新文本（注意无限递归）。如果你的翻译函数自己完成所有递归，你可以在每次调用时安全地返回 0。

请注意，翻译后的文本可以包含 RML 标签，它们将被处理，就像它们在原始流中一样；例如，这可以用于为某些标记替换图像。

#### 路径

```cpp
// Joins the path of an RML or RCSS file with the path of a resource specified within the file.
virtual void JoinPath(String& translated_path, const String& document_path, const String& path);
```
此函数可以被特化以修改路径的连接方式。例如，当从 RML 文件引用 RCSS 文件，或从 RCSS 文件引用图像文件时，RmlUi 会调用它。在大多数情况下，默认实现应该是合适的。

#### 日志记录

```cpp
// Log the specified message.
virtual bool LogMessage(Rml::Log::Type type, const Rml::String& message);
```
当 RmlUi 生成消息时，会调用 `LogMessage()` 函数。这里，`type` 是 `Rml::Log::LT_ERROR`（错误消息）、`Rml::Log::LT_ASSERT`（失败的内部断言，仅调试库）、`Rml::Log::LT_WARNING`（非致命警告）或 `Rml::Log::LT_INFO`（一般信息消息）之一。`message` 参数是实际消息本身。如果程序执行应继续，该函数应返回 true；如果要生成中断以中断执行，则返回 false。如果你在调试器中运行，这可能很有用，可以确切地看到应用程序做了什么才触发了某条消息。

#### 鼠标光标

```cpp
// Set the mouse cursor.
virtual void SetMouseCursor(const Rml::String& cursor_name);
```
当 RmlUi 想要更改鼠标光标时，会调用 `SetMouseCursor()` 函数。此行为由 [`cursor`{:.prop} 属性](../../rcss/user_interface.html#cursor)控制，其值通过接口直接作为 `cursor_name` 发送。`cursor`{:.prop} 属性的默认值是一个空字符串，因此这可以用于设置默认光标。还有一些[内置光标名称](../contexts.html#builtin-cursors)，当上下文处于某种状态时（例如在自动滚动期间）会提交它们。

用户负责设置系统光标或以其他方式按需渲染光标。可以选择每个上下文是否应调用此函数，更多细节请参阅[上下文光标](../contexts.html#mouse-cursor)。

#### 剪贴板

```cpp
// Set clipboard text.
virtual void SetClipboardText(const String& text);
// Get clipboard text.
virtual void GetClipboardText(String& text);
```
当 RmlUi 想要将给定文本复制到剪贴板时，会调用 `SetClipboardText()`。这通常在用户按下文本输入字段中的复制快捷键（Ctrl+C）时调用。同样，当 RmlUi 想要检索当前存储在剪贴板中的文本时，会调用 `GetClipboardText()`，通常在用户按下粘贴键组合（Ctrl+V）之后。

客户端自己负责在需要时与系统剪贴板交互，默认的库实现只会在应用程序内部复制和粘贴文本。所有文本都被视为 UTF-8 编码。


#### 虚拟键盘

```cpp
// Activate keyboard (for touchscreen devices).
virtual void ActivateKeyboard(Rml::Vector2f caret_position, float line_height);
// Deactivate keyboard (for touchscreen devices).
virtual void DeactivateKeyboard();
```
当 RmlUi 想要激活或停用虚拟键盘时（例如在手机和平板上），会调用这些函数。这通常在用户聚焦或离开文本输入字段时调用。

此外，每当当前文本字段的光标位置更改时，都会调用 `ActivateKeyboard()`。`caret_position` 是光标在窗口坐标中的绝对位置，而 `line_height` 是正在编辑的当前行的像素高度。这些参数可用于定位任何输入法编辑器（IME）。
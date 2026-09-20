---
layout: page
title: 文本输入处理器接口
parent: cpp_manual/interfaces
grandparent: cpp_manual
---

与其他接口不同，文本输入处理器接口即使不实现也不会妨碍应用程序的功能。它监听所有可编辑文本区域的事件，例如文本字段激活，并提供代理对象来操纵相关文本输入。它是[输入法编辑器（IME）](../ime.html)自定义实现的最佳入口点。

要处理这些事件，请创建一个派生自 `Rml::TextInputHandler`（在 `<RmlUi/Core/TextInputHandler.h>`{:.incl} 中定义）的类，并覆盖你感兴趣的抽象方法：

```cpp
// Called when a text input area is activated (e.g., focused).
virtual void OnActivate(TextInputContext* input_context) {}

// Called when a text input area is deactivated (e.g., by losing focus).
virtual void OnDeactivate(TextInputContext* input_context) {}

// Invoked when the context of a text input area is destroyed (e.g., when the element is being removed).
virtual void OnDestroy(TextInputContext* input_context) {}
```

完成实现后，使用 `Rml::SetTextInputHandler()` 全局安装它，或在上下文构造期间传递它，以拥有特定于所创建上下文的实例。请记住，覆盖全局处理器不会影响已存在的上下文。

实现输入处理器的类然后可以与交给它的输入上下文通信。典型情况下，输入上下文的实现由库提供，允许用户专注于 IME 或其他与输入相关的功能。

### 文本输入上下文

文本输入上下文是用于管理可编辑文本区域的代理类。{{ page.lib_name }} 为文本字段元素实现了 `Rml::TextInputContext` 接口（在 `<RmlUi/Core/TextInputContext.h>`{:.incl} 中定义），但库的用户可以决定为纯虚方法提供自定义实现：

```cpp
/// Retrieve the screen-space bounds of the text area (in px).
/// @param[out] out_rectangle The resulting rectangle covering the projected element's box (in px).
/// @return True if the bounds can be successfully retrieved, false otherwise.
virtual bool GetBoundingBox(Rectanglef& out_rectangle) const = 0;

/// Retrieve the selection range.
/// @param[out] start The first character selected.
/// @param[out] end The first character *after* the selection.
virtual void GetSelectionRange(int& start, int& end) const = 0;

/// Select the text in the given character range.
/// @param[in] start The first character to be selected.
/// @param[in] end The first character *after* the selection.
virtual void SetSelectionRange(int start, int end) = 0;

/// Move the cursor caret to after a specific character.
/// @param[in] position The character position after which the cursor should be moved.
virtual void SetCursorPosition(int position) = 0;

/// Replace a text in the given character range.
/// @param[in] text The string to replace the character range with.
/// @param[in] start The first character to be replaced.
/// @param[in] end The first character *after* the range.
/// @note This method does not respect internal restrictions, such as the maximum length.
virtual void SetText(StringView text, int start, int end) = 0;

/// Update the range of the text being composed (for IME).
/// @param[in] start The first character in the range.
/// @param[in] end The first character *after* the range.
virtual void SetCompositionRange(int start, int end) = 0;

/// Commit an composition string (from IME), and respect internal restrictions (e.g., the maximum length).
/// @param[in] composition The string to replace the composition range with.
/// @note If the composition range equals to [0, 0], it takes no action.
virtual void CommitComposition(String composition) = 0;
```

此接口提供了将 {{ page.lib_name }} 与现有游戏引擎连接的方法，以用于 IME 或任何其他与用户输入相关的功能。输入上下文实例的生命周期以 `Rml::TextInputHandler` 中调用 `OnDestroy()` 结束，文本输入处理器必须确保在此时之后不再与同一实例交互。

#### IME 组合

通常，当 IME 组合处于活动状态时，文本可能忽略内部限制（例如最大文本长度）以改善用户体验。`SetText()` 是一个接受传入文本并替换字符范围的方法。然而，一旦组合结束，结果字符串应在遵循输入配置的同时插入；此时应使用 `CommitComposition()`。请注意，它只有在组合范围通过 `SetCompositionRange()` 设置后才生效，这必须在修改文本之前执行；文本修改会取消组合范围。

以下是使用文本输入上下文的文本输入法编辑器示例实现：

```cpp
class TextInputMethodEditor {
public:
    void SetComposition(Rml::StringView composition);
    void ConfirmComposition(Rml::StringView composition);

private:
    // An actively used text input method context.
    Rml::TextInputContext* input_context;

    // Composition range (character position) relative to the text input value.
    int composition_range_start;
    int composition_range_end;
};

void TextInputMethodEditor::SetComposition(Rml::StringView composition)
{
    // Retrieve the composition range if it is missing.
    if (composition_range_start == 0 && composition_range_end == 0)
        input_context->GetSelectionRange(composition_range_start, composition_range_end);

    // First, modify the text value of the text area to insert the current composition string.
    input_context->SetText(composition, composition_range_start, composition_range_end);

    // Calculate the new end of the composition range, as the string has changed.
    size_t length = Rml::StringUtilities::LengthUTF8(composition);
    composition_range_end = composition_range_start + (int)length;

    // Once we are finished with text modifications, apply the composition range for visual feedback.
    input_context->SetCompositionRange(composition_range_start, composition_range_end);
}

void TextInputMethodEditor::ConfirmComposition(Rml::StringView composition)
{
    // First, set the composition range, which will be used for inserting the composition string.
    input_context->SetCompositionRange(composition_range_start, composition_range_end);
    // Once the range is set, insert the composition string into the text field.
    input_context->CommitComposition(Rml::String(composition));

    // Move the cursor to the end of the string.
    input_context->SetCursorPosition(composition_range_end);

    // End the composition, clean up the state, ...

    // ...
}
```

在真实应用程序中，你会希望将编辑器连接到后端并处理组合状态。请参阅[平台实现](https://github.com/mikke89/RmlUi/tree/master/Backends)获取带有可直接使用的文本输入处理器的详细示例。
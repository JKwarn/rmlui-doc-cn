---
layout: page
title: 输入法编辑器
parent: cpp_manual
next: plugins
---

输入法编辑器（IME）是一种软件组件，允许用户输入标准 QWERTY 键盘上无法直接输入的其他字符。这对于使用与拉丁字母不同的书写系统的语言至关重要，例如日语、中文、越南语等。此外，操作系统可能将 IME 用于复杂输入，例如剪贴板历史或 Windows 上的表情符号键盘。

为了获得全面支持，[加载字体](fonts.html)以覆盖上述字符集非常重要。

### 示例

{{ page.lib_name }} 附带 `rmlui_sample_ime` 示例，演示了 IME 支持。它仅在受支持的平台上可用。

![输入法编辑器（IME）与后备字体以支持不同书写系统的展示。](../../assets/images/ime_sample.png)

除了作为全面 IME 支持的独立示例之外，否则它们在输入时只会被渲染为缺失字符。

CMake 选项 `RMLUI_IME_SAMPLE_USE_NOTO_FONTS`
: 默认情况下，此选项被禁用。启用后，将在构建时下载外部 Noto 字体并在此示例中使用。

: ***Win32 后端***：该示例始终可用。默认情况下，它加载系统字体作为后备，以正确表示其他书写系统，例如韩文（Hangul）、蒙古文等。当启用 CMake 选项时，则改而使用 Noto 字体。

: ***SDL 后端***：使此示例可用需要该 CMake 选项，它需要 Noto 字体才能正确运行。

### 实现

{{ page.lib_name }} 旨在为系统 IME 提供默认实现，并提供用于集成你自己的系统的工具。

#### 默认实现

默认情况下，IME 系统消息通过实现从后端全局设置的自定义[文本输入处理器](interfaces/text_input_handler.html)，在平台层面处理。因此，如果你使用默认后端实现，覆盖全局文本输入处理器将停用 IME 功能。

不同平台上 IME 支持的状态如下：

| 平台 | IME | API   |
| -------- |:---:|:-----:|
| GLFW     | ❌   |       |
| SDL      | ✔️   | SDL   |
| SFML     | ❌   |       |
| Win32    | ✔️   | IMM32 |
| X11      | ❌   |       |

如果你不使用提供的后端，但包含平台文件并希望由 {{ page.lib_name }} 处理 IME，你可以使用平台提供的文本输入处理器实现，它位于其头文件中。你可能还必须将此实例传递给系统消息处理器。有关使用 Win32 平台提供的实现的示例，请参阅[初始化](#initialization)一节。

#### 初始化

文本输入处理器可以使用 `Rml::SetTextInputHandler()` 全局安装，或在上下文构造期间传递。例如，以下内容展示了如何安装 Win32 平台提供的默认实现：

```cpp
#include <Backends/RmlUi_Platform_Win32.h>

static Rml::Context *context = nullptr;
static Rml::UniquePtr<TextInputMethodEditor_Win32> text_input_method_editor;

// Local event handler for window and input events.
static LRESULT CALLBACK WindowProcedureHandler(HWND window_handle, UINT message, WPARAM w_param, LPARAM l_param)
{
    return RmlWin32::WindowProcedure(context, *text_input_method_editor, window_handle, message, w_param, l_param);
}

int APIENTRY WinMain(HINSTANCE instance_handle, HINSTANCE previous_instance_handle, char* command_line, int command_show)
{
    // Initialize the window and graphics API being used, along with the renderer, system, and other interfaces, ...

    // ...

    // Instantiate the text input handler managing the IME.
    text_input_method_editor = Rml::MakeUnique<TextInputMethodEditor_Win32>();

    // Install the custom interface.
    Rml::SetTextInputHandler(text_input_method_editor.get());

    // Now we can initialize RmlUi.
    Rml::Initialise();

    // Create a context next.
    context = Rml::CreateContext("main", Rml::Vector2i(window_width, window_height));
    if (context == nullptr)
    {
        Rml::Shutdown();
        return -1;
    }

    // Load documents, handle the application loop, ...

    // ...

    // Shutting down RmlUi releases all its resources, including contexts that work with the text input handler.
    Rml::Shutdown();

    // It is now safe to destroy the custom interfaces previously passed to RmlUi, such as the text input handler.
    text_input_method_editor.reset();

    return 0;
}
```

真实应用程序会适当地抽象化并更加复杂。这只是一个简单的示例，旨在配合[初始化与主循环](main_loop.html)教程。

#### 自定义实现

默认实现可能并不总是自定义游戏引擎的最佳解决方案，特别是当你使用与提供的 API 不同的 API 时（例如，Windows 上使用 Text Services Framework 而不是 IMM32）。

##### 系统接口

IME 与平台紧密相关，例如在定位候选窗口方面。这可以通过 `Rml::SystemInterface` 接口覆盖 `ActivateKeyboard()` 方法来完成，该方法会收到当前的绝对光标位置和行高：

```cpp
#include <RmlUi/Core/SystemInterface.h>

class SampleSystemInterface : public Rml::SystemInterface {
private:
    void ActivateKeyboard(Rml::Vector2f caret_position, float line_height) override;

private:
    HWND window_handle;
};

void SampleSystemInterface::ActivateKeyboard(Rml::Vector2f caret_position, float line_height)
{
    HIMC himc = ImmGetContext(window_handle);
    if (himc == NULL)
        return;

    constexpr LONG BottomMargin = 2;

    // Adjust the position of the input method editor (IME) to the caret.
    const LONG x = static_cast<LONG>(caret_position.x);
    const LONG y = static_cast<LONG>(caret_position.y);
    const LONG w = 1;
    const LONG h = static_cast<LONG>(line_height) + BottomMargin;

    COMPOSITIONFORM comp = {};
    comp.dwStyle = CFS_FORCE_POSITION;
    comp.ptCurrentPos = {x, y};
    ImmSetCompositionWindow(himc, &comp);

    CANDIDATEFORM cand = {};
    cand.dwStyle = CFS_EXCLUDE;
    cand.ptCurrentPos = {x, y};
    cand.rcArea = {x, y, x + w, y + h};
    ImmSetCandidateWindow(himc, &cand);

    ImmReleaseContext(window_handle, himc);
}
```

由于 `ActivateKeyboard()` 会在文本输入区域的每次操作时被调用，候选窗口将始终定位在光标旁边。

##### 文本输入上下文

现有的游戏引擎通常提供接口以将它们与外部 GUI 解决方案（例如 {{ page.lib_name }}）连接。为此，文本输入控件实现了 `Rml::TextInputContext` 接口，可以通过实现 `Rml::TextInputHandler` 接口与之交互。[文本输入处理器](interfaces/text_input_handler.html)的实现位于提供输入的平台层与为其控件实现文本输入上下文的库之间。

```cpp
#include <RmlUi/Core/TextInputHandler.h>

class TextInputMethodEditor : public Rml::TextInputHandler {
public:
    void OnActivate(Rml::TextInputContext* input_context) override;
    void OnDeactivate(Rml::TextInputContext* input_context) override;
    void OnDestroy(Rml::TextInputContext* input_context) override;

    // Add user methods for interacting with the text input context based on platform input here.

private:
    // An actively used text input method context.
    Rml::TextInputContext* active_input_context = nullptr;
};

void TextInputMethodEditor::OnActivate(Rml::TextInputContext* input_context)
{
    active_input_context = input_context;
}

void TextInputMethodEditor::OnDeactivate(Rml::TextInputContext* input_context)
{
    if (active_input_context == input_context)
        active_input_context = nullptr;
}

void TextInputMethodEditor::OnDestroy(Rml::TextInputContext* input_context)
{
    if (active_input_context == input_context)
        active_input_context = nullptr;
}
```

`Rml::TextInputContext` 公开了操作底层文本输入区域所需的全部方法，例如获取当前选择范围、替换文本值的一部分、获取元素的边界框，或更新组合范围（例如用于视觉反馈）。你可以将此上下文视为游戏引擎现有 IME 系统的实现，或者创建自己的编辑器。请参阅[平台实现](https://github.com/mikke89/RmlUi/tree/master/Backends)获取具体示例。

使用 `Rml::SetTextInputHandler()` 全局安装新处理器，如[初始化](#initialization)示例所示，或在上下文构造期间传递它。

##### 文本字段元素

如果你想避免使用文本输入处理器（以及相应的文本输入上下文）而直接访问元素，`Rml::ElementFormControlInput` 和 `Rml::ElementFormControlTextArea` 都公开了必要的实现方法，例如 `SetCompositionRange()` 用于设置范围内组合所用的视觉反馈。请注意，该范围在每次值变化时都会重置。

与之前的技术相比，你必须自己处理激活和停用事件以及自定义文本输入元素。
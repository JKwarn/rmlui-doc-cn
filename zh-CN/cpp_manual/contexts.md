---
layout: page
title: 上下文
parent: cpp_manual
next: events
---

RmlUi 上下文是文档的独立集合。所有文档都存在于单个上下文之中。上下文由应用程序自行决定，彼此独立地进行渲染、更新和接收输入。

### 多上下文的用途

大多数游戏会为主要的界面使用单个上下文。然而，出于多种不同原因，也可以使用多个上下文。

#### 多桌面

可以使用第二个或后续的上下文来存储用户可以在其中切换的备选「桌面」，方式与许多 Linux 桌面类似。这对于界面繁多的游戏可能非常有用，这类游戏用户可能同时打开多个窗口，数量之多可能无法轻松放在一个屏幕上。

#### 世界内界面

3D 游戏世界中的计算机终端或控制台本身就可以是 RmlUi 上下文。由于它们不一定会与屏幕平行观看，因此需要将鼠标输入投影到表面上。渲染上下文时，需要正确变换以贴合表面，或渲染到纹理上。

### 创建上下文

要创建新上下文，请使用 `Rml::CreateContext()` 函数。

```cpp
// Creates a new element context.
// @param[in] name The new name of the context. This must be unique.
// @param[in] dimensions The initial dimensions of the new context.
// @return The new context, or nullptr if the context could not be created.
Rml::Context* CreateContext(const Rml::String& name,
                                     const Rml::Vector2i& dimensions);
```

上下文需要一个唯一的字符串名称和初始尺寸。这些尺寸用于生成相对长度（例如，如果文档具有百分比尺寸），并设置上下文内鼠标光标的范围。

要获取先前构建的上下文，请使用 `GetContext()` 函数。

```cpp
// Fetches a previously constructed context by name.
// @param[in] name The name of the desired context.
// @return The desired context, or nullptr if no context exists with the given name.
Rml::Context* GetContext(const Rml::String& name);
```

### 释放上下文

可以通过调用以下函数手动移除上下文。

```cpp
// Removes and destroys a context.
// @param[in] name The name of the context to remove.
// @return True if name is a valid context, false otherwise.
bool RemoveContext(const Rml::String& name);
```
所有剩余的上下文都会在调用 `Rml::Shutdown()` 期间被销毁。

### 更新与渲染

如果上下文处于活动状态，则应在该帧的输入事件发送给它之后对其调用 `Update()`。

```cpp
// Updates all elements in the context's documents.
bool Update();
```

上下文更新可确保上下文中所有元素的属性和计算值得到更新，并对所有需要的文档执行布局。在上下文更新之前，元素可能不会始终报告其正确的大小或位置，如[元素页面](elements.html#validity-of-retrieved-values)所述。

要渲染上下文，请对其调用 `Render()`。就这么简单！

```cpp
// Renders all visible elements in the context's documents.
bool Render();
```

请参阅[主循环文档](main_loop.html)了解这些调用如何融入应用程序的主循环。另请参阅下面的[按需渲染](#on-demand-rendering)，其中提供了允许应用程序延迟更新和渲染的工具，以防希望在空闲时降低资源消耗。

### 加载与创建文档

文档通过上下文加载。要将文档从 RML 文件加载到上下文中，请在相应的上下文上调用 `LoadDocument()` 函数。

```cpp
// Load a document into the context.
// @param[in] document_path The path to the document to load.
// @return The loaded document, or nullptr if no document was loaded.
ElementDocument* LoadDocument(const Rml::String& document_path);
```

`document_path` 参数将交给 RmlUi 的[文件接口](interfaces/file.html)打开并读取。如果文档加载成功，它将被添加到上下文中并返回。调用文档上的 `Show()` 使其可见。

你也可以直接从内存流加载文档，如果你希望通过网络或类似方式接收文档，这会很有用。

```cpp
/// Load a document into the context.
/// @param[in] document_rml The string containing the document RML.
/// @param[in] source_url Optional string used to set the document's source URL, or naming the document for log messages.
/// @return The loaded document, or nullptr if no document was loaded.
ElementDocument* LoadDocumentFromMemory(const String& document_rml, const String& source_url = "[document from memory]");
```

要创建可以动态填充的新的空文档，请使用 `CreateDocument()` 函数。

```cpp
/// Creates a new, empty document and places it into this context.
/// @param[in] instancer_name The name of the instancer used to create the document.
/// @return The new document, or nullptr if no document could be created.
ElementDocument* CreateDocument(const String& instancer_name = "body");
```

上下文将尝试使用调用方指定的 instancer 实例化一个元素，默认是 'body'。如果实例化出 `Rml::ElementDocument`，它将被添加到上下文中并返回。

### 滚动

上下文可以通过多种方式发起滚动：

- `ProcessMouseWheel()` 可以在悬停元素最近的、可滚动的祖先上发起滚动操作。
- 当按下鼠标中键时，`ProcessMouseButtonDown()` 可以激活[自动滚动模式](#autoscroll)。
- 此外，可以拖动元素的滚动条，或以编程方式设置其滚动位置。

有关这些函数的更多细节，请参阅[输入文档](input.html#mouse-buttons)。在某些情况下，滚动操作会发起[平滑滚动](#smooth-scrolling)。元素最近的、可滚动的祖先由滚动链决定，可以使用 [`overflow-behavior`{:.prop} 属性](../rcss/user_interface.html#overscroll-behavior) 控制。

#### 自动滚动模式
{:#autoscroll}

自动滚动模式通过按下或按住鼠标中键激活。这会以可控的速度滚动文档，速度基于鼠标光标距其初始激活位置的距离。

#### 平滑滚动
{:#smooth-scrolling}

平滑滚动使给定的滚动操作平滑地向其目标动画过渡。平滑滚动可以在几种情况下激活：

- 在调用 `Context::ProcessMouseWheel()` 期间。
- 当点击滚动条的箭头键或轨道时。
- 当使用 `ScrollBehavior::Smooth` 或 `ScrollBehavior::Auto` 调用任何 `Element::Scroll...()` 方法时。

默认的平滑滚动行为可以在上下文上配置，并且默认启用。这会影响所有具有自动滚动行为的滚动操作，包括鼠标滚轮和滚动条交互。

```cpp
/// Sets the default scroll behavior, such as for mouse wheel processing and scrollbar interaction.
/// @param[in] scroll_behavior The default smooth scroll behavior, set to instant to disable smooth scrolling.
/// @param[in] speed_factor A factor for adjusting the final smooth scrolling speed, must be strictly positive, defaults to 1.0.
void SetDefaultScrollBehavior(ScrollBehavior scroll_behavior, float speed_factor);
```
默认情况下，平滑滚动已启用。可以通过将 `scroll_behavior` 设置为 `ScrollBehavior::Instant` 来禁用它。平滑滚动的速度也可以使用 `speed_factor` 参数调整。


### 鼠标光标

每个上下文可以通过[系统接口](interfaces/system.html)将鼠标光标名称传播给用户。光标名称通过 [`cursor`{:.prop} 属性](../rcss/user_interface.html#cursor) 设置在元素上。当光标名称更改时，新名称将通过接口发送。客户端随后可以使用其平台上的光标工具更改显示的光标。

提交的光标名称按以下顺序选择。

1. 如果上下文处于自动滚动模式，提交下面列出的内置光标名称之一。
2. 否则，如果正在拖拽元素，则光标取自该元素的 `cursor`{:.prop} 属性。
3. 否则，如果正在悬停元素，则光标取自该元素的 `cursor`{:.prop} 属性。
4. 否则，提交空字符串。

#### 内置光标名称
{:#builtin-cursors}

以下内置光标名称在特定条件下提交给系统接口。

|        光标名称        | 说明   |
|---------------------------|---------------|
| `rmlui-scroll-idle`       | 自动滚动模式激活，但滚动处于空闲状态。                 |
| `rmlui-scroll-up`         | 自动滚动模式激活，沿给定方向滚动。      |
| `rmlui-scroll-down`       | "                                                              |
| `rmlui-scroll-left`       | "                                                              |
| `rmlui-scroll-right`      | "                                                              |
| `rmlui-scroll-up-left`    | "                                                              |
| `rmlui-scroll-up-right`   | "                                                              |
| `rmlui-scroll-down-left`  | "                                                              |
| `rmlui-scroll-down-right` | "                                                              |


#### 多个上下文

在使用多个上下文的情况下，可能方便仅由单个上下文处理鼠标光标。可以使用以下函数控制此行为：
```cpp
/// Enable or disable handling of the mouse cursor from this context.
/// When enabled, changes to the cursor name is transmitted through the system interface.
/// @param[in] show True to enable mouse cursor handling, false to disable.
void EnableMouseCursor(bool enable);
```
默认情况下它是启用的。

### 媒体主题
{:#themes}

媒体主题可以与[媒体查询](../rcss/media_queries.html)结合使用，通过 `theme`{:.prop} 媒体特性来激活或停用样式表的部分内容。

```cpp
/// Activate or deactivate a media theme. Themes can be used in RCSS media queries.
/// @param theme_name[in] The name of the theme to (de)activate.
/// @param activate True to activate the given theme, false to deactivate.
void ActivateTheme(const String& theme_name, bool activate);
/// Check if a given media theme has been activated.
/// @param theme_name The name of the theme.
/// @return True if the theme is activated.
bool IsThemeActive(const String& theme_name) const;
```

### 事件

事件监听器可以附加到上下文（而不是元素），以接收发送给该上下文内所有元素的事件。与元素一样，调用 `AddEventListener()` 附加监听器，调用 `RemoveEventListener()` 取消附加。

```cpp
// Adds an event listener to the context's root element.
// @param[in] event The name of the event to attach to.
// @param[in] listener Listener object to be attached.
// @param[in] in_capture_phase True if the listener is to be attached to the capture phase, false for the bubble phase.
void AddEventListener(const Rml::String& event,
                      Rml::EventListener* listener,
                      bool in_capture_phase = false);

// Removes an event listener from the context's root element.
// @param[in] event The name of the event to detach from.
// @param[in] listener Listener object to be detached.
// @param[in] in_capture_phase True to detach from the capture phase, false from the bubble phase.
void RemoveEventListener(const Rml::String& event,
                         Rml::EventListener* listener,
                         bool in_capture_phase = false);
```

请注意，与所有原始指针一样，它们是非拥有型的。因此，用户有责任让事件监听器一直存活到被移除，然后将其清理。

### 输入

有关将用户输入从你的应用程序发送到 RmlUi 上下文的细节，请参阅[输入](input.html)一节。

### 按需渲染（省电模式）
{:#on-demand-rendering}

在图形领域，我们可以大致将应用程序分为两类。

1. 尽可能快、尽可能多地输出帧的应用程序，例如游戏。
2. 仅在其内容发生变化时重绘窗口的其他应用程序，以减少 CPU 使用和功耗。

RmlUi 提供了处理这两种情况的工具，以适应用户目标应用程序的需求。RmlUi 用户控制自己的更新循环，因此，采用第一种方式只需在循环中无延迟地运行上下文更新和渲染即可。另一方面，第二种方式需要库侧的一些支持，因为应用程序需要知道例如何时发生动画或文本光标何时应该闪烁。

#### 循环更新触发器

在按需渲染期间，应用程序需要在以下情况下更新用户界面：

1. 依赖时间、库内部的变化影响渲染输出时。
2. 收到平台事件时。
3. 应用程序想要自己对文档做出更改时。

此功能旨在协助第一种情况。第二种情况取决于用户的平台，不在库本身的责任范围内，但[随附的后端](https://github.com/mikke89/RmlUi/tree/master/Backends)中有许多示例。最后一种情况完全由用户负责，用户自己有责任知道何时需要对界面做出自己的更改，并决定如何进行。

#### 更新延迟工具

选择按需渲染需要驱动更新循环的代码提供显式支持。该功能由两个可用于操作时间值的函数组成。

```cpp
// Updates the time until Update should get called again.
// @param[in] delay Maximum time until next update
void RequestNextUpdate(double delay);
```

此函数由 RmlUi 和自定义元素使用，用于设置直到用户界面应再次渲染的延迟时间，除非其间收到平台事件。这不是直接的 setter，它取已存储的值和传入值中的最小值。

渲染循环随后可以使用以下函数获取零到无穷大范围内的值。

```cpp
// Get the max delay until update and render should get called again
// @return Time until next update is expected.
double GetNextUpdateDelay() const;
```

返回值为零意味着渲染循环不应阻塞等待事件，即尽快渲染下一帧。例如，当动画正在播放时会发生这种情况。非零的有限值表示延迟若干秒后应再次调用更新和渲染循环。无穷大意味着除非收到平台事件，否则完全没有理由重绘内容。如果没有自定义元素或正在运行的动画，这通常是常态。

你可以通过调整传递给[随附示例](https://github.com/mikke89/RmlUi/blob/master/Samples/basic/load_document/src/main.cpp)中 `Backend::Process()` 函数的 `power_save` 标志来实际看到这一点。这在大多数[随附后端](https://github.com/mikke89/RmlUi/tree/master/Backends)中都有实现，请查看 `RmlUi_Backend_….cpp`{:.path} 文件以了解该功能是如何在那里集成的。

### 自定义上下文

上下文与元素和装饰器一样，通过 instancer 创建。如果你想创建自定义上下文，可以覆盖默认的上下文 instancer。通常，只有为了添加脚本语言支持时才需要这样做。

#### 创建自定义上下文

自定义上下文是派生自 `Rml::Context` 的类。`Rml::Context` 上没有虚方法，因此它不能被特化。

#### 创建自定义上下文 instancer

自定义上下文 instancer 需要在 RmlUi factory 中注册，以便覆盖默认 instancer。自定义上下文 instancer 需要派生自 `Rml::ContextInstancer`，并实现必需的虚方法：

```cpp
// Instances a context.
// @param[in] name Name of this context.
// @return The instanced context.
virtual Rml::ContextPtr InstanceContext(const Rml::String& name) = 0;

// Releases a context previously created by this context.
// @param[in] context The context to release.
virtual void ReleaseContext(Rml::Context* context) = 0;

// Releases this context instancer
virtual void Release() = 0;
```

每当请求新上下文时，都会调用 `InstanceContext()`。它接受一个参数 name，即新上下文的名称。如果可以创建上下文，则应对其进行初始化并以包装在 `ContextPtr`（一种带有自定义删除器的 unique pointer）中的形式返回。否则，返回 nullptr。

每当释放上下文时，都会调用 `ReleaseContext()`。上下文 instancer 应销毁该上下文并释放为其分配的任何资源。

当 RmlUi 关闭时，会调用 `Release()`。如果 instancer 是动态分配的，则应删除自身。

#### 注册 instancer

要向 RmlUi 注册自定义 instancer，请在 RmlUi 初始化之后调用 RmlUi factory 上的 `RegisterContextInstancer()`。

```cpp
// The custom_instancer must be kept alive until after the call to Rml::Shutdown()
auto custom_instancer = std::make_unique<CustomContextInstancer>();
Rml::Factory::RegisterContextInstancer(custom_instancer.get());
```

与其他 instancer 一样，管理 instancer 的生命周期是用户的责任。因此，它必须保持存活直到调用 `Rml::Shutdown()` 之后，然后由用户清理。

#### 枚举上下文

所有活动上下文都可以通过 `Rml::GetNumContexts()` 和 `Rml::GetContext(int index)` 函数调用进行枚举。
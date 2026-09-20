---
layout: page
title: 调试器插件
parent: cpp_manual
next: lottie
---

RmlUi 附带一个可视化的调试器插件，你可以使用并修改它来辅助开发。你可以在所有随附的示例（例如 _Rocket Invaders from Mars_ 应用程序）中按 `F8` 试用它。

### 工具

调试器附带的工具如下。

#### 事件日志

调试器放入自己的系统接口层，以拦截从 RmlUi 发出的日志消息。当发送了新日志消息时，日志信标（一个小的感叹号）将变得可见，位于其上下文右上角。你可以通过点击信标打开日志，或打开调试器并点击 `Event Log` 按钮。

#### 轮廓渲染器

如果你点击菜单上的 `Outlines` 按钮，调试器将在目标上下文中每个元素的边框区域周围渲染红色轮廓。

#### 元素信息

如果你点击菜单上的 `Element Info` 按钮，可视化调试器将打开。打开后，对目标上下文的鼠标点击将被拦截；任何被点击的元素将成为调试器的活动元素。调试器将显示有关活动元素的以下信息：

* 直接绘制在元素顶部的元素调试区域：内容区域（蓝色）、内边距（紫色）、边框（灰色）、外边距（黄色），以及绘制区域的边界框（白色轮廓）。
* 元素的标记属性（attribute）。
* 元素的样式属性（property），以及它们的声明位置。
* 元素主框的位置和大小。
* 完整的盒模型尺寸，列出为：
  * `box-x (px): margin-left|border-left|padding-left <content> padding-right|border-right|margin-right`
  * `box-y (px): margin-top|border-top|padding-top <content> padding-bottom|border-bottom|margin-bottom`
* 元素的祖先。
* 元素的子元素。

如果调试器在活动元素上又捕捉到一次点击，该点击将穿透到元素本身。

元素信息对话框有一些可以切换的设置：

* `*` `Select elements`（选择元素）。禁用此设置时，调试器将不再拦截文档中的鼠标点击，从而将信息保留在当前选中的元素上。
* `D` `Draw element dimensions`（绘制元素尺寸）。切换是否绘制所选元素的调试区域。
* `U` `Update info continuously`（持续更新信息）。启用后，所列出的元素样式属性（property）将自动刷新。

所有设置默认启用。

由于这些工具都是开源的，我们鼓励你在发现调试器无法提供所需信息时添加更多功能。你可以在 RmlUi 安装目录中的 `Source/Debugger/`{:.path} 目录下找到调试器插件的源码。

下图展示了调试器的工作状态。选中了一个元素，其调试区域绘制在元素顶部，其样式属性（property）和其他有用信息列在右侧。

![Debugger screenshot](../../assets/images/debugger.png)

#### 数据模型

点击 `Data Models` 按钮时，数据模型窗口会打开。此窗口允许检查正在调试的上下文中所有数据模型里所有数据变量的值。数据变量按每个数据模型分区显示。

![Debugger data models screenshot](../../assets/images/debugger-data-models.png)

### 初始化

要将调试器集成到你的应用程序中，请链接 `rmlui_debugger`{:.incl} 或导入的 CMake 目标 `RmlUi::Debugger`{:.incl}。然后在源文件中包含 `<RmlUi/Debugger.h>`{:.incl}。

要启动调试器，请对你希望调试器菜单渲染进其中的上下文调用 `Rml::Debugger::Initialise()`。

```cpp
// Initialises the debug plugin. The debugger will be loaded into the given context.
// @param[in] context The RmlUi context to load the debugger into.
// @return True if the debugger was successfully initialised
bool Initialise(Rml::Context* context);
```

调试器的上下文不一定是被调试的上下文，只是它渲染其元素的上下文。然而，当调试器初始化时，它会自动开始调试其所在的上下文。

### 调试另一个上下文

要调试另一个上下文，请调用 `Rml::Debugger::SetContext()` 方法。

```cpp
// Sets the context to be debugged.
// @param[in] context The context to be debugged.
// @return True if the debugger is initialised and the context was switched, false otherwise.
bool SetContext(Rml::Context* context);
```

调试器随后将准备好调试新上下文中的元素。

### 控制可见性

可以使用 `IsVisible()` 和 `SetVisible()` 函数控制调试器元素的可见性。

```cpp
// Sets the visibility of the debugger.
// @param[in] visibility True to show the debugger, false to hide it.
void SetVisible(bool visibility);

// Returns the visibility of the debugger.
// @return True if the debugger is visible, false if not.
bool IsVisible();
```

### 关闭或重启

如果需要，可以使用 `Rml::Debugger::Shutdown()` 手动关闭调试器。

```cpp
// Shuts down the debugger.
// @return True if the debugger was successfully shut down
void Shutdown();
```

关闭操作将在调用 `Rml::Shutdown()` 期间自动处理，因此通常不需要调用它。但是，如果你想在另一个宿主上下文中重新初始化调试器，它会很有用。关闭后，可以再次调用 `Rml::Debugger::Initialise()` 来重新启动调试器。
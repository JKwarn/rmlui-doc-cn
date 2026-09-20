---
layout: page
title: 故障排除
parent: cpp_manual
next: elements
---

有时在集成新库时会出现挑战。RmlUi 中最常见的集成问题与初始化、生命周期和渲染 API 有关，但也可能有其他原因。以下是当出现问题或渲染不正确时可以尝试的一些方法。

***你应该做的第一件事：***

- 检查日志输出中是否有任何警告或错误。
- 确保你确实得到了日志输出。
    - 尝试在安装系统接口或初始化库之后立即调用 `Rml::Log::Message(Rml::Log::LT_WARNING, "Test warning.")` 以确认。

#### 应用程序崩溃

- 确保所有内容按正确顺序初始化，详情请参阅[初始化与主循环](main_loop.html)。
- 确保你的[自定义接口](interfaces.html)保持存活到调用 `Rml::Shutdown()` 之后。
- 当你调用 `ElementDocument::Close()` 时，确保附加到文档任何元素的事件监听器保持存活到下一次调用 `Context::Update()` 或 `Rml::Shutdown()` 为止。

#### 渲染问题

- 仔细阅读 RmlUi 中使用的[渲染约定](interfaces/render.html#rendering-conventions)和假设。它描述了与 OpenGL 和 DirectX 等图形 API 一起使用的一些提示。
- 确保字体已加载，每当加载字体时日志输出会打印一些信息。
- 不要只依赖被测试文档中的字体渲染。尝试创建一个带彩色背景的已设置大小的 `div` 元素，以防字体有任何问题，请参阅下面的示例文档。
- 确保在调用 `Context::Update` 之前提交输入。
- 确保你先调用 `Context::Update`，然后调用 `Context::Render`（按此顺序）。
- 如果你加载自己的字体有困难，你可以改为使用调试器附带的字体进行测试。要使用它，`RmlDebugger` 必须被链接和初始化，然后在给定元素上设置属性 `font-family: rmlui-debugger-font;`。

#### 动画问题

遇到缓慢、快速或不流畅的动画？

- 确保 `SystemInterface::GetElapsedTime()` 已正确实现。它应返回以秒为单位的高分辨率时间值，并随着应用程序运行而始终增加。

没有什么能解决你的问题？看看随附的示例和后端，了解它们是如何工作的。你也可以在[主仓库]({{page.lib_site}})中发帖描述你的情况，或在 [RmlUi 的 Zulip 频道](https://rmlui.zulipchat.com/)与其他用户交流。


#### 简单文档

以下非常简单的文档可以作为测试，看看你是否能通过渲染接口获得一些渲染调用。

```html
<rml>
<head>
<title>Example</title>
<style>
	body
	{
		position: absolute;
		top: 50px;
		left: 50px;
		width: 500px;
		height: 500px;
		background-color: #ccc;
	}
	div
	{
		display: block;
		height: 150px;
		width: 200px;
		background-color: #f00;
	}
</style>
</head>
<body>
	<div/>
</body>
</rml>
```
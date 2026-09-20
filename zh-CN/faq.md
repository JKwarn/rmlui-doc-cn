---
layout: page
title: 常见问题
---


### 我遇到了渲染问题或崩溃，该如何解决？

请查看 C++ 手册中的[故障排查](cpp_manual/troubleshooting.html)页面。也欢迎你加入 [RmlUi 的 Zulip 频道](https://rmlui.zulipchat.com/)与其他用户交流，或在[主仓库]({{page.lib_site}})中发帖描述你的情况。


### 如何设置自定义光标？

你可以使用操作系统的光标功能来显示自定义光标。有关通过系统接口响应 `cursor`{:.prop} 属性的详细信息，请参见[此处](cpp_manual/contexts.html#mouse-cursor)。


### RmlUi 是线程安全的吗？

RmlUi 不提供任何线程安全方面的保证。从多个线程访问 RmlUi API 时需要进行同步，例如使用互斥锁（mutex）。


### 我可以从脚本中更改装饰器吗？

可以通过内联样式设置装饰器。不过，出于性能原因，强烈建议改为更改元素的类，以影响应用于该元素的装饰器。


### 如何实现高 DPI 支持？

RmlUi 对构建可缩放的用户界面提供了广泛支持。为了正确地缩放尺寸和长度，应在 RCSS 中广泛使用 [`dp`{:.value} 长度单位](rcss/syntax.html#dp-unit)。该单位可以通过 `Context::SetDensityIndependentPixelRatio` 函数设置 *dp-ratio*（密度无关像素比率），从而相对于 `px`{:.value} 单位进行缩放。

此外，RmlUi 还提供以下功能，让高 DPI 图形变得轻而易举：

- [媒体查询](rcss/media_queries.html) 支持 `resolution` 特性，可根据 dp-ratio 切换样式和精灵图。
- [精灵图表](rcss/sprite_sheets.html) 可以使用 `resolution` 属性指定所需的缩放。
- 精灵图可以被后面的 `@spritesheet` 规则覆盖，从而轻松定义[高 DPI 版本的精灵图](rcss/sprite_sheets.html#high-dpi)。
- 当 dp-ratio 发生变化并选中新的精灵图时，装饰器和 `<img>` 元素会自动更新。
- 装饰器和 `<img>` 元素中的精灵图会根据源缩放和目标 dp-ratio 进行缩放。

客户端需要自行向平台查询所需的缩放比率，然后在 RmlUi 上下文中设置 dp-ratio。请查看 RmlUi 附带的各个后端，了解在不同的[支持高 DPI 的平台](https://github.com/mikke89/RmlUi#rmlui-backends)上是如何实现的。


### 我可以实现文档的热重载吗？

当然可以，这是将 UI 文档声明与主应用程序逻辑分离的一大优势。

始终可以对文档进行完整重载。

```cpp
Rml::ElementDocument* my_document = context->LoadDocument("main_menu.rml");
// ...
// Later, after RML source was changed
my_document->Close();
my_document = context->LoadDocument("main_menu.rml");
```
例如，可以在 `.rml` 文档保存时自动进行重载，使你的更改立即生效。实现这种自动化需要用户自己负责，请研究如何在你的平台上实现。请注意，样式表和模板会自动缓存，你可能需要先调用 `Rml::Factory::ClearStyleSheetCache()` 和 `Rml::Factory::ClearTemplateCache()` 分别清除这些缓存。

显然，在此操作期间，任何状态或以编程方式更改的元素都会被重置。有时，我们希望保留当前状态，例如只在文档的样式上工作时。这时，用户可以调用以下方法。

```cpp
my_document->ReloadStyleSheet();
```

这只会重新加载应用于当前文档的样式表，同时保持文档结构及其状态不变。这也会更新头部声明的样式，但值得注意的是，*不会*更新使用元素属性 `style`{:.attr} 内联声明的样式。你可能希望在 `.rcss` 文件发生更改时，对可见文档自动调用此方法。此调用会自动先清除任何缓存。

最后，在编辑纹理时，以下函数可能会有所帮助：
```cpp
Rml::ReleaseTextures();
```
它定义在 `<RmlUi/Core/Core.h>`{:.path} 中。此调用会强制库重新加载所有正在使用的纹理。


### 如何从 C++/脚本绑定事件？

如果你在使用数据绑定，可以将 [`data-event` 视图](data_bindings/views_and_controllers.html#data-event) 与 C++ 中的回调函数一起使用。

或者，使用 `Element::AddEventListener` 函数，传入 `Rml::EventId` 或你想绑定的事件名称（不带 “on” 前缀）、要附加的监听器对象，以及是否希望在捕获阶段绑定，如下例所示。

```cpp
class MyListener : public Rml::EventListener {
public:
	void ProcessEvent(Rml::Event& event) {
		printf("Processing event %s", event.GetType().c_str());
	}
}

void main() {
	/* ... */
	auto my_listener = std::make_unique<MyListener>();
	element = document->GetElementById("my_button");
	element->AddEventListener(Rml::EventId::Click, my_listener.get(), false);
	/* ... */
}
```
有关详细信息，请参阅[事件监听器](cpp_manual/events.html#event-listeners)的文档。

最后，还可以响应内联事件，例如

```html
<button onclick="game.start()">Start Game</button>
```
有关详细信息，请参阅[内联事件](cpp_manual/events.html#inline-events)的文档。
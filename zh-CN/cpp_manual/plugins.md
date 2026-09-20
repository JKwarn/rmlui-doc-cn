---
layout: page
title: 插件
parent: cpp_manual
next: troubleshooting
---

RmlUi 有一个简单、直接的用于编写插件的系统。当上下文、文档、元素和数据模型被创建和销毁时，插件会收到通知。

### 创建插件

所有插件都派生自 `Rml::Plugin` 类。可以覆盖的虚函数有：

```cpp
// Called when RmlUi is initialised.
virtual void OnInitialise();
// Called when RmlUi shuts down.
virtual void OnShutdown();

// Called when a document load request occurs, before the document's file is opened.
virtual void OnDocumentOpen(Context* context, const Rml::String& document_path);
// Called when a document is successfully loaded, initialised, and added to its context. Called before the document's 'load' event.
virtual void OnDocumentLoad(ElementDocument* document);
// Called when a document is unloaded from its context. This is called after the document's 'unload' event.
virtual void OnDocumentUnload(ElementDocument* document);

// Called when a new context is created.
virtual void OnContextCreate(Rml::Context* context);
// Called when a context is destroyed.
virtual void OnContextDestroy(Rml::Context* context);

// Called when a new element is created.
virtual void OnElementCreate(Rml::Element* element);
// Called when an element is destroyed.
virtual void OnElementDestroy(Rml::Element* element);

// Called when a new data model is created on a context.
virtual void OnDataModelCreate(Rml::Context* context, const Rml::String& name);
// Called when a data model is about to be destroyed.
virtual void OnDataModelDestroy(Rml::Context* context, const Rml::String& name);
```

#### RmlUi 引擎事件

当 RmlUi 成功初始化时，将在所有已注册的插件上调用 `OnInitialise()` 函数。如果插件注册时 RmlUi 已经初始化，`OnInitialise()` 将立即在插件上被调用。

当 RmlUi 关闭时，在所有已注册的插件上调用 `OnShutdown()`，紧接着所有上下文和元素被销毁之后。插件必须在此调用期间释放它们分配的任何资源，包括它们自己。

#### 文档事件

当打开 RML 流时调用 `OnDocumentOpen()`，`OnDocumentLoad()` 和 `OnDocumentUnload()` 是在文档加载和卸载之前和之后调用的全局回调。

#### 上下文事件

当上下文被成功创建或销毁时，在每个已注册的插件上调用 `OnContextCreate()` 和 `OnContextDestroy()`。

#### 元素事件

当元素被成功创建或销毁时，在每个已注册的插件上调用 `OnElementCreate()` 和 `OnElementDestroy()`。

#### 数据模型事件

每当通过 `Context::CreateDataModel()` 在上下文上成功创建新的[数据模型](../data_bindings.html)时，都会调用 `OnDataModelCreate()`。尝试使用已存在的名称创建数据模型不会触发该回调。

当数据模型即将被销毁时调用 `OnDataModelDestroy()`，无论是通过 `Context::RemoveDataModel()` 显式销毁，还是在所属上下文被销毁时隐式销毁。在此回调期间，数据模型仍然可以通过 `Context::GetDataModel()` 解析，但一旦回调返回，它就变得不可用。

### 过滤事件类

默认情况下，插件会收到上面列出的所有事件。插件可以覆盖 `GetEventClasses()` 以仅接收其中一部分事件，方法是返回 `Rml::Plugin::EventClasses`{:.cls} 标志的组合：

标志 | 事件
------------------------- | ------
`EVT_BASIC`{:.value}      | `OnInitialise`, `OnShutdown`, `OnContextCreate`, `OnContextDestroy`
`EVT_DOCUMENT`{:.value}   | `OnDocumentOpen`, `OnDocumentLoad`, `OnDocumentUnload`
`EVT_ELEMENT`{:.value}    | `OnElementCreate`, `OnElementDestroy`
`EVT_DATA_MODEL`{:.value} | `OnDataModelCreate`, `OnDataModelDestroy`
`EVT_ALL`{:.value}        | 以上所有（默认）。

例如，一个只对文档事件感兴趣的插件：

```cpp
int GetEventClasses() override {
	return Rml::Plugin::EVT_DOCUMENT;
}
```

### 注册插件

要注册插件，请调用 `Rml::RegisterPlugin()` 函数。

```cpp
Rml::Plugin* plugin = new CustomPlugin();
Rml::RegisterPlugin(plugin);
```
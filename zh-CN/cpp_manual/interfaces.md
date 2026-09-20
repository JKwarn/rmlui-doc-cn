---
layout: page
title: 自定义接口
parent: cpp_manual
next: ime
---

RmlUi 提供了五个接口来控制它如何与你的应用程序交互。

* [渲染接口](interfaces/render.html)
* [系统接口](interfaces/system.html)
* [文件接口](interfaces/file.html)
* [字体引擎接口](interfaces/font_engine.html)
* [文本输入处理器接口](interfaces/text_input_handler.html)

只有渲染接口是所有应用程序都必须实现的。

除非先安装自定义接口，否则系统和文件接口将使用标准库方法的默认实现。还会安装一个默认字体引擎，它使用 FreeType 库加载字体和渲染字形，除非用户提供自己的字体引擎。

文本输入处理器可能由后端的[默认平台实现](ime.html#default-implementation)提供，或由空接口提供。

#### 自定义接口的安装

要安装自定义接口，请实例化你的接口，并在初始化 RmlUi 之前使用适当的 `Rml::Set*Interface()`（文本输入处理器则使用 `Rml::SetTextInputHandler()`）安装它。

```cpp
auto file_interface = std::make_unique<CustomFileInterface>();
Rml::SetFileInterface(file_interface.get());

/* ... */

Rml::Initalise();

/* ... */

Rml::Shutdown();

file_interface.reset();

```

***生命周期注意事项：*** RmlUi 持有接口的非拥有指针，因此请确保保持接口存活到调用 `Rml::Shutdown()` 之后，并在之后清理它。
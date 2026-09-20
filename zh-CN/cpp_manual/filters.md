---
layout: page
title: 滤镜
parent: cpp_manual
next: debugger
---

滤镜是通用的、可配置的、可重用的对象，设计用于附加到元素上，以在渲染期间添加自定义视觉效果。相同的滤镜既可以应用于元素的背景（`backdrop-filter`{:.prop} 属性），也可以应用于其他方面已完成渲染的元素（`filter`{:.prop} 属性）。它们还可以被调用来在其他渲染操作期间创建特殊效果，例如对 `box-shadow`{:.prop} 应用模糊。

关于滤镜如何通过 RML 附加到元素并进行配置的完整描述，请参阅 [RCSS 文档中的相关章节](../rcss/filters.html)。

### 滤镜概览

RmlUi 附带几个内置滤镜，包括模糊、投影和颜色调整。取决于你想要实现的视觉效果，你可能需要开发自定义滤镜。自定义滤镜的定义和实例化方式与自定义装饰器类似。需要创建一个派生自 `Rml::Filter` 的自定义滤镜类，并在 RmlUi factory 中为其注册一个 instancer。

当滤镜应用于元素时，该元素及其子元素的所有渲染都在一个单独的渲染层上完成。当元素完成渲染后，滤镜应用于该层，并与层栈中下面的层合成。另一方面，背景滤镜在元素其余部分渲染之前直接渲染到元素的背景上，而无需对元素及其子元素分层。

滤镜表示需要渲染器侧特定行为的效果。因此，自定义滤镜通常伴随着渲染器侧的一些新代码，例如新的图形着色器。用户需要在其渲染器中实现此行为。然而，通过在 RmlUi 中声明新的滤镜类型，用户将能够直接在 RCSS 中声明其自定义滤镜，就像任何其他内置滤镜一样。此外，RmlUi 将自动处理必要的分层，以便元素在应用滤镜效果的情况下被正确渲染。

与装饰器一样，滤镜在 RCSS 文档中为每条声明实例化一次。然后，对于每个使用该滤镜的元素，都会创建一个编译后的滤镜。该编译后的滤镜用于为该元素渲染滤镜效果。

### 自定义滤镜

如果你需要超出内置滤镜所能提供的自定义滤镜效果，你可以轻松创建自定义滤镜来满足你的需求。

#### 创建自定义滤镜

所有自定义滤镜都是派生自 `Rml::Filter` 的类。自定义滤镜中有两个需要覆盖的虚函数：

```cpp
/// Called to compile the filter for a given element.
/// @param[in] element The element the filter will be applied to.
/// @return A compiled filter constructed through the render manager, or a default-constructed one to indicate an error.
virtual Rml::CompiledFilter CompileFilter(Rml::Element* element) const = 0;

/// Called to allow extending the area being affected by this filter beyond the border box of the element.
/// @param[in] element The element the filter is being rendered on.
/// @param[in,out] overflow The ink overflow rectangle determining the clipping region to be applied when filtering the current element.
virtual void ExtendInkOverflow(Rml::Element* element, Rml::Rectanglef& overflow) const;
```

`CompileFilter()` 将由使用该滤镜的元素在渲染之前调用。此函数应返回一个 `Rml::CompiledFilter` 对象，其中包含在此特定元素上渲染滤镜所需的任何数据。

`ExtendInkOverflow()` 是一个可选函数，允许你将滤镜影响的区域扩展到元素边框盒之外。这对于在边框区域之外生效、或需要考虑相邻像素的滤镜很有用，例如模糊和投影滤镜。如果你的滤镜不需要扩展到元素边界之外，你就不需要覆盖此函数。

完整的示例请参阅库中 `Rml::FilterDropShadow` 滤镜的源码。

#### 生成编译后的滤镜

编译后的滤镜保存着为给定元素渲染滤镜所需的数据。它应在滤镜类的 `CompileFilter()` 函数调用期间构造。

```cpp
Rml::Colourb color(255, 0, 0);
Rml::Vector2f offset = {10, 20};
float sigma = 5.0f;
Rml::CompiledFilter filter = element->GetRenderManager()->CompileFilter("drop-shadow",
    Rml::Dictionary{
        {"color", Variant(color)},
        {"offset", Variant(offset)},
        {"sigma", Variant(sigma)},
    });
return filter;
```

此字典中提供的值将被提交给渲染接口中的 `CompileFilter()` 函数。用户随后可以使用这些值为其渲染器配置滤镜效果。渲染接口将能够返回一个编译后的滤镜句柄，以便以后引用这些值。有关细节请参阅[渲染接口滤镜部分](interfaces/render.html#filters)。

一旦编译后的滤镜从 `CompileFilter()` 返回，库将能够在调用渲染接口合成图层时使用它。它将使用它来渲染为元素声明的任何滤镜或背景滤镜。

#### 创建自定义滤镜 instancer

滤镜的 instancer 负责定义和处理可用于配置滤镜的样式属性（property）。虽然你可以创建没有任何样式属性的自定义滤镜，但我们建议你将所有变量暴露给 RCSS。这既快速又简单，而且你会得到更灵活的滤镜。

滤镜 instancer 需要派生自 `Rml::FilterInstancer`。需要覆盖以下纯虚函数：

```cpp
/// Instances a filter given the name and attributes from the RCSS file.
/// @param[in] name The type of filter desired. For example, "filter: simple(...)" is declared as type "simple".
/// @param[in] properties All RCSS properties associated with the filter.
/// @return A shared_ptr to the filter if it was instanced successfully.
virtual Rml::SharedPtr<Rml::Filter> InstanceFilter(const Rml::String& name,
                                                   const Rml::PropertyDictionary& properties) = 0;
```

每当需要使用此 instancer 创建滤镜时，都会调用 `InstanceFilter()`。它传入 `name`（提供创建滤镜时使用的名称）和 `properties`（包含用于在 RCSS 中指定滤镜的已解析属性值，见下文）。

构造滤镜后，将其作为共享指针返回。如果滤镜未成功创建，返回 `nullptr` 表示错误。

#### 定义滤镜的样式属性（property）

每个滤镜 instancer 都持有其创建的滤镜的完整样式属性（property）规范。在其构造函数中，自定义 instancer 可以通过使用受保护的函数 `RegisterProperty()` 和 `RegisterShorthand()` 来向规范中添加样式属性和简写。有关定义样式属性的详细文档，请参阅[注册用户自定义属性](rcss.html#user-defined-properties)的文档。

以下是一个定义简单属性规范的滤镜示例：

```cpp
CustomFilterInstancer::CustomFilterInstancer() : Rml::FilterInstancer()
{
	property_id1 = RegisterProperty("custom-property-1", "1").AddParser("number").GetId();
	property_id2 = RegisterProperty("custom-property-2", "normal").AddParser("keyword", "normal, colorful")
	                                                              .GetId();
	RegisterShorthand("filter", "custom-property-1, custom-property-2", Rml::ShorthandType::FallThrough);
}
```

自定义滤镜现在有两个属性。传入 instancer 的 `InstanceFilter()` 函数的属性字典将包含这两个属性的值，如果它们在 RCSS 中未设置，则默认为其指定的默认值。

请注意，简写 `filter` 很特殊。此简写将用于解析属性值括号内的文本。这允许像下面的示例一样使用内联属性指定滤镜。

```css
filter: custom-filter( 15 colorful );
```

现在这将由上述规则解析，使得 'custom-property-1' 包含 15，'custom-property-2' 包含关键字 'colorful'。

属性 ID 存储在 instancer 对象上，因此它们可以在调用 `InstanceFilter()` 期间轻松获取解析后的值。

```cpp
int value1 = properties.GetProperty(property_id1)->Get<int>();
```

`value1` 变量现在将包含样式表中指定的值，例如上例中的 '15'。

#### 注册 instancer

要在 RmlUi 初始化后向 RmlUi 注册自定义滤镜 instancer，请调用 RmlUi factory（`Rml::Factory`）上的 `RegisterFilterInstancer()` 函数。

```cpp
// Registers a non-owning pointer to an instancer that will be used to instance filters.
// @param[in] name The name of the filter the instancer will be called for.
// @param[in] instancer The instancer to call when the filter name is encountered.
// @lifetime The instancer must be kept alive until after the call to Rml::Shutdown.
// @return The added instancer if the registration was successful, nullptr otherwise.
static Rml::FilterInstancer* RegisterFilterInstancer(const Rml::String& name,
                                                     Rml::FilterInstancer* instancer);
```

例如：

```cpp
// Keep instancer alive until after the call to Rml::Shutdown().
auto instancer = std::make_unique<CustomFilterInstancer>();
Rml::Factory::RegisterFilterInstancer("custom-filter", instancer.get());
```

这将允许你在 RML 中如下使用自定义滤镜：

```html
<rml>
<head>
	<style>
		div
		{
			filter: custom-filter( 1.5 colorful );
		}
	</style>
</head>
<body>
...
```

与其他 instancer 一样，管理 instancer 的生命周期是用户的责任。因此，它必须保持存活直到调用 `Rml::Shutdown()` 之后，然后由用户清理。

### 更新滤镜

实例化后，滤镜不会从库内部更新。相反，RmlUi 中的滤镜动画涉及销毁现有滤镜，并在每次需要更新参数时实例化一个新滤镜。通常，编译后的滤镜被认为是轻量级的构造。

如果你有一个需要独立于库的动画功能进行更新的滤镜，你需要实现自己的更新机制。这可能涉及通过编译后的滤镜字典中传递的索引或指针单独维护值，并在应用程序的更新循环中更新这些值。
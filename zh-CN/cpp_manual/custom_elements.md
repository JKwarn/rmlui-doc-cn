---
layout: page
title: 自定义元素
parent: cpp_manual
next: hidden_elements
---

如果你需要在元素上实现无法通过事件系统轻松管理的特殊功能，可以选择创建自定义元素。自定义元素直接派生自核心 Element 类定义，并通过自定义元素 instancer 创建。自定义元素可以：

* 响应标记属性（attribute）与样式属性（property）的变化。
* 管理隐藏内部元素的布局。
* 执行自定义更新或渲染代码。
* 内联响应事件。
* 响应后代的添加/移除事件。

### 创建自定义元素

所有自定义元素都是派生自（不一定直接派生）`Rml::Element` 的类。Element 的构造函数接受一个参数，即元素的标签；派生元素的构造函数既可以向基类构造函数传递一个常量字符串，也可以自己接受一个字符串再传递下去。

可以在自定义元素中覆盖的虚函数有：

```cpp
// Returns the baseline of the element, in pixels offset from the bottom of the element's content area.
// @return The element's baseline. A negative baseline will be further 'up' the element, a positive on further 'down'.
virtual float GetBaseline() const;

// Gets the intrinsic dimensions of this element, if it is of a type that has an inherent size.
// @param[out] dimensions The dimensions to size, if appropriate.
// @param[out] ratio The intrinsic ratio (width/height), if appropriate.
// @return True if the element has intrinsic dimensions, false otherwise.
virtual bool GetIntrinsicDimensions(Rml::Vector2f& dimensions, float& ratio);

// Called when an emitted event propagates to this element, for event types with default actions.
// Note: See 'EventSpecification' for the events that call this function and during which phase.
// @param[in] event The event to process.
virtual void ProcessDefaultAction(Rml::Event& event);

// Called during the update loop after children are updated.
virtual void OnUpdate();
// Called during render after backgrounds, borders, decorators, but before children, are rendered.
virtual void OnRender();

// Called when attributes on the element are changed.
// @param[in] changed_attributes The attributes changed on the element.
virtual void OnAttributeChange(const Rml::AttributeNameList& changed_attributes);
// Called when properties on the element are changed.
// @param[in] changed_properties The properties changed on the element.
virtual void OnPropertyChange(const Rml::PropertyIdSet& changed_properties);

// Called when a child node has been added up to two levels below us in the hierarchy.
// @param[in] child The element that has been added. This may be this element.
virtual void OnChildAdd(Rml::Element* child);
// Called when a child node has been removed up to two levels below us in the hierarchy.
// @param[in] child The element that has been removed. This may be this element.
virtual void OnChildRemove(Rml::Element* child);

// Gets the markup and content of the element.
// @param[out] content The content of the element.
virtual void GetInnerRML(Rml::String& content) const;
// Returns the RML of this element and all children.
// @param[out] content The content of this element and those under it, in XML form.
virtual void GetRML(Rml::String& content);
```

#### 布局

如果自定义元素希望作为替换元素（replaced element）进行布局，它可以覆盖 `GetIntrinsicDimensions()` 函数。替换元素是具有固有尺寸的元素，可以像内联或块级内容一样定位。替换元素的示例包括图像和表单控件。

```cpp
// Gets the intrinsic dimensions of this element, if it is of a type that has an inherent size.
// @param[out] dimensions The dimensions to size, if appropriate.
// @param[out] ratio The intrinsic ratio (width/height), if appropriate.
// @return True if the element has intrinsic dimensions, false otherwise.
virtual bool GetIntrinsicDimensions(Rml::Vector2f& dimensions, float& ratio);
```

如果自定义元素要成为替换元素，它应该覆盖此函数并返回 true。元素的实际固有尺寸应放入 dimensions 参数中。如果元素具有固有宽高比，可以在 ratio 参数上设置，可以是在 dimensions 参数之外附加设置，也可以是只设置 ratio。每次元素被布局时都会调用此函数，因此这些参数可以是动态值。默认元素返回 false。

自定义替换元素（即具有固有尺寸的元素）如果希望更改其在行上进行水平定位的参考点，可以覆盖 `GetBaseline()` 函数。

```cpp
// Returns the baseline of the element, in pixels offset from the bottom of the element's content area.
// @return The element's baseline. A negative baseline will be further 'up' the element, a positive on further 'down'.
virtual float GetBaseline() const;
```

`GetBaseline()` 函数返回从元素内容区域底部算起的像素偏移量，默认情况下相邻文本的基线应与之对齐。这只会影响元素在内联放置时的定位。

#### 默认动作

自定义元素可以覆盖 `ProcessDefaultAction()` 函数，以拦截发送给此元素或其某个后代的所有具有默认动作的事件类型。默认动作遵循正常的事件阶段，但只在其定义的 `default_action_phase`（针对每个事件类型定义）对应的阶段中执行。如果事件被 `Event::StopPropagation()` 取消，则除非已经执行，否则不会执行默认动作。有关每个事件类型的细节，以及默认动作在哪些阶段被调用，请参阅[事件规范](events.html#event-specifications)。

请注意，元素可能会收到针对其某个子元素的事件。务必检查事件的目标元素和事件类型。

**重要**：你必须记得将任何未处理的事件调用基类的 `ProcessDefaultAction()` 函数！基元素在其 `ProcessDefaultAction()` 函数中响应许多事件，如果你不这样做，可能会产生各种奇怪的行为。

```cpp
// Called when an emitted event propagates to this element, for event types with default actions.
// @param[in] event The event to process.
virtual void ProcessDefaultAction(Rml::Event& event);
```

#### 更新与渲染循环的钩子

自定义元素可以覆盖 `OnUpdate()` 或 `OnRender()` 函数，以将功能挂接到更新或渲染循环中。

`OnUpdate()` 函数在基元素更新函数的最开始被调用。如果你不希望调用基元素的 `OnUpdate()` 函数，则无需调用。

```cpp
// Called during the update loop after children are updated.
virtual void OnUpdate();
```
请注意，元素的属性定义和计算值将在调用 `OnUpdate()` 之后计算。因此，设置新属性并期望它们在当前更新循环中被正确设置是安全的。但是，查询元素的任何计算值将返回上一次更新循环期间计算的值。

`OnRender()` 函数在以下情况发生后，从基元素的渲染循环中被调用：

* 元素堆叠上下文中 z-index 低于 0 的后代元素已被渲染。
* 已为元素设置裁剪区域（如果适用）。
* 元素的背景、边框和所有适用的装饰器已被渲染。

如果你不希望调用基元素的 `OnRender()` 函数，则无需调用。请注意，大多数自定义渲染可以通过使用自定义装饰器来完成；出于可重用性的考虑，推荐这样做，而不是覆盖 `OnRender()`。

```cpp
// Called during render after backgrounds, borders, decorators, but before children, are rendered.
virtual void OnRender();
```

#### 标记属性（attribute）与样式属性（property）的变化

自定义元素可以覆盖 `OnAttributeChange()` 或 `OnPropertyChange()` 函数，以响应其标记属性或样式属性的变化。

每当标记属性被添加、移除或重新定义时，都会调用 `OnAttributeChange()`。被更改标记属性的名称通过 'changed_attributes' 变量传入函数，该变量是名称和值的字典。要检查某个特定标记属性是否被更改，请使用 `find()` 函数在列表中查找它是否存在。

```cpp
// Called when attributes on the element are changed.
// @param[in] changed_attributes The attributes changed on the element.
virtual void OnAttributeChange(const Rml::AttributeNameList& changed_attributes);
```

每当样式属性（或一组样式属性）的值发生变化时，都会调用 `OnPropertyChange()`。被更改样式属性的名称通过 `changed_properties` 变量传入函数，该变量是一个 `PropertyId` 集合。

```cpp
// Called when properties on the element are changed.
// @param[in] changed_properties The properties changed on the element.
virtual void OnPropertyChange(const Rml::PropertyIdSet& changed_properties);
```

**重要**：如果你覆盖了这两个函数中的任何一个，你必须记得调用基类的相应函数！与 `ProcessDefaultAction()` 一样，基元素响应许多标记属性和样式属性的变化，如果你不这样做，可能会产生各种奇怪的行为。

#### 层级变化

自定义元素可以覆盖 `OnChildAdd()` 或 `OnChildRemove()` 函数，以响应元素层级的变化。当一个元素被添加到另一个元素或从另一个元素移除时，相应的函数会立即在该元素自身及其附近的祖先上被调用。请注意，出于性能原因，只有层级中向上两级以内的节点会收到通知。

```cpp
// Called when a child node has been added up to two levels below us in the hierarchy.
// @param[in] child The element that has been added. This may be this element.
virtual void OnChildAdd(Rml::Element* child);

// Called when a child node has been removed up to two levels below us in the hierarchy.
// @param[in] child The element that has been removed. This may be this element.
virtual void OnChildRemove(Rml::Element* child);
```

#### RML 生成

如果默认的 RML 生成函数不适用，自定义元素可以覆盖 `GetRML()` 和 `GetInnerRML()` 函数。这通常是不需要的，除非元素在内部重新排列其子元素，或者大量使用自定义 XML 节点处理器；在这种情况下，默认函数可能会生成无意义的 RML。

`GetInnerRML()` 旨在返回元素的内部 RML；即，仅生成元素内容所需的 RML，不包含元素本身。默认情况下，它对其所有 DOM 子元素调用 `GetRML()` 并拼接结果。

`GetRML()` 旨在返回生成整个元素所需的 RML。因此，这包括元素的标签及其所有标记属性（attribute），以及所有后代的 RML。默认情况下，它生成开标签，在其后追加 `GetInnerRML()` 的结果，最后追加闭标签。

```cpp
// Gets the markup and content of the element.
// @param[out] content The content of the element.
virtual void GetInnerRML(Rml::String& content) const;

// Returns the RML of this element and all children.
// @param[out] content The content of this element and those under it, in XML form.
virtual void GetRML(Rml::String& content);
```

### 创建自定义元素 instancer

为了通过 RmlUi factory 创建自定义元素，需要在 factory 中针对相应的 RML 标签名注册该元素的 instancer。元素 instancer 负责在需要时创建和销毁其元素，并在 RmlUi 关闭时销毁自身。

自定义元素 instancer 需要派生自 `Rml::ElementInstancer`，并实现必需的纯虚方法：

```cpp
// Instances an element given the tag name and attributes.
// @param[in] parent The element the new element is destined to be parented to.
// @param[in] tag The tag of the element to instance.
// @param[in] attributes Dictionary of attributes.
// @return A unique pointer to the instanced element.
virtual Rml::ElementPtr InstanceElement(Rml::Element* parent,
                                              const Rml::String& tag,
                                              const Rml::XMLAttributes& attributes) = 0;

// Releases an element instanced by this instancer.
// @param[in] element The element to release.
virtual void ReleaseElement(Rml::Element* element) = 0;
```

每当 factory 被调用、需要实例化一个 instancer 已注册的标签元素时，都会调用 `InstanceElement()`。该函数的参数是：

* `parent`：如果新元素成功创建，它将被作为子元素挂到该元素下；你实际上不需要做挂接这件事！仅当元素是从 RML 实例化时，此参数才会非空。
* `tag`：创建元素的任何一方希望该元素使用的标签字符串；由于元素是通过 factory 构造的，这可能不是 instancer 注册的标签之一。建议你将其传递给元素作为其标签名，但这不是必须的。
* `attributes`：在 RML 中元素标签上定义、或传入 factory 的标记属性（attribute）。你不需要自己在元素上设置这些标记属性；如果实例化成功，这将自动完成。只有当元素实例化依赖于这些值时才需要使用它们（例如，`input`{:.tag} 元素的 instancer 会根据 `type`{:.attr} 标记属性的值实例化不同的类型）。

如果 `InstanceElement()` 成功，则返回包装在 `ElementPtr`（unique 元素）中的新元素。否则，返回 nullptr 表示实例化错误。

当元素从其所有者释放后，即其 `ElementPtr` 被销毁或重置时，会调用 `ReleaseElement()`。元素应被适当地删除。

#### 注册 instancer

要向 RmlUi 注册自定义 instancer，请在 RmlUi 初始化之后调用 RmlUi factory（`Rml::Factory`）上的 `RegisterElementInstancer()` 函数。

```cpp
// Make sure custom_instancer is kept alive until after the call to Rml::Shutdown
auto custom_instancer = std::make_unique<ElementInstancerCustom>();
Rml::Factory::RegisterElementInstancer("custom", custom_instancer.get());
```

`RegisterElementInstancer()` 的第一个参数是该 instancer 绑定的标签名。在上面的示例中，当解析 RML 流时遇到标签为 'custom' 的元素，或 factory 另有需要时，将调用该自定义 instancer 来实例化元素。你可以对 factory 使用不同的标签名多次注册同一个 instancer。

库持有指向 instancer 的非拥有指针。因此，instancer 必须保持存活直到调用 `Rml::Shutdown` 之后，然后由用户清理。

#### 使用通用 instancer

如果自定义元素不需要其 instancer 提供任何特殊行为，为其生成 instancer 的最简单方法是使用模板化的 `ElementInstancerGeneric`。无需派生自己的 instancer 类，只需构造一个新的、以你想要实例化的自定义元素类型为模板参数的 `Rml::ElementInstancerGeneric`，并像普通 instancer 一样在 factory 中注册它。

```cpp
// Make sure custom_instancer is kept alive until after the call to Rml::Shutdown
auto custom_instancer = std::make_unique< Rml::ElementInstancerGeneric< CustomElement > >();
Rml::Factory::RegisterElementInstancer("custom", custom_instancer.get());
```

对其所模板化的元素类型唯一的要求是：构造函数像基元素一样接受一个字符串（标签名）。

### 自定义 XML 节点处理

对于一些复杂的自定义元素，生成元素所需的 RML 并不能反映实际的内部层级。例如，tabset 中的选项卡由紧挨在 `<tabset>`{:.tag} 标签下方的 `<tab>`{:.tag} 标签指定。如果执行标准 XML 解析，元素将被实例化并作为子元素挂到 tabset 标签下。但这并不是我们想要的，相反，我们希望将所有选项卡一起放在单个 `<tabs>`{:.tag} 标签下。因此，tabset 使用自定义 XML 节点处理器来以不同方式处理选项卡（面板同理）。

节点处理器针对 RML 标签名注册。解析 RML 文件时，XML 解析器维护一个节点处理器栈。每当遇到新标签时，解析器会检查是否有特定的节点处理器针对该标签注册；如果有，该处理器被压入栈中并接管解析，直到其关联标签闭合。如果没有处理器与特定元素关联，则当前节点处理器继续解析。

#### 创建自定义 XML 节点处理器

自定义节点处理器派生自 `Rml::XMLNodeHandler` 类，并实现纯虚函数：

```cpp
// Called when a new element tag is opened.
// @param parser The parser executing the parse.
// @param name The XML tag name.
// @param attributes The tag attributes.
// @return The new element, may be NULL if no element was created.
virtual Rml::Element* ElementStart(Rml::XMLParser* parser,
                                            const Rml::String& name,
                                            const Rml::XMLAttributes& attributes) = 0;

// Called when an element is closed.
// @param parser The parser executing the parse.
// @param name The XML tag name.
virtual bool ElementEnd(Rml::XMLParser* parser,
                        const Rml::String& name) = 0;

// Called for element data.
// @param parser The parser executing the parse.
// @param data The element data.
virtual bool ElementData(Rml::XMLParser* parser,
                         const Rml::String& data) = 0;
```

当节点处理器处于活动状态期间发生相应的 XML 解析事件时，会在该节点处理器上调用 `ElementStart()`、`ElementEnd()` 和 `ElementData()`。自闭合标签会导致在 `ElementStart()` 之后立即调用 `ElementEnd()`。当在两个标签之间遇到松散的、非空白的文本数据时，会调用 `ElementData()`。

这些函数都会传入一个指向正在执行解析的 XML 解析器的指针。通过解析器可以使用 `GetParseFrame()` 函数请求当前的解析帧；解析帧对象包含当前正在处理的元素和标签，以及活动的节点处理器。

```cpp
struct ParseFrame
{
	// Tag being parsed.
	Rml::String tag;

	// Element representing this frame.
	Rml::Element* element;

	// Handler used for this frame.
	XMLNodeHandler* node_handler;

	// The default handler used for this frame's children.
	XMLNodeHandler* child_handler;
};
```

`ElementStart()` 会以开标签的名称和标记属性（attribute）被调用。如果节点处理器创建了一个新元素，并且希望它位于解析帧栈顶部，则应返回该元素。否则，应返回 NULL 以将当前元素保留在解析帧栈顶部。当节点处理器为当前元素创建内部元素、但又不希望对其执行进一步解析时，这会很有用。

如果节点处理器想为新元素更改节点处理器，它可以在 `ElementStart()` 中使用 `PushHandler()` 或 `PushDefaultHandler()` 将新处理器压入 XML 解析器的栈。默认处理器将按照本文档前面所述的方式实例化元素。

```cpp
// Pushes an element handler onto the parse stack for parsing child elements.
// @param[in] tag The tag the handler was registered with.
// @return True if an appropriate handler was found and pushed onto the stack, false if not.
bool PushHandler(const Rml::String& tag);

// Pushes the default element handler onto the parse stack.
void PushDefaultHandler();
```

如果它不调用这两个方法中的任何一个，它将继续作为其创建的任何子元素的节点处理器。

#### 注册自定义节点处理器

使用 `Rml::XMLParser` 上的静态 `RegisterNodeHandler()` 函数，将自定义节点处理器注册到 RmlUi 的 XML 解析器。你可以使用不同的标签名将同一个处理器多次注册到解析器。`RegisterNodeHandler()` 对处理器持有共享所有权，因此用户完成后无需自己保存副本。

```cpp
// Registers a custom node handler to be used to a given tag.
// @param[in] tag The tag the custom parser will handle.
// @param[in] handler The custom handler.
// @return The registered XML node handler.
static Rml::XMLNodeHandler* RegisterNodeHandler(const Rml::String& tag,
                                                         SharedPtr<Rml::XMLNodeHandler> handler);
```

#### 示例

随附的[元素包](element_packages.html)广泛使用了自定义 XML 节点处理器；请参阅 `XMLNodeHandlerTabSet` 和 `XMLNodeHandlerTextArea` 类的源码，了解它们的使用演示。
---
layout: page
title: 元素
parent: cpp_manual
next: text_elements
---

元素是[文档](documents.html)内功能的最小细分。

### 大小

元素由零个或多个盒（box）组成，每个盒都有一个矩形内容区域，周围环绕着三个厚度可变的区域：内边距、边框和外边距（更多细节请参阅[盒模型文档](../rcss/box_model.html)）。

你可以使用 `GetBox()` 和 `GetNumBoxes()` 函数查询元素的当前大小：

```cpp
// Returns one of the boxes describing the size of the element.
// @param[in] index The index of the desired box.
// @return The requested box.
const Rml::Box& GetBox(int index = 0) const;

// Returns the number of boxes making up this element's geometry.
// @return the number of boxes making up this element's geometry.
int GetNumBoxes() const;
```

大多数元素只有一个盒，除非它们表示跨多行拆分的内联内容。

### 位置

元素将其位置测量为与包含它的祖先元素的像素偏移。包含元素（称为 offset parent）通常是元素的、`position`{:.prop} 值不是 `static`{:.value} 的最近祖先。要获取元素的 offset parent，请调用 `GetOffsetParent()` 函数。

```cpp
// Returns the element from which all offset calculations are currently computed.
// @return This element's offset parent.
Rml::Element* GetOffsetParent();
```

要获取元素的偏移，请使用 `GetRelativeOffset()` 或 `GetAbsoluteOffset()`：

```cpp
// Returns the position of the top-left corner of one of the areas of this element's primary box, relative to its
// offset parent's top-left border corner.
// @param[in] area The desired area position.
// @return The relative offset.
Rml::Vector2f GetRelativeOffset(Rml::Box::Area area = Box::CONTENT) const;

// Returns the position of the top-left corner of one of the areas of this element's primary box, relative to
// the element root.
// @param[in] area The desired area position.
// @return The absolute offset.
Rml::Vector2f GetAbsoluteOffset(Rml::Box::Area area = Box::CONTENT) const;
```

`GetRelativeOffset()` 将返回从元素 offset parent 的左上边框到元素主盒的某个区域的偏移。`GetAbsoluteOffset()` 将返回从元素所属上下文的左上角算起的偏移。

你也可以使用 [DOM 函数](#dom-interface) `GetClientLeft()` 和 `GetClientTop()`。

### 伪类

元素在任何时刻可能有一个或多个活动的伪类。伪类表示小的、暂时的状态变化（例如输入焦点或鼠标悬停），可用于更改 RCSS 属性的值。

要检查某个特定元素上是否设置了伪类，你可以使用 `IsPseudoClassSet()` 或 `GetActivePseudoClasses()` 函数。

```cpp
// Checks if a specific pseudo-class has been set on the element.
// @param[in] pseudo_class The name of the pseudo-class to check for.
// @return True if the pseudo-class is set on the element, false if not.
bool IsPseudoClassSet(const Rml::String& pseudo_class) const;

// Gets a list of the current active pseudo-classes.
// @return The list of active pseudo-classes.
const Rml::PseudoClassList& GetActivePseudoClasses() const;
```

`IsPseudoClassSet()` 将检查元素上是否存在特定伪类，而 `GetActivePseudoClasses()` 将返回一个包含所有伪类的 STL 集合。

要设置或移除伪类，请调用 `SetPseudoClass()`。

```cpp
// Sets or removes a pseudo-class on the element.
// @param[in] pseudo_class The pseudo class to activate or deactivate.
// @param[in] activate True if the pseudo-class is to be activated, false to be deactivated.
void SetPseudoClass(const Rml::String& pseudo_class, bool activate);
```

应用程序可以为其自身的样式需求使用任何他们希望的伪类。但是，RmlUi 在内部维护几个伪类，不推荐你自己设置或清除它们。这些类是：

* `hover`{:.cls}：当鼠标光标位于元素上方时设置。
* `active`{:.cls}：当主鼠标按钮按下，并且在按下时鼠标位于元素上方时设置。
* `focus`{:.cls}：如果元素具有输入焦点则设置。通常发生在元素被点击时。
* `checked`{:.cls}：在选中的[单选按钮或复选框](element_packages/form.html#radio-button-and-checkbox)或[下拉列表控件项](element_packages/form.html#drop-down-select-box)上设置。
* `disabled`{:.cls}：在禁用的[表单控件](element_packages/form.html)上设置。

### DOM 接口
{:#dom-interface}

RmlUi 元素支持 [Gecko 的 HTML DOM 元素接口](https://developer.mozilla.org/en-US/docs/Web/API/element) 的大部分，因此 Web 开发人员应该熟悉元素的大部分功能。

| RmlUi 函数 | 简要说明 | 等价的 DOM 属性 |
|------------------|-------------------|-------------------------|
| `GetAbsoluteLeft()` | 从上下文左边缘到元素左边框的距离。
| `GetAbsoluteTop()` | 从上下文上边缘到元素上边框的距离。
| `SetAttribute()`、`GetAttribute()` | 与元素关联的所有标记属性（attribute）。 | attributes
| `GetChild()`、`GetNumChildren()` | 元素的所有子节点。 | childNodes
| `IsClassSet()`、`SetClass()` | 获取/设置元素的类。 | className
| `GetClientHeight()` | 元素的内部高度。 | clientHeight
| `GetClientLeft()` | 元素左边框的宽度。 | clientLeft
| `GetClientTop()` | 元素上边框的宽度。 | clientTop
| `GetClientWidth()` | 元素的内部宽度。 | clientWidth
| `GetFirstChild()` | 元素的第一个直接子节点。 | firstChild
| `GetId()`、`SetId()` | 获取/设置元素的 id。 | id
| `GetInnerRML()`、`SetInnerRML()` | 获取/设置元素的标记与内容。 | innerHTML
| `GetLastChild()` | 元素的最后一个直接子节点。 | lastChild
| `GetNextSibling()` | 树中紧跟给定节点之后的节点。 | nextSibling
| `GetOffsetHeight()` | 元素相对于布局的高度。 | offsetHeight
| `GetOffsetLeft()` | 从此元素左边框到其 offset parent 左边框的距离。 | offsetLeft
| `GetOffsetParent()` | 当前所有偏移计算依据的元素。 | offsetParent
| `GetOffsetTop()` | 从此元素上边框到其 offset parent 上边框的距离。 | offsetTop
| `GetOffsetWidth()` | 元素相对于布局的宽度。 | offsetWidth
| `GetOwnerDocument()` | 此节点所在的文档。 | ownerDocument
| `GetParentNode()` | 此节点的父元素。 | parentNode
| `GetPreviousSibling()` | 树中紧接给定节点之前的节点。 | previousSibling
| `GetScrollHeight()` | 元素的滚动视图高度。 | scrollHeight
| `GetScrollLeft()` | 获取/设置元素的左侧滚动偏移。 | scrollLeft
| `GetScrollTop()` | 获取/设置元素的顶部滚动偏移。 | scrollTop
| `GetScrollWidth()` | 元素的滚动视图宽度。 | scrollWidth
| `GetProperty()`、`SetProperty()` | 表示元素样式属性（property）声明的对象。 | style
| `GetTagName()` | 给定元素的标签名称。 | tagName

受支持的方法仅仅将其首字母大写以匹配 RmlUi API 其余部分的风格。

| RmlUi 函数 | 简要说明 | 等价的 DOM 方法 |
|-----------------|-------------------|-----------------------|
| `AddEventListener()` | 在元素上为特定事件类型注册事件处理器。 | addEventListener()
| `AppendChild()` | 将节点作为此元素的最后一个子节点插入。新挂接的节点必须首先从现有父节点分离。 | appendChild()
| `Blur()` | 从当前元素移除键盘焦点。 | blur()
| `Click()` | 模拟对当前元素的点击。 | click()
| `Closest()` | 检索匹配所提供的 RCSS 选择器的第一个祖先元素。 | closest()
| `Contains()` | 检查目标元素是否为当前元素的后代。 | contains()
| `DispatchEvent()` | 向 DOM 中的此节点派发事件。 | dispatchEvent()
| `Focus()` | 将键盘焦点赋予当前元素。 | focus()
| `GetAttribute()` | 从当前节点检索指定名称的标记属性（attribute）的值。 | getAttribute()
| `GetElementById()` | 通过 id 返回元素。 | getElementById()
| `GetElementsByTagName()` | 检索具有特定标签名称的所有后代元素的集合。 | getElementsByTagName()
| `GetElementsByClassName()` | 检索设置了特定类的所有后代元素的集合。 | getElementsByClassName()
| `HasAttribute()` | 检查元素是否具有指定的标记属性（attribute）。 | hasAttribute()
| `HasChildNodes()` | 检查元素是否具有任何子节点。 | hasChildNodes()
| `InsertBefore()` | 在 DOM 中将第一个节点插入到第二个子节点之前。新挂接的节点必须首先从现有父节点分离。 | insertBefore()
| `QuerySelector()` | 检索匹配所提供的 RCSS 选择器的第一个后代元素。 | querySelector()
| `QuerySelectorAll()` | 检索匹配所提供的 RCSS 选择器的所有后代元素的集合。 | querySelectorAll()
| `Matches()` | 检查当前元素是否匹配给定的 RCSS 选择器。 | matches()
| `RemoveAttribute()` | 从当前节点移除指定名称的标记属性（attribute）。 | removeAttribute()
| `RemoveChild()` | 从当前元素移除子节点，并将其作为 unique 指针返回。 | removeChild()
| `RemoveEventListener()` | 从元素移除事件监听器。 | removeEventListener()
| `ReplaceChild()` | 用另一个子节点替换当前元素中的一个子节点。 | replaceChild()
| `ScrollIntoView()` | 滚动页面直到元素进入视图。 | scrollIntoView()
| `ScrollTo()` | 将元素滚动到给定偏移。 | scrollTo()
| `SetAttribute()` | 设置当前节点上指定名称的标记属性（attribute）的值。 | setAttribute()

### 检索值的有效性

每当元素在 DOM 层级中被修改、添加或移除时，从 [DOM 接口](#dom-interface) 检索的值可能会变脏。当布局变脏时也是如此，例如更新元素的属性或调整大小事件之后。这些工作大部分不会立即更新任何受影响元素的属性，而是出于性能原因，在 `Context::Update()` 调用期间以精心选择的顺序完成。

因此，与布局相关的值（大小和偏移）以及计算值可能会返回默认值或在上一次更新期间计算的值。如果在 DOM 修改后需要检索这些值，可以调用 `ElementDocument::UpdateDocument()` 来[手动更新元素的文档](documents.html#manually-updating-the-document)，然后再检索这些值，但会带来性能代价。这可以确保所有检索到的值都是正确的。

由于 HTML/CSS 模型的复杂性，在 DOM 或样式修改后准确推断哪些元素的哪些值变脏是一项极具挑战性的任务。同时，出于性能原因，库在检索某个元素值时不能总是对整个文档进行完整更新。在找到处理此类值变脏问题的良好解决方案之前，这种变通方法是必要的。

### 动态创建元素

不应使用 `new` 运算符创建元素；为了被正确地构造、计数和释放，它们需要通过文档（使用 `CreateElement()` 或 `CreateTextNode()` 函数）或通过 RmlUi factory（`Rml::Factory`）的静态 `InstanceElement()` 函数创建。

#### 元素的所有权

通常，元素由其父元素唯一拥有。对于新创建的元素或已移除的元素，元素以唯一所有权返回，例如
```cpp
ElementPtr ElementDocument::CreateElement(const String& name);
```
其中 `ElementPtr` 是一个 unique 指针，别名如下。
```cpp
using ElementPtr = std::unique_ptr<Element, Releaser<Element>>;
```
请注意，自定义删除器 `Releaser` 是为了确保元素从其创建时所在的 `ElementInstancer` 释放。

在存储指向元素的非拥有原始指针时，知道元素何时被销毁可能很有用。`ObserverPtr` 可用于此目的，详情请参阅[核心所有权与生命周期](core_overview.html#ownership-and-lifetimes)。

#### 使用文档

要通过文档创建元素，请使用以下函数之一：

```cpp
// Creates the named element.
// @param[in] name The tag name of the element.
Rml::ElementPtr CreateElement(const Rml::String& name);

// Create a text element with the given text content.
// @param[in] text The text content of the text element.
Rml::ElementPtr CreateTextNode(const Rml::String& text);
```

`CreateElement()` 接受一个参数 name，即新元素的标签名。这将用于查找 instancer 并为元素打标签。与通过 factory 实例化元素一样，如果创建成功将返回新元素，否则返回 `nullptr`。

`CreateTextNode()` 创建一个包含参数 text 中给定文本的单个文本元素。

请注意，这些函数返回的元素与文档本身没有隶属关系。相反，它们通过 unique 指针以无父元素的形式返回，如果需要，必须移动到其他元素中。

在调用 `ElementDocument::CreateElement` 之后，该元素可以移动到另一个元素的子元素列表中。
```cpp
ElementPtr new_child = document->CreateElement("div");
element->AppendChild( std::move(new_child) );
```
由于我们移动了 `new_child`，我们不能再使用该指针。相反，`Element::AppendChild` 返回一个指向所追加子元素的非拥有原始指针，可以使用它。此外，新元素可以就地构造，例如
```cpp
Element* new_child = element->AppendChild( document->CreateElement("div") );
```
现在 `new_child` 可以安全使用，直到元素被销毁。


#### 使用 factory

通过 factory 创建元素允许更多控制。`InstanceElement()` 函数详细说明如下：

```cpp
// Instances a single element.
// @param[in] parent The parent of the new element, or nullptr for a root tag.
// @param[in] instancer The name of the instancer to create the element with.
// @param[in] tag The tag of the element to be instanced.
// @param[in] attributes The attributes to instance the element with.
// @return The instanced element, or nullptr if the instancing failed.
static Rml::ElementPtr InstanceElement(Rml::Element* parent,
                                              const Rml::String& instancer,
                                              const Rml::String& tag,
                                              const Rml::XMLAttributes& attributes);
```

该函数的参数是：

* `parent`：你打算在元素创建后将其挂接到的元素。这仅供自定义 instancer 使用；如果你实例化通用元素，可以省略它。请注意，新元素不会自动挂接到此元素，你仍然需要在元素创建后自己完成挂接。
* `instancer`：你想要用来创建元素的 instancer 注册时所对应的标签名。对于创建通用元素，这可以与第三个参数 `tag` 相同。更多信息请参阅[自定义元素 instancer](custom_elements.html#creating-a-custom-element-instancer) 的文档。
* `tag`：新元素应具有的标签。
* `attributes`：你希望新元素以之构造的任何标记属性（attribute）。这是字典类型。标记属性将传入 instancer，如果实例化成功，将设置到元素上。

例如，以下代码将实例化一个 `<div>`{:.tag} 元素：

```cpp
Rml::ElementPtr div_element = Rml::Factory::InstanceElement(nullptr,
                                                                            "div",
                                                                            "div",
                                                                            Rml::XMLAttributes());
```

以下代码将使用库的 `input` instancer 实例化一个单选按钮元素，但给它一个 `radio`{:.tag} 标签：

```cpp
Rml::XMLAttributes attributes;
attributes.Set("type", "radio");
attributes.Set("name", "graphics");
attributes.Set("value", "OK");
Rml::ElementPtr radio_element = Rml::Factory::InstanceElement(div_element,
                                                                              "input",
                                                                              "radio",
                                                                              attributes);
```

如果元素实例化成功，它将被返回。如果没有，将返回 `nullptr`。由于 `ElementPtr` 是 unique 指针，必须将其移动到元素层级中，例如使用 `std::move`。如果 unique 指针超出作用域，它将自动被释放。

### 销毁和移动元素

原始元素指针是非拥有型的，因此不应直接删除。如果它是无父元素的 unique 指针 `ElementPtr`，只需让对象超出作用域或调用 `element.reset()`。如果元素是层级的一部分，只需使用 `RemoveChild()` 函数将其从父元素移除即可销毁。
```cpp
/// Remove a child element from this element.
/// @param[in] The element to remove.
/// @returns A unique pointer to the element if found, discard the result to immediately destroy.
Rml::ElementPtr RemoveChild(Element* element);
```
remove 返回指向已移除子元素的 unique 指针。丢弃结果以立即释放它。否则，现在可以通过移动返回的 `ElementPtr` 将该元素追加到另一个元素。

请注意，`AppendChild` 和 `InsertBefore` 接受 `ElementPtr`，因此，任何已挂接的元素必须首先被移除，然后才能移动到层级中的另一个位置。
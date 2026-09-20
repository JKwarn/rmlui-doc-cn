---
layout: page
title: 样式表与样式属性
parent: cpp_manual
next: animations_transforms
---

一个 RmlUi 文档可以附加多个样式表。每个样式表都有一系列 RCSS 属性，以及用于选择这些属性应用于哪些元素的规则。任何元素也可以直接在其上设置属性。

本文档只详细说明样式表和属性系统的 C++ 接口；有关支持哪些属性及其功能的详细信息，请参阅 [RCSS 文档](../rcss.html)。

### 样式表

当你在 RML 文档的头部使用 `<link type="text/rcss" />`{:.tag} 标签时，样式表会自动加载并附加到文档；这是样式表最常见的加载方式。

如果你想动态创建或加载样式表，RmlUi factory（类 `Rml::Factory`）具有这样做的能力：

```cpp
// Creates a style sheet from a user-generated string.
static Rml::SharedPtr<Rml::StyleSheet> InstanceStyleSheetString(const Rml::String& string);
// Creates a style sheet from a file.
static Rml::SharedPtr<Rml::StyleSheet> InstanceStyleSheetFile(const Rml::String& file_name);
```

`InstanceStyleSheetString()` 允许你将应用程序中构建的字符串解析为样式表。这在调试器中用于保持其所有 RML 和 RCSS 内容内联。`InstanceStyleSheetFile()` 将从 RCSS 文件加载样式表。这两个函数在成功时都会返回一个样式表指针，然后你可以将其设置在文档上。

样式表通过 `Rml::SharedPtr`（它是 `std::shared_ptr` 的别名）进行引用计数。目前没有方法在样式表加载后向其添加规则或属性。

### 样式属性

#### 查询属性

可以使用 `GetProperty()` 函数从元素请求属性。

```cpp
// Returns one of this element's properties.
const Rml::Property* GetProperty(const Rml::String& name);
// Returns one of this element's properties by id.
const Rml::Property* GetProperty(Rml::PropertyId id);
// Returns the values of one of this element's properties.
template < typename T >
T Rml::GetProperty(const Rml::String& name);
```

前两个非模板版本的 `GetProperty()` 函数将返回元素上给定属性的值，或者按属性名称或其 id。如果元素本身没有定义该属性，它们将返回默认值（如果属性不是继承的）或其父元素的值（如果是继承的）。如果请求的属性无效（即在规范中没有定义），将返回 nullptr。

`Rml::Property` 结构定义在 `<RmlUi/Core/Property.h>`{:.incl} 中。以下是该类的一个子集，列出了它的一些有用成员：

```cpp
class Rml::Property
{
public:
	enum Unit
	{
		UNKNOWN,
		KEYWORD,
		STRING,
		NUMBER,
		PX,
		COLOUR,
		EM,
		PERCENT,
		// ...
	};

	/// Get the property as a string.
	Rml::String ToString() const;

	/// Templatised accessor.
	template <typename T>
	T Get() const
	{
		return value.Get<T>();
	}

	Rml::Variant value;
	Unit unit;
};
```

每个属性将其值的单位以及值本身存储为一个变体类型（`Rml::Variant`），这是一种能够存储多种类型的结构。要从变体中检索值，请在属性或变体本身上使用模板化的 `Get<>()` 函数。你应请求值的类型取决于属性的单位：

* `UNKNOWN` 和 `STRING` 值应作为 `Rml::String` 类型请求。
* `KEYWORD` 值应作为 int 类型请求。关键字值存储为整数以加快速度；要检查值意味着什么，你可以将其与 `<RmlUi/Core/StyleSheetKeywords.h>`{:.incl} 中定义的常量值进行比较。对于自定义关键字属性，请参阅下文。
* `NUMBER`、`PX`、`EM` 和 `PERCENT` 值应作为 float 类型请求。值的确切含义取决于单位。

如果你用错误的类型调用 `Get<>()`，变体将尽最大努力在类型之间转换。例如，如果你在浮点值上请求字符串类型，你将得到转换为字符串的值。

例如，以下代码将请求元素的字族：

```cpp
element->GetProperty(Rml::PropertyId::FontFamily)->Get< Rml::String >();
```

以下代码将检查元素的字重是否为粗体：

```cpp
bool bold = element->GetProperty("font-weight")->Get< int >() == (int)Rml::Style::FontWeight::Bold;
```

你可以使用模板化的 `GetProperty()` 函数方便地返回所请求属性的类型化值。例如：

```cpp
bool bold = element->GetProperty< int >("font-weight") == (int)Rml::Style::FontWeight::Bold;
```

#### 设置属性

可以使用 `SetProperty()` 函数直接在元素上设置属性。

```cpp
// Sets a local property override on the element.
bool SetProperty(const Rml::String& name, const Rml::String& value);
```

这相当于使用 `style`{:.attr} 属性在元素上设置内联属性。例如：

```html
<div id="test" style="width: 200px;" />
```

等价于：

```cpp
Rml::Element* test = document->GetElementById("test");
if (test)
	test->SetProperty("width", "200px");
```

以这种方式更改的属性如果是继承的，将自动传播到子元素，并在必要时强制重新布局。


#### 用户定义的属性

用户定义的属性可以添加到全局样式表规范中，这样你就可以在你想要的任何值附加到元素上。这是通过 `Rml::StyleSheetSpecification` 类（通过 `RmlUi/Core.h`{:.incl} 或 `RmlUi/Core/StyleSheetSpecification.h`{:.incl} 包含）完成的。

```cpp
// Registers a property with a new definition.
// @param[in] property_name The name to register the new property under.
// @param[in] default_value The default value to be used for an element if it has no other definition provided.
// @param[in] inherited True if this property is inherited from parent to child, false otherwise.
// @param[in] forces_layout True if a change in this property on an element will cause the element's layout to possibly change.
// @return The new property definition, ready to have parsers attached.
static Rml::PropertyDefinition& RegisterProperty(const Rml::String& property_name,
                                                          const Rml::String& default_value,
                                                          bool inherited,
                                                          bool forces_layout = false);
```

`RegisterProperty()` 函数接受新属性的名称、属性的默认值（如果元素上未设置该属性，则元素上的值）以及指示属性是否 `inherited` 的布尔值。如果设置为 `true`，当没有在元素上直接设置时，该属性从其父元素继承，而不是使用默认值。如果 `forces_layout` 设置为 `true`，属性的任何更改都将强制元素重新布局。对于用户定义的属性，这通常应保持为 `false`，因为只有内置属性会影响布局。

所以，例如，如果我们想要定义一个用于存储元素被点击时发出的声音的新属性，我们会在 RmlUi 初始化后不久调用：

```cpp
Rml::StyleSheetSpecification::RegisterProperty("click-sound", "none", false);
```

但这对我们没有多大用处，因为我们还没有说明新属性可以取哪些值。为此，我们需要向新属性添加一个属性解析器（property parser）。属性解析器尝试将属性的值从原始字符串解析为应用程序可以使用的格式。

每个属性可以附加多个解析器。RmlUi 中有几个默认的属性解析器，此外自定义解析器[可以添加](#user-defined-value-parsers)。其中一些包括：

- `number` 用于没有单位的数值（'15'）。
- `length` 用于带长度单位（'0px'、'0.5em'）的数值。
- `length_percent` 用于带长度或百分比单位（'80%'）的数值。
- `number_length_percent` 用于无单位、或带长度或百分比单位的数值。
- `angle` 用于角度值（'30deg'、'1.5rad'）。
- `string` 用于可以设置为任何字符串的值（如 `font-family`{:.prop}）。
- `keyword` 用于关键字值（如 `font-weight`{:.prop} 属性，可以是 'normal' 或 'bold'）。
- `color` 用于存储为颜色的值。

要将解析器附加到属性，请在 `RegisterProperty()` 函数返回的值上调用 `AddParser()` 函数。要附加第二个或第三个解析器，请在前一次调用 `AddParser()` 返回的值上再次调用 `AddParser()`。如果添加了多个解析器，值将按指定的顺序依次经过解析器，直到有一个成功解析该值。如果你注册 'string' 解析器，请注意这一点——确保你最后注册它，因为它会乐意解析你给它的任何值！

所以，要为前面的例子添加一个关键字和一个字符串解析器，我们会这样做：

```cpp
Rml::PropertyId click_sound_id = Rml::StyleSheetSpecification::RegisterProperty("click-sound", "none", false)
	.AddParser("keyword", "none, beep, boop, bang")
	.AddParser("string")
	.GetId();
```

`GetId()` 函数将返回为用户定义属性生成的属性 id。这可以用于高效地检索和设置此属性的值。

现在，如果属性被设置为 'none'、'beep'、'boop' 或 'bang'，属性的值将被设置为相应的关键字，否则它将被设置为字符串。所以，以下 RCSS：

```
button
{
	click-sound: beep;
}

button.siren
{
	click-sound: siren.wav;
}
```

将为所有 'button' 元素设置 `click-sound`{:.prop} 属性为关键字 'beep'，除非它们是 'siren' 类的，在这种情况下它将被设置为字符串值 "siren.wav"。

每个解析器都将其值存储为属性变体中的特定单位和类型。其中一些是：

* _number_ 将值存储为 `NUMBER`。使用 `Get< float >()` 请求该值。
* _length_ 将值存储为 `PX`、`EM` 及相关的。使用 `Get< float >()` 请求该值。
* _keyword_ 将值存储为 `KEYWORD`。该值是允许关键字 CSV 列表中指定关键字的整数索引；所以，在前面的例子中，值 'none' 将为 0，'beep' 将为 1，依此类推。使用 `Get< int >()` 请求该值。
* _string_ 将值存储为 `STRING`。使用 `Get< Rml::String >()` 请求该值。
* _colour_ 将值存储为 `COLOUR`。使用 `Get< Rml::Colourb >` 请求该值。

#### 用户定义的简写属性

你可以定义自定义简写属性（shorthand）以及常规属性。使用 `RegisterShorthand()` 函数来做到这一点。

```cpp
// Registers a shorthand property definition.
// @param[in] shorthand_name The name to register the new shorthand property under.
// @param[in] properties A comma-separated list of the properties this definition is shorthand for.
// @param[in] type The type of shorthand to declare.
// @param True if all the property names exist, false otherwise.
static bool RegisterShorthand(const Rml::String& shorthand_name,
                              const Rml::String& property_names,
                              Rml::ShorthandType type);
```

* `shorthand_name`：简写属性的名称（你将在 RCSS 中用来引用它的名称）。
* `property_names`：简写属性映射到的实际属性的逗号分隔列表。
* `type`：一个枚举，定义当给定简写属性的值少于它要赋值的属性时简写属性的行为；大多数时候你可以使用 `ShorthandType::FallThrough`，但还有其他行为可用，请参阅下文。

例如，`margin`{:.prop} 简写属性是这样定义的：

```cpp
Rml::StyleSheetSpecification::RegisterShorthand("margin", "margin-top, margin-right, margin-bottom, margin-left");
```

这里将描述三种最常见的简写类型 `FallThrough`、`Replicate` 和 `Box`。`FallThrough` 将针对其属性列表解析它拥有的每个值。如果任何值解析失败，它们将落到下一个属性，依此类推，直到成功解析。如果解析出来的值少于属性，其余属性将不会被设置。`font`{:.prop} 简写属性是这方面最好的例子；它是 `font-style`{:.prop}、`font-weight`{:.prop}、`font-size`{:.prop}、`font-family`{:.prop} 的 `FallThrough` 简写属性。RCSS：

```css
font: italic Lacuna;
```

将把 `font-style`{:.prop} 解析为 'italic'；'Lacuna' 作为 `font-weight`{:.prop} 属性和 `font-size`{:.prop} 都将解析失败，并落到 `font-family`{:.prop}。

`Replicate` 简写属性在任何值解析失败时会失败，如果值少于属性，最后一个值将被复制给其他属性。例如，`overflow`{:.prop} 是 `overflow-x`{:.prop} 和 `overflow-y`{:.prop} 属性的复制简写属性。RCSS：

```css
overflow: auto;
```

将把 'auto' 关键字赋给 `overflow-x`{:.prop} 和 `overflow-y`{:.prop}。如果 overflow 是 `FallThrough` 属性，`overflow-y`{:.prop} 将保留其默认值。

`Box` 简写属性用于诸如 `margin`{:.prop}、`padding`{:.prop} 等简写属性，它们为一个盒的上、右、下和左四边（按顺序）定义四个值。如果 `Box` 简写属性以少于四个值调用，则应用标准 CSS 规则；也就是说，一个值将复制到所有四边。两个值将设置到垂直和水平边。三个值将设置到上边、水平边和下边。

#### 用户定义的值解析器

如果你想为属性值定义更复杂的解析器，你可以在注册任何用户定义属性之前注册一个新的属性解析器。所有属性解析器的基类是 `Rml::PropertyParser`；从继承这个类并实现唯一的纯虚函数开始：

```cpp
// Called to parse a RCSS declaration.
// @param[out] property The property to set the parsed value on.
// @param[in] value The raw value defined for this property.
// @param[in] parameters The list of parameters defined for this property.
// @return True if the value was parsed successfully, false otherwise.
virtual bool ParseValue(Rml::Property& property,
                        const Rml::String& value,
                        const Rml::ParameterMap& parameters) const = 0;
```

`ParseValue()` 是解析器的核心。每当需要解析器将原始字符串值解析为有用的值时，都会调用它。

* `property`：应将解析后的值和单位写入的属性。
* `value`：原始字符串（例如 '15px'）。
* `parameters`：声明属性时给予解析器的逗号分隔参数映射。

例如，如果自定义解析器以以下方式附加到属性：

```cpp
Rml::StyleSheetSpecification::RegisterProperty("custom-property", "parameter-1", false)
	.AddParser("custom-parser", "parameter-1, parameter-2")
```

`parameters` 映射将包含值 'parameter-1' 和 'parameter-2'。每个值的值是它在逗号分隔值列表中的索引；所以，'parameter-1' 解析为 0，'parameter-2' 解析为 1。

如果值无法解析，属性的单位应设置为 `Rml::Property::UNKNOWN`。如果它可以解析，单位应设置为 `UNKNOWN` 以外的值，并将值适当地设置在属性的变体上。

一旦你有一个可用的自定义解析器，在 `StyleSheetSpecification` 上调用 `RegisterParser()`，将你的解析器注册到一个解析器名称。解析器名称在属性注册时立即解析，所以你需要先注册解析器，然后再注册属性。指向你的解析器的指针存储在库内部，因此请确保将该对象保持存活到调用 `Rml::Shutdown()` 之后，然后清理它。
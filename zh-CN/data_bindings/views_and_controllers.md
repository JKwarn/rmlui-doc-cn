---
layout: page
title: 数据视图与控制器
parent: data_bindings
---

{% raw %}

数据视图和数据控制器将文档与给定数据模型中的数据连接起来。*数据视图*（data view）用于以不同方式在文档中呈现数据变量。另一方面，*数据控制器*（data controller）用于响应文档中的变化，通常是用户输入的结果。当控制器被触发时，它会在其数据模型中设置一个数据变量。

数据视图和控制器通过元素属性在文档中声明：

	data-[type]-[modifier]="[value]"

修饰符（modifier）是否必需取决于具体的数据视图/控制器。某些数据绑定会从同一属性同时附加视图和控制器，从而实现双向绑定。

下表列出了 RmlUi 中所有内置的数据视图和控制器及其声明。


| 名称                         | 类型       | 属性                    | 值                                           | 备注 |
| ---------------------------- | ---------- | ---------------------------  | ----------------------------------------------- | ----- |
| [属性](#data-attr)      | 视图       | data-attr-[attribute_name]   | [data_expression]                               |       |
| [属性条件](#data-attrif) | 视图       | data-attrif-[attribute_name] | [data_expression]                               |       |
| [类](#data-class)         | 视图       | data-class-[class_name]      | [data_expression]                               |       |
| [样式](#data-style)         | 视图       | data-style-[property_name]   | [data_expression]                               |       |
| [条件](#data-if)               | 视图       | data-if                      | [data_expression]                               |       |
| [可见性](#data-visible)     | 视图       | data-visible                 | [data_expression]                               |       |
| [循环](#data-for)             | 视图       | data-for                     | [iterator_name], [index_name] : [data_address]  | [1]   |
| [Rml](#data-rml)             | 视图       | data-rml                     | [data_expression]                               |       |
| [文本](#data-text)           | 视图       | N/A                          | N/A                                             | [2]   |
| [别名](#data-alias)         | 视图       | data-alias-[alias_name]      | [data_address]                                  |       |
| [值](#data-value)         | 双向    | data-value                   | [data_address]                                  | [3]   |
| [选中](#data-checked)     | 双向    | data-checked                 | [data_address]                                  | [3]   |
| [事件](#data-event)         | 控制器 | data-event-[event_type]      | [assignment_expression]                         |       |

[1] `iterator_name` 和 `index_name` 是可选的。默认值分别为 `it` 和 `it_index`。\
[2] 当元素文本中出现双花括号 {{ }} 时，会自动添加文本视图。\
[3] 这些属性启用双向绑定，将为元素同时附加视图和控制器。

当数据视图更新时，会对其数据表达式求值，并使用任何必要的类型转换将其应用到文档中，该转换由数据视图的种类决定。类型转换使用 RmlUi 内置的 `TypeConverter` 工具完成。这种转换的一个特点是布尔值会被转换为字符串 `"0"` 或 `"1"`。考虑一个元素

```html
<div data-attr-foo="user_data"></div>
```

其中值 `user_data` 绑定到 C++ 变量 `bool user_data = true`。元素的属性将被设置为 `foo="1"`{:.attr}。任何关联的 RCSS 属性选择器都应使用相同的值表示形式，即 `div[foo=1]`。

#### 属性
{:#data-attr.data-desc}
`data-attr-[attribute_name]="[data_expression]"`
{:.data-attr}

将元素的属性 `[attribute_name]` 设置为求值后的表达式。

```html
<img data-attr-sprite="item.icon"/>
```

#### 属性条件
{:#data-attrif.data-desc}
`data-attrif-[attribute_name]="[data_expression]"`
{:.data-attr}

当表达式求值为 `true` 时设置元素的属性 `[attribute_name]`，否则从元素上移除该属性。

```html
<input type="checkbox" name="meals" value="pizza" data-attrif-disabled="rating > 70"/>
```

这对于取决于属性是否存在（例如 `disabled`）的元素行为非常有用。设置后，属性的值为空字符串。


#### 类
{:#data-class.data-desc}
`data-class-[class_name]="[data_expression]"`
{:.data-attr}

如果表达式求值为 `true`，则在元素上启用类 `[class_name]`，否则禁用该类。

```html
<h1 data-class-red="score < 30">Score</h1>
```


#### 样式
{:#data-style.data-desc}
`data-style-[property_name]="[data_expression]"`
{:.data-attr}

将元素样式的属性 `[property_name]` 设置为求值后的表达式。

```html
<img sprite="invader" data-style-image-color="invader.color"/>
```


#### 条件
{:#data-if.data-desc}
`data-if="[data_expression]"`
{:.data-attr}

如果表达式求值为 `false`，则将元素的 `display` 属性设置为 `none`，否则从元素的内联样式中移除 `display` 属性。

```html
<div data-if="rating > 50">
	Thanks for the <span data-if="rating >= 80">awesome</span> rating!
</div>
```

*注意。* 应用于元素的样式表规则应确保元素的 `display` 属性求值为 `none` 以外的值。否则，该元素将始终处于隐藏状态。


#### 可见性
{:#data-visible.data-desc}
`data-visible="[data_expression]"`
{:.data-attr}

如果表达式求值为 `false`，则将元素的 `visibility` 属性设置为 `hidden`，否则从元素的内联样式中移除 `visibility` 属性。

```html
<div data-visible="collected_stars > 0">
	<img sprite="star"/>
</div>
```

与 `data-if` 视图不同，`data-visible` 视图确保元素无论可见性如何都保持其大小。

*注意。* 应用于元素的样式表规则应确保元素的 `visibility` 属性求值为默认值 `visible`。否则，该元素将始终处于隐藏状态。


#### 循环
{:#data-for.data-desc}
`data-for="[iterator_name], [index_name] : [data_address]"`
{:.data-attr}

根据 `data_address` 指定的数据变量中的每一项，将元素及其子元素重复 *n* 次。该变量必须是数据数组类型。

```html
<div data-for="invader : invaders">
	<h1>{{ invader.name }}</h1>
	<p>Invader {{it_index + 1}} of {{ invaders.size }}.</p>
	<img data-attr-sprite="invader.sprite" data-style-image-color="invader.color"/>
	<p>Scores: <span data-for="invader.scores"> {{it}} </span></p>
</div>
```

可以使用迭代器从数据数组中的当前项检索值。

`data-for` 属性可以使用以下任一值，允许用户根据需要覆盖默认的迭代器和索引名称。请注意，索引从 0 开始。

| 属性值                                 | 迭代器名称    | 索引名称     |
| ----------------------------------------------- | ---------------- | -------------- |
| [data_address]                                  | `it`             | `it_index`     |
| [iterator_name] : [data_address]                | [iterator_name]  | `it_index`     |
| [iterator_name], [index_name] : [data_address]  | [iterator_name]  | [index_name]   |

`data-for` 循环通过为数组中的每个条目复制元素（连同其属性和内部 RML）来展开。例如：

```html
<p data-for="subject, i : subjects" data-class-selected="i == selected_subject">{{i + ': ' + subject}}</p>
```
如果 `subjects` 中有三个条目，则会变成
```html
<p data-class-selected="i == selected_subject">{{i + ': ' + subject}}</p>
<p data-class-selected="i == selected_subject">{{i + ': ' + subject}}</p>
<p data-class-selected="i == selected_subject">{{i + ': ' + subject}}</p>
<p style="display: none;"/>
```
其中 `i` 和 `subject` 分别成为数组索引和条目的别名。此外，在所有条目之后还会添加一个元素，这样即使没有条目，for 循环在文档树中的位置也能得到明确界定。该元素将由数据视图添加的 `display: none` 内联样式隐藏。

*注意 1.* 出于性能原因，全局数据变量的名称会遮蔽迭代器名称。因此，不要使用已用于数据绑定的迭代器名称。\
*注意 2.* 即使更改了数据数组的条目，`data-for` 循环的元素也可能被重复使用，而不是销毁并重新构造。\
*实现说明。* 在内部实现中，XML 解析器在遇到 `data-for` 属性时会使用特殊的解析规则，将当前元素的所有子元素作为原始 RML 文本提供给数据视图，这些文本随后用于创建数据数组中的每个条目。


#### Rml
{:#data-rml.data-desc}
`data-rml="[data_expression]"`
{:.data-attr}

将元素的内部 RML 设置为求值后的表达式。

```html
<div data-rml="incoming_invaders ? '<em>Send help!</em>' : 'Clear skies.'">
</div>
```


#### 文本
{:#data-text.data-desc}
`N/A`
{:.data-attr}

对元素文本中遇到的双花括号 {{ }} 内的任何数据表达式求值。

```html
<span class="position"> x: {{ position.x }}, y: {{ position.y }}</span>
<span data-for="i : indices"> {{ i * 2 + (i > 10 ? ' wow!' | to_upper : '') }}</span>
```

每当文本中出现双花括号时，会自动添加此数据视图，不应将其作为属性添加。


#### 别名
{:#data-alias.data-desc}
`data-alias-[alias_name]="[data_address]"`
{:.data-attr}

在给定的作用域内创建一个新的别名变量，允许通过其别名名称引用所指定的数据地址。

这允许将[模板](../rml/templates.html)用作数据模型中的可重用组件。通过将内联模板包装在定义变量名别名的元素中，模板可以通过固定名称引用任何外部变量。

为了说明这一点，请考虑以下模板。

```html
<template name="data-title">
<head></head>
<body>
	<div class="icon" data-attr-icon="icon"></div>
	<h1 class="title">{{ title }}</h1>
</body>
</template>
```
然后可以将此模板与不同的变量一起使用，如下所示：
```html
<div data-alias-title="t0" data-alias-icon="i0">
	<template src="data-title"/>
</div>
<div data-alias-title="t1" data-alias-icon="i1">
	<template src="data-title"/>
</div>
```


#### 值
{:#data-value.data-desc}
`data-value="[data_address]"`
{:.data-attr}

将元素的 `value`{:.attr} 属性与位于 `data_address` 的数据变量的值同步。该变量必须是标量类型。这通常对 `input`{:.tag} 元素很有用。

```html
<input type="range" min="0" max="100" step="1" data-value="rating"/>
```

每当当前元素上发生 `change`{:.evt} 事件时，都会为指定的数据变量赋一个新值。每当客户端侧的数据变量发生变化时，元素的 `value`{:.attr} 属性就会更新。

*注意。* 此属性不支持数据表达式和赋值表达式。如需更高的灵活性，请改用 `data-attr-value` 视图和 `data-event-change` 控制器。


#### 选中
{:#data-checked.data-desc}
`data-checked="[data_address]"`
{:.data-attr}

将复选框或单选按钮的 `checked` 状态绑定到位于 `data_address` 的变量。该变量必须是标量类型。通常与 `<input type="checkbox"/>`{:.tag} 和 `<input type="radio"/>`{:.tag} 元素结合使用。

```html
<input type="radio" name="animal" value="dog" data-checked="animal"/> Dog
<input type="radio" name="animal" value="cat" data-checked="animal"/> Cat
<input type="checkbox" name="meals" value="pasta" data-checked="pasta"/> Pasta
```

对于复选框，底层数据类型应为 `bool`，其中 `true` 表示选中，`false` 表示未选中。对于单选按钮，底层类型应为 `Rml::String` 类型，其值与当前选中的单选按钮的 `value` 属性相对应。

每当当前元素上发生 `change`{:.evt} 事件时，都会为指定的数据变量赋一个新值。每当客户端侧的数据变量发生变化时，元素的 `checked`{:.attr} 属性就会被添加或移除。

*注意。* 此属性不支持数据表达式和赋值表达式。如需更高的灵活性，请改用 `data-attrif-checked` 视图和 `data-event-change` 控制器。示例：
```html
<input type="checkbox" data-attrif-checked="pasta" data-event-change="pasta = ev.checked || force_pasta"/>
```


#### 事件
{:#data-event.data-desc}
`data-event-[event_type]="[assignment_expression]"`
{:.data-attr}

每当当前元素上发生 `[event_type]` 事件时，事件控制器就会被触发。支持 RmlUi 中的所有事件类型。触发后，关联的*赋值表达式*（assignment expression）会被求值。

赋值表达式可以指定为以下两种语句之一。

(1) `[data_address] = [data_expression]`\
(2) `[event_callback_name]([data_expression], [data_expression], ...)`

此外，单个赋值表达式可以通过分号分隔多个此类语句。

在 (1) 中，左侧地址关联的数据变量会被赋值为右侧求值后的表达式。只能对标量类型赋值。

在 (2) 中，给定的事件回调会在 C++ 中被调用，参数包括触发事件本身、当前数据模型的句柄以及圆括号内的参数列表。

可以在表达式中使用特殊变量 `ev` 从触发事件中检索值。

```html
<div class="mouse_detector"
	data-event-mousemove="mouse_detector = 'x: ' + ev.mouse_x + '<br/>y: ' + ev.mouse_y"
	data-event-click="add_mouse_pos(); hello_world = 'Hello click!'"
	data-rml="mouse_detector">
</div>
<h1>{{hello_world}}</h1>
<div data-for="positions">{{it}}</div>
```

所引用的 `add_mouse_pos` 事件回调会在元素被点击时触发，可以在 C++ 中按如下方式实现。

```cpp
using namespace Rml;

std::vector<Vector2f> positions;

void AddMousePos(DataModelHandle model_handle, Event& ev, const VariantList& arguments)
{
	positions.emplace_back(ev.GetParameter("mouse_x", 0.f), ev.GetParameter("mouse_y", 0.f));
	model_handle.DirtyVariable("positions");
}
```


{% endraw %}
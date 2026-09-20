---
layout: page
title: 数据变量与表达式
parent: data_bindings
next: model
---

{% raw %}

### 数据变量

数据变量（data variable）是用户原始数据的包装。共有三种主要类型。

1. `Scalar`（标量）。一个可读取、通常也可写入（但不一定）的单一值。
2. `Array`（数组）。一个可以索引的容器。其底层类型可以是任何数据变量类型。
3. `Struct`（结构体）。一组命名字段的集合。成员可以是任何数据变量类型。

在数据模型中，每个变量都有一个关联的*数据地址*（data address）。地址遵循常规的 C++ 语法：使用 `.x` 访问成员，使用 `[i]` 索引数组。此外，可以对数组使用 `.size` 来获取其大小。

以下示例都是有效的数据地址。
```
title
invader.health
invaders[1].name
invaders.size
a.very[5].long.data[99].address
```

算术类型（如 `int`、`float`）、枚举以及 `Rml::String` 无需注册即可支持。枚举按其底层类型处理，也可以手动注册。其他类型需要先注册。还可以使用 getter 和 setter 函数来绑定变量，此时数据变量表现为标量类型。有关注册类型的详细信息，请参阅数据模型文档。


### 数据表达式

数据表达式（data expression）是一些小型表达式，可以接受一个或多个数据变量，通过常见运算对其进行修改，并返回结果。多种数据视图和控制器都可以使用它们，从而更灵活地控制数据的显示方式。

其语法与 C++ 类似，大多数程序员应该都很熟悉。下表列出了允许的运算符及其优先级。具有相同优先级的运算符按从左到右的顺序求值。

| 优先级 | 运算符 | 说明                       |
| --------- | ----------------| --------------------------------- |
|   1       |  !              | 逻辑非。                      |
|   2       |  \* /           | 乘法和除法。      |
|   3       |  +              | 加法或字符串拼接。 |
|   3       |  -              | 减法。                      |
|   4       | == != < <= > => | 关系比较。           |
|   5       | && \|\|         | 逻辑与、或。                  |
|   5       | \|              | 变换。                        |
|   5       | a?b:c           | 三元条件。              |

圆括号 `( )` 始终优先于运算符。如果加法运算符的任一参数是字符串，则进行字符串拼接，否则使用数值加法。

表达式中可以使用以下类型。

1. 数据地址，指向标量数据变量。
2. 字面量（literal）。
    - 数值。如 `42` 或 `-3.2`。整数或小数。
    - 字符串。如 `'Play!'`。始终使用单引号。
3. 关键字。`true` 或 `false`。

运算符将其参数读取为 `bool`、`double` 或 `String` 类型。需要时，会使用 RmlUi 中的类型转换机制隐式完成转换。

#### 变换函数

*变换函数*（transform function）接受任意数量的输入参数并生成一个新值。可以使用函数调用约定来调用该函数。
```
transform_name([data_expression], [data_expression], ...)
```
或者，也可以等效地使用管道运算符 `|`，它将运算符左侧的值作为变换函数的第一个参数。
```
[data_expression] | transform_name([data_expression], ...)
```
如果变换函数只接受一个参数，则可以省略圆括号。
```
[data_expression] | transform_name
```

有几个内置的变换函数。

| 变换名称 | 参数                                                | 返回类型  | 说明                           |
| -------------  | -------------------------------------------------------- | ------------ | ------------------------------------- |
|   to_upper     |  `value`                                                 | String       | 将字符串转换为大写。       |
|   to_lower     |  `value`                                                 | String       | 将字符串转换为小写。       |
|   round        |  `value`                                                 | Numeric      | 将数值四舍五入到最接近的整数。 |
|   format       |  `value`, `precision`, `remove_trailing_zeros` = `false` | String       | 格式化数值。<br/>`precision` 决定写入的小数位数。<br/>`remove_trailing_zeros` 移除数字末尾的零以及可能的小数点字符。 |

此外，用户可以根据数据模型文档中的详细说明[提供自己的变换函数](model.html#registering-transforms)。

管道运算符 `|` 允许变换函数轻松串联，如下例所示。
```
i * 3.14159 | round | my_pow(4) | transform(2)
```
在其他情况下，函数调用语法或组合方式可能更方便。
```
make_lines('It takes', num_trolls*3 + ' goats', 'to outsmart', num_trolls | number_suffix('troll','trolls'))
```


#### 赋值表达式

数据视图从不向数据变量赋值，它们只读取数据变量。另一方面，数据控制器可以向数据变量赋值。为此，还支持*赋值表达式*（assignment expression）。

目前，赋值表达式只能在 [`data-event` 控制器](views_and_controllers.html#data-event) 中使用。语法和详细信息位于该控制器的文档中。


#### 表达式示例


| 示例                                                                 | 可能的结果       |
| ---------------------------------------------------------------------   | --------------------- |
| `rating < 80`                                                           | `1`                   |
| `radius + 'm'`                                                          | `8.7m`                |
| `(radius | format(2)) + 'm'`                                            | `8.70m`               |
| `radius < 10.5 ? 'small' : 'large'`                                     | `small`               |
| `'hot' + 'dog' | to_upper`                                              | `HOTDOG`              |
| `'x: ' + ev.mouse_x + '<br/>y: ' + ev.mouse_y`                          | `x: 128<br/>y: 958`   |
| `true || false ? (true && 3==1+2 ? 'Absolutely!' : 'well..') : 'no'`    | `Absolutely!`         |


{% endraw %}
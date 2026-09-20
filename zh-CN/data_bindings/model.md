---
layout: page
title: 数据模型
parent: data_bindings
next: views_and_controllers
---

{% raw %}

数据模型（data model）是用户数据与分配给该模型的视图和控制器之间的接口。

每个 `Context` 都可以存储多个具名数据模型。在 RML 文档中，通过使用 `data-model=[model_name]` 属性来应用指定的数据模型。之后，其所有子元素都属于该数据模型，并且可以引用其中的数据变量。

设置和管理数据模型的过程应如下所示。

1. 在上下文上以给定名称创建数据模型。
2. 在*数据模型构造函数*中注册任何标量、结构体或数组类型。
3. 使用数据模型构造函数绑定变量。
4. 加载文档。

然后，在更新循环中：

1. 像往常一样向上下文提交输入。数据控制器会在客户端侧按需更新数据变量，并随之在同一变量上设置脏（dirty）标志。
2. 现在可以安全地按需查询数据模型中脏的数据变量，也可以在客户端侧为任何已更改的数据设置脏状态。
3. 最后，在调用 `Context::Update` 期间，所有数据视图都将使用任何已变脏的数据变量进行更新。

模型构造函数和模型句柄的用法将在以下章节中详细说明。

### 模型构造函数

`Context::CreateModel` 函数返回一个数据模型构造函数，可用于注册类型和函数以及绑定变量。

```cpp
/// Creates a data model.
/// @param[in] name The name of the data model.
/// @param[in] data_type_register The data type register to use for the data model, or null to use the default register.
/// @param[in] allow_missing_variables If true, allows variables to be bound after document load. Views referencing
///            not-yet-bound variables will silently produce default values until the variable is bound and dirtied.
/// @return A constructor for the data model, or empty if it could not be created.
DataModelConstructor Context::CreateDataModel(
    const String& name,
    DataTypeRegister* data_type_register = nullptr,
    bool allow_missing_variables = false
);
```

#### 注册类型

用户应在绑定变量之前先注册类型，因为 RmlUi 可能需要类型信息来实例化数据变量。所有已注册的类型都适用于当前上下文中的每个数据模型。

内置类型会自动处理，无需注册，这适用于 `int` 和 `float` 等算术类型以及 `Rml::String`。

##### 数组

```cpp
template<typename Container>
bool DataModelConstructor::RegisterArray();
```
将 `Container` 注册为数组（Array）。该容器必须定义 `size()` 和 `begin()` 成员函数，后者返回一个可递增的迭代器。`std::vector` 和 `std::array` 等多个容器都满足此要求。设置数组仅需这一次注册调用。

##### 结构体

```cpp
template<typename T>
StructHandle<T> DataModelConstructor::RegisterStruct();
```
将 `T` 注册为结构体（Struct）。该函数返回一个可用于注册其成员的对象。可以注册成员对象以及 getter 和 setter 函数。请参阅以下示例。

```cpp
struct Vec2 {
	float x, y;

	float GetLength() {
		return std::sqrt(x*x + y*y);
	}
	void SetLength(float new_length) {
		float cur_length = std::sqrt(x*x + y*y);
		x *= new_length / cur_length;
		y *= new_length / cur_length;
	}
}

if (auto vec2_handle = constructor.RegisterStruct<Vec2>())
{
	vec2_handle.RegisterMember("x", &Vec2::x);
	vec2_handle.RegisterMember("y", &Vec2::y);
	vec2_handle.RegisterMember("length", &Vec2::GetLength, &Vec2::SetLength);
}
```

成员对象和成员函数不能使用 const 限定，且其类型必须已先注册。getter 函数可以按引用或指针返回任何数据类型（包括数组和结构体）。按值返回的 getter 函数以及组合的 getter 与 setter 函数必须返回或接受标量（Scalar）类型。

##### 标量

```cpp
template<typename T>
bool DataModelConstructor::RegisterScalar(DataTypeGetFunc<T> get_func, DataTypeSetFunc<T> set_func = {});
```
注册一个新类型 `T` 以像标量（Scalar）变量一样使用。它接受 getter 和 setter 函数，用于将该类型与 `Rml::Variant` 相互转换，请参阅以下示例。

```cpp
constructor.RegisterScalar<Rml::Colourb>(
	[](const Rml::Colourb& color, Rml::Variant& variant) {
		variant = "rgba(" + Rml::ToString(color) + ')';
	},
	[](Rml::Colourb& color, const Rml::Variant& variant) {
		Rml::String str = variant.Get<Rml::String>();
		bool success = false;
		if (str.size() > 6 && str.substr(0, 5) == "rgba(")
			success = Rml::TypeConverter<Rml::String, Rml::Colourb>::Convert(str.substr(5), color);
		if (!success)
			Rml::Log::Message(Rml::Log::LT_WARNING, "Invalid color specified: '%s'. Use syntax rgba(R,G,B,A).", str.c_str());
	}
);
```


#### 注册变换函数
{:#registering-transforms}

变换函数可以在数据表达式中使用，通过函数调用语法 `fnc()` 或管道运算符 `| fnc` 调用。可以使用以下函数注册变换函数：

```cpp
void DataModelConstructor::RegisterTransformFunc(const String& name, DataTransformFunc transform_func);
```
其中变换函数定义为
```cpp
using DataTransformFunc = std::function<Variant(const VariantList&)>;
```
输入参数包含传入变换函数的所有参数，顺序与它们在数据表达式中出现的顺序一致。使用管道运算符调用函数时，第一个参数将是 `|` 运算符左侧的值。变换函数应返回一个包含新值的 `Variant`，或返回空值以表示失败。

```cpp
// Register a transform function for formatting time
constructor.RegisterTransformFunc("format_time", [](const Rml::VariantList& arguments) -> Rml::Variant {
	if (arguments.empty())
		return {};
	const double t = arguments[0].Get<double>();
	const int minutes = int(t) / 60;
	const double seconds = t - 60.0 * double(minutes);
	return Rml::Variant(Rml::CreateString(10, "%02d:%05.2f", minutes, seconds));
});
```

#### 绑定数据变量

数据变量严格应用于当前数据模型。数据变量是原始指针或 get/set 函数对的包装。除非指向的类型是算术类型（如 `int`、`char`、`float`）或 `Rml::String`，否则该类型必须已*注册*。

使用以下函数绑定数据变量。
```cpp
// Bind a data variable.
template<typename T>
bool DataModelConstructor::Bind(const String& name, T* ptr);
```
将数据变量 `name` 绑定到数据模型。之后，在数据表达式中引用该数据变量、以及获取和设置变量的脏状态时都将使用此名称。`ptr` 是指向用户侧数据的指针。该数据的生命周期必须比当前数据模型更长。也就是说，要么持续到调用 `Rml::Shutdown()` 之后，要么持续到上下文被销毁，要么持续到数据模型被手动从上下文中移除。

也支持绑定指针，特别是原始指针、`std::unique_ptr` 和 `std::shared_ptr`，并且会根据需要自动解引用。但不支持 const 限定的对象。

```cpp
// Bind a get/set function pair.
bool DataModelConstructor::BindFunc(const String& name, DataGetFunc get_func, DataSetFunc set_func = {});
```
绑定标量数据类型的 `name`，接受 getter 和 setter 函数来检索值并将值赋给 `Rml::Variant`。get/set 函数定义如下。

```cpp
using DataGetFunc = std::function<void(Variant&)>;
using DataSetFunc = std::function<void(const Variant&)>;
```

#### 绑定事件回调函数

事件回调可以在 `data-event` 控制器中使用，用于接收事件并作出响应。

```cpp
bool DataModelConstructor::BindEventCallback(const String& name, DataEventFunc event_func);
```

其中

```cpp
using DataEventFunc = std::function<void(DataModelHandle, Event&, const VariantList&)>;
```

`DataModelHandle` 是生成事件回调的数据模型的句柄。`Event` 是生成事件回调的事件，可以像 RmlUi 中的其他事件一样使用，包括读取其属性和停止传播。`VariantList` 提供用户在 `data-event` 赋值表达式中传入的参数列表。

#### 返回数据模型句柄

最后，可以通过调用以下函数从 `DataModelConstructor` 获取数据模型句柄：

```cpp
DataModelHandle DataModelConstructor::GetModelHandle() const;
```


### 模型句柄

数据模型句柄用于在完成数据模型设置后与之交互。

```cpp
void DataModelHandle::DirtyVariable(const String& variable_name);

bool DataModelHandle::IsVariableDirty(const String& variable_name);
```

每当客户端侧的数据发生变化时，都应调用 `DirtyVariable()`。`IsVariableDirty()` 可用于检查控制器是否更改了数据变量的值。所有脏变量都会在调用 `Context::Update()` 后被清除。因此，应在处理完输入之后、上下文更新之前检查脏变量。


### 移除数据模型

可以通过在所属上下文上调用以下函数来手动关闭数据模型。

```cpp
/// Removes the given data model.
/// This also removes all data views, controllers and bindings contained by the data model.
/// @warning Invalidates all handles and constructors pointing to the data model.
/// @param[in] name The name of the data model.
/// @return True if succesfully removed, false if no data model was found.
bool Context::RemoveDataModel(const String& name);
```

否则，数据模型会在上下文销毁时自动移除。

### 附录

#### 跨库边界注册类型

如果你想在某个共享库（例如 `.dll` 或 `.so`）中注册类型，并在另一个共享库中使用相同的类型绑定变量，则需要考虑一些问题。在这种情况下，尝试绑定数据变量时可能会看到类似“*data type T not registered with the type register*”这样的错误。这是因为 RmlUi 会为每个类型分配一个唯一 ID，但该 ID 不会自动跨库边界可见。这会导致已注册类型与数据变量类型之间的 ID 不匹配。

一种解决方案是从其中一个库导出该 ID，并确保其他库可以看到该导出。例如：

`my_data_types.hpp`{:.path}:
```cpp
extern template class MY_DATATYPES_LIBRARY_API Rml::Family<MyTypes::Variant>;
extern template class MY_DATATYPES_LIBRARY_API Rml::Family<MyTypes::Vector3>;
```

`my_data_types.cpp`{:.path}:
```cpp
template class MY_DATATYPES_LIBRARY_API Rml::Family<MyTypes::Variant>;
template class MY_DATATYPES_LIBRARY_API Rml::Family<MyTypes::Vector3>;
```

此处，`MY_DATATYPES_LIBRARY_API` 应遵循[导出宏](https://cmake.org/cmake/help/latest/module/GenerateExportHeader.html)的常见惯例。现在，请确保在所有使用这些类型进行数据绑定的库中包含 `my_data_types.hpp`{:.path}。

*注意：* 某些编译器需要在声明处使用导出宏，而另一些编译器需要在定义处使用。你可能需要相应地调整代码，更多详情请参阅 [RmlUi#759](https://github.com/mikke89/RmlUi/pull/759#issuecomment-2832679164) 和 [fmt#2229](https://github.com/fmtlib/fmt/issues/2228)。

{% endraw %}
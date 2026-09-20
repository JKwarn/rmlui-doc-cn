---
layout: page
title: 数据绑定示例
parent: data_bindings
next: expressions
---

{% raw %}

务必查看 `databinding` 示例以获取更多示例。

### 基本示例

```html
<h1>Simple data binding example</h1>
<div data-model="my_model">
	<h2>{{title}}</h2>
	<p data-if="show_text">The quick brown fox jumps over the lazy {{animal}}.</p>
	<input type="text" data-value="animal"/>
</div>
```

`data-model` 属性声明其所有子元素均隶属于 `my_model`。
- 当遇到 `{{title}}` 时，它会自动被绑定到其模型的数据变量 `title` 所替换。此外，每当该变量被修改时，其内容也会自动更新。
- `data-if` 属性会创建一个数据视图，当其数据变量的求值结果为 `true` 时显示其内容。
- `data-value` 属性会同时创建一个数据视图和一个数据控制器，实现双向绑定。当应用程序中的数据发生变化时，视图会更新元素的值；反之，控制器会监听元素值的修改并相应地更新数据变量。因此，每当用户更改文本字段时，`animal` 变量都会被修改，从而使 `p` 标签的文本内容反映出新文本。


#### 设置数据模型

数据模型首先在 C++ 中设置。使用上述示例，只需以下代码即可。
```cpp
using namespace Rml;

struct MyData {
	String title = "Hello World!";
	String animal = "dog";
	bool show_text = true;
} my_data;

bool SetupDataBinding(Context* context, DataModelHandle& my_model)
{
	DataModelConstructor constructor = context->CreateDataModel("my_model");
	if (!constructor)
		return false;

	constructor.Bind("title", &my_data.title);
	constructor.Bind("animal", &my_data.animal);
	constructor.Bind("show_text", &my_data.show_text);

	my_model = constructor.GetModelHandle();

	return true;
}
```
应在加载文档之前调用一次 `SetupDataBinding` 函数。

就是这样！现在上面的基本示例将按预期工作：每当输入文本发生变化时，将其赋值给 `animal` 数据绑定，并更新段落文本。

不过，我们可能还想做更多的事情，实际上这里还有更强大的功能。让我们添加一个 `Update()` 方法，它在每次游戏循环迭代时被调用。该方法应在向上下文提交输入事件之后、上下文更新之前调用。
```cpp
void Update(DataModelHandle my_model)
{
	if (my_model.IsVariableDirty("animal"))
	{
		my_data.title = " Hello " + my_data.animal + "!";
		my_model.DirtyVariable("title");
	}
}
```
现在，每当输入文本发生变化时，标题也会随之更新。请注意，我们必须从 C++ 侧告知模型数据已更改。这个示例略显牵强，因为这种行为即使不使用数据绑定也很容易实现。不过，我们可以很容易地预见到其强大之处，接下来让我们做一个更复杂的示例来说明。


### 扩展示例

```html
<p>
	Incoming invaders:
	<input type="range" name="rating" min="0" max="20" step="5" data-value="incoming_invaders_rate"/>
	{{ incoming_invaders_rate }} / min.
</p>
<button data-event-click="launch_weapons">Launch weapons!</button>
<div data-for="invader : invaders">
	<h1 data-class-red="invader.danger_rating > 70">{{invader.name}}</h1>
	<p>Invader {{it_index + 1}} of {{ invaders.size }}.</p>
	<img data-attr-sprite="invader.sprite" data-style-image-color="invader.color"/>
	<p>
		Shots fired (damage): <span data-for="invader.damage"> {{it}} </span>
	</p>
</div>
<h1 data-if="invaders.size == 0">It's all safe and sound, sir!</h1>
```

注意到某些地方使用的比较和加法运算了吗？这些就是*数据表达式*（data expression），可以在多个地方使用。这是 RmlUi 内置的功能，支持最常见的运算符。此外，它们还可以通过用户提供的函数进行扩展。

接下来，让我们定义要用于该模型的数据。

```cpp
using namespace Rml;

struct Invader {
	String name;
	String sprite;
	Colourb color{ 255, 255, 255 };
	std::vector<int> damage;
	float danger_rating = 50;

	String GetColor() {
		return "rgba(" + ToString(color) + ')';
	}
};

struct InvadersData {
	double time_last_invader_spawn = 0;
	double time_last_weapons_launched = 0;

	float incoming_invaders_rate = 10; // Per minute

	std::vector<Invader> invaders = {
		Invader{"Angry invader", "icon-invader", {255, 40, 30}, {3, 6, 7}, 80}
	};

	void LaunchWeapons(DataModelHandle model_handle, Event& /*ev*/, const VariantList& /*arguments*/) {
		invaders.clear();
		model_handle.DirtyVariable("invaders");
	}

} invaders_data;
```

这里有简单的普通旧数据（POD）类型，也有容器，甚至还有结构体容器。实际上，无论你想嵌套多深，RmlUi 都能处理所有这些情况。不过，我们需要告诉 RmlUi 如何处理各种类型。为此，我们需要在绑定类型之前先注册它们。

RmlUi 支持三种主要的数据变量类型：

1. `Scalar`（标量）。一个可读取、通常也可写入（但不一定）的单一值。
2. `Array`（数组）。一个可以索引的容器。其底层类型可以是任何数据变量类型。
3. `Struct`（结构体）。一组命名字段的集合。成员可以是任何数据变量类型。

算术类型（如 `int`、`float`）以及 `Rml::String` 无需注册即可支持。其他类型需要先注册。下面的 C++ 代码演示了如何为上述数据注册类型并绑定变量。

```cpp
bool SetupDataBinding(Context* context, DataModelHandle& invaders_model)
{
	DataModelConstructor constructor = context->CreateDataModel("invaders");
	if (!constructor)
		return false;

	// First, register types so that RmlUi knows how to process them.

	// Invader::damage uses std::vector<int>, we need to tell RmlUi that this is an array type.
	constructor.RegisterArray<std::vector<int>>();

	// Structs are registered by adding all its members through the returned handle.
	if (auto invader_handle = constructor.RegisterStruct<Invader>())
	{
		invader_handle.RegisterMember("name", &Invader::name);
		invader_handle.RegisterMember("sprite", &Invader::sprite);
		invader_handle.RegisterMember("damage", &Invader::damage);
		invader_handle.RegisterMember("danger_rating", &Invader::danger_rating);

		// Getter and setter functions can also be used. Alternatively, register
		// the Colourb type as a new Scalar type instead.
		invader_handle.RegisterMember("color", &Invader::GetColor);
	}

	// We can even have an Array of Structs, infinitely nested if we so desire.
	// Make sure the underlying type (here Invader) is registered before the array.
	constructor.RegisterArray<std::vector<Invader>>();

	// Now we can bind the variables to the model.
	constructor.Bind("incoming_invaders_rate", &invaders_data.incoming_invaders_rate);
	constructor.Bind("invaders", &invaders_data.invaders);

	// This function will be called when the user clicks the 'Launch weapons' button.
	constructor.BindEventCallback("launch_weapons", &InvadersData::LaunchWeapons, &invaders_data);

	invaders_model = constructor.GetModelHandle();
}
```


最后，我们想让行为变得更有趣一些，例如根据用户设置的速率生成新的入侵者。以下代码应在应用程序的更新循环中运行。

```cpp
void Update(DataModelHandle invaders_model)
{
	const double t = GetSystemInterface()->GetElapsedTime();

	// Add new invaders at regular time intervals.
	const double t_next_spawn = invaders_data.time_last_invader_spawn + 60.0 / double(invaders_data.incoming_invaders_rate);
	if (t >= t_next_spawn)
	{
		const int num_items = 4;
		static std::array<Rml::String, num_items> names = { "Angry invader", "Harmless invader", "Deceitful invader", "Cute invader" };
		static std::array<Rml::String, num_items> sprites = { "icon-invader", "icon-flag", "icon-game", "icon-waves" };
		static std::array<Rml::Colourb, num_items> colors = {{ { 255, 40, 30 }, {20, 40, 255}, {255, 255, 30}, {230, 230, 230} }};

		Invader new_invader;
		new_invader.name = names[rand() % num_items];
		new_invader.sprite = sprites[rand() % num_items];
		new_invader.color = colors[rand() % num_items];
		new_invader.danger_rating = float((rand() % 100) + 1);
		invaders_data.invaders.push_back(new_invader);

		invaders_model.DirtyVariable("invaders");
		invaders_data.time_last_invader_spawn = t;
	}

	// Launch shots from a random invader.
	if (t >= invaders_data.time_last_weapons_launched + 1.0)
	{
		if (!invaders_data.invaders.empty())
		{
			const size_t index = size_t(rand() % int(invaders_data.invaders.size()));

			Invader& invader = invaders_data.invaders[index];
			invader.damage.push_back(rand() % int(invader.danger_rating));

			invaders_model.DirtyVariable("invaders");
		}
		invaders_data.time_last_weapons_launched = t;
	}
}
```

这个更新循环以固定的时间间隔生成新的入侵者，间隔由 `range` 输入滑块决定。`data-for` 循环确保新入侵者自动显示。数据绑定进一步确保入侵者的精灵图和颜色被设置为给定的值。

该示例的完整版本位于随附的 `databinding` 示例中，鼓励用户查看并在这个小游戏中体验一番。

{% endraw %}
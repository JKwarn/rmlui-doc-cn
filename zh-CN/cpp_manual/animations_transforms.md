---
layout: page
title: 动画与变换
parent: cpp_manual
next: decorators
---

RmlUi 对变换与动画提供了丰富的支持。本指南介绍如何从 C++ 侧控制这些特性。

另请参阅 [RCSS 文档](../rcss/animations_transitions_transforms.html) 中关于动画、过渡与变换的更多细节及从 RCSS 使用这些特性的方法。


### 变换
{:#transform}

变换通过 `transform`{:.prop} 属性设置在元素上。

```cpp
element->SetProperty("transform", "rotate(30deg)");
```

这会解析提供的字符串，并在元素上启用所提供的变换。另请参阅相关属性 `perspective`{:.prop}、`perspective-origin`{:.prop} 和 `transform-origin`{:.prop}，它们控制变换的施加方式与渲染效果。

变换也可以直接提供而无需经过解析步骤。这样可以提高性能，并且在变换值以编程方式提供时更为方便。借助辅助函数 `Transform::MakeProperty`，我们可以这样设置变换：

```cpp
auto p = Transform::MakeProperty({ Transforms::Rotate2D{10.f}, Transforms::TranslateX{100.f} });
element->SetProperty(PropertyId::Transform, p);
```

可以使用 `Transforms::Matrix3D` 变换原语提供自定义变换矩阵。请参阅 `TransformPrimitive.h`{:.path} 头文件中所有可应用的变换原语。你也可以查看随附的 `transform` 示例和 `animation` 示例以获取更多示例。


### 动画
{:#animation}

对动画的支持主要参见 [RCSS 文档](../rcss/animations_transitions_transforms.html)。从 C++ 侧，可以通过调用以下函数在元素上启动动画。

```c++
// Start an animation of the given property on this element.
// @return True if a new animation was added.
bool Element::Animate(
	const String& property_name,
	const Property& target_value,
	float duration,
	Tween tween = Tween{},
	int num_iterations = 1,
	bool alternate_direction = true,
	float delay = 0.0f,
	const Property* start_value = nullptr
);
```

这将启动由 `property_name` 指定的属性的动画。动画将从元素上该属性的当前值开始，或者从提供的 `start_value` 开始，然后平滑地插值到 `target_value`。`duration` 以秒为单位。可以提供缓动函数 `tween` 来控制插值的时间进度，详细信息请参阅 RCSS 文档。动画将重复 `num_iterations` 次，当指定为 -1 时则无限重复。`delay` 参数以秒为单位，设置在属性开始动画之前的延迟时间。

动画属性的值会在 `Context::Update` 期间更新。

可以通过调用以下函数来添加额外的动画关键帧，从而延长动画的持续时间：

```c++
// Add a key to an animation, extending its duration.
// @return True if a new animation key was added.
bool Element::AddAnimationKey(
	const String& property_name,
	const Property& target_value,
	float duration,
	Tween tween = Tween{}
);
```

该动画关键帧将被添加到同一属性上已有的动画中。参数与 `Element::Animate` 中的参数对应。

示例用法：

```c++
auto p1 = Transform::MakeProperty({ Transforms::Rotate2D{10.f}, Transforms::TranslateX{100.f} });
auto p2 = Transform::MakeProperty({ Transforms::Scale2D{3.f} });
el->Animate("transform", p1, 1.8f, Tween( Tween::Elastic, Tween::InOut ), -1, true);
el->AddAnimationKey("transform", p2, 1.3f, Tween( Tween::Elastic, Tween::InOut ));
```

除了使用任何内置的缓动函数之外，还可以通过如下方式构造自定义缓动函数：

```c++
Tween tween(
	[](float t) { return t * t; },
	Tween::Out
);
```
该函数应提供从归一化时间 `float t`（范围 [0, 1]）到插值因子 `float` 输出的映射。它是一个轻量级的函数指针，因此不能携带任何 lambda 绑定。

更多示例与细节请参阅 `animation` 示例。
---
layout: page
title: 事件
parent: cpp_manual
next: rcss
---

事件被发送到元素，以指示该元素发生了某些动作。RmlUi 在内部生成许多事件。应用程序也可以向元素发送任意事件。

当事件被派发到元素时，它按以下顺序经历三个不同的阶段。
* 捕获阶段（Capture phase）。从根元素传播到目标元素的父元素。
* 目标阶段（Target phase）。目标元素。
* 冒泡阶段（Bubble phase）。从目标元素的父元素传播到根元素。仅对某些事件类型执行。

事件监听器能够订阅元素上的特定事件，并且每当这些事件发生时都会收到通知。每个事件监听器要么附加到冒泡阶段（默认），要么附加到捕获阶段。如果事件监听器在目标阶段被到达，无论其附加的阶段如何，它都会被执行。监听器按照它们附加到元素的顺序执行。事件监听器可以在任何阶段停止事件的进一步传播，但是，事件类型必须可中断才能停止传播。

在所有事件监听器执行完毕后，可以处理事件的默认动作。默认动作主要用于库内部执行的动作，可以通过停止传播来阻止。任何派生自 `Element` 的对象都可以覆盖默认行为并添加新行为。默认动作仅在特定阶段处理，每个事件类型都定义了这些阶段。

事件由以下内容指定：
* 一个标识符，`Rml::EventId`，例如 `EventId::Keydown`。
* 一个描述性的字符串名称，例如 `keydown`{:.evt} 或 `blur`{:.evt}。
* 是否可中断。
* 是否执行冒泡阶段。
* 在哪些阶段执行 `Element::ProcessDefaultAction()`。
* 一个进一步描述事件的参数字典。例如，`keydown`{:.evt} 事件具有用于识别实际按下的键和按键修饰符状态的参数。

有关每种类型的细节，请参阅下面的[事件规范](#event-specifications)，有关每个事件的描述和参数列表，请参阅 [RML 事件文档](../rml/events.html)。


### 事件接口

事件由 `Rml::Event` 结构表示，定义于 `RmlUi/Core/Event.h`{:.incl}。下面给出事件对象公共接口的一个子集。

```cpp
enum class EventPhase { None, Capture = 1, Target = 2, Bubble = 4 };

class Event
{
public:
	// Get the current propagation phase.
	Rml::EventPhase GetPhase() const;
	// Get the current element in the propagation.
	Rml::Element* GetCurrentElement() const;
	// Get the target element.
	Rml::Element* GetTargetElement() const;

	// Get the event type.
	const Rml::String& GetType() const;
	// Get the event id.
	EventId GetId() const;

	// Stops propagation of the event if it is interruptible, but finish all listeners on the current element.
	void StopPropagation();
	// Stops propagation of the event if it is interruptible, including to any other listeners on the current element.
	void StopImmediatePropagation();

	// Returns the value of one of the event's parameters.
	// @param key[in] The name of the desired parameter.
	// @return The value of the requested parameter.
	template < typename T >
	T GetParameter(const Rml::String& key, const T& default_value);
};
```

事件所处的阶段由 `GetPhase()` 返回，将是 `EventPhase::Capture`、`EventPhase::Target` 和 `EventPhase::Bubble` 之一。

目标元素由 `GetTargetElement()` 返回，是事件最初发送到的元素。当前元素由 `GetCurrentElement()` 返回，是事件当前正在发送到的元素。这可能是目标元素或目标元素的祖先之一。

事件的 id，例如 `EventId::Keydown` 和 `EventId::Focus`，由 `GetId()` 返回。你也可以使用相等运算符将事件与 `EventId` 比较。事件也可以类似地与字符串比较，例如 `keydown`{:.evt} 和 `focus`{:.evt}。

你可以使用模板化的 `GetParameter()` 函数获取事件的参数。每个事件的确切参数在[事件文档](../rml/events.html)中有详细说明。

对于可以中断的事件类型，监听器可以调用 `StopPropagation()` 和 `StopImmediatePropagation()` 函数来停止事件的传播。立即变体还将停止当前元素上其余监听器的执行。如果传播被中断，则不会处理默认动作。

### 事件监听器

任何想要监听事件的对象都派生自 `Rml::EventListener`，并实现一个必需的纯虚函数：

```cpp
// Process the incoming event.
virtual void ProcessEvent(Rml::Event& event) = 0;
```

每当相关事件被发送到监听器所订阅的元素时，都会调用 `ProcessEvent()` 函数。

#### 附加到元素

要将事件监听器订阅到元素，请调用要附加到的元素上的 `AddEventListener()` 函数。

```cpp
// Adds an event listener to this element.
// @param[in] event Event to attach to.
// @param[in] listener The listener object to be attached.
// @param[in] in_capture_phase True to attach in the capture phase, false in bubble phase.
void AddEventListener(const Rml::String& event,
                      Rml::EventListener* listener,
                      bool in_capture_phase = false);
```

该函数接受以下参数：

* `event`：监听器想要附加的事件的字符串名称，例如 "keydown"、"focus" 等。
* `listener`：要附加的事件监听器对象。
* `in_capture_phase`：如果为 true，事件监听器将在捕获阶段接收事件，否则在冒泡阶段接收。更多信息请参阅 RML 事件文档。

请注意，事件监听器必须保持存活，直到监听器被移除或元素被销毁。
请注意，使用 `ElementDocument::Close()` 关闭的文档实际上直到下一次调用 `Context::Update()` 或 `Rml::Shutdown()` 时才会被销毁。

#### 从元素分离

要从元素取消订阅事件监听器，请调用元素上的 `RemoveEventListener()` 函数：

```cpp
// Removes an event listener from this element.
// @param[in] event Event to detach from.
// @param[in] listener The listener object to be detached.
// @param[in] in_capture_phase True to detach from the capture phase, false from the bubble phase.
void RemoveEventListener(const Rml::String& event,
                         Rml::EventListener* listener,
                         bool in_capture_phase = false);
```

### 发送事件

应用程序可以通过 `Rml::Element` 上的 `DispatchEvent()` 函数向元素发送任意事件。

```cpp
// Sends an event to this element.
// @param[in] event Name of the event in string form.
// @param[in] parameters The event parameters.
// @param[in] interruptible True if the propagation of the event be stopped.
void DispatchEvent(const Rml::String& event,
                   const Rml::Dictionary& parameters);
```

事件将被创建并通过标准事件循环发送。以下示例向元素发送一个 "close" 事件：

```cpp
Rml::Dictionary parameters;
parameters["source"] = "user";

element->DispatchEvent("close", parameters);
```

### 自定义事件

事件与上下文类似，通过事件 instancer 实例化。如果需要自定义事件，可以用自定义 instancer 覆盖 instancer；这通常仅在将脚本语言集成到 RmlUi 时才需要。

自定义事件继承自 `Rml::Event`。没有需要覆盖的虚函数。

#### 创建自定义事件 instancer

为了实例化自定义事件，需要创建自定义事件 instancer 并在 RmlUi factory 中注册。自定义事件 instancer 派生自 `Rml::EventInstancer` 并实现必需的纯虚函数：

```cpp
// Instance an event object.
// @param[in] target Target element of this event.
// @param[in] id EventId of this event.
// @param[in] name Name of this event.
// @param[in] parameters Additional parameters for this event.
// @param[in] interruptible If the event propagation can be stopped.
virtual Rml::EventPtr InstanceEvent(Rml::Element* target,
										   Rml::EventId id,
                                           const Rml::String& name,
                                           const Rml::Dictionary& parameters,
                                           bool interruptible) = 0;

// Releases an event instanced by this instancer.
// @param[in] event The event to release.
virtual void ReleaseEvent(Event* event) = 0;
```

每当 factory 被调用需要实例化事件时，都会调用 `InstanceEvent()`。该函数的参数是：

* `target`：事件所针对的元素。
* `id`：事件的 EventId（EventId::Keydown、EventId::Focus 等）。
* `name`：事件的名称（"keydown"、"focus" 等）。
* `parameters`：作为字典的事件参数。
* `interruptible`：如果事件可以被中断（即防止在整个事件循环中传播）则为 true，否则为 false。

如果 `InstanceEvent()` 成功，则返回包装在 `EventPtr`（一种带有自定义删除器的 unique 指针）中的新事件。否则，返回 nullptr 表示实例化错误。

当系统不再需要通过 instancer 实例化的事件时，会调用 `ReleaseEvent()`。它应被适当地删除。

#### 注册 instancer

要在 RmlUi 初始化后向 RmlUi 注册自定义 instancer，请调用 RmlUi factory（`Rml::Factory`）上的 `RegisterEventInstancer()` 函数。

```cpp
// Registers an instancer for all events.
// @param[in] instancer The instancer to be called.
// @return The registered instanced on success, NULL on failure.
static Rml::EventInstancer* RegisterEventInstancer(Rml::EventInstancer* instancer);
```

与其他 instancer 一样，管理 instancer 的生命周期是用户的责任。因此，它必须保持存活直到调用 `Rml::Shutdown()` 之后，然后由用户清理。

### 内联事件

事件响应可以像 HTML 一样在 RML 中指定为元素标记属性（attribute）。例如，在以下 RML 片段中，对 `click`{:.evt} 事件给出了一个响应。

```html
<rml>
	<head>
	</head>
	<body>
		<button onclick="game.start()">Start Game</button>
...
```

注意 `click`{:.evt} 事件名称之前的 `on`{:.attr} 前缀。来自 RML 的所有事件绑定都以这种方式加前缀。此外，可以使用后缀 `capture`{:.attr} 将事件绑定到捕获阶段，而不是默认为冒泡阶段。

RmlUi 将内联事件发送给由应用程序创建的事件监听器代理对象。因此，应用程序必须注册自定义事件监听器 instancer，才有机会解释这些事件。

#### 创建自定义事件监听器 instancer

自定义事件监听器 instancer 派生自 `Rml::EventListenerInstancer`。必须实现以下纯虚函数：

```cpp
// Instance an event listener object.
// @param value Value of the inline event.
// @param element Element that triggers this call to the instancer.
// @return An event listener which will be attached to the element.
// @lifetime The returned event listener must be kept alive until the call to `EventListener::OnDetach` on the
//           returned listener, and then cleaned up by the user. The detach function is called when the listener
//           is detached manually, or automatically when the element is destroyed.
virtual Rml::EventListener* InstanceEventListener(const Rml::String& value, Rml::Element* element) = 0;
```

每当 factory 需要为内联事件找到事件监听器时，都会在 RML 解析期间调用 `InstanceEventListener()`。参数 value 将是 RML 中指定的原始事件响应字符串，例如 `game.start()`。

创建事件监听器 instancer 后，可以将其传递给 factory，这必须在加载文档之前完成。

```cpp
// Register the instancer to be used for all event listeners, or nullptr to clear an existing instancer.
// This must be done before loading a Document, otherwise, no event handlers that are specified will be instatiated from it.
// @lifetime The instancer must be kept alive until after the call to Rml::Shutdown, or until a new instancer is set.
void Rml::Factory::RegisterEventListenerInstancer(Rml::EventListenerInstancer* instancer);
```

然后所有遇到的内联事件声明都将传递给 instancer。任何时刻只能有一个 instancer 处于活动状态。

### 自定义事件类型

自定义事件可以在没有任何特殊设置的情况下派发。它们随后将自动被分配一个唯一的 `EventId` 并赋予默认规范：`interruptible: true, bubbles: true, default_action_phase: None`。

要为新事件提供自定义规范，首先调用该方法：
```cpp
EventId Rml::RegisterEventType(const String& type, bool interruptible, bool bubbles, DefaultActionPhase default_action_phase);
```
在此调用之后，此类型的任何使用都将默认使用所提供的规范。返回的 `EventId` 可以用来取代类型字符串来派发事件。


### 事件规范

以下列出所有内置事件的规范。另请参阅 [RML 事件文档](../rml/events.html) 中每个事件类型可用的参数。

|  `EventId` id  |  `String` type  | `bool` interruptible  | `bool` bubbles |   `DefaultActionPhase` default_action  |
|------------------------|-----------------|-------|-------|---------------------------------------|
| Mousedown    | mousedown     | true  | true  | TargetAndBubble |
| Mousescroll  | mousescroll   | true  | true  | None            |
| Mouseover    | mouseover     | true  | true  | Target          |
| Mouseout     | mouseout      | true  | true  | Target          |
| Focus        | focus         | false | false | Target          |
| Blur         | blur          | false | false | Target          |
| Keydown      | keydown       | true  | true  | TargetAndBubble |
| Keyup        | keyup         | true  | true  | TargetAndBubble |
| Textinput    | textinput     | true  | true  | TargetAndBubble |
| Mouseup      | mouseup       | true  | true  | TargetAndBubble |
| Click        | click         | true  | true  | TargetAndBubble |
| Dblclick     | dblclick      | true  | true  | TargetAndBubble |
| Load         | load          | false | false | None            |
| Unload       | unload        | false | false | None            |
| Show         | show          | false | false | None            |
| Hide         | hide          | false | false | None            |
| Mousemove    | mousemove     | true  | true  | None            |
| Dragmove     | dragmove      | true  | true  | None            |
| Drag         | drag          | false | true  | Target          |
| Dragstart    | dragstart     | false | true  | Target          |
| Dragover     | dragover      | true  | true  | None            |
| Dragdrop     | dragdrop      | true  | true  | None            |
| Dragout      | dragout       | true  | true  | None            |
| Dragend      | dragend       | true  | true  | None            |
| Handledrag   | handledrag    | false | true  | None            |
| Resize       | resize        | false | false | None            |
| Scroll       | scroll        | false | true  | None            |
| Animationend | animationend  | false | true  | None            |
| Transitionend| transitionend | false | true  | None            |
|              |		       |       |                         |
| Change       | change        | false | true  | None            |
| Submit       | submit        | true  | true  | None            |
| Tabchange    | tabchange     | false | true  | None            |
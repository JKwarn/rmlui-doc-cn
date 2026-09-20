---
layout: page
title: RML 事件
parent: rml
next: images
---

事件系统基于极为灵活的 DOM 事件系统。当事件在目标元素上触发时，它会从根元素**捕获**到目标元素，然后再**冒泡**回根元素。事件监听器可以在捕获阶段或冒泡阶段附加。在 RML 中进行的绑定始终附加在冒泡阶段。

某些事件不会执行冒泡阶段。更多细节，请参阅 [C++ 事件文档](../cpp_manual/events.html)。

### RML 绑定

可以通过在 RML 中声明的元素上指定一个属性来绑定事件监听器，该属性的名称是要绑定的事件名称，并带有 `on`{:.attr} 前缀。例如，要将监听器绑定到 `click`{:.evt} 事件，可以声明如下内容：

```html
<button onclick="load game">Start Game</button>
```

请注意，这是唯一需要在事件名称前加 `on`{:.attr} 前缀的地方；其他所有引用事件的地方，都只使用事件名称本身。

默认情况下，上述绑定将监听器绑定到冒泡阶段。在少数情况下，可能希望将监听器绑定到捕获阶段。在 RmlUi 中，可以通过在属性名后附加 `capture`{:.attr} 来实现，例如 `<button onclickcapture="load game">`。

### 事件

下面是事件列表及其关联的事件属性。

许多输入事件会传递按键修饰符。在这种情况下，如果动作发生时按键修饰符处于激活状态，以下参数将被设为 true：

* ctrl_key
* shift_key
* meta_key
* alt_key
* caps_lock_key
* num_lock_key
* scroll_lock_key

#### 常规事件

`show`{:.evt}
: 当文档变为可见时发送给文档。

`hide`{:.evt}
: 当文档变为不可见时发送给文档。

`resize`{:.evt}
: 当文档的上下文被调整大小时发送给文档。

`scroll`{:.evt}
: 当元素被滚动时发送给该元素。

`focus`{:.evt}
: 当元素成为主焦点时发送给该元素。
* `focus_visible`：如果焦点应通过视觉方式指示，则设为 true。

`blur`{:.evt}
: 当元素失去焦点时发送给该元素。


#### 键盘事件

`keydown`{:.evt}
: 当按下按键时发送给焦点元素。
* `key_identifier`：来自 `Rml::Input::KeyIdentifier` 枚举（位于 `<RmlUi/Core/Input.h>`{:.incl}）的值。
* 按键修饰符。

`keyup`{:.evt}
: 当松开按键时发送给焦点元素。
* `key_identifier`：来自 `Rml::Input::KeyIdentifier` 枚举的值。
* 按键修饰符。

`textinput`{:.evt}
: 当输入一个或多个文本字符时发送给焦点元素。
* `text`：以 UTF-8 编码的 `Rml::String` 字符。

#### 鼠标事件

所有鼠标事件都会传递按键修饰符。

`click`{:.evt}
: 当鼠标按钮在某个元素上被点击时，发送给鼠标光标下的元素。点击定义为在同一元素上按下按钮并随后释放按钮。
* `mouse_x`：鼠标在上下文中的 x 位置。
* `mouse_y`：鼠标在上下文中的 y 位置。
* `button`：被点击的鼠标按钮编号。

`dblclick`{:.evt}
: 当鼠标按钮在某个元素上被双击时，发送给鼠标光标下的元素。请注意，`click`{:.attr} 事件总是会在 `dblclick`{:.evt} 之前发送。
* `mouse_x`：鼠标在上下文中的 x 位置。
* `mouse_y`：鼠标在上下文中的 y 位置。
* `button`：被点击的鼠标按钮编号。

`mouseover`{:.evt}
: 当鼠标光标移动到元素上时发送给该元素。
* `mouse_x`：鼠标在上下文中的 x 位置。
* `mouse_y`：鼠标在上下文中的 y 位置。

`mouseout`{:.evt}
: 当鼠标光标移出元素时发送给该元素。
* `mouse_x`：鼠标在上下文中的 x 位置。
* `mouse_y`：鼠标在上下文中的 y 位置。

`mousemove`{:.evt}
: 当鼠标移动时，发送给鼠标光标下的元素。
* `mouse_x`：鼠标在上下文中的 x 位置。
* `mouse_y`：鼠标在上下文中的 y 位置。

`mouseup`{:.evt}
: 当鼠标按钮被释放时，发送给鼠标光标下的元素。
* `mouse_x`：鼠标在上下文中的 x 位置。
* `mouse_y`：鼠标在上下文中的 y 位置。
* `button`：被释放的鼠标按钮编号。

`mousedown`{:.evt}
: 当鼠标按钮被按下时，发送给鼠标光标下的元素。
* `mouse_x`：鼠标在上下文中的 x 位置。
* `mouse_y`：鼠标在上下文中的 y 位置。
* `button`：被按下的鼠标按钮编号。

`mousescroll`{:.evt}
: 当鼠标滚轮被滚动，或正在启动[自动滚动模式](../cpp_manual/contexts.html#autoscroll)时，发送给焦点元素。可以通过停止事件的传播来取消滚动。
* `mouse_x`：鼠标在上下文中的 x 位置。
* `mouse_y`：鼠标在上下文中的 y 位置。
* `wheel_delta_x`：滚轮水平滚动的距离，为浮点值，正值表示向右。
* `wheel_delta_y`：滚轮垂直滚动的距离，为浮点值，正值表示向下。
* `autoscroll`：如果正在启动自动滚动，则设为 true。

#### 拖拽事件

所有鼠标拖拽事件都会传递按键修饰符。

`dragstart`{:.evt}
: 当元素第一次被拖拽时，在第一个拖拽事件之前发送给该元素。
* `mouse_x`：鼠标在上下文中的 x 位置。
* `mouse_y`：鼠标在上下文中的 y 位置。
* `drag_element`：正在被拖拽的元素。

`dragend`{:.evt}
: 当鼠标按钮被释放时，发送给被拖拽的元素。
* `mouse_x`：鼠标在上下文中的 x 位置。
* `mouse_y`：鼠标在上下文中的 y 位置。
* `drag_element`：正在被拖拽的元素。

`drag`{:.evt}
: 当鼠标移动时，发送给被拖拽的元素。
* `mouse_x`：鼠标在上下文中的 x 位置。
* `mouse_y`：鼠标在上下文中的 y 位置。
* `drag_element`：正在被拖拽的元素。

以下事件仅在拖拽元素具有 **drag-drop** 拖拽属性时发送。它们被发送给被拖拽元素以外的元素，通常在鼠标光标经过这些元素时发送。

`dragover`{:.evt}
: 在拖拽操作期间，当鼠标光标移动到某个元素上时发送给该元素（与 mouseover 事件类似）。
* `mouse_x`：鼠标在上下文中的 x 位置。
* `mouse_y`：鼠标在上下文中的 y 位置。
* `drag_element`：正在被拖拽的元素。

`dragout`{:.evt}
: 在拖拽操作期间，当鼠标光标移出某个元素时发送给该元素（与 mouseout 事件类似）。
* `mouse_x`：鼠标在上下文中的 x 位置。
* `mouse_y`：鼠标在上下文中的 y 位置。
* `drag_element`：正在被拖拽的元素。

`dragmove`{:.evt}
: 在拖拽操作期间，当鼠标移动时，发送给鼠标悬停的最顶层元素（不包括被拖拽的元素）。
* `mouse_x`：鼠标在上下文中的 x 位置。
* `mouse_y`：鼠标在上下文中的 y 位置。
* `drag_element`：正在被拖拽的元素。

`dragdrop`{:.evt}
: 在拖拽操作结束时，发送给光标悬停在上方的元素。
* `mouse_x`：鼠标在上下文中的 x 位置。
* `mouse_y`：鼠标在上下文中的 y 位置。
* `drag_element`：正在被拖拽的元素。


#### 动画事件

`animationend`{:.evt}
: 当动画执行完毕时发送。
* `property`：已完成动画的属性的名称。

`transitionend`{:.evt}
: 当过渡执行完毕时发送。
* `property`：已完成过渡的属性的名称。

#### 表单事件

`submit`{:.evt}
: 当表单被提交时发送给表单。
* `parameters`：事件对象将为表单中的每个命名值包含一个属性。

#### 表单控件事件

`change`{:.evt}
: 当表单控件的值发生变化时发送给该控件。
  * `value`：新的值。

  此外，仅适用于复选框和单选按钮：
  * `checked`：元素新的布尔选中状态。

#### 文档事件

`load`{:.evt}
: 当文档初始加载时发送给文档。

`unload`{:.evt}
: 当文档被卸载时发送给文档。

#### 句柄事件

`handledrag`{:.evt}
: 当句柄被移动时发送给句柄。
* `handle_x`：句柄的 x 位置。
* `handle_y`：句柄的 y 位置。

#### 选项卡集事件

`tabchange`{:.evt}
: 当活动标签页被更改时发送给选项卡集。
* `tab_index`：新的标签页索引。
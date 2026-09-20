---
layout: page
title: Lua API 参考
parent: lua_manual
---

本参考中列出的大多数 Lua 类型、属性和函数都直接对应其 C++ API 中的等价物，建议用户查阅 [C++ 手册](../cpp_manual.html) 以获得更详细的描述。

所有可实例化的类都定义了一个 `new()` 函数，该函数返回该特定类的对象。除这个 `new()` 函数外，列出的所有成员都是成员函数。

#### 主要类型
- [Context](#Context)
- [Document](#Document)
- [Element](#Element)
- [Event](#Event)
- [rmlui](#rmlui)

#### 工具

- [Colourb](#Colourb)
- [Colourf](#Colourf)
- [ElementInstancer](#ElementInstancer)
- [ElementPtr](#ElementPtr)
- [GlobalLuaFunctions](#GlobalLuaFunctions)
- [Log](#Log)
- [Vector2f](#Vector2f)
- [Vector2i](#Vector2i)

#### 特殊元素

- [ElementForm](#ElementForm)
- [ElementFormControl](#ElementFormControl)
- [ElementFormControlInput](#ElementFormControlInput)
- [ElementFormControlSelect](#ElementFormControlSelect)
- [ElementFormControlTextArea](#ElementFormControlTextArea)
- [ElementTabSet](#ElementTabSet)
- [ElementText](#ElementText)

#### 枚举

- [DocumentFocus](#DocumentFocus)
- [DocumentModal](#DocumentModal)

#### 代理
- [ContextDocumentsProxy](#ContextDocumentsProxy)
- [ElementAttributesProxy](#ElementAttributesProxy)
- [ElementChildNodesProxy](#ElementChildNodesProxy)
- [ElementStyleProxy](#ElementStyleProxy)
- [EventParametersProxy](#EventParametersProxy)
- [RmlUiContextsProxy](#RmlUiContextsProxy)
- [SelectOptionsProxy](#SelectOptionsProxy)


---

### <a href='#Colourb' name='Colourb'>Colourb</a>

继承自：`nil`{: .lua-type }

构造一个具有四个通道的颜色，每个通道的取值范围为 0 到 255。

#### 属性

| 名称 | 类型 |
| ------------ | ---- |
| [alpha](#Colourb-alpha){: .lua-function } | `integer`{: .lua-type } |
| [blue](#Colourb-blue){: .lua-function } | `integer`{: .lua-type } |
| [green](#Colourb-green){: .lua-function } | `integer`{: .lua-type } |
| [red](#Colourb-red){: .lua-function } | `integer`{: .lua-type } |
| [rgba](#Colourb-rgba){: .lua-function } | `integer, integer, integer, integer`{: .lua-type } |


#### 函数

| 名称 | 返回类型 |
| ------------ | ---- |
| [new](#Colourb-new){: .lua-function }(`integer` red, `integer` green, `integer` blue, `integer` alpha) | `Colourb`{: .lua-type} |


#### 元函数

| 元函数 |
| ------------- |
| __add |
| __eq |
| __mul |


#### 属性说明

<a href='#Colourb-alpha' name='Colourb-alpha'>alpha</a>{: .lua-function }  :: `integer`{: .lua-type }
: Alpha 通道

<a href='#Colourb-blue' name='Colourb-blue'>blue</a>{: .lua-function }  :: `integer`{: .lua-type }
: 蓝色通道

<a href='#Colourb-green' name='Colourb-green'>green</a>{: .lua-function }  :: `integer`{: .lua-type }
: 绿色通道

<a href='#Colourb-red' name='Colourb-red'>red</a>{: .lua-function }  :: `integer`{: .lua-type }
: 红色通道

<a href='#Colourb-rgba' name='Colourb-rgba'>rgba</a>{: .lua-function }  :: `integer`{: .lua-type }, `integer`{: .lua-type }, `integer`{: .lua-type }, `integer`{: .lua-type }


#### 函数说明

<a href='#Colourb-new' name='Colourb-new'>new</a>{: .lua-function }(`integer` red, `integer` green, `integer` blue, `integer` alpha)  &rarr; `Colourb`{: .lua-type}
: 构造一个新的 `Colourb` 对象

---

### <a href='#Colourf' name='Colourf'>Colourf</a>

继承自：`nil`{: .lua-type }

构造一个具有四个浮点通道的颜色。

#### 属性

| 名称 | 类型 |
| ------------ | ---- |
| [alpha](#Colourf-alpha){: .lua-function } | `number`{: .lua-type } |
| [blue](#Colourf-blue){: .lua-function } | `number`{: .lua-type } |
| [green](#Colourf-green){: .lua-function } | `number`{: .lua-type } |
| [red](#Colourf-red){: .lua-function } | `number`{: .lua-type } |
| [rgba](#Colourf-rgba){: .lua-function } | `number, number, number, number`{: .lua-type } |


#### 函数

| 名称 | 返回类型 |
| ------------ | ---- |
| [new](#Colourf-new){: .lua-function }(`number` red, `number` green, `number` blue, `number` alpha) | `Colourf`{: .lua-type} |


#### 元函数

| 元函数 |
| ------------- |
| __eq |


#### 属性说明

<a href='#Colourf-alpha' name='Colourf-alpha'>alpha</a>{: .lua-function }  :: `number`{: .lua-type }
: Alpha 通道

<a href='#Colourf-blue' name='Colourf-blue'>blue</a>{: .lua-function }  :: `number`{: .lua-type }
: 蓝色通道

<a href='#Colourf-green' name='Colourf-green'>green</a>{: .lua-function }  :: `number`{: .lua-type }
: 绿色通道

<a href='#Colourf-red' name='Colourf-red'>red</a>{: .lua-function }  :: `number`{: .lua-type }
: 红色通道

<a href='#Colourf-rgba' name='Colourf-rgba'>rgba</a>{: .lua-function }  :: `number`{: .lua-type }, `number`{: .lua-type }, `number`{: .lua-type }, `number`{: .lua-type }


#### 函数说明

<a href='#Colourf-new' name='Colourf-new'>new</a>{: .lua-function }(`number` red, `number` green, `number` blue, `number` alpha)  &rarr; `Colourf`{: .lua-type}
: 构造一个新的 `Colourf` 对象。

---

### <a href='#Context' name='Context'>Context</a>

继承自：`nil`{: .lua-type }

Context 类没有构造函数；必须通过 `CreateContext()` 函数实例化。它具有以下函数和属性：

#### 属性

| 名称 | 类型 |
| ------------ | ---- |
| [dimensions](#Context-dimensions){: .lua-function } | `Vector2i`{: .lua-type } |
| [documents](#Context-documents){: .lua-function } | `ContextDocumentsProxy`{: .lua-type } |
| [dp_ratio](#Context-dp_ratio){: .lua-function } | `number`{: .lua-type } |
| [focus_element](#Context-focus_element){: .lua-function } | `Element`{: .lua-type } |
| [hover_element](#Context-hover_element){: .lua-function } | `Element`{: .lua-type } |
| [name](#Context-name){: .lua-function } | `string`{: .lua-type } |
| [root_element](#Context-root_element){: .lua-function } | `Element`{: .lua-type } |


#### 函数

| 名称 | 返回类型 |
| ------------ | ---- |
| [AddEventListener](#Context-AddEventListener){: .lua-function }(`string`{: .lua-type } event, `function, string`{: .lua-type } script, `Element`{: .lua-type } element_context, `boolean`{: .lua-type } in_capture_phase) | `nil`{: .lua-type } |
| [CreateDocument](#Context-CreateDocument){: .lua-function }(`string`{: .lua-type } tag) | `Document`{: .lua-type }<br> |
| [IsMouseInteracting](#Context-IsMouseInteracting){: .lua-function }() | `boolean`{: .lua-type }<br> |
| [LoadDocument](#Context-LoadDocument){: .lua-function }(`string`{: .lua-type } document_path) | `Document`{: .lua-type }<br> |
| [ProcessKeyDown](#Context-ProcessKeyDown){: .lua-function }(`integer`{: .lua-type } key_identifier, `integer`{: .lua-type } key_modifier_state) | `boolean`{: .lua-type } <br> |
| [ProcessKeyUp](#Context-ProcessKeyUp){: .lua-function }(`integer`{: .lua-type } key_identifier, `integer`{: .lua-type } key_modifier_state) | `boolean`{: .lua-type } <br> |
| [ProcessMouseButtonDown](#Context-ProcessMouseButtonDown){: .lua-function }( `integer`{: .lua-type } button_index, `integer`{: .lua-type } key_modifier_state) | `boolean`{: .lua-type } <br> |
| [ProcessMouseButtonUp](#Context-ProcessMouseButtonUp){: .lua-function }( `integer`{: .lua-type } button_index, `integer`{: .lua-type } key_modifier_state) | `boolean`{: .lua-type } <br> |
| [ProcessMouseLeave](#Context-ProcessMouseLeave){: .lua-function }() | `boolean`{: .lua-type }<br> |
| [ProcessMouseWheel](#Context-ProcessMouseWheel){: .lua-function }(`number`{: .lua-type} delta, `integer`{: .lua-type } key_modifier_state) | `boolean`{: .lua-type } <br> |
| [ProcessTextInput](#Context-ProcessTextInput){: .lua-function }(`string`{: .lua-type} `integer`{: .lua-type }  input) | `boolean`{: .lua-type } <br> |
| [Render](#Context-Render){: .lua-function }() | `boolean`{: .lua-type }<br> |
| [UnloadAllDocuments](#Context-UnloadAllDocuments){: .lua-function }() | `nil`{: .lua-type } |
| [UnloadDocument](#Context-UnloadDocument){: .lua-function }(`Document`{: .lua-type } document) | `nil`{: .lua-type } |
| [Update](#Context-Update){: .lua-function }() | `boolean`{: .lua-type }<br> |


#### 属性说明

<a href='#Context-dimensions' name='Context-dimensions'>dimensions</a>{: .lua-function }  :: `Vector2i`{: .lua-type }
: 上下文的尺寸，以 Vector2i 类型表示。

<a href='#Context-documents' name='Context-documents'>documents</a>{: .lua-function }  :: `ContextDocumentsProxy`{: .lua-type }
: 返回上下文中文档的数组。可以将其作为数组或字典查询。只读。

<a href='#Context-dp_ratio' name='Context-dp_ratio'>dp_ratio</a>{: .lua-function }  :: `number`{: .lua-type }
: 上下文的密度无关像素比。该值决定 'dp' 与 'px' 单位之间的比率。

<a href='#Context-focus_element' name='Context-focus_element'>focus_element</a>{: .lua-function }  :: `Element`{: .lua-type }
: 返回上下文焦点树的叶子节点。只读。

<a href='#Context-hover_element' name='Context-hover_element'>hover_element</a>{: .lua-function }  :: `Element`{: .lua-type }
: 返回上下文光标下方的元素。只读。

<a href='#Context-name' name='Context-name'>name</a>{: .lua-function }  :: `string`{: .lua-type }
: 上下文的名称，在构造时指定。只读。

<a href='#Context-root_element' name='Context-root_element'>root_element</a>{: .lua-function }  :: `Element`{: .lua-type }
: 返回上下文的根元素。只读。



#### 函数说明

<a href='#Context-AddEventListener' name='Context-AddEventListener'>AddEventListener</a>{: .lua-function }(`string`{: .lua-type } event, `function, string`{: .lua-type } script, `Element`{: .lua-type } element_context, `boolean`{: .lua-type } in_capture_phase)  &rarr; `nil`{: .lua-type}
: 将内联 Lua 脚本或 Lua 函数 `script` 作为事件监听器添加到上下文。`element_context` 是一个可选的 `Element`；如果它不为 `nil`，则脚本将像绑定到该元素一样执行。

<a href='#Context-CreateDocument' name='Context-CreateDocument'>CreateDocument</a>{: .lua-function }(`string`{: .lua-type } tag)  &rarr; `Document`{: .lua-type }
: 创建一个标签名为 `tag` 的新文档。

<a href='#Context-IsMouseInteracting' name='Context-IsMouseInteracting'>IsMouseInteracting</a>{: .lua-function }() &rarr; `boolean`{: .lua-type }
: 返回一个提示，指示鼠标当前是否正在与此上下文中的任何元素交互。

<a href='#Context-LoadDocument' name='Context-LoadDocument'>LoadDocument</a>{: .lua-function }(`string`{: .lua-type } document_path)  &rarr; `Document`{: .lua-type }
: 尝试从 `document_path` 处的 RML 文件加载文档。如果成功，将返回引用计数为 1 的文档。

<a href='#Context-ProcessKeyDown' name='Context-ProcessKeyDown'>ProcessKeyDown</a>{: .lua-function }(`integer`{: .lua-type } key_identifier, `integer`{: .lua-type } key_modifier_state) &rarr; `boolean`{: .lua-type }
: 向此上下文发送按键按下事件。`key_identifier` 是按下的按键，`key_modifier_state` 是事件发生时键盘修饰键的状态。如果事件已被消耗则返回 true，否则返回 false。

<a href='#Context-ProcessKeyUp' name='Context-ProcessKeyUp'>ProcessKeyUp</a>{: .lua-function }(`integer`{: .lua-type } key_identifier, `integer`{: .lua-type } key_modifier_state) &rarr; `boolean`{: .lua-type }
: 向此上下文发送按键释放事件。`key_identifier` 是释放的按键，`key_modifier_state` 是事件发生时键盘修饰键的状态。如果事件已被消耗则返回 true，否则返回 false。

<a href='#Context-ProcessMouseButtonDown' name='Context-ProcessMouseButtonDown'>ProcessMouseButtonDown</a>{: .lua-function }(`integer`{: .lua-type } button_index, `integer`{: .lua-type } key_modifier_state) &rarr; `boolean`{: .lua-type }
: 向此上下文发送鼠标按键按下事件。`button_index` 是被按下按键的索引（0 表示左键，1 表示右键，其他按键从 2 开始），`key_modifier_state` 是事件发生时键盘修饰键的状态。如果鼠标未与此上下文中的任何元素交互则返回 true，否则返回 false。

<a href='#Context-ProcessMouseButtonUp' name='Context-ProcessMouseButtonUp'>ProcessMouseButtonUp</a>{: .lua-function }(`integer`{: .lua-type } button_index, `integer`{: .lua-type } key_modifier_state) &rarr; `boolean`{: .lua-type }
: 向此上下文发送鼠标按键释放事件。`button_index` 是被释放按键的索引（0 表示左键，1 表示右键，其他按键从 2 开始），`key_modifier_state` 是事件发生时键盘修饰键的状态。如果鼠标未与此上下文中的任何元素交互则返回 true，否则返回 false。

<a href='#Context-ProcessMouseLeave' name='Context-ProcessMouseLeave'>ProcessMouseLeave</a>{: .lua-function }()  &rarr; `boolean`{: .lua-type }
: 通知上下文鼠标已离开窗口。如果鼠标未与此上下文中的任何元素交互则返回 true，否则返回 false。

<a href='#Context-ProcessMouseWheel' name='Context-ProcessMouseWheel'>ProcessMouseWheel</a>{: .lua-function }(`number`{: lua-type} delta, `integer`{: .lua-type } key_modifier_state) &rarr; `boolean`{: .lua-type }
: 向此上下文发送鼠标滚轮移动事件。`wheel_delta` 是这一帧的鼠标滚轮移动量，`key_modifier_state` 是事件发生时键盘修饰键的状态。如果事件未被消耗（即被元素阻止传播）则返回 true，如果被消耗则返回 false。

<a href='#Context-ProcessTextInput' name='Context-ProcessTextInput'>ProcessTextInput</a>{: lua-function }(`string`{: lua-type} `integer`{: .lua-type }  input) &rarr; `boolean`{: .lua-type }
: 向上下文中发送文本输入事件。如果 `input` 的类型是 `integer`，则发送单个按键事件；如果 `input` 是 `string`，则将该字符串作为文本输入事件发送。如果事件未被消耗（即被元素阻止传播）则返回 true，如果被消耗则返回 false。

<a href='#Context-Render' name='Context-Render'>Render</a>{: .lua-function }()  &rarr; `boolean`{: .lua-type }
: 渲染上下文。

<a href='#Context-UnloadAllDocuments' name='Context-UnloadAllDocuments'>UnloadAllDocuments</a>{: .lua-function }()  &rarr; `nil`{: .lua-type}
: 关闭当前随上下文加载的所有文档。

<a href='#Context-UnloadDocument' name='Context-UnloadDocument'>UnloadDocument</a>{: .lua-function }(`Document`{: .lua-type } document)  &rarr; `nil`{: .lua-type}
: 卸载上下文中的特定文档。

<a href='#Context-Update' name='Context-Update'>Update</a>{: .lua-function }()  &rarr; `boolean`{: .lua-type }
: 更新上下文。



---

### <a href='#ContextDocumentsProxy' name='ContextDocumentsProxy'>ContextDocumentsProxy</a>

继承自：`nil`{: .lua-type }

文档表，可以迭代，也可以通过整数或字符串索引。

#### 元函数

| 元函数 |
| ------------- |
| __index |
| __pairs |


---

### <a href='#DocumentFocus' name='DocumentFocus'>DocumentFocus</a>

继承自：`nil`{: .lua-type }

一种枚举类型，用作需要焦点选项的各种函数的参数。

#### 属性

| 名称 | 类型 |
| ------------ | ---- |
| [None](#DocumentFocus-None){: .lua-function } | `integer`{: .lua-type } |
| [Document](#DocumentFocus-Document){: .lua-function } | `integer`{: .lua-type } |
| [Keep](#DocumentFocus-Keep){: .lua-function } | `integer`{: .lua-type } |
| [Auto](#DocumentFocus-Auto){: .lua-function } | `integer`{: .lua-type } |

#### 属性说明

<a href='#DocumentFocus-None' name='DocumentFocus-None'>None</a>{: .lua-function }  :: `integer`{: .lua-type }
: 无焦点。

<a href='#DocumentFocus-Document' name='DocumentFocus-Document'>Document</a>{: .lua-function }  :: `integer`{: .lua-type }
: 文档焦点。

<a href='#DocumentFocus-Keep' name='DocumentFocus-Keep'>Keep</a>{: .lua-function }  :: `integer`{: .lua-type }
: 保持焦点。

<a href='#DocumentFocus-Auto' name='DocumentFocus-Auto'>Auto</a>{: .lua-function }  :: `integer`{: .lua-type }
: 自动焦点。

---

### <a href='#DocumentModal' name='DocumentModal'>DocumentModal</a>

继承自：`nil`{: .lua-type }

一种枚举类型，用作需要模态选项的各种函数的参数。

#### 属性

| 名称 | 类型 |
| ------------ | ---- |
| [None](#DocumentModal-None){: .lua-function } | `integer`{: .lua-type } |
| [Modal](#DocumentModal-Modal){: .lua-function } | `integer`{: .lua-type } |
| [Keep](#DocumentModal-Keep){: .lua-function } | `integer`{: .lua-type } |

#### 属性说明

<a href='#DocumentModal-None' name='DocumentModal-None'>None</a>{: .lua-function }  :: `integer`{: .lua-type }
: 无模态。

<a href='#DocumentModal-Modal' name='DocumentModal-Modal'>Modal</a>{: .lua-function }  :: `integer`{: .lua-type }
: 模态。

<a href='#DocumentModal-Keep' name='DocumentModal-Keep'>Keep</a>{: .lua-function }  :: `integer`{: .lua-type }
: 保持模态。

---

### <a href='#Document' name='Document'>Document</a>

继承自：`Element`{: .lua-type }

Document 派生自 Element。Document 没有构造函数；必须通过 Context 对象实例化，可以加载外部 RML 文件或创建空文档。它具有以下函数和属性：

#### 属性

| 名称 | 类型 |
| ------------ | ---- |
| [context](#Document-context){: .lua-function } | `Context`{: .lua-type } |
| [title](#Document-title){: .lua-function } | `string`{: .lua-type } |


#### 函数

| 名称 | 返回类型 |
| ------------ | ---- |
| [Close](#Document-Close){: .lua-function }() | `nil`{: .lua-type } |
| [CreateElement](#Document-CreateElement){: .lua-function }(`string`{: .lua-type } tag_name) | `ElementPtr`{: .lua-type }<br> |
| [CreateTextNode](#Document-CreateTextNode){: .lua-function }(`string`{: .lua-type } text) | `ElementPtr`{: .lua-type }<br> |
| [Hide](#Document-Hide){: .lua-function }() | `nil`{: .lua-type } |
| [PullToFront](#Document-PullToFront){: .lua-function }() | `nil`{: .lua-type } |
| [PushToBack](#Document-PushToBack){: .lua-function }() | `nil`{: .lua-type } |
| [Show](#Document-Show){: .lua-function }(`nil, DocumentModal`{: .lua-type } modal, `nil, DocumentFocus`{: .lua-type } focus) | `nil`{: .lua-type } |


#### 属性说明

<a href='#Document-context' name='Document-context'>context</a>{: .lua-function }  :: `Context`{: .lua-type }
: 文档所属的上下文。只读。

<a href='#Document-title' name='Document-title'>title</a>{: .lua-function }  :: `string`{: .lua-type }
: 文档的标题，由文档头部中的 \<title\> 标签初始设置。



#### 函数说明

<a href='#Document-Close' name='Document-Close'>Close</a>{: .lua-function }()  &rarr; `nil`{: .lua-type}
: 隐藏并关闭文档，销毁其内容。

<a href='#Document-CreateElement' name='Document-CreateElement'>CreateElement</a>{: .lua-function }(`string`{: .lua-type } tag_name)  &rarr; `ElementPtr`{: .lua-type }
: 实例化一个标签为 tag_name 的元素。

<a href='#Document-CreateTextNode' name='Document-CreateTextNode'>CreateTextNode</a>{: .lua-function }(`string`{: .lua-type } text)  &rarr; `ElementPtr`{: .lua-type }
: 实例化一个包含字符串 text 的文本元素。

<a href='#Document-Hide' name='Document-Hide'>Hide</a>{: .lua-function }()  &rarr; `nil`{: .lua-type}
: 隐藏文档。

<a href='#Document-PullToFront' name='Document-PullToFront'>PullToFront</a>{: .lua-function }()  &rarr; `nil`{: .lua-type}
: 将文档拉到其上下文内 z-index 相近的其他文档之前。

<a href='#Document-PushToBack' name='Document-PushToBack'>PushToBack</a>{: .lua-function }()  &rarr; `nil`{: .lua-type}
: 将文档推到其上下文内 z-index 相近的其他文档之后。

<a href='#Document-Show' name='Document-Show'>Show</a>{: .lua-function }(`nil, DocumentModal`{: .lua-type } modal, `nil, DocumentFocus`{: .lua-type } focus)  &rarr; `nil`{: .lua-type}
: 显示文档。可选的枚举参数用于指定模态和焦点模式。默认为 `DocumentModal.None` 和 `DocumentFocus.Auto`。



---

### <a href='#Element' name='Element'>Element</a>

继承自：`nil`{: .lua-type }

Element 类没有构造函数；必须通过 [Document](#document) 对象实例化。它具有以下函数和属性：

#### 属性

| 名称 | 类型 |
| ------------ | ---- |
| [attributes](#Element-attributes){: .lua-function } | `ElementAttributesProxy`{: .lua-type } |
| [child_nodes](#Element-child_nodes){: .lua-function } | `ElementChildNodesProxy`{: .lua-type } |
| [class_name](#Element-class_name){: .lua-function } | `string`{: .lua-type } |
| [client_height](#Element-client_height){: .lua-function } | `number`{: .lua-type } |
| [client_left](#Element-client_left){: .lua-function } | `number`{: .lua-type } |
| [client_top](#Element-client_top){: .lua-function } | `number`{: .lua-type } |
| [client_width](#Element-client_width){: .lua-function } | `number`{: .lua-type } |
| [first_child](#Element-first_child){: .lua-function } | `nil, Element`{: .lua-type } |
| [id](#Element-id){: .lua-function } | `string`{: .lua-type } |
| [inner_rml](#Element-inner_rml){: .lua-function } | `string`{: .lua-type } |
| [last_child](#Element-last_child){: .lua-function } | `nil, Element`{: .lua-type } |
| [next_sibling](#Element-next_sibling){: .lua-function } | `nil, Element`{: .lua-type } |
| [offset_height](#Element-offset_height){: .lua-function } | `number`{: .lua-type } |
| [offset_left](#Element-offset_left){: .lua-function } | `number`{: .lua-type } |
| [offset_parent](#Element-offset_parent){: .lua-function } | `Element`{: .lua-type } |
| [offset_top](#Element-offset_top){: .lua-function } | `number`{: .lua-type } |
| [offset_width](#Element-offset_width){: .lua-function } | `number`{: .lua-type } |
| [owner_document](#Element-owner_document){: .lua-function } | `Document`{: .lua-type } |
| [parent_node](#Element-parent_node){: .lua-function } | `nil, Element`{: .lua-type } |
| [previous_sibling](#Element-previous_sibling){: .lua-function } | `nil, Element`{: .lua-type } |
| [scroll_height](#Element-scroll_height){: .lua-function } | `number`{: .lua-type } |
| [scroll_left](#Element-scroll_left){: .lua-function } | `number`{: .lua-type } |
| [scroll_top](#Element-scroll_top){: .lua-function } | `number`{: .lua-type } |
| [scroll_width](#Element-scroll_width){: .lua-function } | `number`{: .lua-type } |
| [style](#Element-style){: .lua-function } | `ElementStyleProxy`{: .lua-type } |
| [tag_name](#Element-tag_name){: .lua-function } | `string`{: .lua-type } |


#### 函数

| 名称 | 返回类型 |
| ------------ | ---- |
| [AddEventListener](#Element-AddEventListener){: .lua-function }(`string`{: .lua-type } event, `function, string`{: .lua-type } listener, `boolean`{: .lua-type } in_capture_phase) | `nil`{: .lua-type } |
| [AppendChild](#Element-AppendChild){: .lua-function }(`ElementPtr`{: .lua-type } element) | `nil, Element`{: .lua-type } |
| [Blur](#Element-Blur){: .lua-function }() | `nil`{: .lua-type } |
| [Click](#Element-Click){: .lua-function }() | `nil`{: .lua-type } |
| [DispatchEvent](#Element-DispatchEvent){: .lua-function }(`string`{: .lua-type } event, `table`{: .lua-type } parameters) | `nil`{: .lua-type }<br> |
| [new](#Element-new){: .lua-function }(`string`{: .lua-type } tag) | `Element`{: .lua-type} |
| [Focus](#Element-Focus){: .lua-function }() | `nil`{: .lua-type } |
| [GetAttribute](#Element-GetAttribute){: .lua-function }(`string`{: .lua-type } name) | `Variant`{: .lua-type }<br> |
| [GetElementById](#Element-GetElementById){: .lua-function }(`string`{: .lua-type } id) | `Element`{: .lua-type }<br> |
| [GetElementsByTagName](#Element-GetElementsByTagName){: .lua-function }(`string`{: .lua-type } tag_name) | `table`{: .lua-type }<br> |
| [HasAttribute](#Element-HasAttribute){: .lua-function }(`string`{: .lua-type } name) | `boolean`{: .lua-type }<br> |
| [HasChildNodes](#Element-HasChildNodes){: .lua-function }() | `boolean`{: .lua-type }<br> |
| [InsertBefore](#Element-InsertBefore){: .lua-function }(`ElementPtr`{: .lua-type } element, `Element`{: .lua-type } adjacent_element) | `nil, Element`{: .lua-type } |
| [IsClassSet](#Element-IsClassSet){: .lua-function }(`string`{: .lua-type } name) | `boolean`{: .lua-type }<br> |
| [QuerySelector](#Element-QuerySelector){: .lua-function }(`string`{: .lua-type } selectors) | `Element`{: .lua-type }<br> |
| [QuerySelectorAll](#Element-QuerySelectorAll){: .lua-function }(`string`{: .lua-type } selectors) | `table`{: .lua-type }<br> |
| [Matches](#Element-Matches){: .lua-function }(`string`{: .lua-type } selectors) | `boolean`{: .lua-type }<br> |
| [RemoveAttribute](#Element-RemoveAttribute){: .lua-function }(`string`{: .lua-type } name) | `nil`{: .lua-type } |
| [RemoveChild](#Element-RemoveChild){: .lua-function }(`Element`{: .lua-type } element) | `boolean`{: .lua-type }<br> |
| [ReplaceChild](#Element-ReplaceChild){: .lua-function }(`ElementPtr`{: .lua-type } inserted_element, `Element`{: .lua-type } replaced_element) | `boolean`{: .lua-type }<br> |
| [ScrollIntoView](#Element-ScrollIntoView){: .lua-function }(`boolean`{: .lua-type } align_with_top) | `nil`{: .lua-type } |
| [SetAttribute](#Element-SetAttribute){: .lua-function }(`string`{: .lua-type } name, `string`{: .lua-type } value) | `nil`{: .lua-type } |
| [SetClass](#Element-SetClass){: .lua-function }(`string`{: .lua-type } name, `boolean`{: .lua-type } value) | `nil`{: .lua-type } |


#### 属性说明

<a href='#Element-attributes' name='Element-attributes'>attributes</a>{: .lua-function }  :: `ElementAttributesProxy`{: .lua-type }
: 元素上属性的数组。每个条目都具有只读属性 name 和 value。只读。

<a href='#Element-child_nodes' name='Element-child_nodes'>child_nodes</a>{: .lua-function }  :: `ElementChildNodesProxy`{: .lua-type }
: 元素上子节点的数组。只读。

<a href='#Element-class_name' name='Element-class_name'>class_name</a>{: .lua-function }  :: `string`{: .lua-type }
: 元素上以空格分隔的类列表。

<a href='#Element-client_height' name='Element-client_height'>client_height</a>{: .lua-function }  :: `number`{: .lua-type }
: 元素客户区的高度。只读。

<a href='#Element-client_left' name='Element-client_left'>client_left</a>{: .lua-function }  :: `number`{: .lua-type }
: 元素左边框边缘与左客户区边缘之间的距离。只读。

<a href='#Element-client_top' name='Element-client_top'>client_top</a>{: .lua-function }  :: `number`{: .lua-type }
: 元素上边框边缘与上客户区边缘之间的距离。只读。

<a href='#Element-client_width' name='Element-client_width'>client_width</a>{: .lua-function }  :: `number`{: .lua-type }
: 元素客户区的宽度。只读。

<a href='#Element-first_child' name='Element-first_child'>first_child</a>{: .lua-function }  :: `nil`{: .lua-type }, `Element`{: .lua-type }
: 元素的第一个子节点，如果元素没有子节点则为 `nil`。只读。

<a href='#Element-id' name='Element-id'>id</a>{: .lua-function }  :: `string`{: .lua-type }
: 元素的 ID，如果元素没有 ID 则为空字符串。

<a href='#Element-inner_rml' name='Element-inner_rml'>inner_rml</a>{: .lua-function }  :: `string`{: .lua-type }
: 元素的 RML 内容。

<a href='#Element-last_child' name='Element-last_child'>last_child</a>{: .lua-function }  :: `nil`{: .lua-type }, `Element`{: .lua-type }
: 元素的最后一个子节点，如果元素没有子节点则为 `nil`。只读。

<a href='#Element-next_sibling' name='Element-next_sibling'>next_sibling</a>{: .lua-function }  :: `nil`{: .lua-type }, `Element`{: .lua-type }
: 元素的下一个兄弟节点，如果它是最后一个兄弟节点则为 `nil`。只读。

<a href='#Element-offset_height' name='Element-offset_height'>offset_height</a>{: .lua-function }  :: `number`{: .lua-type }
: 元素的高度，不包括外边距（margin）。只读。

<a href='#Element-offset_left' name='Element-offset_left'>offset_left</a>{: .lua-function }  :: `number`{: .lua-type }
: 元素的 offset parent 左边框边缘与此元素左边框边缘之间的距离。只读。

<a href='#Element-offset_parent' name='Element-offset_parent'>offset_parent</a>{: .lua-function }  :: `Element`{: .lua-type }
: 元素的 offset parent。只读。

<a href='#Element-offset_top' name='Element-offset_top'>offset_top</a>{: .lua-function }  :: `number`{: .lua-type }
: 元素的 offset parent 上边框边缘与此元素上边框边缘之间的距离。只读。

<a href='#Element-offset_width' name='Element-offset_width'>offset_width</a>{: .lua-function }  :: `number`{: .lua-type }
: 元素的宽度，不包括外边距（margin）。只读。

<a href='#Element-owner_document' name='Element-owner_document'>owner_document</a>{: .lua-function }  :: `Document`{: .lua-type }
: 此元素所属的文档。只读。

<a href='#Element-parent_node' name='Element-parent_node'>parent_node</a>{: .lua-function }  :: `nil`{: .lua-type }, `Element`{: .lua-type }
: 直接作为此元素父节点的元素。只读。

<a href='#Element-previous_sibling' name='Element-previous_sibling'>previous_sibling</a>{: .lua-function }  :: `nil`{: .lua-type }, `Element`{: .lua-type }
: 元素的上一个兄弟节点，如果它是第一个兄弟节点则为 None。只读。

<a href='#Element-scroll_height' name='Element-scroll_height'>scroll_height</a>{: .lua-function }  :: `number`{: .lua-type }
: 此元素内容的高度。它至少与客户区高度相同。只读。

<a href='#Element-scroll_left' name='Element-scroll_left'>scroll_left</a>{: .lua-function }  :: `number`{: .lua-type }
: 此元素客户区左边缘与内容区左边缘之间的偏移。

<a href='#Element-scroll_top' name='Element-scroll_top'>scroll_top</a>{: .lua-function }  :: `number`{: .lua-type }
: 此元素客户区上边缘与内容区上边缘之间的偏移。

<a href='#Element-scroll_width' name='Element-scroll_width'>scroll_width</a>{: .lua-function }  :: `number`{: .lua-type }
: 此元素内容的宽度。它至少与客户区宽度相同。只读。

<a href='#Element-style' name='Element-style'>style</a>{: .lua-function }  :: `ElementStyleProxy`{: .lua-type }
: 用于访问此元素样式信息的对象。可以通过将属性名称作为对象本身的 Lua 属性来访问各个 RCSS 属性（例如 element.style.width = "40px"）。

<a href='#Element-tag_name' name='Element-tag_name'>tag_name</a>{: .lua-function }  :: `string`{: .lua-type }
: 用于实例化此元素的标签名。只读。



#### 函数说明

<a href='#Element-AddEventListener' name='Element-AddEventListener'>AddEventListener</a>{: .lua-function }(`string`{: .lua-type } event, `function, string`{: .lua-type } listener, `boolean`{: .lua-type } in_capture_phase)  &rarr; `nil`{: .lua-type}
: 注意：从 Lua 添加的事件无法移除。

<a href='#Element-AppendChild' name='Element-AppendChild'>AppendChild</a>{: .lua-function }(`ElementPtr`{: .lua-type } element)  &rarr; `nil, Element`{: .lua-type}
: 将 element 作为子节点追加到此元素。

<a href='#Element-Blur' name='Element-Blur'>Blur</a>{: .lua-function }()  &rarr; `nil`{: .lua-type}
: 从此元素移除输入焦点。

<a href='#Element-Click' name='Element-Click'>Click</a>{: .lua-function }()  &rarr; `nil`{: .lua-type}
: 模拟点击此元素。

<a href='#Element-DispatchEvent' name='Element-DispatchEvent'>DispatchEvent</a>{: .lua-function }(`string`{: .lua-type } event, `table`{: .lua-type } parameters)  &rarr; `nil`{: .lua-type }
: 向此元素派发一个事件。事件是事件类型的字符串值，*不带* 'on' 前缀。事件的参数在字典参数 parameters 中给出；字典只能包含字符串键，以及数字、字符串或布尔值。

<a href='#Element-new' name='Element-new'>new</a>{: .lua-function }(`string`{: .lua-type } tag)  &rarr; `Element`{: .lua-type}
: 构造一个新的 `Element` 对象。

<a href='#Element-Focus' name='Element-Focus'>Focus</a>{: .lua-function }()  &rarr; `nil`{: .lua-type}
: 将此元素设为输入焦点。

<a href='#Element-GetAttribute' name='Element-GetAttribute'>GetAttribute</a>{: .lua-function }(`string`{: .lua-type } name)  &rarr; `Variant`{: .lua-type }
: 返回名为 name 的属性的值。如果不存在该属性，则返回空字符串。

<a href='#Element-GetElementById' name='Element-GetElementById'>GetElementById</a>{: .lua-function }(`string`{: .lua-type } id)  &rarr; `Element`{: .lua-type }
: 从此元素的文档中返回具有给定 id 的元素。

<a href='#Element-GetElementsByTagName' name='Element-GetElementsByTagName'>GetElementsByTagName</a>{: .lua-function }(`string`{: .lua-type } tag_name)  &rarr; `table`{: .lua-type }
: 返回所有标签为 `tag_name` 的后代元素的列表。返回的表可以使用整数索引。

<a href='#Element-HasAttribute' name='Element-HasAttribute'>HasAttribute</a>{: .lua-function }(`string`{: .lua-type } name)  &rarr; `boolean`{: .lua-type }
: 如果元素具有名为 name 的属性的值，则返回 true，否则返回 false。

<a href='#Element-HasChildNodes' name='Element-HasChildNodes'>HasChildNodes</a>{: .lua-function }()  &rarr; `boolean`{: .lua-type }
: 如果元素至少有一个子节点，则返回 true，否则返回 false。

<a href='#Element-InsertBefore' name='Element-InsertBefore'>InsertBefore</a>{: .lua-function }(`ElementPtr`{: .lua-type } element, `Element`{: .lua-type } adjacent_element)  &rarr; `nil, Element`{: .lua-type}
: 将 element 作为此元素的子节点插入，位置在子节点列表中 adjacent_element 的正前方。

<a href='#Element-IsClassSet' name='Element-IsClassSet'>IsClassSet</a>{: .lua-function }(`string`{: .lua-type } name)  &rarr; `boolean`{: .lua-type }
: 如果元素上设置了该类名，则返回 true，否则返回 false。

<a href='#Element-QuerySelector' name='Element-QuerySelector'>QuerySelector</a>{: .lua-function }(`string`{: .lua-type } selectors)  &rarr; `Element`{: .lua-type }
: 返回与所提供的 RCSS 选择器匹配的第一个后代元素。

<a href='#Element-QuerySelectorAll' name='Element-QuerySelectorAll'>QuerySelectorAll</a>{: .lua-function }(`string`{: .lua-type } selectors)  &rarr; `table`{: .lua-type }
: 返回与所提供的 RCSS 选择器匹配的所有后代元素的集合。返回的表可以使用整数索引。

<a href='#Element-Matches' name='Element-Matches'>Matches</a>{: .lua-function }(`string`{: .lua-type } selectors)  &rarr; `boolean`{: .lua-type }
: 如果元素与所提供的 RCSS 选择器匹配，则返回 true，否则返回 false。

<a href='#Element-RemoveAttribute' name='Element-RemoveAttribute'>RemoveAttribute</a>{: .lua-function }(`string`{: .lua-type } name)  &rarr; `nil`{: .lua-type}
: 从元素中移除名为 name 的属性。

<a href='#Element-RemoveChild' name='Element-RemoveChild'>RemoveChild</a>{: .lua-function }(`Element`{: .lua-type } element)  &rarr; `boolean`{: .lua-type }
: 从此元素中移除子元素 element。

<a href='#Element-ReplaceChild' name='Element-ReplaceChild'>ReplaceChild</a>{: .lua-function }(`ElementPtr`{: .lua-type } inserted_element, `Element`{: .lua-type } replaced_element)  &rarr; `boolean`{: .lua-type }
: 在此元素的子节点列表中，用 `inserted_element` 替换子元素 replaced_element。如果 replaced_element 不是此元素的子节点，则将 `inserted_element` 追加到列表末尾。

<a href='#Element-ScrollIntoView' name='Element-ScrollIntoView'>ScrollIntoView</a>{: .lua-function }(`boolean`{: .lua-type } align_with_top)  &rarr; `nil`{: .lua-type}
: 如果此元素的祖先元素隐藏了溢出内容，则将元素滚动到可见区域。如果 `align_with_top` 为 true，则元素的顶部边缘将与祖先元素可视窗口的顶部（或尽可能接近顶部）对齐。如果为 false，则其底部边缘将与底部对齐。

<a href='#Element-SetAttribute' name='Element-SetAttribute'>SetAttribute</a>{: .lua-function }(`string`{: .lua-type } name, `string`{: .lua-type } value)  &rarr; `nil`{: .lua-type}
: 将名为 name 的属性的值设置为 value。

<a href='#Element-SetClass' name='Element-SetClass'>SetClass</a>{: .lua-function }(`string`{: .lua-type } name, `boolean`{: .lua-type } value)  &rarr; `nil`{: .lua-type}
: 在元素上设置（如果 value 为 true）或清除（如果 value 为 false）类名。



---

### <a href='#ElementAttributesProxy' name='ElementAttributesProxy'>ElementAttributesProxy</a>

继承自：`nil`{: .lua-type }



#### 元函数

| 元函数 |
| ------------- |
| __index |
| __pairs |


---

### <a href='#ElementChildNodesProxy' name='ElementChildNodesProxy'>ElementChildNodesProxy</a>

继承自：`nil`{: .lua-type }



#### 元函数

| 元函数 |
| ------------- |
| __index |
| __pairs |
| __len   |


---

### <a href='#ElementForm' name='ElementForm'>ElementForm</a>

继承自：`Element`{: .lua-type }

ElementForm 派生自 Element。表单元素具有以下函数：

#### 函数

| 名称 | 返回类型 |
| ------------ | ---- |
| [Submit](#ElementForm-Submit){: .lua-function }(`nil, string`{: .lua-type } name, `nil, string`{: .lua-type } submit_value) | `nil`{: .lua-type } |


#### 函数说明

<a href='#ElementForm-Submit' name='ElementForm-Submit'>Submit</a>{: .lua-function }(`nil, string`{: .lua-type } name, `nil, string`{: .lua-type } submit_value)  &rarr; `nil`{: .lua-type}
: 以 `name` 作为名称、`submit_value` 作为提交值提交表单。`name` 和 `value` 是可选的，默认为空。



---

### <a href='#ElementFormControl' name='ElementFormControl'>ElementFormControl</a>

继承自：`Element`{: .lua-type }



#### 属性

| 名称 | 类型 |
| ------------ | ---- |
| [disabled](#ElementFormControl-disabled){: .lua-function } | `boolean`{: .lua-type } |
| [name](#ElementFormControl-name){: .lua-function } | `string`{: .lua-type } |
| [value](#ElementFormControl-value){: .lua-function } | `string`{: .lua-type } |


#### 属性说明

<a href='#ElementFormControl-disabled' name='ElementFormControl-disabled'>disabled</a>{: .lua-function }  :: `boolean`{: .lua-type }


<a href='#ElementFormControl-name' name='ElementFormControl-name'>name</a>{: .lua-function }  :: `string`{: .lua-type }


<a href='#ElementFormControl-value' name='ElementFormControl-value'>value</a>{: .lua-function }  :: `string`{: .lua-type }


---

### <a href='#ElementFormControlInput' name='ElementFormControlInput'>ElementFormControlInput</a>

继承自：`ElementFormControl`{: .lua-type }

ElementFormControlInput 派生自 IElementFormControl。该控件具有以下属性，仅适用于相关类型：

#### 属性

| 名称 | 类型 |
| ------------ | ---- |
| [checked](#ElementFormControlInput-checked){: .lua-function } | `boolean`{: .lua-type } |
| [max](#ElementFormControlInput-max){: .lua-function } | `integer`{: .lua-type } |
| [maxlength](#ElementFormControlInput-maxlength){: .lua-function } | `integer`{: .lua-type } |
| [min](#ElementFormControlInput-min){: .lua-function } | `integer`{: .lua-type } |
| [size](#ElementFormControlInput-size){: .lua-function } | `integer`{: .lua-type } |
| [step](#ElementFormControlInput-step){: .lua-function } | `integer`{: .lua-type } |


#### 函数

| 名称 | 返回类型 |
| ------------ | ---- |
| [GetSelection](#ElementFormControlInput-GetSelection){: .lua-function }() | `integer, integer, string`{: .lua-type } |
| [Select](#ElementFormControlInput-Select){: .lua-function }() | `nil`{: .lua-type } |
| [SetSelection](#ElementFormControlInput-SetSelection){: .lua-function }(`integer`{: .lua-type } selection_start, `integer`{: .lua-type } selection_end) | `nil`{: .lua-type } |


#### 属性说明

<a href='#ElementFormControlInput-checked' name='ElementFormControlInput-checked'>checked</a>{: .lua-function }  :: `boolean`{: .lua-type }
: 适用于单选（radio）和复选框（checkbox）类型。输入的选中状态。

<a href='#ElementFormControlInput-max' name='ElementFormControlInput-max'>max</a>{: .lua-function }  :: `integer`{: .lua-type }
: 适用于范围（range）类型。滑块底部/右侧的控件值。

<a href='#ElementFormControlInput-maxlength' name='ElementFormControlInput-maxlength'>maxlength</a>{: .lua-function }  :: `integer`{: .lua-type }


<a href='#ElementFormControlInput-min' name='ElementFormControlInput-min'>min</a>{: .lua-function }  :: `integer`{: .lua-type }
: 适用于范围（range）类型。滑块顶部/左侧的控件值。

<a href='#ElementFormControlInput-size' name='ElementFormControlInput-size'>size</a>{: .lua-function }  :: `integer`{: .lua-type }
: 适用于文本（text）类型。文本字段水平方向一次显示的大致字符数。

<a href='#ElementFormControlInput-step' name='ElementFormControlInput-step'>step</a>{: .lua-function }  :: `integer`{: .lua-type }
: 适用于范围（range）类型。控件值变化的步长。


#### 函数说明

<a href='#ElementFormControlInput-GetSelection' name='ElementFormControlInput-GetSelection'>GetSelection</a>{: .lua-function }()  &rarr; `integer, integer, string`{: .lua-type }
: 获取选中范围和文本。如果没有选中文本，两个偏移量都等于 1。

<a href='#ElementFormControlInput-Select' name='ElementFormControlInput-Select'>Select</a>{: .lua-function }()  &rarr; `nil`{: .lua-type }
: 选中所有文本。

<a href='#ElementFormControlInput-SetSelection' name='ElementFormControlInput-SetSelection'>SetSelection</a>{: .lua-function }(`integer`{: .lua-type } selection_start, `integer`{: .lua-type } selection_end)  &rarr; `nil`{: .lua-type }
: 选中给定字符范围内的文本。


---

### <a href='#ElementFormControlSelect' name='ElementFormControlSelect'>ElementFormControlSelect</a>

继承自：`ElementFormControl`{: .lua-type }

ElementFormControlSelect 派生自 IElementFormControl。该控件具有以下函数和属性：

#### 属性

| 名称 | 类型 |
| ------------ | ---- |
| [options](#ElementFormControlSelect-options){: .lua-function } | `SelectOptionsProxy`{: .lua-type } |
| [selection](#ElementFormControlSelect-selection){: .lua-function } | `integer`{: .lua-type } |


#### 函数

| 名称 | 返回类型 |
| ------------ | ---- |
| [Add](#ElementFormControlSelect-Add){: .lua-function }(`string`{: .lua-type } rml, `string`{: .lua-type } value, `nil, integer`{: .lua-type } before) | `integer`{: .lua-type }<br> |
| [Remove](#ElementFormControlSelect-Remove){: .lua-function }(`integer`{: .lua-type } index) | `nil`{: .lua-type } |
| [RemoveAll](#ElementFormControlSelect-RemoveAll){: .lua-function }() | `nil`{: .lua-type } |


#### 属性说明

<a href='#ElementFormControlSelect-options' name='ElementFormControlSelect-options'>options</a>{: .lua-function }  :: `SelectOptionsProxy`{: .lua-type }
: 选择框中可用选项的数组。数组中的每个条目都具有属性 value（选项的字符串值）和 element（列表中表示该选项的元素层级根）。

<a href='#ElementFormControlSelect-selection' name='ElementFormControlSelect-selection'>selection</a>{: .lua-function }  :: `integer`{: .lua-type }
: 当前选中选项的索引。



#### 函数说明

<a href='#ElementFormControlSelect-Add' name='ElementFormControlSelect-Add'>Add</a>{: .lua-function }(`string`{: .lua-type } rml, `string`{: .lua-type } value, `nil, integer`{: .lua-type } before)  &rarr; `integer`{: .lua-type }
: 向选择框添加一个新选项。新选项的字符串值为 value，并由 RML 字符串 rml 创建的元素表示。新选项将插入到 before 指定的索引处；如果该索引越界（默认情况），则新选项将追加到列表末尾。将返回新选项的索引。

<a href='#ElementFormControlSelect-Remove' name='ElementFormControlSelect-Remove'>Remove</a>{: .lua-function }(`integer`{: .lua-type } index)  &rarr; `nil`{: .lua-type}
: 从选择框中移除一个现有选项。

<a href='#ElementFormControlSelect-RemoveAll' name='ElementFormControlSelect-RemoveAll'>RemoveAll</a>{: .lua-function }()  &rarr; `nil`{: .lua-type}


---

### <a href='#ElementFormControlTextArea' name='ElementFormControlTextArea'>ElementFormControlTextArea</a>

继承自：`ElementFormControl`{: .lua-type }

ElementFormControlTextArea 派生自 IElementFormControl。该控件具有以下属性：

#### 属性

| 名称 | 类型 |
| ------------ | ---- |
| [cols](#ElementFormControlTextArea-cols){: .lua-function } | `integer`{: .lua-type } |
| [maxlength](#ElementFormControlTextArea-maxlength){: .lua-function } | `integer`{: .lua-type } |
| [rows](#ElementFormControlTextArea-rows){: .lua-function } | `integer`{: .lua-type } |
| [wordwrap](#ElementFormControlTextArea-wordwrap){: .lua-function } | `boolean`{: .lua-type } |


#### 函数

| 名称 | 返回类型 |
| ------------ | ---- |
| [GetSelection](#ElementFormControlTextArea-GetSelection){: .lua-function }() | `integer, integer, string`{: .lua-type } |
| [Select](#ElementFormControlTextArea-Select){: .lua-function }() | `nil`{: .lua-type } |
| [SetSelection](#ElementFormControlTextArea-SetSelection){: .lua-function }(`integer`{: .lua-type } selection_start, `integer`{: .lua-type } selection_end) | `nil`{: .lua-type } |


#### 属性说明

<a href='#ElementFormControlTextArea-cols' name='ElementFormControlTextArea-cols'>cols</a>{: .lua-function }  :: `integer`{: .lua-type }
: 文本区域水平方向一次显示的大致字符数。

<a href='#ElementFormControlTextArea-maxlength' name='ElementFormControlTextArea-maxlength'>maxlength</a>{: .lua-function }  :: `integer`{: .lua-type }


<a href='#ElementFormControlTextArea-rows' name='ElementFormControlTextArea-rows'>rows</a>{: .lua-function }  :: `integer`{: .lua-type }
: 文本区域一次显示的行数。

<a href='#ElementFormControlTextArea-wordwrap' name='ElementFormControlTextArea-wordwrap'>wordwrap</a>{: .lua-function }  :: `boolean`{: .lua-type }


#### 函数说明

<a href='#ElementFormControlTextArea-GetSelection' name='ElementFormControlTextArea-GetSelection'>GetSelection</a>{: .lua-function }()  &rarr; `integer, integer, string`{: .lua-type }
: 获取选中范围和文本。如果没有选中文本，两个偏移量都等于 1。

<a href='#ElementFormControlTextArea-Select' name='ElementFormControlTextArea-Select'>Select</a>{: .lua-function }()  &rarr; `nil`{: .lua-type }
: 选中所有文本。

<a href='#ElementFormControlTextArea-SetSelection' name='ElementFormControlTextArea-SetSelection'>SetSelection</a>{: .lua-function }(`integer`{: .lua-type } selection_start, `integer`{: .lua-type } selection_end)  &rarr; `nil`{: .lua-type }
: 选中给定字符范围内的文本。


---

### <a href='#ElementInstancer' name='ElementInstancer'>ElementInstancer</a>

继承自：`nil`{: .lua-type }



#### 函数

| 名称 | 返回类型 |
| ------------ | ---- |
| [new](#ElementInstancer-new){: .lua-function }() | `ElementInstancer`{: .lua-type} |
| [InstanceElement](#ElementInstancer-InstanceElement){: .lua-function }(`ElementInstancer`{: .lua-type } ) | `value`{: .lua-type }<br> |


#### 函数说明

<a href='#ElementInstancer-new' name='ElementInstancer-new'>new</a>{: .lua-function }()  &rarr; `ElementInstancer`{: .lua-type}


<a href='#ElementInstancer-InstanceElement' name='ElementInstancer-InstanceElement'>InstanceElement</a>{: .lua-function }(`ElementInstancer`{: .lua-type } )  &rarr; `value`{: .lua-type }


---

### <a href='#ElementPtr' name='ElementPtr'>ElementPtr</a>

继承自：`nil`{: .lua-type }

表示一个被拥有的元素。此类型主要用于通过将对象传递给其他元素来修改 DOM 树。例如 [Element.AppendChild()](#Element-AppendChild)。

Lua 插件目前的一个限制是，`Element`{: .lua-type } 的成员属性和函数不能直接用于此类型。


---

### <a href='#ElementStyleProxy' name='ElementStyleProxy'>ElementStyleProxy</a>

继承自：`nil`{: .lua-type }



#### 元函数

| 元函数 |
| ------------- |
| __index |
| __newindex |
| __pairs |


---

### <a href='#ElementTabSet' name='ElementTabSet'>ElementTabSet</a>

继承自：`Element`{: .lua-type }

ElementTabSet 派生自 Element。该控件具有以下函数和属性：

#### 属性

| 名称 | 类型 |
| ------------ | ---- |
| [active_tab](#ElementTabSet-active_tab){: .lua-function } | `integer`{: .lua-type } |
| [num_tabs](#ElementTabSet-num_tabs){: .lua-function } | `integer`{: .lua-type } |


#### 函数

| 名称 | 返回类型 |
| ------------ | ---- |
| [SetPanel](#ElementTabSet-SetPanel){: .lua-function }(`integer`{: .lua-type } index, `string`{: .lua-type } rml) | `nil`{: .lua-type } |
| [SetTab](#ElementTabSet-SetTab){: .lua-function }(`integer`{: .lua-type } index, `string`{: .lua-type } rml) | `nil`{: .lua-type } |


#### 属性说明

<a href='#ElementTabSet-active_tab' name='ElementTabSet-active_tab'>active_tab</a>{: .lua-function }  :: `integer`{: .lua-type }
: 活动面板的索引。

<a href='#ElementTabSet-num_tabs' name='ElementTabSet-num_tabs'>num_tabs</a>{: .lua-function }  :: `integer`{: .lua-type }
: 选项卡集合中选项卡的数量。只读。



#### 函数说明

<a href='#ElementTabSet-SetPanel' name='ElementTabSet-SetPanel'>SetPanel</a>{: .lua-function }(`integer`{: .lua-type } index, `string`{: .lua-type } rml)  &rarr; `nil`{: .lua-type}
: 将面板的内容设置为 RML 内容 rml。如果 index 越界，将在末尾添加一个新面板。

<a href='#ElementTabSet-SetTab' name='ElementTabSet-SetTab'>SetTab</a>{: .lua-function }(`integer`{: .lua-type } index, `string`{: .lua-type } rml)  &rarr; `nil`{: .lua-type}
: 将选项卡的内容设置为 RML 内容 rml。如果 index 越界，将在末尾添加一个新选项卡。



---

### <a href='#ElementText' name='ElementText'>ElementText</a>

继承自：`Element`{: .lua-type }



#### 属性

| 名称 | 类型 |
| ------------ | ---- |
| [text](#ElementText-text){: .lua-function } | `string`{: .lua-type } |


#### 属性说明

<a href='#ElementText-text' name='ElementText-text'>text</a>{: .lua-function }  :: `string`{: .lua-type }


---

### <a href='#Event' name='Event'>Event</a>

继承自：`nil`{: .lua-type }

Event 类没有构造函数；它由内部生成。它具有以下函数和属性：

#### 属性

| 名称 | 类型 |
| ------------ | ---- |
| [current_element](#Event-current_element){: .lua-function } | `Element`{: .lua-type } |
| [parameters](#Event-parameters){: .lua-function } | `EventParametersProxy`{: .lua-type } |
| [target_element](#Event-target_element){: .lua-function } | `Element`{: .lua-type } |
| [type](#Event-type){: .lua-function } | `string`{: .lua-type } |


#### 函数

| 名称 | 返回类型 |
| ------------ | ---- |
| [StopPropagation](#Event-StopPropagation){: .lua-function }() | `nil`{: .lua-type } |
| [StopImmediatePropagation](#Event-StopImmediatePropagation){: .lua-function }() | `nil`{: .lua-type } |


#### 属性说明

<a href='#Event-current_element' name='Event-current_element'>current_element</a>{: .lua-function }  :: `Element`{: .lua-type }
: 事件传播到的元素。只读。

<a href='#Event-parameters' name='Event-parameters'>parameters</a>{: .lua-function }  :: `EventParametersProxy`{: .lua-type }
: 一个类似字典的对象，包含事件中的所有参数。

<a href='#Event-target_element' name='Event-target_element'>target_element</a>{: .lua-function }  :: `Element`{: .lua-type }
: 事件最初针对的元素。只读。

<a href='#Event-type' name='Event-type'>type</a>{: .lua-function }  :: `string`{: .lua-type }
: 事件的字符串名称。只读。



#### 函数说明

<a href='#Event-StopPropagation' name='Event-StopPropagation'>StopPropagation</a>{: .lua-function }()  &rarr; `nil`{: .lua-type}
: 如果允许，则停止事件在事件循环中的传播。

<a href='#Event-StopImmediatePropagation' name='Event-StopImmediatePropagation'>StopImmediatePropagation</a>{: .lua-function }()  &rarr; `nil`{: .lua-type}
: 停止事件在事件循环中的传播，包括停止传播到当前元素上的任何其他监听器。



---

### <a href='#EventParametersProxy' name='EventParametersProxy'>EventParametersProxy</a>

继承自：`nil`{: .lua-type }



#### 元函数

| 元函数 |
| ------------- |
| __index |
| __pairs |


---

### <a href='#GlobalLuaFunctions' name='GlobalLuaFunctions'>GlobalLuaFunctions</a>

继承自：`nil`{: .lua-type }

#### 函数

| 名称 | 返回类型 |
| ------------ | ---- |
| [print](#GlobalLuaFunctions-print){: .lua-function }(`...` output) | `nil`{: .lua-type } |

#### 函数说明

<a href='#GlobalLuaFunctions-print' name='GlobalLuaFunctions-print'>print</a>{: .lua-function }(`...` output)  &rarr; `nil`{: .lua-type}
: 覆盖 Lua 的 print 方法，并将其重定向到 RmlUi 日志系统，该系统例如可以通过 RmlUi 调试器访问。

---

### <a href='#Log' name='Log'>Log</a>

继承自：`nil`{: .lua-type }

通过 RmlUi 记录消息。

#### 属性

| 名称 | 类型 |
| ------------ | ---- |
| [logtype](#Log-logtype){: .lua-function } | `table`{: .lua-type } |

#### 函数

| 名称 | 返回类型 |
| ------------ | ---- |
| [Message](#Log-Message){: .lua-function }(`Log.logtype`{: .lua-type } type, `string`{: .lua-type } str) | `nil`{: .lua-type } |


#### 属性说明

<a href='#Log-logtype' name='Log-logtype'>logtype</a>{: .lua-function }  :: `table`{: .lua-type }
: 用于指定日志类型的枚举表。

* `Log.logtype.always`
* `Log.logtype.error`
* `Log.logtype.warning`
* `Log.logtype.info`
* `Log.logtype.debug`

#### 函数说明

<a href='#Log-Message' name='Log-Message'>Message</a>{: .lua-function }(`Log.logtype`{: .lua-type } type, `string`{: .lua-type } str)  &rarr; `nil`{: .lua-type}
: 以指定类型记录一条消息。

---

### <a href='#rmlui' name='rmlui'>rmlui</a>

继承自：`nil`{: .lua-type }

`rmlui` 在 Lua 中全局暴露了一些常用的 RmlUi 功能。通过全局表 `rmlui` 访问。

#### 属性

| 名称 | 类型 |
| ------------ | ---- |
| [contexts](#LuaRmlUi-contexts){: .lua-function } | `RmlUiContextsProxy`{: .lua-type } |
| [key_identifier](#LuaRmlUi-key_identifier){: .lua-function } | `table`{: .lua-type } |
| [key_modifier](#LuaRmlUi-key_modifier){: .lua-function } | `table`{: .lua-type } |


#### 函数

| 名称 | 返回类型 |
| ------------ | ---- |
| [CreateContext](#LuaRmlUi-CreateContext){: .lua-function }(`string`{: .lua-type } name, `Vector2i`{: .lua-type } dimensions) | `nil`{: .lua-type }<br>`Context`{: .lua-type }<br> |
| [LoadFontFace](#LuaRmlUi-LoadFontFace){: .lua-function }(`string`{: .lua-type } path, `boolean`{: .lua-type } fallback, `integer`{: .lua-type } face_index) | `boolean`{: .lua-type }<br> |
| [RegisterTag](#LuaRmlUi-RegisterTag){: .lua-function }(`string`{: .lua-type } tag) | `nil`{: .lua-type } |


#### 属性说明

<a href='#LuaRmlUi-contexts' name='LuaRmlUi-contexts'>contexts</a>{: .lua-function }  :: `RmlUiContextsProxy`{: .lua-type }
: 活动上下文的表，可以使用整数和上下文名称字符串索引。

<a href='#LuaRmlUi-key_identifier' name='LuaRmlUi-key_identifier'>key_identifier</a>{: .lua-function }  :: `table`{: .lua-type }
: 包含所有输入按键标识符的枚举。

<a href='#LuaRmlUi-key_modifier' name='LuaRmlUi-key_modifier'>key_modifier</a>{: .lua-function }  :: `table`{: .lua-type }
: 包含所有输入按键修饰键的枚举。

#### 函数说明

<a href='#LuaRmlUi-CreateContext' name='LuaRmlUi-CreateContext'>CreateContext</a>{: .lua-function }(`string`{: .lua-type } name, `Vector2i`{: .lua-type } dimensions)  &rarr; `Context`{: .lua-type }, `Context`{: .lua-type }
: 使用指定的 `dimensions` 创建 RmlUi 上下文。

<a href='#LuaRmlUi-LoadFontFace' name='LuaRmlUi-LoadFontFace'>LoadFontFace</a>{: .lua-function }(`string`{: .lua-type } path, `boolean`{: .lua-type } fallback, `integer`{: .lua-type } face_index)  &rarr; `boolean`{: .lua-type }
: 加载位于 `path` 的字体面。使用 `fallback` 选项使给定字体面用于其他字体中的任何未知字符。可选的 `face_index` 参数允许在字体集合中选择字体面。

<a href='#LuaRmlUi-RegisterTag' name='LuaRmlUi-RegisterTag'>RegisterTag</a>{: .lua-function }(`string`{: .lua-type } tag)  &rarr; `nil`{: .lua-type}
: 将标签注册到元素实例化器。

---

### <a href='#RmlUiContextsProxy' name='RmlUiContextsProxy'>RmlUiContextsProxy</a>

继承自：`nil`{: .lua-type }



#### 元函数

| 元函数 |
| ------------- |
| __index |
| __pairs |


---

### <a href='#SelectOptionsProxy' name='SelectOptionsProxy'>SelectOptionsProxy</a>

继承自：`nil`{: .lua-type }



#### 元函数

| 元函数 |
| ------------- |
| __index |
| __pairs |


---

### <a href='#Vector2f' name='Vector2f'>Vector2f</a>

继承自：`nil`{: .lua-type }

构造一个二维浮点向量。

#### 属性

| 名称 | 类型 |
| ------------ | ---- |
| [magnitude](#Vector2f-magnitude){: .lua-function } | `number`{: .lua-type } |
| [x](#Vector2f-x){: .lua-function } | `number`{: .lua-type } |
| [y](#Vector2f-y){: .lua-function } | `number`{: .lua-type } |


#### 函数

| 名称 | 返回类型 |
| ------------ | ---- |
| [DotProduct](#Vector2f-DotProduct){: .lua-function }(`Vector2f`{: .lua-type } other) | `number`{: .lua-type }<br> |
| [Normalise](#Vector2f-Normalise){: .lua-function }() | `Vector2f`{: .lua-type }<br> |
| [Rotate](#Vector2f-Rotate){: .lua-function }(`number`{: .lua-type } angle) | `Vector2f`{: .lua-type }<br> |
| [new](#Vector2f-new){: .lua-function }(`number`{: .lua-type } x, `number`{: .lua-type } y) | `Vector2f`{: .lua-type} |


#### 元函数

| 元函数 |
| ------------- |
| __add |
| __div |
| __eq |
| __mul |
| __sub |


#### 属性说明

<a href='#Vector2f-magnitude' name='Vector2f-magnitude'>magnitude</a>{: .lua-function }  :: `number`{: .lua-type }


<a href='#Vector2f-x' name='Vector2f-x'>x</a>{: .lua-function }  :: `number`{: .lua-type }


<a href='#Vector2f-y' name='Vector2f-y'>y</a>{: .lua-function }  :: `number`{: .lua-type }


#### 函数说明

<a href='#Vector2f-DotProduct' name='Vector2f-DotProduct'>DotProduct</a>{: .lua-function }(`Vector2f`{: .lua-type } other)  &rarr; `number`{: .lua-type }


<a href='#Vector2f-Normalise' name='Vector2f-Normalise'>Normalise</a>{: .lua-function }()  &rarr; `Vector2f`{: .lua-type }


<a href='#Vector2f-Rotate' name='Vector2f-Rotate'>Rotate</a>{: .lua-function }(`number`{: .lua-type } angle)  &rarr; `Vector2f`{: .lua-type }


<a href='#Vector2f-new' name='Vector2f-new'>new</a>{: .lua-function }(`number`{: .lua-type } x, `number`{: .lua-type } y)  &rarr; `Vector2f`{: .lua-type}


---

### <a href='#Vector2i' name='Vector2i'>Vector2i</a>

继承自：`nil`{: .lua-type }

构造一个二维整数向量。

#### 属性

| 名称 | 类型 |
| ------------ | ---- |
| [magnitude](#Vector2i-magnitude){: .lua-function } | `number`{: .lua-type } |
| [x](#Vector2i-x){: .lua-function } | `integer`{: .lua-type } |
| [y](#Vector2i-y){: .lua-function } | `integer`{: .lua-type } |


#### 函数

| 名称 | 返回类型 |
| ------------ | ---- |
| [new](#Vector2i-new){: .lua-function }(`integer`{: .lua-type } x, `integer`{: .lua-type } y) | `Vector2i`{: .lua-type} |


#### 元函数

| 元函数 |
| ------------- |
| __add |
| __div |
| __eq |
| __mul |
| __sub |


#### 属性说明

<a href='#Vector2i-magnitude' name='Vector2i-magnitude'>magnitude</a>{: .lua-function }  :: `number`{: .lua-type }


<a href='#Vector2i-x' name='Vector2i-x'>x</a>{: .lua-function }  :: `integer`{: .lua-type }


<a href='#Vector2i-y' name='Vector2i-y'>y</a>{: .lua-function }  :: `integer`{: .lua-type }


#### 函数说明

<a href='#Vector2i-new' name='Vector2i-new'>new</a>{: .lua-function }(`integer`{: .lua-type } x, `integer`{: .lua-type } y)  &rarr; `Vector2i`{: .lua-type}


---
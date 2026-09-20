---
layout: page
title: 元素
parent: rml
next: documents
---

RmlUi 除了内置的[元素类型](element_index.html)之外，对 XML 元素没有预先了解。

解析标签时，RmlUi 会查找与该标签名称关联的自定义元素，找不到时则回退到通用元素。所需的自定义元素很少，因为 RmlUi 的绝大部分能力来自使用 [RCSS](../rcss.html) 为元素设置样式，从而产生所需的布局。

我们鼓励用户尽可能遵循标准 HTML 规范，以提高社区间的可读性。有关将 RmlUi 设置为模拟 HTML4 的更多信息，请参阅[附录：HTML4 样式表](html4_style_sheet.html)。

### 全局属性

元素有一组所有类型通用的基础属性，如下所示：

`id`{:.attr} = id (CS)
: 元素在此文档中的唯一标识符。

`class`{:.attr} = cdata (CI)
: 为元素分配一个类名或一组类名。任意数量的元素都可以分配相同的类名或类名组。多个类名必须以空白字符分隔。参见 [RCSS](../rcss.html)。

`style`{:.attr} = cdata (CS)
: 为元素指定内联样式信息。参见 [RCSS](../rcss.html)。

`lang`{:.attr} = language-code (CI)
: 指定元素文本的语言。该值会传递给字体引擎，以辅助文本整形。子元素会继承该属性。

`dir`{:.attr} = ltr | rtl | auto (CS)
: 指定元素文本的流动方向。该值会传递给字体引擎，以辅助文本整形。子元素会继承该属性。与 HTML 不同，该属性区分大小写，且不影响文档布局。

`on*`{:.attr} 事件 = cdata (CS)
: 事件绑定。参见[事件](events.html)。

`data-*`{:.attr} 数据绑定 = cdata (CS)
: 表示[数据绑定](../data_bindings.html)的视图与控制器。
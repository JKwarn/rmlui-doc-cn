---
layout: page
title: RML 数据展示元素
parent: rml
next: element_index
---

另请参阅[数据绑定](../data_bindings.html)，了解如何从客户端应用程序动态显示和更新数据。

### \<progress\>

`<progress>`{:.tag} 元素可以显示进度条和仪表。详细说明与样式信息请参阅 C++ 手册中的 [progress 元素]({{"pages/cpp_manual/element_packages/progress_bar.html"|relative_url}})。

_属性_

`value`{:.attr} = number (CN)
: 介于 `0` 和 `max` 之间的数字，表示 progress 元素被填充的比例，其中 `max` 表示完全填满。

`max`{:.attr} = number (CN)
: 表示最大值的正数，默认为 `1`。

`direction`{:.attr} = cdata (CI)
: 进度条随值增大而扩展的方向。必须为以下之一：
* `top`{:.value}
* `right`{:.value}（默认）
* `bottom`{:.value}
* `left`{:.value}
* `clockwise`{:.value}
* `counter-clockwise`{:.value}

`start-edge`{:.attr} = cdata (CI)
: 仅适用于 `clockwise`{:.value} 或 `counter-clockwise`{:.value} 方向。定义圆开始扩展的边。必须为以下之一：
* `top`{:.value}（默认）
* `right`{:.value}
* `bottom`{:.value}
* `left`{:.value}
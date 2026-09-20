---
layout: page
title: RML 控件
parent: rml
next: data_display
---

### \<handle\>

`<handle>`{:.tag} 元素可用于移动元素或改变元素的大小。

_属性_

`move_target`{:.attr} = idref (CI)
: 如果指定了该属性，则拖动句柄时，句柄将移动由该 ID 指定的元素。可以设为 `#document`{:.value} 以引用当前文档，或设为 `#parent`{:.value} 以引用父元素。

`size_target`{:.attr} = idref (CI)
: 如果指定了该属性，则拖动句柄时，句柄将调整由该 ID 指定的元素的尺寸。可以设为 `#document`{:.value} 以引用当前文档，或设为 `#parent`{:.value} 以引用父元素。

`edge_margin`{:.attr} = \<length-percentage\>{1-4} | none
: 将目标的放置约束在其包含块的边缘。该属性可以接受任意长度或百分比，用于指定目标与其包含块边缘之间的最小距离。无论在位置目标还是尺寸目标上，拖动句柄时这些约束都会得到满足。\
默认情况下，该值为 `0px`，这意味着句柄目标将被严格约束在包含块的边缘。该值也可以由最多四个以空格分隔的值（按盒顺序：上/右/下/左）指定，以确定到各边的最小距离。允许使用负值，这样可以移动到包含块边缘之外。百分比将相对于目标元素的尺寸进行解析。可以使用 `none`{:.value} 值移除所有约束。

在拖动过程中，句柄元素将首先考虑目标元素的 inset 属性组合（`top`{:.prop}、`right`{:.prop}、`bottom`{:.prop}、`left`{:.prop}）与尺寸属性（`width`{:.prop}、`height`{:.prop}）。然后，它会调整上述必要的属性，以根据拖动增量移动目标元素或调整其尺寸，同时保留该元素所锚定的边。这样，即使句柄更改了目标元素的位置，当容器调整大小时，目标元素仍然可以自动调整大小。

```html
<div id="bucket">Bucket</div>
<handle move_target="bucket">Drag to move the bucket.</handle>
```

```html
<handle move_target="#document">
	<div id="title">My document</div>
</handle>
```

```html
<div class="help_box">
	<handle size_target="#parent" edge_margin="20px 30px"/>
</div>
```

```html
<handle class="drag_icon" move_target="#self" edge_margin="-50%"/>
```


### \<tabset\>

`<tabset>`{:.tag} 元素包含 `<tab>`{:.tag} 元素和 `<panel>`{:.tag} 元素。

另请参阅 C++ 手册中的[选项卡集文档]({{"pages/cpp_manual/element_packages/tab_set.html"|relative_url}})。

#### \<tab\>

每个 `<tab>`{:.tag} 元素都充当一个按钮，点击后会隐藏当前可见的面板，并显示其对应的面板。

#### \<panel\>

`<panel>`{:.tag} 元素是选项卡集的主体。面板的可见性由父选项卡集中的 tab 元素控制。
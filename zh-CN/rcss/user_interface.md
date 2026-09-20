---
layout: page
title: 用户界面
parent: rcss
next: flexboxes
---

### 鼠标光标：'cursor' 属性
{:#cursor}

`cursor`{:.prop}

取值： | \<string\>
初始值： | *空*
适用于： | 所有元素
继承： | 是
百分比： | 不适用

此属性定义鼠标悬停在元素上时显示的光标。如果元素的[上下文](../cpp_manual/contexts.html#mouse-cursor)设置为启用光标，则该值会直接通过[系统接口](../cpp_manual/interfaces/system.html)提交。

### 插入符颜色
{:#caret-color}

`caret-color`{:.prop}

取值： | auto \| \<colour\>
初始值： | auto
适用于： | 所有元素
继承： | 是
百分比： | 不适用

此属性设置文本输入光标（即指示下一个字符将被插入位置的标记）的颜色。可用于 `<input>`{:.tag} 和 `<textarea>`{:.tag} 元素等文本字段。`auto`{:.value} 值表示插入符颜色将使用元素的 `color`{:.prop} 属性。

### 盒尺寸
{:#box-sizing}

`box-sizing`{:.prop}

取值： | content-box \| border-box
初始值： | content-box
适用于： | 块级元素和可替换行内元素
继承： | 否
百分比： | 不适用

决定宽度和高度如何计算。

`content-box`{:.value}
: 这是正常行为。`width`{:.prop} 和 `height`{:.prop} 属性设置*内容盒（content box）*的大小。

`border-box`{:.value}
: `width`{:.prop} 和 `height`{:.prop} 属性设置*边框盒（border box）*的大小。这包括内容、内边距和边框，但不包括外边距。内容盒的大小通过减去内边距和边框大小来计算，然后以零为下限。

将值设置为 `border-box`{:.value} 对于布局适合放在一行上的元素很有价值，尤其是在组合使用百分比和长度作为宽度或高度、内边距和边框时。例如，如果你有两个 `width: 50%`{:.value} 且边框为某个正长度的元素，它们通常无法放在同一行上。但是，通过对元素应用 `box-sizing: border-box`{:.value}，它们将能够并排放置。

此属性对 `width`{:.prop} 或 `height`{:.prop} 的 `auto`{:.value} 值不生效。

### 指针事件：'pointer-events' 属性
{:#pointer-events}

`pointer-events`{:.prop}

取值： | auto \| none
初始值： | auto
适用于： | 所有元素
继承： | 是
百分比： | 不适用

设置元素属性以忽略此元素及其后代元素上的鼠标输入事件。


`auto`{:.value}
: 元素的行为与未指定 pointer-events 属性时相同。

`none`{:.value}
: 该元素永远不会成为指针事件的目标。


### 滚动链接：'overscroll-behavior' 属性
{:#overscroll-behavior}

`overscroll-behavior`{:.prop}

取值： | auto \| contain
初始值： | auto
适用于： | 滚动容器
继承： | 否
百分比： | 不适用

控制滚动操作如何沿滚动链从一个滚动容器向上传递到其父滚动容器。

`auto`{:.value}
: 如果元素的任何滚动条可见，它将消耗滚动操作。否则，它将滚动操作向上传递到滚动链。

`contain`{:.value}
: 如果元素的任何滚动条可见，它将消耗滚动操作。否则，滚动操作被取消。

`contain`{:.value} 值可用于确保鼠标滚轮滚动不会传播到给定元素之外，无论其滚动条是否可见。该元素永远不会将滚动操作向上传递到滚动链。


### 拖放：'drag' 属性
{:#drag}

`drag`{:.prop} 属性是一个新属性，CSS 中没有。它控制当鼠标光标在元素上开始拖拽（即点击鼠标左键并移动鼠标）、拖过元素（按住按钮移动鼠标）以及完成拖拽或'放下'元素时事件的生成。

`drag`{:.prop}

取值： | none \| drag \| drag-drop \| block \| clone
初始值： | none
适用于： | 所有元素
继承： | 否
百分比： | 不适用

取值含义如下：

`none`{:.value}
: 如果鼠标在该元素上开始拖拽，该元素不会被拖拽，也不会生成任何拖拽消息。但是，它不会阻止祖先元素被拖拽。

`drag`{:.value}
: 如果鼠标在该元素上开始拖拽，该元素将开始生成拖拽消息。但是，不会向其他元素发送与该拖拽或最终放下相关的消息。

`drag-drop`{:.value}
: 如果鼠标在该元素上开始拖拽，该元素将开始生成拖拽消息。如果被拖拽的元素被拖过某个元素，也会向该元素发送消息。

`block`{:.value}
: 如果鼠标在该元素上开始拖拽，该元素不会被拖拽，任何祖先元素也不会。

`clone`{:.value}
: 与 `drag-drop`{:.value} 类似，但拖拽期间该元素的一个克隆会附着在鼠标光标上。该克隆被设置为伪类 `:drag`{:.cls}，以便与原始元素区分。


### Tab 索引：'tab-index' 属性
{:#tab-index}

'tab-index' 属性是 RCSS 引入的。它控制 tab 顺序的生成，tab 顺序是文档内元素的排序列表，当按下'tab'键时这些元素依次获得输入焦点。

`tab-index`{:.prop}

取值： | none \| auto
初始值： | none
适用于： | 所有元素
继承： | 否
百分比： | 不适用

取值含义如下：

`none`{:.value}
: 该元素不是 tab 顺序的一部分。

`auto`{:.value}
: 该元素会插入到 tab 顺序中与其在元素层级结构中的顺序相对应的位置。

也可以为 body 元素启用 tabbing，这样便有可能 tab 回到 body，使文档内的任何元素都不具有焦点。


### 空间导航：导航属性
{:#nav}

导航属性用于确定按下键盘导航按钮（方向键）之一（上、右、下、左）时焦点如何移动。

`nav-up`{:.prop}、`nav-right`{:.prop}、`nav-down`{:.prop}、`nav-left`{:.prop}

取值： | none \| auto \| tree-order \| \<id\>
初始值： | none
适用于： | 所有可 tab 聚焦的元素
继承： | 否
百分比： | 不适用

取值含义如下：

`none`{:.value}
: 按下给定方向的导航按钮时，焦点不会自动移动。

`auto`{:.value}
: 焦点移动到按下导航按钮方向上最近的可 tab 聚焦元素。

`tree-order`{:.value}
: 焦点按文档树顺序移动到最近的可 tab 聚焦元素，方向根据按下的导航按钮向前或向后。

`<id>`{:.value}
: 焦点移动到具有给定 id 的元素。该元素用 `#`{:.value} 前缀书写，例如 `#my_element`{:.value}。

只有<span class="prop-def-symbol" title="elements with 'tab-index: auto'">可 tab 聚焦的元素</span>才被视为导航源和目标。此外，自动导航被限制在同一个<span class="prop-def-symbol" title="elements whose 'overflow' property is set to anything other than 'visible' establish a new scroll container">滚动容器</span>内。导航也可以设置在 body 元素上，此时 `auto`{:.value} 表示在 body 具有焦点时按 tab 顺序导航。

> *推荐做法*：在同一文档中使用空间导航功能时，始终在 `body`{:.tag} 元素上设置 `nav: auto`{:.value}。这可以确保用户始终能够在文档内导航，即使焦点从原本可导航的区域丢失，例如由于鼠标焦点或手动调用 blur。

按 `tree-order`{:.value} 导航类似于在文档中按 tab 键浏览。此模式可以导航进入和离开滚动容器，就像 tabbing 一样，与 auto 导航不同。但是，它不会绕回到文档根。

执行导航操作时，新聚焦的元素的 `:focus-visible`{:.cls} [伪类](selectors.html#pseudo-selectors) 会被设置。这可以用来为当前聚焦的元素设置样式。

还有一个可以同时设置上述所有属性的简写属性。

`nav`{:.prop}

取值： | none \| auto \| horizontal \| vertical \| tree-order
初始值： | none
适用于： | 所有可 tab 聚焦的元素
继承： | 否
百分比： | 不适用

取值含义如下：

`none`{:.value}
: 禁用所有方向的导航。等价于将所有导航属性设置为 `none`{:.value}。

`auto`{:.value}
: 启用所有方向的自动导航。等价于将所有导航属性设置为 `auto`{:.value}。

`horizontal`{:.value}
: 启用水平方向的自动导航。等价于将水平导航属性设置为 `auto`{:.value}，将垂直导航属性设置为 `none`{:.value}。

`vertical`{:.value}
: 启用垂直方向的自动导航。等价于将水平导航属性设置为 `none`{:.value}，将垂直导航属性设置为 `auto`{:.value}。

`tree-order`{:.value}
: 启用按文档树顺序导航。等价于将所有导航属性设置为 `tree-order`{:.value}。

该简写还可以按盒子顺序（上、右、下、左）设置多个属性。示例：`nav: tree-order none`{:.value} 将 `tree-order`{:.value} 设置到上和下方向，将 `none`{:.value} 设置到水平方向。

### 焦点：'focus' 属性
{:#focus}

`focus`{:.prop}

取值： | none \| auto
初始值： | auto
适用于： | 所有元素
继承： | 是
百分比： | 不适用

'focus' 属性是 RCSS 引入的。它控制元素是否可以接收焦点。通常对禁用的输入元素设置为 `none`{:.value}。

取值含义如下：

`none`{:.value}
: 该元素无法接收焦点。这也会阻止点击事件（源自用户输入时）到达该元素。

`auto`{:.value}
: 该元素可以接收焦点。
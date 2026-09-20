---
layout: page
title: 属性索引
parent: rcss
comment: Please run '_tools/generate_elements_and_properties_index.py' whenever properties or their URLs are added or changed.
---

下表列出了 RCSS 认可的所有属性。**备注** 列详细说明了相比 CSS 规范的重要差异。

名称 | 取值 | 初始值 | 适用于 | 继承 | 百分比 | 备注
---- | ------ | ------------- | ---------- | ---------- | ----------- | -----
[`align-content`{:.prop}][align-content] |flex-start \| flex-end \| center \| space-between \| space-around \| space-evenly \| stretch | stretch | 多行 flex 容器 | 否 | |
[`align-items`{:.prop}][align-items] | flex-start \| flex-end \| center \| baseline \| space-around \| stretch | stretch | flex 容器 | 否 | |
[`align-self`{:.prop}][align-self] | auto \| flex-start \| flex-end \| center \| baseline \| space-around \| stretch | auto | flex 容器 | 否 | |
[`animation`{:.prop}][animation] | 参见[动画](animations_transitions_transforms.html#animation) | none | 所有 | 否 | |
[`backdrop-filter`{:.prop}][backdrop-filter] | none \| \<filter-function\>( \<properties\> ) | none | 所有 | 否 | |
[`background`{:.prop}][background] | `background-color`{:.prop} | | | | | 不含图像，请改用装饰器。
[`background-color`{:.prop}][background-color] | \<colour\> | transparent | 所有 | 否 | |
[`border`{:.prop}][border] | `border-width`{:.prop} `border-color`{:.prop} | | | | | 不含边框样式。
[`border-color`{:.prop}][border-color] | `border-top-color`{:.prop} `border-right-color`{:.prop} `border-bottom-color`{:.prop} `border-left-color`{:.prop} | | | | |
[`border-top`{:.prop}][border] [`border-right`{:.prop}][border] [`border-bottom`{:.prop}][border] [`border-left`{:.prop}][border] | `border-<edge>-width`{:.prop} `border-<edge>-color`{:.prop} | | | | | 不含边框样式。
[`border-top-color`{:.prop}][border-color] [`border-right-color`{:.prop}][border-color] [`border-bottom-color`{:.prop}][border-color] [`border-left-color`{:.prop}][border-color] | \<color\> | black | 所有 | 否 | |
[`border-top-width`{:.prop}][border-width] [`border-right-width`{:.prop}][border-width] [`border-bottom-width`{:.prop}][border-width] [`border-left-width`{:.prop}][border-width] | \<length\> \| \<percentage\> | 0px | 所有 | 否 | 包含块的宽度 |
[`border-width`{:.prop}][border-width] | `border-top-width`{:.prop} `border-right-width`{:.prop} `border-bottom-width`{:.prop} `border-left-width`{:.prop} | | 所有 | | |
[`border-top-left-radius`{:.prop}][border-radius] [`border-top-right-radius`{:.prop}][border-radius] [`border-bottom-right-radius`{:.prop}][border-radius] [`border-bottom-left-radius`{:.prop}][border-radius] | \<length\> | 0px | 所有 | 否 | | 不支持百分比和双轴半径。
[`border-radius`{:.prop}][border-radius] | `border-top-left-radius`{:.prop} `border-top-right-radius`{:.prop} `border-bottom-right-radius`{:.prop} `border-bottom-left-radius`{:.prop} | | 所有 | | |
[`bottom`{:.prop}][top_right_bottom_left] | auto \| \<length\> \| \<percentage\> | auto | 定位元素 | 否 | 包含块的高度 |
[`box-sizing`{:.prop}][box-sizing] | content-box \| border-box | content-box | 块级和替换行内元素 | 否 | |
[`box-shadow`{:.prop}][box-shadow] | none \| \<color\>? \<offset-x\> \<offset-y\> \<blur-radius\>? \<spread-radius\>? inset? | none | 所有元素 | 否 | |
[`caret-color`{:.prop}][caret-color] | auto \| \<colour\> | auto | 所有元素 | 是 | |
[`clear`{:.prop}][clear] | left \| right \| both \| none | none | 块级元素 | 否 | |
[`clip`{:.prop}][clip] | auto \| none \| always \| \<number\> | auto | 所有 | 否 | | 控制与祖先元素裁剪区域的交互。
[`color`{:.prop}][color] | \<colour\> | black | 所有 | 是 | |
[`column-gap`{:.prop}][gap] | \<length\> \| \<percentage\> | 0px | flex 容器和表格元素 | 否 | flex 容器或表格的初始宽度 |
[`cursor`{:.prop}][cursor] | \<string\> | *空* | 所有 | 是 | | \<string\> 指应用程序特定的光标名称。
[`decorator`{:.prop}][decorator] | none \| \<name\> \| \<type\>( \<properties\> ) | none | 所有 | 否 | | 详见[装饰器](decorators.html)。
[`display`{:.prop}][display] | inline \| block \| inline-block \| flow-root \| flex \| inline-flex \| table \| inline-table \| table-row-group \| table-row \| table-column-group \| table-column \| table-cell \| none | inline | 所有 | 否 | |
[`drag`{:.prop}][drag] | none \| drag \| drag-drop \| block \| clone | none | 所有 | 否 | | 为 RCSS 引入。控制拖拽消息的生成。
[`filter`{:.prop}][filter] | none \| \<filter-function\>( \<properties\> ) | none | 所有 | 否 | |
[`fill-image`{:.prop}][fill-image] | \<string\> | *空* | [progress]({{"pages/cpp_manual/element_packages/progress_bar.html"|relative_url}}) 元素 | 否 | | \<string\> 指精灵名称或图像 URL。
[`flex`{:.prop}][flex] | auto \| none \| \<flex-grow\> \<flex-shrink\>? \<flex-basis\>? \| \<flex-basis\> | 0 1 auto | flex 项目 | 否 | |
[`flex-basis`{:.prop}][flex-basis] | \<length\> \| \<percentage\> \| auto | auto | flex 项目 | 否 | |
[`flex-direction`{:.prop}][flex-direction] | row \| row-reverse \| column \| column-reverse | row | flex 容器 | 否 | |
[`flex-flow`{:.prop}][flex-flow] |  \<flex-direction\> \<flex-wrap\> | | | | |
[`flex-grow`{:.prop}][flex-grow] | \<number\> | 0 | flex 项目 | 否 | |
[`flex-shrink`{:.prop}][flex-shrink] | \<number\> | 1 | flex 项目 | 否 | |
[`flex-wrap`{:.prop}][flex-wrap] | nowrap \| wrap \| wrap-reverse | nowrap | flex 容器 | 否 | |
[`float`{:.prop}][float] | left \| right \| none | none | 所有 | 否 | |
[`focus`{:.prop}][focus] | none \| auto | auto | 所有 | 是 | | 为 RCSS 引入。
[`font`{:.prop}][font] | `font-style`{:.prop} `font-weight`{:.prop} `font-size`{:.prop} `font-family`{:.prop} | | | | |
[`font-effect`{:.prop}][font-effect] | none \| \<type\>( \<properties\> ) | none | 所有 | 是 | | 详见[字体效果](font_effects.html)。
[`font-family`{:.prop}][font-family] | \<string\> | | 所有 | 是 | | 仅支持单一字体族。
[`font-kerning`{:.prop}][font-kerning] | auto \| normal \| none | auto | 所有 | 是 | |
[`font-size`{:.prop}][font-size] | \<length\> \| \<percentage\> | 12px | 所有 | 是 | 父字体的字号 |
[`font-style`{:.prop}][font-style] | normal \| italic | normal | 所有 | 是 | | 不支持 'oblique'。
[`font-weight`{:.prop}][font-weight] | normal \| bold \| \<number \[1,1000\]\> | normal | 所有 | 是 | | 不支持相对字重。
[`gap`{:.prop}][gap] | `row-gap`{:.prop} `column-gap`{:.prop} | | flex 容器和表格元素 | | | 同时支持表格，取代 CSS 的 `border-spacing`{:.prop} 属性。
[`height`{:.prop}][height] | \<length\> \| \<percentage\> \| auto | auto | 块级和替换行内元素 | 否 | 包含块的高度 |
[`image-color`{:.prop}][image-color] | \<color\> | white | \<img\> 元素和装饰器 | 否 | | 为 RCSS 引入。
[`inset`{:.prop}][top_right_bottom_left] | `top`{:.prop} `right`{:.prop} `bottom`{:.prop} `left`{:.prop} | | | | |
[`justify-content`{:.prop}][justify-content] | flex-start \| flex-end \| center \| space-between \| space-around \| space-evenly | flex-start | flex 容器 | 否 | |
[`left`{:.prop}][top_right_bottom_left] | auto \| \<length\> \| \<percentage\> | auto | 定位元素 | 否 | 包含块的宽度 |
[`letter-spacing`{:.prop}][letter-spacing] | normal \| \<length\> | normal | 所有元素 | 是 | |
[`line-height`{:.prop}][line-height] | \<number\> \| \<length\> \| \<percentage\> | 1.2 | 所有 | 是 | 字号 | 不支持 'normal'。
[`margin`{:.prop}][margin] | `margin-top`{:.prop} `margin-right`{:.prop} `margin-bottom`{:.prop} `margin-left`{:.prop} | | | | |
[`margin-top`{:.prop}][margin] [`margin-right`{:.prop}][margin] [`margin-bottom`{:.prop}][margin] [`margin-left`{:.prop}][margin] | \<length\> \| \<percentage\> \| auto | 0px | 所有 | 否 | 包含块的宽度 |
[`mask-image`{:.prop}][mask-image] | none \| \<name\> \| \<type\>( \<properties\> ) | none | 所有 | 否 | | 遮罩图像使用[装饰器](decorators.html)渲染。
[`max-height`{:.prop}][max-height] | \<length\> \| \<percentage\> \| none | none | 块级和替换行内元素 | 否 | 包含块的高度 |
[`min-height`{:.prop}][min-height] | \<length\> \| \<percentage\> | 0px | 块级和替换行内元素 | 否 | 包含块的高度 |
[`max-width`{:.prop}][max-width] | \<length\> \| \<percentage\> \| none | none | 块级和替换行内元素 | 否 | 包含块的宽度 |
[`min-width`{:.prop}][min-width] | \<length\> \| \<percentage\> | 0px | 块级和替换行内元素 | 否 | 包含块的宽度 |
[`nav`{:.prop}][nav] | none \| auto \| horizontal \| vertical \| tree-order | none | 可通过 Tab 键聚焦的元素 | 否 | | 导航属性的简写。
[`nav-up`{:.prop}][nav] [`nav-right`{:.prop}][nav] [`nav-down`{:.prop}][nav] [`nav-left`{:.prop}][nav] | none \| auto \| tree-order \| \<id\> | none | 可通过 Tab 键聚焦的元素 | 否 | | 控制空间导航。
[`opacity`{:.prop}][opacity] | \<number\> | 1 | 所有 | 是 | |
[`overflow`{:.prop}][overflow] | `overflow-x`{:.prop} `overflow-y`{:.prop} | | | | |
[`overflow-x`{:.prop}][overflow] | visible \| hidden \| scroll \| auto | visible | 块级元素 | 否 | | 任一坐标轴不是 'visible' 时内容将被裁剪。
[`overflow-y`{:.prop}][overflow] | visible \| hidden \| scroll \| auto | visible | 块级元素 | 否 | | 任一坐标轴不是 'visible' 时内容将被裁剪。
[`overscroll-behavior`{:.prop}][overscroll-behavior] | auto \| contain | auto | 滚动容器 | 否 | |
[`padding`{:.prop}][padding] | `padding-top`{:.prop} `padding-right`{:.prop} `padding-bottom`{:.prop} `padding-left`{:.prop} | | | | |
[`padding-top`{:.prop}][padding] [`padding-right`{:.prop}][padding] [`padding-bottom`{:.prop}][padding] [`padding-left`{:.prop}][padding] | \<length\> \| \<percentage\> | 0px | 所有 | 否 | 包含块的宽度 |
[`perspective`{:.prop}][perspective] | none \| \<length ≥ 0px\> | none | 所有 | 否 | |
[`perspective-origin`{:.prop}][perspective-origin] | \<perspective-origin-x\> \|\| \<perspective-origin-y\> | 50% 50% | 所有 | 否 | |
[`pointer-events`{:.prop}][pointer-events] | auto \| none | auto | 所有 | 是 | |
[`position`{:.prop}][position] | static \| relative \| absolute \| fixed | static | 所有 | 否 | | 'fixed' 的定位方式与 'absolute' 相同，但忽略滚动。
[`right`{:.prop}][top_right_bottom_left] | auto \| \<length\> \| \<percentage\> | auto | 定位元素 | 否 | 包含块的宽度 |
[`row-gap`{:.prop}][gap] | \<length\> \| \<percentage\> | 0px | flex 容器和表格元素 | 否 | flex 容器或表格的初始高度 |
[`scrollbar-margin`{:.prop}][scrollbar-margin] | \<length\> | 0px | scrollbar-horizontal 和 scrollbar-vertical 元素 | 否 | | 为 RCSS 引入。指定底部/右侧外边距（取决于方向），该外边距将在互补轴上与滚动条合并。
[`tab-index`{:.prop}][tab-index] | none \| auto | none | 所有 | 否 | | 为 RCSS 引入。控制按下 Tab 键时焦点切换的顺序。
[`text-align`{:.prop}][text-align] | left \| right \| center | left | 块级元素 | 是 | | 不支持 'justify'。
[`text-decoration`{:.prop}][text-decoration] | none \| underline \| overline \| line-through | none | 所有 | 是 | |
[`text-overflow`{:.prop}][text-overflow] | clip \| ellipsis \| \<string\> | clip | 所有 | 否 | |
[`text-transform`{:.prop}][text-transform] | none \| capitalize \| uppercase \| lowercase | none | 所有 | 是 | |
[`top`{:.prop}][top_right_bottom_left] | auto \| \<length\> \| \<percentage\> | auto | 定位元素 | 否 | 包含块的高度 |
[`transition`{:.prop}][transition] | 参见[过渡](animations_transitions_transforms.html#transition) | none | 所有 | 否 | |
[`transform`{:.prop}][transform] | none \| \<transform-function\>+ | none | 所有 | 否 | |
[`transform-origin`{:.prop}][transform-origin] | \[\<transform-origin-x\> \|\| \<transform-origin-y\>\] \<transform-origin-z\>? | 50% 50% 0px | 所有 | 否 | |
[`vertical-align`{:.prop}][vertical-align] | baseline \| sub \| super \| text-top \| text-bottom \| middle \| top \| center \| bottom \| \<percentage\> \| \<length\> | baseline | 行内级元素 | 否 | 行高 |
[`visibility`{:.prop}][visibility] | visible \| hidden | visible | 所有 | 否 | |
[`white-space`{:.prop}][white-space] | normal \| pre \| nowrap \| pre-wrap \| pre-line | normal | 所有元素 | 是 | |
[`word-break`{:.prop}][word-break] | normal \| break-all \| break-word | normal | 所有元素 | 是 | |
[`width`{:.prop}][width] | \<length\> \| \<percentage\> \| auto | auto | 块级和替换行内元素 | 否 | 包含块的宽度 |
[`z-index`{:.prop}][z-index] | \<number\> \| auto | auto | 所有 | 否 | | 适用于所有元素。对文档而言，'auto' 允许置顶，否则保持在顶部或底部。


[align-content]: flexboxes.html#align-content
[align-items]: flexboxes.html#align-items
[align-self]: flexboxes.html#align-self
[animation]: animations_transitions_transforms.html#animation
[backdrop-filter]: filters.html#backdrop-filter
[background-color]: colours_backgrounds.html#background-color
[background]: colours_backgrounds.html#background-color
[border]: box_model.html#border
[border-color]: box_model.html#border-color
[border-radius]: colours_backgrounds.html#border-radius
[border-width]: box_model.html#border-width
[box-shadow]: colours_backgrounds.html#box-shadow
[box-sizing]: user_interface.html#box-sizing
[caret-color]: user_interface.html#caret-color
[clear]: visual_formatting_model.html#clear
[clip]: visual_effects.html#clip
[color]: colours_backgrounds.html#color
[cursor]: user_interface.html#cursor
[decorator]: decorators.html#decorator
[display]: visual_formatting_model.html#display
[drag]: user_interface.html#drag
[filter]: filters.html#filter
[fill-image]: {{"pages/cpp_manual/element_packages/progress_bar.html#fill-image"|relative_url}}
[flex]: flexboxes.html#flex
[flex-basis]: flexboxes.html#flex-basis
[flex-direction]: flexboxes.html#flex-direction
[flex-flow]: flexboxes.html#flex-flow
[flex-grow]: flexboxes.html#flex-grow
[flex-shrink]: flexboxes.html#flex-shrink
[flex-wrap]: flexboxes.html#flex-wrap
[float]: visual_formatting_model.html#float
[focus]: user_interface.html#focus
[font]: fonts.html#font
[font-effect]: font_effects.html#font-effect
[font-family]: fonts.html#font-family
[font-kerning]: fonts.html#font-kerning
[font-size]: fonts.html#font-size
[font-style]: fonts.html#font-style
[font-weight]: fonts.html#font-weight
[gap]: flexboxes.html#gap
[height]: visual_formatting_model_details.html#height
[image-color]: colours_backgrounds.html#image-color
[justify-content]: flexboxes.html#justify-content
[letter-spacing]: text.html#letter-spacing
[line-height]: visual_formatting_model_details.html#line-height
[margin]: box_model.html#margin
[mask-image]: masking.html#mask-image
[max-height]: visual_formatting_model_details.html#max-height
[max-width]: visual_formatting_model_details.html#max-width
[min-height]: visual_formatting_model_details.html#min-height
[min-width]: visual_formatting_model_details.html#min-width
[nav]: user_interface.html#nav
[opacity]: colours_backgrounds.html#opacity
[overflow]: visual_effects.html#overflow
[overscroll-behavior]: user_interface.html#overscroll-behavior
[padding]: box_model.html#padding
[perspective]: animations_transitions_transforms.html#perspective
[perspective-origin]: animations_transitions_transforms.html#perspective-origin
[pointer-events]: user_interface.html#pointer-events
[position]: visual_formatting_model.html#position
[scrollbar-margin]: ../style_guide.html#scrollbar-margin
[tab-index]: user_interface.html#tab-index
[text-align]: text.html#text-align
[text-decoration]: text.html#text-decoration
[text-overflow]: text.html#text-overflow
[text-transform]: text.html#text-transform
[top_right_bottom_left]: visual_formatting_model.html#top_right_bottom_left
[transition]: animations_transitions_transforms.html#transition
[transform]: animations_transitions_transforms.html#transform
[transform-origin]: animations_transitions_transforms.html#transform-origin
[vertical-align]: tables.html#vertical-align
[vertical-align]: visual_formatting_model_details.html#vertical-align
[visibility]: visual_effects.html#visibility
[white-space]: text.html#white-space
[width]: visual_formatting_model_details.html#width
[word-break]: text.html#word-break
[z-index]: visual_formatting_model.html#z-index
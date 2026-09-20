---
layout: page
title: 选择器
parent: rcss
next: cascade
---

选择器用于选择要应用特定规则的元素。RCSS 支持以下选择器：

选择器                     | 匹配
---                        | ---
`*`{:.cls}                 | 任意元素。
`E`{:.cls}                 | 任意类型为 E 的元素（即在 RML 文档中声明为 `<E>`{:.tag} 的元素）。
`.foo`{:.cls}              | 任意声明了类 `foo`{:.cls} 的元素。
`#foo`{:.cls}              | 任意声明了 ID 为 `foo`{:.value} 的元素。
`:foo`{:.cls}              | 任意当前处于激活状态的伪类 `foo`{:.cls} 的元素，或匹配下文结构选择器的元素。
`[foo]`{:.cls}             | 任意具有 `foo`{:.attr} 属性的元素，无论其取值如何。
`[foo=bar]`{:.cls}         | 任意具有 `foo`{:.attr} 属性且取值等于 `bar`{:.value} 的元素。
`[foo~=bar]`{:.cls}        | 任意具有 `foo`{:.attr} 属性、属性值以空格分隔的列表中包含等于 `bar`{:.value} 的元素的元素。
`[foo|=bar]`{:.cls}        | 任意具有 `foo`{:.attr} 属性且取值等于 `bar`{:.value} 或以 `bar-`{:.value} 开头（包括连字符）的元素。
`[foo^=bar]`{:.cls}        | 任意具有 `foo`{:.attr} 属性且取值以 `bar`{:.value} 开头的元素。
`[foo$=bar]`{:.cls}        | 任意具有 `foo`{:.attr} 属性且取值以 `bar`{:.value} 结尾的元素。
`[foo*=bar]`{:.cls}        | 任意具有 `foo`{:.attr} 属性且取值包含 `bar`{:.value} 的元素。
`E F`{:.cls}               | 任意类型为 F 且是 E 元素后代的元素。
`E > F`{:.cls}             | 任意类型为 F 且是 E 元素直接子代的元素。
`E + F`{:.cls}             | 任意类型为 F 且紧跟在 E 元素之后的元素。
`E ~ F`{:.cls}             | 任意类型为 F 且位于 E 元素之后的元素。

下面描述所列选择器的细节及组合方式。


#### 伪类选择器
{:#pseudo-selectors}

下表列出了内置的伪类选择器，以及否定选择器和 CSS3 中的所有树结构选择器。

**伪类**                                    |
`:hover`{:.cls pseudo-def}                   | 匹配当前位于鼠标光标下的元素。<br/>与 CSS 不同，此伪类会向其父元素反向传播。
`:active`{:.cls pseudo-def}                  | 匹配已被点击的元素，仅在按钮释放前有效。<br/>与 CSS 不同，此伪类会向其父元素反向传播。
`:focus`{:.cls pseudo-def}                   | 匹配具有输入焦点的元素。<br/>与 CSS 不同，此伪类会向其父元素反向传播。
`:focus-visible`{:.cls pseudo-def}           | 匹配具有输入焦点且其焦点应被明显指示出来的元素。在使用键盘或空间导航时，这对于设置焦点元素的样式尤为有用。<br/>与 CSS 不同，此伪类会向其父元素反向传播。
`:checked`{:.cls pseudo-def}                 | 匹配已勾选的复选框和单选按钮。当[选择元素]({{"pages/cpp_manual/element_packages/form.html#drop-down-select-box"|relative_url}})展开时也会匹配该元素，以及其下拉列表中被选中的选项。
**逻辑**                                    |
`:not(s1, s2, …)`{:.cls pseudo-def}          | 匹配不匹配任何选择器 s1、s2、… 的元素。
**树结构**                                  |
`:nth-child(an + b)`{:.cls pseudo-def}       | 匹配在其之前有 an + b - 1 个兄弟元素的元素。
`:nth-last-child(an + b)`{:.cls pseudo-def}  | 与 nth-child 类似，但从后往前计数。
`:nth-of-type(an + b)`{:.cls pseudo-def}     | 与 nth-child 类似，但只计算同类型的兄弟元素。
`:nth-last-of-type(an + b)`{:.cls pseudo-def}| 与 nth-of-type 类似，但从后往前计数。
`:first-child`{:.cls pseudo-def}             | 匹配是其父元素第一个子元素的元素。
`:last-child`{:.cls pseudo-def}              | 匹配是其父元素最后一个子元素的元素。
`:first-of-type`{:.cls pseudo-def}           | 匹配是其类型的第一个子元素的元素。
`:last-of-type`{:.cls pseudo-def}            | 匹配是其类型的最后一个子元素的元素。
`:only-child`{:.cls pseudo-def}              | 匹配没有兄弟元素的元素。
`:only-of-type`{:.cls pseudo-def}            | 匹配没有同类型兄弟元素的元素。
`:empty`{:.cls pseudo-def}                   | 匹配没有任何子节点的元素。
`:scope`{:.cls pseudo-def}                   | 与[元素 DOM 接口](../cpp_manual/elements.html#dom-interface)中的选择器函数（如 `QuerySelector()`）一起使用时，匹配当前元素。否则不匹配任何元素。
**输入**                                    |
`:placeholder-shown`{:.cls pseudo-def}       | 匹配当前显示[占位文本](../rml/forms.html)的输入元素。

关于选择器的使用，更详尽的文档和示例请参阅 [CSS 选择器规范](https://www.w3.org/TR/selectors-4/)。请注意，RCSS 尚不支持 `::first-letter`{:.cls} 和 `::before`{:.cls} 等伪元素。


#### 复合选择器

*复合选择器（compound selector）*由一个可选的元素类型后跟零个或多个类选择器、ID 选择器、属性选择器和伪选择器组成。如果未给出元素类型，则匹配任意元素类型。例如，以下选择器：

```css
div#level_list:hover
```

将匹配任何类型为 `div`{:.tag}、ID 为 `level_list`{:.value} 且当前正被光标悬停的元素。


#### 复杂选择器

*复杂选择器（complex selector）*由可能多个复合选择器组成，每个复合选择器之间由一个组合符分隔。

```css
div.content p {}
div.content > p {}
div.content + p {}
div.content ~ p {}
```
要使一个元素被含多个复合选择器的选择器匹配，元素本身必须匹配最后一个复合选择器。然后，前面的每个复合选择器都必须按照其连接组合符的规则，匹配 RML 层级结构中的元素。

##### 后代组合符

后代组合符（空白符）要求在 RML 层级结构中存在匹配前面复合选择器的后代。例如，以下选择器：

```css
div#level_list input.select option:nth-child(even)
```

只有在 *全部* 满足以下条件时才会匹配：
- 一个类型为 `option`{:.tag} 的元素，是其父元素的偶数位子元素，
- 其祖先中包含一个类为 `select`{:.cls} 的 `input`{:.tag} 元素，
- 后者自身又有一个 ID 为 `level_list`{:.value} 的 `div`{:.tag} 元素作为祖先。

##### 子代组合符

子代组合符 `>` 可以像在 CSS 中一样用于选择另一个元素的子元素。
```css
p.green_theme > button { image-color: #0f0; }
```
这里，任何父元素为 `p.green_theme`{:.value} 的 `button`{:.tag} 元素，其图像颜色都会被设置为绿色。

在下面的示例中，它与通用选择器 `*`{:.value} 组合使用。
```css
div.red_theme > * > p { color: #f00; }
```
这里，`div.red_theme`{:.value} 的孙元素 `p`{:.tag} 的颜色会被设置为红色。

##### 兄弟组合符

下一个兄弟组合符 `+` 可用于为紧挨着彼此、共享同一父元素的元素设置样式。
```css
p + img { margin-top: 0; }
```
类似地，后续兄弟组合符 `~` 可用于选择位于另一个元素之后、共享同一父元素的元素。
```css
p.content ~ p { font-size: 0.9em; }
```


#### 选择器列表

多个选择器可以用逗号追加，等价于 OR 语句。例如，以下内容：

```css
div#level_list,
div#weapon_list,
.color_list
```

将匹配 ID 为 `level_list`{:.value} 的 `div`{:.tag} 元素、ID 为 `weapon_list`{:.value} 的元素，或任何具有 `color_list`{:.value} 类的元素。


#### 否定选择器 `:not()`{:.cls}

否定选择器 `:not()`{:.cls} 可用于过滤某些类型，例如所有未被勾选的输入元素。
```css
input:not(:checked)
```
它还可以接受多个复杂选择器。以下内容将匹配所有不是 `p`{:.tag} 的子元素、也不是其父元素第二个子元素的 `div`{:.tag} 元素。
```css
div:not(:nth-child(2),p > *)
```
该选择器的特异性由具有最大特异性的子选择器决定，与 CSS 一致。


#### 编号选择器 `:nth-`{:.cls}

有关 `:nth-`{:.cls} 风格选择器的更完整说明，请参阅 CSS 选择器规范的[相应章节](https://www.w3.org/TR/selectors-4/#the-nth-child-pseudo)。RCSS 支持 `even`{:.cls} 和 `odd`{:.cls}。


#### 性能注意事项

简而言之，每个元素都会与每个[复杂选择器](#complex-selectors)进行匹配。此过程从匹配最右侧的复合选择器开始，然后在遍历元素树的同时依次匹配其左侧的各个选择器。为了加速这一过程，所有带 ID、类和标签的样式规则都会被建立索引以便快速检索。这样，许多选择器可以立即被排除。但是，如果最右侧的复合选择器不包含这三类选择器（ID、类、标签）中的任何一种，则必须对每个元素进行测试。

基于此，以下是确保良好性能的一些通用准则：

- 尽量保持样式规则的数量较少。
- 最右侧的选择器应包含 ID、类或标签（按优先顺序——越独特越好）。
- 伪类、结构性和属性选择器不会被索引，可能较慢。最好将它们与 ID、类或标签组合使用。
- 优先使用子代 `>` 和下一个兄弟 `+` 组合符，而不是后代（空白符）和后续兄弟 `~` 组合符。
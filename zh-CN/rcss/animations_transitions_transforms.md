---
layout: page
title: 动画、过渡与变换
parent: rcss
next: custom_properties
---

RmlUi 为动画、过渡和变换提供了全面的支持。它们可以组合使用，构建出非常丰富的用户体验。这些功能大体上以 CSS3 规范为模型，但存在一些差异。

另请参阅 [C++ 文档](../cpp_manual/animations_transforms.html) 中关于动画和变换的内容。

### 动画
{:#animation}

RCSS 中的大多数属性都可以设置动画。这尤其包括表示以下内容的属性：

- 数字、长度和百分比
- 角度
- 颜色
- 关键字
- 变换
- 装饰器
- 滤镜

值得注意的是，盒阴影目前还不支持动画。

动画可以完全在 RCSS 中声明，使用以下属性配合关键帧。

`animation`{:.prop}

取值： | none \| \[\<duration\> \<delay\>? \<tweening-function\>? \[\<num-iterations\>\|infinite\]? alternate? paused? \<keyframes-name\>\]<span class="prop-def-symbol" title="one or more comma-separated occurrences">#</span>
初始值： | none
适用于： | 所有元素
继承： | 否
百分比： | 不适用

`none`{:.value}
: 未指定动画。

`<duration>`{:.value}
: 动画持续时间，以秒（`s`{:.value} 单位）指定。必需值。

`<delay>`{:.value}
: 开始动画前的延迟时间，以秒指定。默认值：`0s`{:.value}。

`<tweening-function>`{:.value}
: 补间函数指定动画值在动画周期内的推进方式。详细信息和可能的取值请参阅下面的[补间函数](#tweening-functions)。默认值：`linear-in-out`{:.value}。

`<num-iterations> | infinite`{:.value}
: 暂停前播放动画的迭代次数。指定为整数或关键字 `infinite`{:.value}。默认值：1。

`alternate`{:.value}
: 如果存在，则每隔一个周期交替动画的方向。

`paused`{:.value}
: 如果存在，则动画在加载时不会启动。

`<keyframes-name>`{:.value}
: 指定关键帧名称的字符串。关键帧的指定[与 CSS 中一样](https://developer.mozilla.org/en-US/docs/Web/CSS/@keyframes)，参见下面的示例。必需值。

取值可以按任意顺序给出，但 `duration`{:.value} 必须位于 `delay`{:.value} 之前。

用法示例：

```css
@keyframes my-progress-bar {
	0%, 30% {
		background-color: #d99;
	}
	50% {
		background-color: #9d9;
	}
	to {
		background-color: #f9f;
		width: 100%;
	}
}
#my_element {
	width: 25px;
	animation: 2s cubic-in-out infinite alternate my-progress-bar;
}
```

通过使用逗号分隔的列表，可以在同一元素上指定多个动画。

```css
@keyframes my-progress-bar { ... }
@keyframes make-red {
	from { color: #333; }
	to   { color: #f33; }
}
#multi-animation { animation: 1s elastic-out my-progress-bar, 2s make-red; }
```

在内部，动画将其属性应用于元素的局部样式。因此，应避免在同一元素上混用 RML 样式属性和动画。

更多示例和细节请参阅 `animation` 示例。


### 过渡
{:#transition}

过渡在元素的属性发生变化时，在两个属性值之间应用动画。RCSS 中过渡的实现方式与 CSS 类似。但是，在 RCSS 中，它们仅在向元素添加或从元素移除类或伪类时应用。

`transition`{:.prop}

取值： | none \| \[\[\<property-name\><span class="prop-def-symbol" title="one or more space-separated occurrences">+</span> \| all \| none\] \<duration\> \<delay\>? \<tweening-function\>?\]<span class="prop-def-symbol" title="one or more comma-separated occurrences">#</span>
初始值： | none
适用于： | 所有元素
继承： | 否
百分比： | 不适用

`none`{:.value}
: 未指定过渡。

`<property-name>+ | all | none`{:.value}
: 指定更改时要设置动画的属性列表，以空格分隔的名称列表形式给出。或者，`all`{:.value} 关键字为所有属性设置动画，而 `none`{:.value} 则不会为任何属性设置动画。

`<duration>`{:.value}
: 动画持续时间，以秒（`s`{:.value} 单位）指定。必需值。

`<delay>`{:.value}
: 开始动画前的延迟时间，以秒指定。默认值：`0s`{:.value}。

`<tweening-function>`{:.value}
: 补间函数指定动画值在动画周期内的推进方式。详细信息和可能的取值请参阅下面的[补间函数](#tweening-functions)。默认值：`linear-in-out`{:.value}。

取值可以按任意顺序给出，但 `duration`{:.value} 必须位于 `delay`{:.value} 之前。通过使用逗号分隔的列表，可以在同一元素上指定多个过渡。

用法示例：

```css
#transition_test {
	transition: padding-left background-color transform 1.6s elastic-out;
	transform: scale(1.0);
	background-color: #c66;
}
#transition_test:hover {
	padding-left: 60px;
	transform: scale(1.5);
	background-color: #ddb700;
}
```

更多示例和细节请参阅 `animation` 示例。


### 补间函数
{:#tweening-functions}

动画和过渡可以选择性地接受一个*补间（tweening）*函数，它指定动画值在动画周期内的推进方式。这里我们与 CSS 规范有所不同，CSS 中它们被称为 `animation-timing-function`{:.value}。

RCSS 中的补间函数指定为 `<name>-in`{:.value}、`<name>-out`{:.value} 或 `<name>-in-out`{:.value}，名称可以是以下之一：

- `back`{:.value}
- `bounce`{:.value}
- `circular`{:.value}
- `cubic`{:.value}
- `elastic`{:.value}
- `exponential`{:.value}
- `linear`{:.value}
- `quadratic`{:.value}
- `quartic`{:.value}
- `quintic`{:.value}
- `sine`{:.value}

上面的动画和过渡文档中有用法示例。每个补间函数在归一化时间 *t* 与所用的插值 *y* 之间提供特定的映射，如下面的图形所示。

<div style="text-align: center">
	<img alt="Tweening functions" src="../../assets/images/tweening_functions.svg" style="width: 100%; max-width: 700px">
</div>

另请参阅 `demo` 示例，用户可以在其中尝试不同的补间函数和持续时间，并查看生成的动画。也可以在 [C++ 动画 API](../cpp_manual/animations_transforms.html) 中提供自定义的补间函数。


### 变换
{:#transform}

可以使用 `transform`{:.prop} 属性对元素应用变换。相关的 `transform-origin`{:.prop}、`perspective`{:.prop} 和 `perspective-origin`{:.prop} 属性在 RCSS 中也受支持，它们控制变换应用和渲染方式的各个方面。这些大致相当于各自的 [CSS 属性](https://developer.mozilla.org/en-US/docs/Web/CSS/transform)。

```css
transform: rotateX(10deg) skew(-10deg, 15deg) translateZ(100px);
transform-origin: left top 0;
perspective: 1000px;
perspective-origin: 20px 50%;
```

请注意，RmlUi 的一个限制是：变换不会影响裁剪何时应用于该元素。例如，`overflow: hidden`{:.value} 的元素不会裁剪其已变换的内容，除非内容在没有变换的情况下溢出。此时，可以使用 [`clip: always`{:.value} 属性](visual_effects.html#clip) 配合 `overflow: hidden`{:.value} 来强制发生裁剪。

控制变换的属性定义如下。

`transform`{:.prop}

取值： | none \| \<transform-function\><span class="prop-def-symbol" title="one or more space-separated occurrences">+</span>
初始值： | none
适用于： | 所有元素
继承： | 否
百分比： | 参见各个变换函数

`none`{:.value}
: 不应用变换。

`<transform-function>+`{:.value}
: 指定要应用于元素的变换函数列表，参见下面的[所有可用取值](#transform-functions)。


`transform-origin`{:.prop}
{:#transform-origin}

取值： | \[\<transform-origin-x\> <span class="prop-def-symbol" title="one or both must be specified">\|\|</span> \<transform-origin-y\>\] \<transform-origin-z\>?
初始值： | 50% 50% 0px
适用于： | 所有元素
继承： | 否
百分比： | 相对于元素边框盒的大小

描述变换发生所围绕的原点，以距元素边框盒左上角的距离给出。这是一个简写属性，其基础属性沿每个维度指定如下。

`transform-origin-x`{:.prop}：\[left \| center \| right \| \<length-percentage\>\]

`transform-origin-y`{:.prop}：\[top \| center \| bottom \| \<length-percentage\>\]

`transform-origin-z`{:.prop}：\<length\>


#### 变换函数
{:#transform-functions}

下面列出所有变换函数及其参数类型。

**`<transform-function>`{:.value}**

`matrix`{:.value}( `<number>#{6}`{:.value} )            |  `rotateZ`{:.value}( `<angle>`{:.value} )       |  `skewX`{:.value}( `<angle>`{:.value} )
`matrix3d`{:.value}( `<number>#{16}`{:.value} )         |  `scale`{:.value}( `<number>#{1,2}`{:.value} )  |  `skewY`{:.value}( `<angle>`{:.value} )
`perspective`{:.value}( `<length>`{:.value} )           |  `scale3d`{:.value}( `<number>#{3}`{:.value} )  |  `translate`{:.value}( `<length-percentage>#{2}`{:.value} )
`rotate`{:.value}( `<angle>`{:.value} )                 |  `scaleX`{:.value}( `<number>`{:.value} )       |  `translate3d`{:.value}( `<length-percentage>#{2}, <length>`{:.value} )
`rotate3d`{:.value}( `<number>#{3}, <angle>`{:.value})  |  `scaleY`{:.value}( `<number>`{:.value} )       |  `translateX`{:.value}( `<length-percentage>`{:.value} )
`rotateX`{:.value}( `<angle>`{:.value} )                |  `scaleZ`{:.value}( `<number>`{:.value} )       |  `translateY`{:.value}( `<length-percentage>`{:.value} )
`rotateY`{:.value}( `<angle>`{:.value} )                |  `skew`{:.value}( `<angle>#{2}`{:.value} )      |  `translateZ`{:.value}( `<length>`{:.value} )

每个函数的详细描述请参阅 [CSS 变换规范](https://drafts.csswg.org/css-transforms-2/#transform-functions)。角度采用 'deg' 或 'rad' 单位。更多示例请参阅 `transform` 和 `animation` 示例。


#### 透视
{:#perspective}

`perspective`{:.prop}

取值： | none \| \<length ≥ 0px\>
初始值： | none
适用于： | 所有元素
继承： | 否
百分比： | 不适用

与 3d 变换结合使用时，透视可以使较远的物体看起来更小。

`none`{:.value}
: 不应用透视，等价于无限远的距离。

`<length ≥ 0px>`{:.value}
: 到投影中心的距离。


`perspective-origin`{:.prop}
{:#perspective-origin}

取值： | \<perspective-origin-x\> <span class="prop-def-symbol" title="one or both must be specified">\|\|</span> \<perspective-origin-y\>
初始值： | 50% 50%
适用于： | 所有元素
继承： | 否
百分比： | 相对于元素边框盒的大小

描述 `perspective`{:.prop} 属性的原点。这是一个简写属性，其基础属性沿每个维度指定如下。

`perspective-origin-x`{:.prop}：\[left \| center \| right \| \<length-percentage\>\]

`perspective-origin-y`{:.prop}：\[top \| center \| bottom \| \<length-percentage\>\]


#### 插值

RmlUi 对变换具有完整的插值支持，使其与动画和过渡结合使用时非常具有吸引力。

<video src="../animations/animation_sample.webm" width="640" height="360" poster="../animations/animation_sample_poster.png" preload="metadata" controls></video>

以下视频演示了主菜单上带变换的过渡。

<video src="../animations/game_main_menu.webm" width="640" height="360" poster="../animations/game_main_menu_poster.png" preload="metadata" controls></video>

通过对元素应用变换，我们可以通过改变透视和原点，基本上就像在三维空间中移动摄像机一样，如下所示。

<video src="../animations/game_menu_transform.webm" width="640" height="360" poster="../animations/game_menu_transform_poster.png" preload="metadata" controls></video>
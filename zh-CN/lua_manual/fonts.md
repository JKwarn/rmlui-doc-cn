---
layout: page
title: 加载字体
parent: lua_manual
next: attaching_to_events
---

- [rmlui Lua API 参考](api_reference.html#rmlui)
- [加载字体 C++ 手册](../cpp_manual/fonts.html)

---

Lua 插件安装了一个全局表 `rmlui`，它提供了一种从 Lua 加载受支持字体文件的方法。加载字体面的最简单方式是执行 `LoadFontFace()` 函数，参数为一个字符串，即要加载的字体文件名：

```python
rmlui.LoadFontFace('../assets/LatoLatin-Regular.ttf')
rmlui.LoadFontFace('../assets/LatoLatin-Bold.ttf')
```

不过，您还可以提供两个附加参数（按此顺序）：

- 一个 `fallback` 选项，类型为 `boolean`。启用后，它会使给定的字体面用于其他字体中的任何未知字符。例如，这对于为 emoji 提供一个单一字体面、再为西里尔字母（Cyrillic）、希腊字母等字符提供另一个字体面非常有用。当遇到的字符不在文档指定的字体中时，就会使用这些字体。可以使用多个回退字体面，它们将按照加载顺序获得优先级。
- 一个 `face_index` 参数，类型为 `integer`。它允许在字体集合中选择字体面。这对于加载包含多个字体的单个字体文件非常有用。

在此示例中，加载了同一字体面的不同字重，因为它们都属于同一个文件（请参阅 [OpenType Font Variations](https://learn.microsoft.com/en-us/typography/opentype/spec/otvaroverview)），并且包含了一个用于 emoji 的回退字体：

```python
rmlui.LoadFontFace('data/NotoSansJP-VariableFont_wght.ttf', false, 0)
rmlui.LoadFontFace('data/NotoSansJP-VariableFont_wght.ttf', false, 1)
rmlui.LoadFontFace('data/NotoSansJP-VariableFont_wght.ttf', false, 2)
rmlui.LoadFontFace('seguiemj.ttf', true)
```
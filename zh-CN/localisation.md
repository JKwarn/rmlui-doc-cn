---
layout: page
title: 本地化
---

RmlUi 通过下述接口完整支持本地化。

### 字符串编码

RmlUi 假定它接收的所有数据（无论是从 RML 中读取还是以程序方式提供的）都是 UTF-8 编码。这意味着如果你使用的是 8 位 ASCII，则无需更改任何内容，但如果需要，你也可以指定多字节 Unicode 字符。

### 翻译

RmlUi 在解析 RML 时读取的所有原始文本（即除 XML 标签之外的所有内容）都会通过[系统接口](cpp_manual/interfaces/system.html)上的 `TranslateString()` 函数发送。该函数接收读取到的原始字符串，应用程序可以在将翻译后的字符串（以及所做替换的数量）返回给 RmlUi 之前进行任何必要的修改。

一个直接透传的翻译器可以这样实现：

```cpp
#include <RmlUi/Core/SystemInterface.h>

class SampleSystemInterface : public Rml::SystemInterface
{
	int TranslateString(Rml::String& translated, const Rml::String& input) override
	{
		translated = input;
		return 0;
	}
```

#### 字符串表

`TranslateString()` 方法可以与应用程序的字符串表结合使用，对文档的文本进行替换。例如，以 _Rocket Invaders_ 示例中的 pause.rml 文件为例：

```html
<rml>
	<head>
		<title>Quit?</title>
	</head>
	<body>
		<p>Are you sure you want to end this game?</p>
		<button>Yes</button>
		<button>No!</button>
	</body>
</rml>
```

如果我们要对 _Rocket Invaders_ 进行本地化，我们希望将所有英文字符串从 RML 中移出并放入字符串表。然后，RML 中的原始文本将被替换为字符串表的标记：

```html
<rml>
	<head>
		<title>[QUIT_TITLE]</title>
	</head>
	<body>
		<p>[QUIT_CONFIRM]</p>
		<button>[CONFIRM]</button>
		<button>[DENY]</button>
	</body>
</rml>
```

假设应用程序有一个 `StringTable` 类，并且已为相应语言加载了合适的字符串表，那么我们的示例翻译器将变成：

```cpp
	int TranslateString(Rml::String& translated, const Rml::String& input) override
	{
		// Attempt to find the translation in the string table.
		if (StringTable::GetString(translated, input))
			return 1;

		// No translation; return the raw input string.
		translated = input;
		return 0;
	}
```

现在，无论我们为哪种语言指定字符串表，这些字符串都将有效。在实践中，你可能需要一个更复杂的翻译器，能够在字符串中替换多个标记。

请注意，你可以将 RML 放入翻译后的字符串中，它将被适当地解析。例如，你可以用一个 `<img>`{:.tag} 标签替换某个标记，以渲染控制器按钮的图标。
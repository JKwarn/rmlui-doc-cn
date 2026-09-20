---
layout: page
title: 文件接口
parent: cpp_manual/interfaces
grandparent: cpp_manual
next: font_engine
---

文件接口控制 RmlUi 如何打开和读取文件，例如字体、RCSS 和 RML 文件。如果你不安装自定义文件接口，RmlUi 将默认使用标准 C 文件 I/O API，并尝试从当前工作目录打开文件。如果这对你的应用程序来说已经足够，你将不需要提供自定义文件接口。

文件接口提供在 `<RmlUi/Core/FileInterface.h>`{:.incl} 中。要开发自定义文件接口，请创建一个派生自 `Rml::FileInterface` 的类，并为纯虚函数提供函数定义：

```cpp
// Opens a file.
virtual Rml::FileHandle Open(const Rml::String& path) = 0;

// Closes a previously opened file.
virtual void Close(Rml::FileHandle file) = 0;

// Reads data from a previously opened file.
virtual size_t Read(void* buffer, size_t size, Rml::FileHandle file) = 0;

// Seeks to a point in a previously opened file.
virtual bool Seek(Rml::FileHandle file, long offset, int origin) = 0;

// Returns the current position of the file pointer.
virtual size_t Tell(Rml::FileHandle file) = 0;
```

这些函数原型应该相当不言自明。`Open()` 函数返回并被传入其他函数的 `Rml::FileHandle` 类型是一个 void 指针类型。它可以是你需要用于唯一标识每个已打开文件的任何值，但是 NULL（0）值保留给无效文件句柄，所以确保你不要用它来表示有效句柄！

`Open()` 接受为打开文件的任何系统提供的字符串值；这可能通过字体数据库、RML 文档中的样式表引用等。根据你如何配置文件接口，它不必是一个文件路径。该函数应在成功打开时返回非 NULL 文件句柄，如果打开失败则返回 NULL。

RmlUi 在读取完先前打开的文件后会调用 `Close()`。

`Read()` 函数应从文件的当前文件指针位置开始，将 size 字节读入 buffer。应返回实际读取的字节数，文件指针应相应增加。

`Seek()` 将文件指针定位到文件内的给定位置。参数与 C 函数 `fseek()` 相同；origin 是 `SEEK_SET`（文件开头）、`SEEK_CUR`（文件指针的当前位置）或 `SEEK_END`（文件末尾）之一，offset 是从 origin 起的偏移量（以字节为单位）。如果 seek 操作由于某种原因失败则返回 false，否则返回 true。

`Tell()` 应返回文件指针的位置，作为从文件开头起的字节偏移量。
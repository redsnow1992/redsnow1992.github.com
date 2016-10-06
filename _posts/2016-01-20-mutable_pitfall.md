---
title: mutable pitfall
date: 2016-01-20 16:00
categories: programming
tags:
- ruby
- pitfall
- mutable
---

今天测试一个项目的scala版本和ruby版本的时候，出现了这样的错误，我把这个错误用一段ruby代码复现了一下：
``` ruby
class Track
  attr_accessor :cover_path
end

def picture_url(path)
  puts path
  path << "-some-suffix"
end

t = Track.new
t.cover_path = File.join("first", "second")
picture_url(t.cover_path)
picture_url(t.cover_path)
picture_url(t.cover_path)
```
在 `picture_url` 这个函数的调用中，每次都会打印传入的参数，表面来看调用的地方，
传入的都是 `t.cover_path` 这个参数，应该输出是一样的，可是：
```
first/second
first/second-some-suffix
first/second-some-suffix-some-suffix
```
`path` 这个参数在函数里面被改变了，然后这个改变传到了外面，就这样灾难开始了。
这种代码一旦发生就很难调试，让我们拥抱 immutable 吧。但如果把 `<<` 改为 `+=` 就不会出现这个问题，我不太建议这么做，看者像 mutable。如果把 `path <<` 改为 `path.concat` 这样 `mutable` 问题就更容易暴露出来。

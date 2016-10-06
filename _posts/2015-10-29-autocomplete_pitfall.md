---
title: autocomplete pitfall
date: 2015-10-29  09:40
categories: programming
tags: pitfall
---
firefox会在页面重载（还有前进、后退）的时候缓存form中的所有字段，而chrome却不会。

当然要避免firefox的这一行为也很简单，给 `input` 标签多加一个属性 `autocomplete=off` ，

也可以给整个 `form` 加上这个属性，当需要对某个 `input` 特别对待的时候，就把该属性加到该 `input` 。

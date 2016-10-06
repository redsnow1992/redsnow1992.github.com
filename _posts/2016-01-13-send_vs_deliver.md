---
title: Sent vs Delivered
date: 2016-01-13  13:40
categories: english
tags: word
---
看zookpeer的[这篇文档](http://zookeeper.apache.org/doc/trunk/zookeeperInternals.html) 的时候，有如下一段英文：

	Ordered delivery
	   Data is delivered in the same order it is sent and a message m is delivered only after all messages sent
	   before m have been delivered. (The corollary to this is that if message m is lost all messages after m will 
	   be lost.)

这段文字讲的是TCP的一个特性，发送的有序性和接收的有序性。以前认为 `sent` 和 `delivered` 这两个词是相同的，但如果是相同的，那么上述这段文字就很难理解了， `Data is delivered in the same order it is sent`这段话使用了这两个词，如果这两个词意思相同，那么这段话就会变成 `Data is sent in the same order it is sent` ，这段话就不知道想表达什么。于是我查了下 `sent` 和 `delivered` 的意思，得到了如下的解释：

	"Sent" is just that something has been despatched. 例如发送邮件用的就是sent，东西没有直接给对方，而是给了第三方，再由第三方给对方
	"Delivered" means that the goods have arrived at their desitnation and have been received.

有了如上的解释，上面的这段话就好理解了。

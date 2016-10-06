---
title: implicit笔记_Evidence_implicitNotFound_CanBuildFrom
date: 2015-10-22 17:00
categories: programming
tags: scala
---

# Evidence
```  scala
T =:= U   // equal 
T <:< U   // a subtype of u
T <%< U   // view-convertible to u
```
使用上述的类型约束的时候，还需要我们提供隐式参数，我们以 `<:<` 为例，有如下使用：
```  scala
def firstLast[A, C](it: C)(implicit ev: C <:< Iterable[A]) =
  (it.head, it.last)
```
在 `Predef` Object中定义了 `<:<` 和其隐式值，2.11.7中定义如下：
```  scala
@implicitNotFound(msg = "Cannot prove that ${From} <:< ${To}.")
sealed abstract class <:<[-From, +To] extends (From => To) with Serializable
private[this] final val singleton_<:< = new <:<[Any,Any] { def apply(x: Any): Any = x }
// The dollar prefix is to dodge accidental shadowing of this method
// by a user-defined method of the same name (SI-7788).
// The collections rely on this method.
implicit def $conforms[A]: A <:< A = singleton_<:<.asInstanceOf[A <:< A]
```
在2.9.3定义如下：
```  scala
@implicitNotFound(msg = "Cannot prove that ${From} <:< ${To}.")
sealed abstract class <:<[-From, +To] extends (From => To) with Serializable
private[this] final val singleton_<:< = new <:<[Any,Any] { def apply(x: Any): Any = x }
// not in the <:< companion object because it is also
// intended to subsume identity (which is no longer implicit)
implicit def conforms[A]: A <:< A = singleton_<:<.asInstanceOf[A <:< A]
```
从上我们可以看出这个类继承自一个单参数函数，从一定意义上讲我们可以将 `<:<` 的对象视做函数。
当编译器处理 `implicit ev: String <:< AnyRef` 这样一个约束的时候，它会在伴生对象中查找 `String <:< AnyRef`
的隐式对象，因为 `From` 为协变， `To` 为逆变，故而 `<:<.conforms[String]` 可作为 `String <:< AnyRef` 的实例。
而将 `ev` 称为一个 `evidence object` 是因为 `String` 很明显是 `AnyRef` 的子类型。
`ev` 的函数性体现在隐式转换中，将参数进行包裹转换（其实还是类型转换）。
``` scala
def firstLast[A, C](it: C)(implicit ev: C <:< Iterable[A]) =
  (ev(it).head, ev(it).last)
```
**@implicitNotFound标记** 在以上代码中就有使用该标记，为了给程序员有用的错误信息。

# 难啃的骨头 `CanBuildFrom[Repr, B, That]`
``` scala
"abc".map(_.toUpper) // => String
"abc".map(_.toInt) // => Vector
```
上述代码的返回类型发现变化，正是 `CanBuildFrom` 搞的鬼，具体的分析参见[Here](http://hongjiang.info/scala-canbuildfrom-detail)。
`Repr` 被隐式转换为 `StringOps` ， `B` 为 `toInt` 的返回值， `That` 则表示 `map` 返回的类型。

一个简易版本的 `ArrayBuffer` ：
``` scala
trait Builder[-E,+To] {
  def +=(e: E): Unit
  def result(): To
}

trait CanBuildFrom[-Form, -E, +To] {
  def apply(): Builder[E, To]
}

class Buffer[E : Manifest] extends Iterable[E, Buffer[E]]
  with Builder[E, Buffer[E]] {
  private var elems = new Array[E](10)
  ...
  def iterator() = ...
    private var i = 0
    def hasNext = i < length
    def next() = { i += 1; elems(i - 1) }
  }
  def +=(e: E) = { ... }
  def result() = this
}

object Buffer {
  implicit def canBuildFrom[E : Manifest] = new CanBuildFrom[Buffer[_], E, Buffer[E]] {
    def apply() = new Buffer[E]
  }
}
```

# 一些tips
1. 要检测是否存在一个隐式对象，则可以在REPL中使用如下方法，例如：
```  scala
scala> implicitly[String <:< AnyRef] 
res0: <:<[String,AnyRef] = <function1>
```

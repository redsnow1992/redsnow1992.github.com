---
title: Scala Style
date: 2015-07-30 11:31
categories: programming
tags: scala
---
本文相对于是对[该目录](http://docs.scala-lang.org/style/)下的内容的截取翻译。
# 缩进
代码使用2个space缩进。
```scala
class Foo {
  def bar = ..
}
```
## 单行表达式换行
+ 换行产生的行应该相对于第一行缩进2个space
+ 每个断行应该以未闭合的括号或者中缀方法结尾

```scala
val result = 1 + 2 + 3 + 4 + 5 + 6 +
  7 + 8 + 9 + 10 + 11 + 12 + 13 + 14 +
  15 + 16 + 17 + 18 + 19 + 20
```
## 调用多参数方法
将每个参数放在一个单行，并相对于方法名缩进2个space
```scala
foo(
  someVeryLongFieldName,
  andAnotherVeryLongFieldName,
  "this is a string",
  3.1415)
```
```scala
val myOnerousAndLongFieldNameWithNoRealPoint = 
  foo(
    someVeryLongFieldName,
    andAnotherVeryLongFieldName,
    "this is a string",
    3.1415)
```
# 命名约定
Scala使用驼峰式，而下划线是非常不鼓励的，因为它在Scala语法中有特殊的含义。

## Class/Trait
驼峰式＋第一个字母大写
```scala
class MyFairLady
```
## Object
一般和Class的命名方式相同，除非想模仿一个package或者function。以下是特例情况：
```scala
object ast {
  sealed trait Expr
  case class Plus(e1: Expr, e2: Expr) extends Expr
  ...
}
object inc {
  def apply(x: Int): Int = x + 1
}
```
## package
遵循java package的命名约定
```scala
// wrong!
package coolness
// right!
package com.novell.coolness
// right, for package object com.novell.coolness
package com.novell
/**
 * Provides classes related to coolness
 */
package object coolness {
}
```
## method
驼峰式
```scala
def myFairMethod = ...
```
### Accessor/Mutator
Scala不使用set/get来表示mutator和accessor，而使用以下的约定：
+ 属性的访问：方法名和属性名相同
+ 一般后缀`is`表示一个返回Boolean的accessor
+ 对于mutator，使用属性名＋后缀`_=`

```scala
class Foo {
  def bar = ...
  def bar_=(bar: Bar) {
    ...
  }
  def isBaz = ...
}
val foo = new Foo
foo.bar             // accessor
foo.bar = bar2      // mutator
foo.isBaz           // boolean property
```
### 括号
于Ruby不同，Scala会给声明时是否带括号的无参函数附加不同的含义。
网站上对这部分讲得并不详细，以下的内容和例子来自[此处](http://hongjiang.info/scala-parenthesis-and-apply/)，无参函数的定义惯例是：
1. 方法没有参数
2. 方法不会改变状态（无副作用）

**不对等：**
```scala
def foo() = println("nl") 
scala> foo   // OK

def bar = println("nl")
scala> bar()
  error: Unit does not take parameters
```
后者报错是因为`bar()`被翻译为`(bar).apply()`，而`bar`返回`Unit`类型的值，这类值没有`apply`方法。

### 符号式方法名
主要使用在以下两种场合：

+ DSL（eg: actor ! Msg）
+ 逻辑数学运算（eg: a + b or c :: d）

官方建议：尽量别用

## 类型参数（泛型）
一般而言对于简单的类型参数，一个大写字母足以（按照英文字母序），从A开始（不同于Java的以T开始）：
```scala
class List[A] {
  def map[B](f: A => B): List[B] = ...
}
```
当类型参数有更明确的含义是，可以使用一个表述性的词（命名遵循Class的命名）：
```scala
// Right
class Map[Key, Value] {
  def get(key: Key): Value
  def put(key: Key, value: Value): Unit
}
// Also right
class Map[K, V] {
  def get(key: K): V
  def put(key: K, value: V): Unit
}
 
// Wrong; don't use all-caps
class Map[KEY, VALUE] {
  def get(key: KEY): VALUE
  def put(key: KEY, value: VALUE): Unit
}
```
**高阶示例**：
```scala
class HigherOrderMap[Key[_], Value[_]] { ... }

def doSomething[M[_]: Monad](m: M[Int]) = ...
```
# Type
## 推导
在保证清晰性的前提下，尽量使用类型推导。
不该对私有属性或者本地变量标明类型，因为它们值非常明显的出卖了自己的类型。
当然对于不明确或者复杂的赋值通常还是标明类型。
所有的公开函数都都应该显式地声明类型，这样可以保证内部代码修改之后，对于调用者而言是透明的。而且这样做可以提高编译效率。

### 函数值
函数值支持一个类型推导的特例：
```scala
val ls: List[String] = ...
ls map (str => str.toInt)
```
这种情况下，Scala已经知道我们声明的函数的值，所以没必要在标明（`str`就是这样）。
## 函数
当函数为一个参数时，可以省略括号，不会声明成这样`(A) => B`
```scala
def foo(f: Int => String) = ...
def bar(f: (Boolean, Double) => List[String]) = ...

// wrong!
def foo(f: (Int) => (String) => (Boolean) => Double) = ...
// right!
def foo(f: Int => String => Boolean => Double) = ...
```
## 结构型参数
当结构型参数比较多时，单独将其提取成一个类型：
```scala
def foo(a: { def bar(a: Int, b: Int): String; val baz: List[String =>
String] }) = ...

private type FooParam = {
  val baz: List[String => String]
  def bar(a: Int, b: Int): String
}
```
# 声明
## Class
当构造函数的参数太多时，将每个参数方在一个单行，并缩进4个space
```scala
class Person(name: String, age: Int) {
}

class Person(
    name: String,
    age: Int,
    birthdate: Date,
    astrologicalSign: String,
    shoeSize: Int,
    favoriteColor: java.awt.Color) {
  def firstMethod: Foo = ...
}
```
如果某个Class/Object/Trait还extends了其他东西，需要将它们每个方在单行，并且缩进2个space
```scala
class Person(
    name: String,
    age: Int,
    birthdate: Date,
    astrologicalSign: String,
    shoeSize: Int,
    favoriteColor: java.awt.Color) 
  extends Entity
  with Logging
  with Identifiable
  with Serializable {
}
```
### 类中元素的顺序
一般情况下属性在方法之前，特例就是有些val是用block来定义的，就需要当作方法来对待了。
```scala
class Foo {
  val bar = 42
  val baz = "Daniel"

  def doSomething(): Unit = { ... }
  def add(x: Int, y: Int): Int = x + y
  val test = {  // method-like  }
}
```
### 方法
1. 一般情况
```scala
def foo(bar: Baz): Bin = expr
```
2. 带有默认参数
```scala
def foo(x: Int = 6, y: Int = 7): Int = x + y
```
#### 方法的Modifiers顺序
1. Annotations
2. override
3. protected, private
4. final
5. def
```scala
@Transaction
@throws(classOf[IOException])
override protected final def foo() {
  ...
}
```
#### 方法体
1. 单行
```scala
def add(a: Int, b: Int): Int = a + b
```
2. 两行
```scala
def sum(ls: List[String]): Int =
  ls.map(_.toInt).foldLeft(0)(_ + _)
```
3. 多行
```scala
def sum(ls: List[String]): Int = {
  val ints = ls map (_.toInt)
  ints.foldLeft(0)(_ + _)
}
```
4. 带有`match`表达式（`match`和方法名同行）
```scala
def sum(ls: List[Int]): Int = ls match {
  case hd :: tail => hd + sum(tail)
  case Nil => 0
}
```
#### 多个参数列表
1. 可以定制自己的"control structures"
```scala
def unless(exp: Boolean)(code: => Unit): Unit = if (!exp) code
unless(x < 5) { 
  println("x was not less than five")
}
```
2. 当只想对某些参数使用`implicit`的时候，必须用多个参数列表
3. 只使用部分参数列表调用一个方法时，类型推导器允许以一种更简单的方法来设置其余参数列表：
```scala
def foldLeft[B](z: B)(op: (A,B) => B): B
List("").foldLeft(0)(_ + _.length)   // 不需要指定 B
以上是标准函数
如果我们改成以下的，就必须指定类型
def foldLeft[B](z: B, op: (B, A) => B): B
List("").foldLeft(0, (b: Int, a: String) => a + b.length)
List("").foldLeft[Int](0, _ + _.length)
```
#### 高阶函数
当高阶函数的最后一个参数是函数并且curried时，Scala允许一种更好的语法来调用它：
SML定义`foldl`方法如下：
```SML
fun foldl (f: ('b * 'a) -> 'b)(init: 'b)(ls 'a list) = ...
```
而Scala却相反：
```scala
def foldLeft[A, B](ls: List[A])(init: B)(f: (B, A) => B): B = ...
```
通过将函数型参数放到最后面，我们可以用以下方式调用：
```scala
foldLeft(List(1, 2, 3, 4))(0)(_ + _)
```
### lazy放在val之前
```scala
private lazy val foo = bar()
```
## 函数值
以下四种方式是等价的：
```scala
val f1 = ((a: Int, b: Int) => a + b)
val f2 = (a: Int, b: Int) => a + b
val f3 = (_: Int) + (_: Int)
val f4: (Int, Int) => Int = (_ + _)
```
多表达式函数：
```scala
val f1 { (a: Int, b: int) =>
  val sum = a + b
  sum
}
```
# 控制结构
所有的控制结构都应该和定义的关键字留1个space：
```scala
// right!
if (foo) bar else baz
for (i <- 0 to 10) { ... }
while (true) { println("Hello, World!") }

// wrong!
if(foo) bar else baz
for(i <- 0 to 10) { ... }
while(true) { println("Hello, World!") }
```
## 大括号
1. `if`：当只有一个`else`时省略大括号，其他时候都用大括号。
2. `while`：总是使用大括号。
3. `for`：当有一个`yield`时省略大括号，其他时候都用大括号。
4. `case`：总是省略`case`语句中的大括号。

```scala
val news = if (foo)
  goodNews()
else
  badNews()

if (foo) {
  println("foo was true")
}

news match {
  case "good" => println("Good news!")
  case "bad" => println("Bad news!")
}
```
## Comprehensions
Scala中for-comprehensions不仅是一个生成器：
```scala
// wrong!
for (x <- board.rows; y <- board.files) 
  yield (x, y)

// right!
for {
  x <- board.rows
  y <- board.files
} yield (x, y)
```
当Comprehensions只是一个生成器时，应当使用第一种形式：`for (i <- 0 to 10) yield i`
而当for-comprehensions没有`yield`时，也应当使用第一种形式：
```scala
// wrong!
for {
  x <- board.rows
  y <- board.files
} {
  printf("(%d, %d)", x, y)
}

// right!
for (x <- board.rows; y <- board.files) {
  printf("(%d, %d)", x, y)
}
```
最后for-comprehensions通常会和`map`，`flatMap`，`filter`连用。
# 方法调用
## 无参函数
```scala
reply()
// is the same as
reply
```
当且仅当该函数没有副作用时，例如`queue.size`，而`println()`就不行。
### 中缀形式
Scala允许无参函数的中缀形式调用：
```scala
names.toList
// is the same as

names toList // Unsafe, don't use!
```
更可能会造成编译器错误：（虽然在2.11.6中并没有报错），但这种写法任然不好：
```scala
names toList
val answer = 42 
```
## 单参函数
两种调用形式：
```scala
names.mkString(",")
// is the same as
names mkString ","
```
中缀形式依然应该只用于无副作用的方法。
```scala
// right!
names foreach (n => println(n))
names mkString ","
optStr getOrElse "<empty>"

// wrong!
javaList add item
```
### 高阶函数
类似`map`，`filter`这样的高阶函数应该使用中缀形式，虽然一下调用是合法的：
```scala
names.map (_.toUpperCase)     // 并不好
```
以上调用有个缺点就是无法将方法调用串起来：
```scala
names.map (_.toUpperCase).filter (_.length > 5) // 并不好
// right!
names map (_.toUpperCase) filter (_.length > 5)
```
# 文件管理
一般伴生对象和其对应的类或者trait在同一个文件中：
```scala
package com.novell.coolness
class Inbox { ... }
// companion object
object Inbox { ... }
```
sealed trait和多个子类在同一个文件中：
```
sealed trait Option[+A]
case class Some[A](a: A) extends Option[A]
case object None extends Option[Nothing]
```

# ScalaDoc示例
## 通常如此
```scala
/** This is a brief description of what's being documented.
  *
  * This is further documentation of what we're documenting.  It should
  * provide more details as to how this works and what it does. 
  */
def myMethod = {}

/** Does something very simple */
def simple = {}
```
## package
```scala
package parent.package.name

/** This is the ScalaDoc for the package. */
package object mypackage {
}
```
更多文档，引用其他类时，使用方括号：
```scala
package my.package
/** Provides classes for dealing with complex numbers.  Also provides
  * implicits for converting to and from `Int`.
  *
  * ==Overview==
  * The main class to use is [[my.package.complex.Complex]], as so
  * {{{
  * scala> val complex = Complex(4,3)
  * complex: my.package.complex.Complex = 4 + 3i
  * }}}
  *
  * If you include [[my.package.complex.ComplexConversions]], you can 
  * convert numbers more directly
  * {{{
  * scala> import my.package.complex.ComplexConversions._
  * scala> val complex = 4 + 3.i
  * complex: my.package.complex.Complex = 4 + 3i
  * }}} 
  */
package complex {}
```
## 类
```scala
/** A person who uses our application.
  *
  * @constructor create a new person with a name and age.
  * @param name the person's name
  * @param age the person's age in years 
  */
class Person(name: String, age: Int) {
}
```
## object
```scala
/** Factory for [[mypackage.Person]] instances. */
object Person {
  /** Creates a person with a given name and age.
    *
    * @param name their name
    * @param age the age of the person to create 
    */
  def apply(name: String, age: Int) = {}
  /** Creates a person with a given name and birthdate
    *
    * @param name their name
    * @param birthDate the person's birthdate
    * @return a new Person instance with the age determined by the 
    *         birthdate and current date. 
    */
  def apply(name: String, birthDate: java.util.Date) = {}
}
```
当object中有隐式转换时，应在文档中给出示例：
```scala
/** Implicit conversions and helpers for [[mypackage.Complex]] instances.
  *
  * {{{
  * import ComplexImplicits._
  * val c: Complex = 4 + 3.i
  * }}} 
  */
object ComplexImplicits {}
```









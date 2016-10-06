---
title: scala-traits
date: 2015-05-15 14:33
updated: 2015-05-15 14:33
categories: programming
tags: scala
---
# Traits
Traits are a fundamental unit of code reuse in Scala. A trait encapsulates method and field definitions, which can then be reused by mixing them into classes.

## How traits work
```scala
trait Philosophical {
  def philosophize() {
    println("I consume memory, therefore I am!")
  }
}

class Frog extends Philosophical {
  override def toString = "green"
}
```
Once a trait is defined, it can be *mixed* in to a class using either the `extends` or `with` keywords.

```scala
val frog = new Frog
frog.philosophize()
```
A trait also defines a type. Here's an example in which `Philosophical` is used as a type.

```scala
val phil: Philosophical = frog  // here trait acts as a superclass
phil.philosophize()
```
The type of `phil` is `Philosophical`, a trait. Thus, variable phil could have been initialized with any object whose class mixes in `Philosophical`.

```scala
class Animal
trait HasLegs
class Frog extends Animal with Philosophical with HasLegs {
  override def toString = "green"

  override def philosophize() {
    println("It ain't easy being "+ toString +"!")
  }
}

val phrog: Philosophical = new Frog
phrog.philosophize()   // => "It ain't ... "
```
## Thin versus rich interfaces
One major use of traits is to **automatically add methods to a class** in terms of methods the class **already has**.

```scala
trait CharSequence {
  def charAt(index: Int): Char
  def length: Int
  def subSequence(start: Int, end: Int): CharSequence
  def toString(): String
}
```
You only need to implement the method once, in the trait itself, instead of needing to reimplement it for every class that mixes in the trait.
## Example: Rectanglar objects
original class-version:

```scala
class Point(val x: Int, val y: Int)
class Rectangle(val topLeft: Point, val bottomRight: Point) {
  def left = topLeft.x
  def right = bottomRight.x
  def width = right - left
}

abstract class Component {
  def topLeft: Point
  def bottomRight: Point
  def left = topLeft.x
  def right = bottomRight.x
  def width = right - left
  // and many more geometric methods...
}
```
changed to trait-version:

```scala
trait Rectangular {
  def topLeft: Point    // abstract
  def bottomRight: Point   // abstract

  def left = topLeft.x     // concrete
  def right = bottomRight.x   // concrete
  def width = right - left    // concrete
}

abstract class Component extends Rectangular {
}
class Rectangle(val topLeft: Point, val bottomRight: Point) extends Rectangular {
}
```
## The Ordered trait
```scala
class Rational(n: Int, d: Int) extends Ordered[Rational] {
 //  ...
 def compare(that: Rational) =
   (this.numer * that.denom) - (that.numer * this.denom)

  /// not need to define >, <, <=, >=
}
```
## Traits as *statckable* modifications
Traits let you *modify* the methods of a class, and they do so in a way that allows you to *stack* those modifications with each other.

+ **Doubling**: double all integers that are put in the queue
+ **Incrementing**: increment all integers that are put in the queue
+ **Filtering**: filter out negative integers from a queue

```scala
abstract class IntQueue {
  def get(): Int
  def put(x: Int)
}

import scala.collection.mutable.ArrayBuffer

class BasicIntQueue extends IntQueue {
  private val buf = new ArrayBuffer[Int]
  def get() = buf.remove(0)
  def put(x: Int) { buf += x }
}

trait Doubling extends IntQueue {
  abstract override def put(x: Int) { super.put(2 * x) }
}

class MyQueue extends BasicIntQueue with Doubling
// val queue = new BasicIntQueue with Doubling

trait Incrementing extends IntQueue {
  abstract override def put(x: Int) { super.put(x + 1) }
}

trait Filtering extends IntQueue {
  abstract override def put(x: Int) {
    if (x >= 0) super.put(x)
  }
}
```
```scala
val queue = (new BasicIntQueue with Incrementing with Filtering)
call put --> Filtering --> Incrementing --> BasicIntQueue

val queue = (new BasicIntQueue with Filtering with Incrementing)
```
## Why not multiple inheritance
Traits are a way to inherit from multiple class-like constructs, but they differ in important ways from the multiple inheritance present in many languages. One difference is especially important: the interpretation of `super`. 
With multiple inheritance, the method called by a `super` call can be determined right where the call appears. With traits, the method called is determined by a *linearization* of the classes and traits that are mixed into a class. 
This is the difference that enables the stacking of modifications described in the previous section.

The main properties of Scala’s linearization are illustrated by the following example:

```scala
class Animal
trait Furry extends Animal
trait HasLegs extends Animal
trait FourLegged extends HasLegs
class Cat extends Animal with Furry with FourLegged
```
arrows with white, triangular arrowheads indicate *inheritance*, with the arrowhead pointing to the supertype. The arrows with darkened, non-triangular arrowheads depict *linearization*. 
The darkened arrowheads point in the direction in which super calls will be resolved.     
Each class **appears only once** in `cat`'s linearization.    
![scala_inheritance_linearization](http://images.cnblogs.com/cnblogs_com/hard-work/689518/o_cat.jpg)

## To trait, or not to trait?
Whenever you implement a reusable collection of behavior, you will have to decide whether you want to use a trait or an abstract class. There is no firm rule, but this section contains a few guidelines to consider:

+ If the behavior will not be reused, then make it a concrete class. It is not reusable behavior after all.
+ If it might be reused in multiple, unrelated classes, make it a trait. Only traits can be mixed into different parts of the class hierarchy.
+ If you want to inherit from it in Java code, use an abstract class.
+ If you plan to *distribute it in compiled form*, and you expect outside groups to write classes inheriting from it, you might lean towards using an abstract class. **The issue is that when a trait gains or loses a member,
any classes that inherit from it must be recompiled, even if they have not changed**. **If outside clients will only call into the behavior, instead of inheriting from it, then using a trait is fine**.
+ If efficiency is very important, lean towards using a class. Most Java runtimes make a virtual method invocation of a class member a faster operation than an interface method invocation. 
**Traits get compiled to interfaces and therefore may pay a slight performance overhead**. However, you should make this choice only if you know that the trait in question constitutes a
performance bottleneck and have evidence that using a class instead actually solves the problem.
+ If you still do not know, after considering the above, then start by making it as a trait. You can always change it later, and in general using a trait keeps more options open.
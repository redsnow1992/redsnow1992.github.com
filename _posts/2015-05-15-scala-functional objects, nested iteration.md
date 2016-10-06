---
title: scala-functional objects, nested iteration
date: 2015-05-15 14:34
updated: 2015-05-15 14:34
categories: programming
tags: scala
---
## Functional Objects
Functional Objects do not have any mutable state.   

The `Rational` class Example:

1. Constructing a `Rational`
2. Reimplementing the `toString` method
3. Checking preconditions
4. Adding fields(`that` could refer to)
5. Self references
6. Auxiliary constructors
7. Private fields and methods
8. Defining operators
9. Method overloading
10. Implicit conversions

In scala, every auxiliary constructors **must invoke another constructors**
of the same class as its first action.

```scala
class Rational(n: Int, d: Int){       // 1
  require(d != 0)            // 3
  private val g = gcd(n.abs, d.abs)  // 7

  val numer: Int = n / g   // 4
  val denom: Int = d / g   // 4

  def this(n: Int) = this(n, 1)     // 6

  override def toString = numer + "/" + denom  // 2

  def add(that: Rational): Rational =
    new Rational(numer * that.denom + that.numer * denom, denom * that.denom)

  def lessThan(that: Rational) =   // 5
    this.numer * that.denom < that.numer * this.denom

  def max(that: Rational) =  // 5
    if(this.lessThan(that)) that else this

  def + (that: Rational): Rational =  // 8
    add(that)

  def + (i: Int): Rational =  // 9
    new Rational(numer + i * denom, denom)

  private def gcd(a: Int, b: Int): Int =   // 7
    if (b == 0) a else gcd(b, a % b)
}
implicit def intToRational(x: Int) = new Rational(x) // 10
```
scala类的初始化函数方法的定义：
1. 定义一个基础初始化方法
2. 若需要其他初始化方法，在这个新的初始化函数中调用 1 中定义的方法

## Nested iteration
```scala
def fileLines(file: java.io.File) =
  scala.io.Source.fromFile(file).getLines().toList

def grep(pattern: String) =
  for(
    file <- files
    if file.getName.endsWith(".scala");
    line <- fileLines(file)
    trimmed = line.trim
    if trimmed.matches(pattern)
  ) println(file + ": " + trimmed)  

grep(".*gcd.*")
```
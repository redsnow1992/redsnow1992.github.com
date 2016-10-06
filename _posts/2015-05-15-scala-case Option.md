---
title: scala-case Option
date: 2015-05-15 14:35
updated: 2015-05-15 14:35
categories: programming
tags: scala
---
# Case Class and Pattern Matching
## A simple example
```scala
abstract class Expr

case class Var(name: String) extends Expr
case class Number(name: Double) extends Expr
case class UnOp(operator: String, arg: Expr) extends Expr
case class BinOp(operator: String, left: Expr, right: Expr) extends Expr

val v = Var("x")                       // 1
val op = BinOp("+", Number(1), v)      // 1
v.name ;  op.left                      // 2
op.right == Var("x")  // true          // 3
op.copy(operator = "-")                // 4
```
The other noteworthy thing about the declarations of above is that each subclass has a `case` modifier. Classes with such a modifier are called *case classes*. 
Using the modifier makes the Scala compiler add some syntactic conveniences to your class.

1. Adds a factory method with the name of the class. 
2. All arguments in the parameter list of a case class implicitly get a `val` prefix, so they are maintained as fields.
3. The compiler adds "natural" implementations of methods `toString`, `hashCode` , and `equals` to your class.
4. The compiler adds a `copy` method to your class for making modified copies.

**Pattern matching** 

```scala
def simplifyTop(expr: Expr): Expr = expr match {
  case UnOp("-", UnOp("-", e)) => e
  case BinOp("+", e, Number(0)) => e
  case BinOp("*", e, Number(1)) => e
  case _ => expr
}
```
**different from java `switch`**

1. `match` is an expression in Scala, i.e., it always results in a value.
2. Scala's alternative expressions never "fall through" into the next case.
3. If none of the patterns match, an exception named `MatchError` is thrown.

## Kinds of patterns
**Wildcard patterns**

```scala
expr match {
case BinOp(_, _, _) => println(expr +" is a binary operation")
case _ => println("It's something else")
}
```
**Constant patterns**

```scala
def describe(x: Any) = x match {
  case 5 => "five"
  case true => "truth"
  case "hello" => "hi!"
  case Nil => "the empty list"
  case _ => "something else"
}
```

**Variable patterns**   
**A variable pattern matches any object, just like a wildcard**. Unlike a wildcard, Scala binds the variable to whatever the object is.

*Variable or contant?*

```scala
import math.{E, Pi}

E match {
  case Pi => "strange math? Pi = "+ Pi
  case _ => "OK"
}
// => OK

val pi = math.Pi
E match {
  case pi => "strange math? Pi = "+ pi
}
// strange math? Pi = 2.718281828459045   !!!!

E match {
  case pi => "strange math? Pi = "+ pi
  case _ => "OK"
}
output: 
warning: patterns after a variable pattern cannot match (SLS 8.1.1)
              case pi => "strange math? Pi = "+ pi
                   ^
<console>:12: warning: unreachable code due to variable pattern 'pi' on line 11
              case _ => "OK"
                        ^
<console>:12: warning: unreachable code
              case _ => "OK"
// `pi` would again be interpreted as a constant, not as a variable
E match {
  case `pi` => "strange math? Pi = "+ pi`
  case _ => "OK"
}
// OK
```

**Constructor patterns**    
A constructor pattern looks like `BinOp("+", e, Number(0))`. These extra patterns mean that Scala patterns support *deep* matches.
Such patterns not only check the top-level object supplied, but also check the contents of the object against further patterns.

```scala
expr match {
  case BinOp("+", e, Number(0)) => println("a deep match")
  case _ =>
}
```

**Sequence, Tuple, Typed patterns**    
You can match against sequence types like List or Array just like you match against case classes. Use the same syntax, but now you can specify any number of elements within the pattern.

```scala
expr match {
  case List(0, _, _)    => println("found it")
  case 0::_             => println("zero first list")  // List(0, _*)
  case _                =>
}

def tupleDemo(expr: Any) =
  expr match {
    case (a, b, c)  =>  println("matched "+ a + b + c)
    case _ =>
}

def generalSize(x: Any) = x match {
  case s: String        => s.length
  case m: Map[_, _]     => m.size
  case _                => -1
}
```
Note that, even though `s` and `x` refer to the same value, the type of `x`
is `Any` , but the type of `s` is `String`.    
**But ...**

```scala
def isIntIntMap(x: Any) = x match {
  case m: Map[Int, Int] => true
  case _ => false
}
warning: non-variable type argument Int in type pattern scala.collection.immutable.Map[Int,Int] (the underlying of Map[Int,Int]) is
unchecked since it is eliminated by erasure
       case m: Map[Int, Int] => true
               ^
isIntIntMap: (x: Any)Boolean
```
Scala uses the *erasure* model of generics, just like Java does. This means that no information about type arguments is maintained at runtime.
Consequently, there is no way to determine at runtime whether a given `Map` object has been created with two `Int` arguments, rather than with arguments of different types.
The **only exception** to the erasure rule is arrays, because they are handled specially in Java as well as in Scala. The element type of an array is stored
with the array value, so you can pattern match on it.

```scala
def isStringArray(x: Any) = x match {
  case a: Array[String] => "yes"
  case _ => "no"
}
```

**Variable binding**   
In addition to the standalone variable patterns, you can also add a variable to any other pattern. You simply write the variable name, an at sign (@), and
then the pattern. This gives you a variable-binding pattern. The meaning of  such a pattern is to perform the pattern match as normal, and if the pattern
succeeds, **set the variable to the matched object just as with a simple variable pattern**.

```scala
expr match {
  case UnOp("abs", e @ UnOp("abs", _)) => e
  case _ =>
}
```

## Pattern guards
```scala
def simplifyAdd(e: Expr) = e match {
  case BinOp("+", x, x) => BinOp("*", x, Number(2))
  case _ => e

  // pattern guard
  case BinOp("+", x, y) if x == y =>
    BinOp("*", x, Number(2))
}
error: x is already defined as value x
       case BinOp("+", x, x) => BinOp("*", x, Number(2))
```
This fails, because Scala restricts patterns to be linear: a pattern variable may only appear once in a pattern. However, you can re-formulate the match with a `pattern guard`.

## Pattern overlaps
```scala
def simplifyAll(expr: Expr): Expr = expr match {
  case UnOp("-", UnOp("-", e)) =>
    simplifyAll(e)
  case BinOp("+", e, Number(0)) =>
    simplifyAll(e)
  case BinOp("*", e, Number(1)) =>
    simplifyAll(e)
  case UnOp(op, e) =>
    UnOp(op, simplifyAll(e))
  case BinOp(op, l, r) =>
    BinOp(op, simplifyAll(l), simplifyAll(r))
  case _ => expr
}

def simplifyBad(expr: Expr): Expr = expr match {
  case UnOp(op, e) => UnOp(op, simplifyBad(e))
  case UnOp("-", UnOp("-", e)) => e
}
warning: unreachable code
       case UnOp("-", UnOp("-", e)) => e
```
## Sealed classes
Whenever you write a pattern match, you need to make sure you have covered all of the possible cases. Sometimes you can do this by adding a default
case at the end of the match, but that only applies if there is a sensible default behavior. What do you do if there is no default? How can you ever feel safe
that you covered all the cases?    
The alternative is to make the superclass of your case classes `sealed`. A sealed class cannot have any new subclasses added except the ones in the same file.    
If you match against case classes that inherit from a sealed class, the compiler will flag missing combinations of patterns with a warning message.

```scala
sealed abstract class Expr

case class Var(name: String) extends Expr
case class Number(name: Double) extends Expr
case class UnOp(operator: String, arg: Expr) extends Expr
case class BinOp(operator: String, left: Expr, right: Expr) extends Expr
```
Now define a pattern match where some of the possible cases are left out:

```scala
def describe(e: Expr): String = e match {
  case Number(_) => "a number"
  case Var(_)    => "a variable"
}

warning: match may not be exhaustive.
It would fail on the following inputs: BinOp(_, _, _), UnOp(_, _)
       def describe(e: Expr): String = e match {
```
If we don't use `sealed`, the warning will not be reported.

```scala
def describe(e: Expr): String = e match {
  case Number(_) => "a number"
  case Var(_) => "a variable"
  case _ => throw new RuntimeException // Should not happen
}

def describe(e: Expr): String = (e: @unchecked) match {
  case Number(_) => "a number"
  case Var(_)    => "a variable"
}
```
## The `Option` type
Scala has a standard type named `Option` for optional values. Such a value can be of two forms. It can be of the form `Some(x)` where `x` is the actual
value. Or it can be the `None` object, which represents **a missing value**.   
Optional values are produced by some of the standard operations on Scala's collections. For instance, the get method of Scala's `Map` produces
`Some(value)` if a value corresponding to a given key has been found, or  `None` if the given key is not defined in the `Map`.   
The most common way to take optional values apart is through a pattern match. For instance:

```scala
def show(x: Option[String]) = x match {
  case Some(s) => s
  case None => "?"
}
```
## Patterns everywhere
```scala
val myTuple = (123, "abc")
val (number, string) = myTuple

val exp = new BinOp("*", Number(5), Number(1))
val BinOp(op, left, right) = exp
```
**Case sequences as partial functions**

```scala
val withDefault: Option[Int] => Int = {
  case Some(x) => x
  case None => 0
}
withDefault(Some(10))
withDefault(None)

val second: List[Int] => Int = {
  case x :: y :: _ => y
}
warning: match may not be exhaustive.
It would fail on the following inputs: List(_), Nil
       val second: List[Int] => Int = {

// change to
val second: PartialFunction[List[Int],Int] = {
  case x :: y :: _ => y
}
second.isDefinedAt(List(5,6,7))  // true
second.isDefinedAt(List())       // false
// translated to 
new PartialFunction[List[Int], Int] {
  def apply(xs: List[Int]) = xs match {
    case x :: y :: _ => y
  }
  def isDefinedAt(xs: List[Int]) = xs match {
    case x :: y :: _ => true
    case _ => false
  }
}
```
**Patterns in `for` expressions**

```scala
for ((country, city) <- capitals)
  println("The capital of "+ country +" is "+ city)

val results = List(Some("apple"), None, Some("orange"))
for (Some(fruit) <- results) println(fruit)
apple
orange
```

**List Match**

```scala
def isort(xs: List[Int]): List[Int] = xs match {
  case List() => List()
  case x :: xs1 => insert(x, isort(xs1))
}
def insert(x: Int, xs: List[Int]): List[Int] = xs match {
  case List() => List(x)
  case y :: ys => if (x <= y) x :: xs
  else y :: insert(x, ys)
}
def append[T](xs: List[T], ys: List[T]): List[T] =
  xs match {
    case List() => ys
    case x :: xs1 => x :: append(xs1, ys)
  }
```
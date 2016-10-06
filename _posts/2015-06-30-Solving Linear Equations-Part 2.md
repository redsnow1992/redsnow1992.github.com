---
title: Solving Linear Equations-Part 2
date: 2015-06-30 10:16
categories: math
tags: linear algebra
mathjax: true
---
# Rules for Matrix Operations
When $A$ has $m$ rows and $n$ columns, it is an "$m$ by $n$" matrix. Matrices can be added if their shapes are the same.
$$
\begin{bmatrix}
1 & 2\\\\
3 & 4\\\\
0 & 0
\end{bmatrix}+\begin{bmatrix}
2 & 2\\\\
4 & 4\\\\
9 & 9
\end{bmatrix}=\begin{bmatrix}
3 & 4\\\\
7 & 8\\\\
9 & 9
\end{bmatrix}\qquad and\qquad2\begin{bmatrix}
1 & 2\\\\
3 & 4\\\\
0 & 0
\end{bmatrix}=\begin{bmatrix}2 & 4\\\\
6 & 8\\\\
0 & 0
\end{bmatrix}
$$
Matrix addition is easy. The serious question is *matrix multiplication*. When can we multiply $A$ times $B$, and what is the product $AB$? We cannot multiply when $A$ and $B$ are $3$ by $2$. They don't pass the following test:
> To multiply AB: If A has n columns, B must have n rows.

In every case $AB$ is filled with dot products. For the top corner, the $(1,1)$ entry for $AB$ is $(row\; 1\; of\; A)\cdot(column\; 1\; of\; B)$.

$$
\begin{bmatrix}\*\\\\
a\_{i1} & a\_{i2} & \cdots &  & a\_{i5}\\\\
\*\\\\
\*
\end{bmatrix}\begin{bmatrix}\* & \* & b\_{1j} & \* & \* & \*\\\\
 &  & b\_{2j}\\\\
 &  & \vdots\\\\
\\\\
 &  & b\_{5j}
\end{bmatrix}=\begin{bmatrix} &  & \*\\\\
\* & \* & (AB)\_{ij} & \* & \* & \*\\\\
 &  & \*\\\\
 &  & \*
\end{bmatrix}
$$
## Rows and Columns of $AB$
**Each column of $AB$ is a combination of the columns of $A$**. That is the column picture of matrix multiplication:
$$\text{Matrix A times column of B}\qquad A[b_1 \cdots b_p]=[Ab_1 \cdots Ab_p]$$
**Row picture is reversed**:
$$\text{Row times matrix}\qquad [row\; i\; of\; A] 
\begin{bmatrix}
1 & 2 & 3\\\\
4 & 5 & 6\\\\
7 & 8 & 9
\end{bmatrix} = [row \; i \; of \; AB]
$$
## The Laws for Matrix Operations
### Addition laws:
$$
A+B=B+A \qquad (commutative\; law)  \\\\
c(A+B)=cA+cB \qquad (distributive\; law)   \\\\
A+(B+C)=(A+B)+C \qquad (associative\; law)
$$
### Multiplication laws:
$$
AB\ne BA \qquad (\text{the commutative "law" is usually broken}) \\\\
C(A+B)=CA+CB \qquad (\text{distributive law from the left}) \\\\
(A+B)C=AC+BC \qquad (\text{distributive law from the right}) \\\\
A(BC)=(AB)C \qquad (\text{associative law for ABC})
$$
## Block Matrices and Block Multiplication
$$
\text{4 by 6 matrix 2 by 3 blocks} \quad
A=\left[\begin{array}{cc|cc|cc}1 & 0 & 1 & 0 & 1 & 0\\\\
0 & 1 & 0 & 1 & 0 & 1\\\\
\hline
1 & 0 & 1 & 0 & 1 & 0\\\\
0 & 1 & 0 & 1 & 0 & 1
\end{array}\right]
=\begin{bmatrix}I & I & I\\\\
I & I & I
\end{bmatrix}
$$
**Block multiplication:** If the cuts between columns of $A$ match the cuts between rows of $B$, then block multiplication of $AB$ is allowed:
$$
\begin{bmatrix}A\_{11} & A\_{12} \\\\
A\_{21} & A\_{22}
\end{bmatrix}=\begin{bmatrix}B\_{11} & \cdots \\\\
B\_{21} & \cdots
\end{bmatrix}=\begin{bmatrix}A\_{11}B\_{11}+A\_{21}B\_{21} & \cdots \\\\
A\_{21}B\_{11}+A\_{22}B\_{21} & \cdots
\end{bmatrix}
$$
**Important special case:**
1. Columns times rows
$$
\begin{bmatrix}| &  & \|\\\\
a\_{1} & \cdots & a\_{n}\\\\
\| &  & \|
\end{bmatrix}\begin{bmatrix}\- & b\_{1} & \-\\\\
 & \vdots\\\\
\- & b\_{n} & \-
\end{bmatrix}=\begin{bmatrix}\\\\
a\_{1}b\_{1}+\cdots+a\_{n}b\_{n}\\\\
\\\\
\end{bmatrix}
$$
2. Matrix add matrix
$$
\begin{bmatrix}1 & 4\\\\
1 & 5
\end{bmatrix}\begin{bmatrix}3 & 2\\\\
1 & 0
\end{bmatrix}=\begin{bmatrix}1\\\\
1
\end{bmatrix}\begin{bmatrix}3 & 2\end{bmatrix}+\begin{bmatrix}1\\\\
1
\end{bmatrix}\begin{bmatrix}1 & 0\end{bmatrix}=\begin{bmatrix}3 & 2\\\\
3 & 2
\end{bmatrix}+\begin{bmatrix}4 & 0\\\\
5 & 0
\end{bmatrix}
$$

**Elimination by blocks:**
$$
\text{One at a time}\qquad
E\_{21}=\begin{bmatrix}1 & 0 & 0\\\\
-3 & 1 & 0\\\\
0 & 0 & 1
\end{bmatrix}\quad and\quad E\_{31}=\begin{bmatrix}1 & 0 & 0\\\\
0 & 1 & 0\\\\
-4 & 0 & 1
\end{bmatrix}
$$
The "block idea" is to do both eliminations with one matrix $E$. That matrix clears out the whole first column of $A$ below the pivot $a=1$:
$$
E=\begin{bmatrix}1 & 0 & 0\\\\
-3 & 1 & 0\\\\
0 & 0 & 1
\end{bmatrix}\quad multiples\quad \begin{bmatrix}1 & x & x\\\\
3 & x & x\\\\
4 & x & x
\end{bmatrix}\quad to\; give \quad EA=\begin{bmatrix}1 & x & x\\\\
0 & x & x\\\\
0 & x & x
\end{bmatrix} \\\\
Block\; elimination \qquad
\left[\begin{array}{c|c}I & 0 \\\\
\hline
-CA^{-1} & I
\end{array}\right]
\left[\begin{array}{c|c}A & B \\\\
\hline
C & D
\end{array}\right]=
\left[\begin{array}{c|c}A & B \\\\
\hline
0 & D-CA^{-1}B
\end{array}\right]
$$
















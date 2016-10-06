---
title: Linear Algebra Preface
date: 2015-06-07 09:31
categories: math
tags: linear algebra
mathjax: true
---
When the matrix has *m* rows, each column is a vector in *m*-dimensional space. The crucial operation in linear algebra is taking **linear combinations of vectors**.When we take all linear combinations of the column vectors, we get the *column space*. If this space includes the vector b, we can solve the equation $Ax=b$.
# The Start of Course
The equation $Ax=b$ uses the language of linear combinations right away. The vector $Ax$ is a combination of the columns of $A$. The equation is asking for ** a combination that produces b**. The solution vector $x$ comes at three levels and all are important:
1. **Direct solution** to find $x$ by forward elimination and back substiution.
2. **Matrix solution** using the inverse of $A: x=A^{-1}b $ (if $A$ has an inverse).
3. **Vector space solution** $x = y + z$ as shown on the cover of the book:      **Particular solution** (to $Ay=b$) plus **nullspace solution** (to $Az=0$). 

# Structure of Textbook
The books moves gradually and steadily from *numbers* to *vectors* to *subspaces* --each level comes naturally and everyone can get it.
Here are ten points abouts the organization of this book:

+ Chapter 1 starts with vectors and dot products and then linear combinations.
+ Chapter 2 shows the row picture and the column picture of $Ax=b$.
+ Chapter 3 is linear algebra at the best level: *subspaces*.
+ Chapter 4 has *m* equations and only *n* unknowns.
+ Chapter 5 shows **Determinants**.
+ Chapter 6 **introduces eigenvalues for 2 by 2 matrices**.
+ Chapter 7 explains the **linear transformation** approach.
+ Chapter 8 is full of applications.
+ Every sections in the basic course ends with a **Review of the Key Ideas**.
+ How should computing be included in a linear algebra courses?

# The variety of Linear Algebra
*The truth is that vectors and matrices have become the language to know*. Part of that language is wonderful variety of matrices. Let me give three examples:
$$
\overset{Symmetrix\;matrix}{\begin{bmatrix}2 & -1 & 0 & 0 \\\\
-1 & 2 & -1 & 0  \\\\
0 & -1 & 2 & -1  \\\\
0 & 0 & -1 & 2
\end{bmatrix}}\quad\overset{Orthogonal\;matrix}{\frac{1}{2}\begin{bmatrix}1 & 1 & 1 & 1  \\\\
1 & -1 & 1 & -1  \\\\
1 & 1 & -1 & -1  \\\\
1 & -1 & -1 & 1
\end{bmatrix}}\quad\overset{Triangular\;matrix}{\begin{bmatrix}1 & 1 & 1 & 1 \\\\
0 & 1 & 1 & 1  \\\\
0 & 0 & 1 & 1   \\\\
0 & 0 & 0 & 1
\end{bmatrix}}
$$

A *key goal* is learning to "read" a matrix. You need to see the meaning in the numbers. This is really the essence of mathematrics--patterns and their meaning.


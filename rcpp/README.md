# Speeding up R wih C++ (Rcpp) - from basics to more advanced applications

Authors: Piotr WóJcik, [Faculty of Economic Sciences, University of Warsaw](https://www.wne.uw.edu.pl/)

### Description

Typical bottlenecks of programs in R are (1) loops that can not easily be vectorized, because   calculations in a given iteration depend on the results from the previous iterations; (2) recursive functions or problems that require multiple calling the same function.
C++ can help to solve these problems. It is a modern, fast and very well supported programming language with numerous additional libraries allowing to perform various types of computational tasks.

Thanks to the Rcpp package written by Dirk Eddelbuettel and Romain Francois combining C++ with R is very easy.
Various aspects of C++ and Rcpp will be discussed starting from simple examples that will help you easily replace the R code with often significantly faster counterparts in C++.

An earlier knowledge of C++ is NOT required, but it will probably be helpful.

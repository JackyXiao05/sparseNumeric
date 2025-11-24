
<!-- README.md is generated from README.Rmd. Please edit that file -->

## sparseNumeric

<!-- badges: start -->

[![R-CMD-check](https://github.com/JackyXiao05/sparseNumeric/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/JackyXiao05/sparseNumeric/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of ‘sparseNumeric’ is to provide an S4 class for representing
sparse numeric vectors - that is, vectors that contain many zeros - and
to turn the sparse-vector code from HW5 into a complete, well-documented
R package.

This package stors sparse vectors efficiently by keeping only the
non-zero values and their positions. It supports arithmetic operations
(ex. addition, multiplication, etc.) and dot product directly on the
sparse representation, so the full vector never needs to be rebulit.

In addition to basic arithmetic, the package also includes useful
statistical methods:

- ‘mean()’ - computes the mean of the vector, counding all zeros,
  without converting the vector back to dense form.
- ‘norm()’ - computes the Euclidean norm (the square root of the sum of
  squared values)
- ‘standardize()’ - standardizes the vector by subtracting its mean and
  dividing by its standard deviation.

All methods operate **directly on the sparse structure**, making them
both efficient and memory-friendly. The package includes roxygen2
documentation unit tests, a proper DESCRIPTION file, and Github Actions
to ensure the package passes R CMD check.

Along with these methods, the package includes:

- roxygen2 documentation for the class and all methods  
- a clean DESCRIPTION file with real metadata  
- unit tests written with **testthat**, reaching at least **90%
  coverage**  
- a passing **R CMD check**  
- a GitHub Actions workflow to run checks on every push  
- a `pkgdown` website documenting all functions

## Installation

You can install the development version of sparseNumeric from Github:

``` r
# install.packages("devtools")
devtools::install_github("JackyXiao05/sparseNumeric")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(sparseNumeric)

# Create a regular R vector
v <- c(0, 0, 5, 0, 3)

# Convert to sparse_numeric
s <- as(v, "sparse_numeric")

# Display the sparse object
s
#> An object of class 'sparse_numeric'
#>   length:5  nnz:2
#>   first nonzeros (pos:value):
#>    3:5
#>    5:3

# Compute statistics
mean(s)
#> [1] 1.6
norm(s)
#> Note: method with signature 'sparse_numeric#ANY' chosen for function 'norm',
#>  target signature 'sparse_numeric#missing'.
#>  "ANY#missing" would also be valid
#> [1] 5.830952
standardize(s)
#> [1] -0.6949956 -0.6949956  1.4768656 -0.6949956  0.6081211
```

# Standardize sparse_numeric vector

Centers and scales a `sparse_numeric` vector by subtracting the mean and
dividing by the sample standard deviation (like base
[`scale()`](https://rdrr.io/r/base/scale.html)), computed including
implicit zeros.

Centers and scales a `sparse_numeric` vector by subtracting the mean and
dividing by the sample standard deviation (like base
[`scale()`](https://rdrr.io/r/base/scale.html)), computed including
implicit zeros.

## Usage

``` r
standardize(x, ...)

# S4 method for class 'sparse_numeric'
standardize(x, ...)

standardize(x, ...)

# S4 method for class 'sparse_numeric'
standardize(x, ...)
```

## Arguments

- x:

  A `sparse_numeric` vector.

- ...:

  Additional arguments (ignored).

## Value

Numeric vector of the same length as `x` with standardized values (mean
0, sd 1).

Numeric vector of the same length as `x` with standardized values (mean
0, sd 1).

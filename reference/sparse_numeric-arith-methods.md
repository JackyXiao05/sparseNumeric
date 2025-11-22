# Methods for sparse_numeric arithmetic generics

These methods implement the actual arithmetic operations for
`sparse_numeric` vectors, corresponding to the exported generics
`sparse_add`, `sparse_sub`, `sparse_mult`, and `sparse_crossprod`.

These methods implement the actual arithmetic operations for
`sparse_numeric` vectors, corresponding to the exported generics
`sparse_add`, `sparse_sub`, `sparse_mult`, and `sparse_crossprod`.

## Usage

``` r
# S4 method for class 'sparse_numeric,sparse_numeric'
sparse_add(x, y, ...)

# S4 method for class 'sparse_numeric,sparse_numeric'
sparse_sub(x, y, ...)

# S4 method for class 'sparse_numeric,sparse_numeric'
sparse_mult(x, y, ...)

# S4 method for class 'sparse_numeric,sparse_numeric'
sparse_crossprod(x, y, ...)

# S4 method for class 'sparse_numeric,sparse_numeric'
sparse_add(x, y, ...)

# S4 method for class 'sparse_numeric,sparse_numeric'
sparse_sub(x, y, ...)

# S4 method for class 'sparse_numeric,sparse_numeric'
sparse_mult(x, y, ...)

# S4 method for class 'sparse_numeric,sparse_numeric'
sparse_crossprod(x, y, ...)
```

## Arguments

- x:

  A `sparse_numeric` vector.

- y:

  A `sparse_numeric` vector.

- ...:

  Additional arguments (ignored).

## Value

A `sparse_numeric` vector, except for `sparse_crossprod`, which returns
a numeric scalar.

A `sparse_numeric` vector, except for `sparse_crossprod`, which returns
a numeric scalar.

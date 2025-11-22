library(testthat)

test_that("validity method exists", {
  expect_false({
    validity_method <- getValidity(getClassDef("sparse_numeric"))
    is.null(validity_method)
  })
})

test_that("basic validity passes for a correct object", {
  expect_true({
    x <- new("sparse_numeric",
             value  = c(1, 2, 3, 1),
             pos    = c(1L, 2L, 3L, 5L),
             length = 5L)
    validObject(x)
  })
})

test_that("validity detects incorrect length slot after modification", {
  expect_error({
    x <- new("sparse_numeric",
             value  = c(1, 2, 3, 1),
             pos    = c(1L, 2L, 3L, 5L),
             length = 5L)
    x@length <- 2L
    validObject(x)
  })
})

test_that("validity fails when length slot has length > 1", {
  expect_error(
    new("sparse_numeric",
        value  = c(1),
        pos    = c(1L),
        length = c(3L, 4L))
  )
})

test_that("validity fails when length is negative", {
  expect_error(
    new("sparse_numeric",
        value  = c(1),
        pos    = c(1L),
        length = -3L)
  )
})

test_that("validity fails when length is NA", {
  expect_error(
    new("sparse_numeric",
        value  = c(1),
        pos    = c(1L),
        length = as.integer(NA))
  )
})

test_that("validity fails when value and pos lengths differ", {
  expect_error(
    new("sparse_numeric",
        value  = c(1, 2),
        pos    = c(1L),
        length = 3L)
  )
})

test_that("validity fails when pos has NA", {
  expect_error(
    new("sparse_numeric",
        value  = c(1),
        pos    = as.integer(NA),
        length = 3L)
  )
})

test_that("validity fails when pos is out of range", {
  expect_error(
    new("sparse_numeric",
        value  = c(1),
        pos    = 5L,
        length = 3L)
  )
})

test_that("validity fails when pos not strictly increasing", {
  expect_error(
    new("sparse_numeric",
        value  = c(1, 2),
        pos    = c(2L, 2L),
        length = 3L)
  )
})

test_that("validity fails when value contains zero", {
  expect_error(
    new("sparse_numeric",
        value  = c(0),
        pos    = c(1L),
        length = 3L)
  )
})

test_that("validity fails when value is non-finite", {
  expect_error(
    new("sparse_numeric",
        value  = c(Inf),
        pos    = c(1L),
        length = 3L)
  )
})

test_that("coercion from numeric to sparse_numeric returns correct class", {
  expect_s4_class({
    as(c(0, 0, 0, 1, 2), "sparse_numeric")
  }, "sparse_numeric")
})

test_that("numeric to sparse_numeric coercion stores only nonzeros", {
  z <- as(c(0, 2, 0, 4), "sparse_numeric")
  expect_s4_class(z, "sparse_numeric")
  expect_identical(z@pos, c(2L, 4L))
  expect_identical(z@value, c(2, 4))
  expect_identical(z@length, 4L)
})

test_that("numeric to sparse_numeric with all zeros produces empty slots", {
  z <- as(c(0, 0, 0, 0), "sparse_numeric")
  expect_s4_class(z, "sparse_numeric")
  expect_identical(z@pos, integer())
  expect_identical(z@value, numeric())
  expect_identical(z@length, 4L)
})

test_that("coercion from sparse_numeric to numeric works", {
  x <- new("sparse_numeric",
           value  = c(1, 3),
           pos    = c(1L, 4L),
           length = 5L)

  v1 <- as(x, "numeric")
  v2 <- as.numeric(x)

  expect_identical(v1, v2)
})

test_that("show method exists and works", {
  x <- new("sparse_numeric",
           value  = c(1, 2),
           pos    = c(1L, 2L),
           length = 4L)

  expect_no_error(getMethod("show", "sparse_numeric"))
  expect_output(show(x), "sparse_numeric")
})

test_that("show works for empty sparse vector", {
  x <- new("sparse_numeric",
           value  = numeric(),
           pos    = integer(),
           length = 5L)
  expect_output(show(x), "nnz:0")
})

test_that("show truncates output when many nonzeros", {
  x <- new("sparse_numeric",
           value  = as.numeric(1:12),
           pos    = as.integer(1:12),
           length = 12L)

  expect_output(show(x), "\\.\\.\\.")
})

test_that("plot method exists", {
  expect_no_error({
    getMethod("plot", c("sparse_numeric", "sparse_numeric"))
  })
})

test_that("plot runs without error when there is overlap", {
  x <- as(c(0, 1, 0, 2), "sparse_numeric")
  y <- as(c(3, 0, 4, 0), "sparse_numeric")

  tmp <- tempfile(fileext = ".png")
  grDevices::png(tmp, width = 800, height = 600)
  on.exit({ grDevices::dev.off(); unlink(tmp) }, add = TRUE)

  expect_invisible(plot(x, y))
})

test_that("plot works when there is no overlap", {
  x <- new("sparse_numeric",
           value  = c(1, 2),
           pos    = c(1L, 3L),
           length = 5L)

  y <- new("sparse_numeric",
           value  = c(4, 5),
           pos    = c(2L, 4L),
           length = 5L)

  tmp <- tempfile(fileext = ".png")
  grDevices::png(tmp, width = 800, height = 600)
  on.exit({ grDevices::dev.off(); unlink(tmp) }, add = TRUE)

  expect_silent(plot(x, y))
})

test_that("arithmetic method generics exist", {
  expect_no_error(getMethod("+", c("sparse_numeric", "sparse_numeric")))
  expect_no_error(getMethod("-", c("sparse_numeric", "sparse_numeric")))
  expect_no_error(getMethod("*", c("sparse_numeric", "sparse_numeric")))
})

test_that("sparse_* generics exist and have appropriate formals", {
  expect_true(isGeneric("sparse_add"))
  expect_true(isGeneric("sparse_mult"))
  expect_true(isGeneric("sparse_sub"))
  expect_true(isGeneric("sparse_crossprod"))

  expect_true(length(formals(sparse_add))       >= 2L)
  expect_true(length(formals(sparse_mult))      >= 2L)
  expect_true(length(formals(sparse_sub))       >= 2L)
  expect_true(length(formals(sparse_crossprod)) >= 2L)
})

test_that("basic arithmetic operations work", {
  x <- new("sparse_numeric",
           value  = c(1, 2, 3),
           pos    = c(1L, 3L, 5L),
           length = 5L)

  y <- new("sparse_numeric",
           value  = c(4, 5),
           pos    = c(2L, 5L),
           length = 5L)

  v_x <- as.numeric(x)
  v_y <- as.numeric(y)
  expect_length(v_x, 5)
  expect_length(v_y, 5)

  s  <- x + y
  d  <- x - y
  p  <- x * 2
  q  <- 2 * x

  expect_s4_class(s, "sparse_numeric")
  expect_s4_class(d, "sparse_numeric")
  expect_s4_class(p, "sparse_numeric")
  expect_s4_class(q, "sparse_numeric")
})

test_that("sparse_add returns correct class and values", {
  expect_s4_class({
    x <- as(c(0, 0, 0, 1, 2), "sparse_numeric")
    y <- as(c(1, 1, 0, 0, 4), "sparse_numeric")
    sparse_add(x, y)
  }, "sparse_numeric")

  result <- as(c(1, 1, 0, 1, 6), "sparse_numeric")
  expect_equal({
    x <- as(c(0, 0, 0, 1, 2), "sparse_numeric")
    y <- as(c(1, 1, 0, 0, 4), "sparse_numeric")
    sparse_add(x, y)
  }, result)

  result2 <- as(c(2, 4, 6, 10, 12), "sparse_numeric")
  expect_equal({
    x <- as(c(1, 3, 4, 1, 2), "sparse_numeric")
    y <- as(c(1, 1, 2, 9, 10), "sparse_numeric")
    sparse_add(x, y)
  }, result2)
})

test_that("sparse_add drops entries that sum to zero", {
  x <- as(c(1, 0, 0), "sparse_numeric")
  y <- as(c(-1, 0, 0), "sparse_numeric")

  z <- sparse_add(x, y)
  expect_identical(z@pos, integer())
  expect_identical(z@value, numeric())
})

test_that("sparse_mult and * work for overlapping nonzeros", {
  x <- new("sparse_numeric",
           value  = c(2, 3),
           pos    = c(1L, 3L),
           length = 4L)

  y <- new("sparse_numeric",
           value  = c(5, 7),
           pos    = c(1L, 2L),
           length = 4L)

  z1 <- sparse_mult(x, y)
  expect_s4_class(z1, "sparse_numeric")
  expect_identical(z1@pos, 1L)
  expect_identical(z1@value, 10)

  z2 <- x * y
  expect_s4_class(z2, "sparse_numeric")
  expect_identical(z2@pos, z1@pos)
  expect_identical(z2@value, z1@value)
})

test_that("mismatched lengths throw errors for arithmetic operations", {
  x <- new("sparse_numeric",
           value  = c(1, 2),
           pos    = c(1L, 2L),
           length = 3L)

  y <- new("sparse_numeric",
           value  = c(3, 4),
           pos    = c(1L, 2L),
           length = 4L)

  expect_error(sparse_add(x, y))
  expect_error(sparse_sub(x, y))
  expect_error(sparse_mult(x, y))
  expect_error(sparse_crossprod(x, y))

  x2 <- as(rep(0, 10), "sparse_numeric")
  y2 <- as(rep(0, 9), "sparse_numeric")
  expect_error(sparse_add(x2, y2))
})

test_that("length method returns correct logical length", {
  x <- new("sparse_numeric",
           value  = c(1, 2),
           pos    = c(1L, 2L),
           length = 4L)

  expect_identical(length(x), 4L)
})

test_that("mean works correctly for non-trivial sparse vector", {
  x_dense <- c(0, 0, 3, 0, 5)
  x <- as(x_dense, "sparse_numeric")
  expect_equal(mean(x), mean(x_dense))
})

test_that("mean of all-zero sparse_numeric is 0", {
  x <- as(c(0, 0, 0, 0), "sparse_numeric")
  expect_equal(mean(x), 0)
})

test_that("mean of length-0 sparse_numeric is NaN", {
  x0 <- new("sparse_numeric",
            value  = numeric(),
            pos    = integer(),
            length = 0L)
  m0 <- mean(x0)
  expect_true(is.nan(m0))
})

test_that("norm works correctly for non-trivial sparse vector", {
  x_dense <- c(0, 3, 4)
  x <- as(x_dense, "sparse_numeric")
  expect_equal(norm(x), sqrt(sum(x_dense^2)))
})

test_that("norm of all-zero sparse_numeric is 0", {
  x0 <- new("sparse_numeric",
            value  = numeric(),
            pos    = integer(),
            length = 5L)
  expect_identical(norm(x0, type = "2"), 0)
})

test_that("standardize works correctly", {
  x_dense <- c(0, 1, 2, 3, 4)
  x <- as(x_dense, "sparse_numeric")

  z <- standardize(x)

  expect_length(z, length(x_dense))
  expect_equal(mean(z), 0, tolerance = 1e-8)
  expect_equal(sd(z),   1, tolerance = 1e-8)
})

test_that("standardize errors on constant vector", {
  x <- as(c(1, 1, 1, 1), "sparse_numeric")
  expect_error(standardize(x))
})

test_that("standardize errors on very short vectors", {
  short1 <- new("sparse_numeric",
                value  = numeric(),
                pos    = integer(),
                length = 1L)
  expect_error(standardize(short1))

  short2 <- as(c(5), "sparse_numeric")
  expect_error(standardize(short2))
})

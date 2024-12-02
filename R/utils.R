#' Check that argument `x` is `n` character(s) long
#'
#' @param x `<chr>` unquoted, string; argument name
#'
#' @param n `<int>` number of characters `x` should be
#'
#' @autoglobal
#'
#' @noRd
check_nchar <- function(x, n) {

  if (!is.null(x)) {

    stopifnot(
      rlang::is_integerish(n),
      n > 0
      )

    arg  <- rlang::caller_arg(x)
    call <- rlang::caller_env()

    if (any(stringfish::sf_nchar(x) != n, na.rm = TRUE)) {
      cli::cli_abort(
        "{.arg {arg}} must be {.val {n}} character{?s} long.",
        arg = arg,
        call = call)
    }
    stringfish::sf_toupper(x)
  }
}

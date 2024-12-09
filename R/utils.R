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

  if (not_null(x)) {
    stopifnot(rlang::is_integerish(n), n > 0)

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

#' Read from a URL
#'
#' @param url `<chr>` url
#'
#' @autoglobal
#'
#' @keywords internal
#'
#' @export
read_url <- \(url) qs::qread_url(url)

#' Is `x` `NULL`?
#'
#' @param x vector
#'
#' @returns `<lgl>` `TRUE` if `x` is `NULL`, `FALSE` otherwise
#'
#' @autoglobal
#'
#' @noRd
null <- \(x) is.null(x)

#' Is `x` not `NULL`?
#'
#' @param x vector
#'
#' @returns `<lgl>` `FALSE` if `x` is `NULL`, `TRUE` otherwise
#'
#' @autoglobal
#'
#' @noRd
not_null <- \(x) !is.null(x)

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

    if (any(sf_chars(x) != n, na.rm = TRUE)) {
      cli::cli_abort(
        "{.arg {arg}} must be {.val {n}} character{?s} long.",
        arg = arg,
        call = call)
    }
    stringfish::sf_toupper(x)
  }
}

#' Valid Taxonomy Code with Regex
#'
#' @param code `<chr>` Health Care Provider Taxonomy code, a unique
#'  alphanumeric code, ten characters in length
#' @param negate `<lgl>` if `TRUE`, return `TRUE` for invalid codes
#'
#' @returns `<lgl>` vector
#'
#' @examples
#' valid_taxonomy_regex("103T00000X")
#'
#'
#' x <- c("207RA0002X", "207SG0207X", "207V10300X", "207WX0009X",
#'        "207WX0108X", "226000000X", "342000000X", "405300000X")
#'
#' valid_taxonomy_regex(x)
#'
#' x[!valid_taxonomy_regex(x)]
#' @autoglobal
#'
#' @noRd
valid_taxonomy_regex <- function(code, negate = FALSE) {
  stringi::stri_detect_regex(
    str     = code,
    pattern = "^[1-4][0-9]{2}[0-9A-HJ-NP-Z][0A-IL-NP-X][0-4][0-9][0-69][0-9][X]$",
    negate  = negate)
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
read_url <- function(url) qs::qread_url(url)

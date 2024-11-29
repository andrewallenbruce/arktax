#' Retrieve Taxonomy Source File
#'
#' @param year `<int>` year of source file release; options are `2009:2024`
#'
#' @param version `<int>` version of source file; options are `0` or `1`
#'
#' @param code `<chr>`  Health Care Provider Taxonomy code, a unique
#'   alphanumeric code, ten characters in length
#'
#' @returns `<tibble>` of search results
#'
#' @examples
#' retrieve_raw(year = 2024, code = "101Y00000X")
#'
#' retrieve_raw(code = "101Y00000X")
#'
#' @importFrom fuimus search_in_if
#'
#' @autoglobal
#'
#' @export
retrieve_raw <- function(year = NULL,
                         version = NULL,
                         code = NULL) {
  check_nchar(code, 10)
  pin <- get_pin("ark_taxonomy")
  pin <- search_in_if(pin, pin[["year"]], year)
  pin <- search_in_if(pin, pin[["version"]], version)
  pin <- search_in_if(pin, pin[["code"]], code)
  return(pin)
}

#' Retrieve Taxonomy Sources
#'
#' @param code `<chr>`  Health Care Provider Taxonomy code, a unique
#'   alphanumeric code, ten characters in length
#'
#' @returns `<tibble>` of search results
#'
#' @examples
#' retrieve_sources(code = "101Y00000X")
#'
#' retrieve_sources(code = "103TA0400X")
#'
#' @importFrom fuimus search_in_if
#'
#' @autoglobal
#'
#' @export
retrieve_sources <- function(code = NULL) {
  check_nchar(code, 10)
  pin <- get_pin("sources")
  search_in_if(pin, pin[["code"]], code)
}

#' Retrieve Taxonomy Changelog
#'
#' @param code `<chr>`  Health Care Provider Taxonomy code, a unique
#'   alphanumeric code, ten characters in length
#'
#' @returns `<tibble>` of search results
#'
#' @examples
#' retrieve_changelog(code = "103GC0700X")
#'
#' retrieve_changelog(code = "103G00000X")
#'
#' @importFrom fuimus search_in_if
#'
#' @autoglobal
#'
#' @export
retrieve_changelog <- function(code = NULL) {
  check_nchar(code, 10)
  pin <- get_pin("changelog")
  search_in_if(pin, pin[["code"]], code)
}

#' Retrieve Taxonomy Hierarchy
#'
#' @param code `<chr>`  Health Care Provider Taxonomy code, a unique
#'   alphanumeric code, ten characters in length
#'
#' @returns `<tibble>` of search results
#'
#' @examples
#' retrieve_hierarchy(code = "101Y00000X")
#'
#' retrieve_hierarchy(code = "103TA0400X")
#'
#' @importFrom fuimus search_in_if
#'
#' @autoglobal
#'
#' @export
retrieve_hierarchy <- function(code = NULL) {
  check_nchar(code, 10)
  pin <- get_pin("ark_long")
  search_in_if(pin, pin[["code"]], code)
}


#' Check that input is `n` character(s) long
#'
#' @param x `<chr>` string
#'
#' @param n `<int>` number of characters
#'
#' @autoglobal
#'
#' @noRd
check_nchar <- function(x, n) {

  if (!is.null(x)) {

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

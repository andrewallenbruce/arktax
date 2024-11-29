#' Raw Taxonomy File
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
#' taxonomy_raw(year = 2024, code = "101Y00000X")
#'
#' taxonomy_raw(code = "101Y00000X")
#'
#' @importFrom fuimus search_in_if
#'
#' @autoglobal
#'
#' @export
taxonomy_raw <- function(year = NULL,
                         version = NULL,
                         code = NULL) {
  check_nchar(code, 10)
  pin <- get_pin("raw")
  pin <- search_in_if(pin, pin[["year"]], year)
  pin <- search_in_if(pin, pin[["version"]], version)
  pin <- search_in_if(pin, pin[["code"]], code)
  return(pin)
}

#' Taxonomy Sources
#'
#' @param code `<chr>`  Health Care Provider Taxonomy code, a unique
#'   alphanumeric code, ten characters in length
#'
#' @returns `<tibble>` of search results
#'
#' @examples
#' taxonomy_sources(code = "101Y00000X")
#'
#' taxonomy_sources(code = "103TA0400X")
#'
#' @importFrom fuimus search_in_if
#'
#' @autoglobal
#'
#' @export
taxonomy_sources <- function(code = NULL) {
  check_nchar(code, 10)
  pin <- get_pin("sources")
  search_in_if(pin, pin[["code"]], code)
}

#' Taxonomy Change Log
#'
#' @param code `<chr>`  Health Care Provider Taxonomy code, a unique
#'   alphanumeric code, ten characters in length
#'
#' @returns `<tibble>` of search results
#'
#' @examples
#' taxonomy_changelog(code = "103GC0700X")
#'
#' taxonomy_changelog(code = "103G00000X")
#'
#' @importFrom fuimus search_in_if
#'
#' @autoglobal
#'
#' @export
taxonomy_changelog <- function(code = NULL) {
  check_nchar(code, 10)
  pin <- get_pin("changelog")
  search_in_if(pin, pin[["code"]], code)
}

#' Taxonomy Hierarchy
#'
#' @param code `<chr>`  Health Care Provider Taxonomy code, a unique
#'   alphanumeric code, ten characters in length
#'
#' @returns `<tibble>` of search results
#'
#' @examples
#' taxonomy_hierarchy(code = "101Y00000X")
#'
#' taxonomy_hierarchy(code = "103TA0400X")
#'
#' @importFrom fuimus search_in_if
#'
#' @autoglobal
#'
#' @export
taxonomy_hierarchy <- function(code = NULL) {
  check_nchar(code, 10)
  pin <- get_pin("hierarchy")
  search_in_if(pin, pin[["code"]], code)
}

#' Taxonomy Display Names
#'
#' @param code `<chr>`  Health Care Provider Taxonomy code, a unique
#'   alphanumeric code, ten characters in length
#'
#' @returns `<tibble>` of search results
#'
#' @examples
#' taxonomy_display(code = "101Y00000X")
#'
#' taxonomy_display(code = "103TA0400X")
#'
#' @importFrom fuimus search_in_if
#'
#' @autoglobal
#'
#' @export
taxonomy_display <- function(code = NULL) {
  check_nchar(code, 10)
  pin <- get_pin("display")
  search_in_if(pin, pin[["code"]], code)
}

#' Taxonomy Definitions
#'
#' @param code `<chr>`  Health Care Provider Taxonomy code, a unique
#'   alphanumeric code, ten characters in length
#'
#' @returns `<tibble>` of search results
#'
#' @examples
#' taxonomy_definition(code = "101Y00000X")
#'
#' taxonomy_definition(code = "103TA0400X")
#'
#' @importFrom fuimus search_in_if
#'
#' @autoglobal
#'
#' @export
taxonomy_definition <- function(code = NULL) {
  check_nchar(code, 10)
  pin <- get_pin("definitions")
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

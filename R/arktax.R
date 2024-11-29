#' Get Taxomony Source File
#'
#' @param year `<int>` year of source file release; options are `2009:2024`
#'
#' @param version `<int>` version of source file; options are `0` or `1`
#'
#' @param code `<chr>`  Health Care Provider Taxonomy code, a unique alphanumeric code, ten characters in length
#'
#' @param which `<chr>` `wide` or `long` version of the taxonomy
#'
#' @returns `<tibble>` of search results
#'
#' @examples
#' retrieve_ark(year = 2024, code = "101Y00000X", which = "wide")
#'
#' retrieve_ark(code = "101Y00000X", which = "long")
#'
#' @importFrom fuimus search_in_if
#'
#' @autoglobal
#'
#' @export
retrieve_ark <- function(year = NULL,
                         version = NULL,
                         code = NULL,
                         which = c("wide", "long")) {

  ark <- switch(
    which,
    wide = get_pin("ark_taxonomy"),
    long = get_pin("ark_long")
  )

  if (which == "wide") {
    ark <- search_in_if(ark, ark[["year"]], year)
    ark <- search_in_if(ark, ark[["version"]], version)
  }

  ark <- search_in_if(ark, ark[["code"]], code)

  return(ark)
}

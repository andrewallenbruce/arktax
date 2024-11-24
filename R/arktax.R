#' Get Taxomony Source File
#'
#' @param year `<int>` year of source file release; options are `2009:2024`
#'
#' @param code `<chr>` Taxonomy code
#'
#' @param which `<chr>` wide or long version of the taxonomy; options are `wide` or `long`
#'
#' @returns `<tibble>` of search results
#'
#' @examples
#' retrieve_ark(year = 2024, code = "101Y00000X", which = "wide")
#'
#' retrieve_ark(year = 2024, code = "101Y00000X", which = "long")
#'
#' @importFrom fuimus search_in_if
#'
#' @autoglobal
#'
#' @export
retrieve_ark <- function(year = NULL,
                         code = NULL,
                         which = c("wide", "long")) {

  ark <- switch(
    which,
    wide = get_pin("ark_taxonomy"),
    long = get_pin("ark_long")
  )

  ark <- search_in_if(ark, ark[["year"]], year)

  ark <- search_in_if(ark, ark[["code"]], code)

  return(ark)
}

#' Get Taxomony Source File
#'
#' @param year `<int>` year of rvu source file; default is `2020`
#'
#' @param code `<chr>` Taxonomy code
#'
#' @returns `<tibble>` of search results
#'
#' @examples
#' retrieve_ark(2024, "101Y00000X")
#'
#' @importFrom dplyr mutate
#' @importFrom data.table year
#' @importFrom fuimus search_in_if
#'
#' @autoglobal
#'
#' @export
retrieve_ark <- function(year = 2024, code = NULL) {

  ark <- get_pin("ark_taxonomy") |>
    mutate(year = as.character(year(release_date)))

  year <- match.arg(
    arg = as.character(year),
    choices = as.character(ark[["year"]]),
    several.ok = TRUE)

  ark <- search_in_if(ark, ark[["year"]], year)
  ark <- search_in_if(ark, ark[["code"]], code)

  return(ark)
}

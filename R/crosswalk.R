#' Raw Crosswalk File
#'
#' @param code `<chr>`  Health Care Provider Taxonomy code, a unique
#'   alphanumeric code, ten characters in length
#'
#' @returns `<tibble>` of search results
#'
#' @examples
#' crosswalk_raw(code = "103T00000X")
#'
#' head(crosswalk_raw(), 10)
#'
#' @importFrom fuimus search_in_if
#'
#' @autoglobal
#'
#' @export
crosswalk_raw <- function(code = NULL) {
  check_nchar(code, 10)
  pin <- get_pin("cross_raw")
  pin <- search_in_if(pin, pin[["taxonomy_code"]], code)
  return(pin)
}

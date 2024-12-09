#' Raw Crosswalk File
#'
#' @param taxonomy_code `<chr>`  Health Care Provider Taxonomy code, a unique
#'   alphanumeric code, ten characters in length
#'
#' @returns `<tibble>` of search results
#'
#' @examples
#' crosswalk_raw(taxonomy_code = "103T00000X")
#'
#' head(crosswalk_raw(), 10)
#'
#' @autoglobal
#'
#' @export
crosswalk_raw <- function(taxonomy_code = NULL) {

  check_nchar(taxonomy_code, 10)

  pin <- get_pin("cross_raw")

  pin <- search_in(pin, pin[["taxonomy_code"]], taxonomy_code)

  return(pin)
}

#' Taxonomy - Medicare Specialty Crosswalk
#'
#' @param taxonomy_code `<chr>`  Health Care Provider Taxonomy code, a unique
#'   alphanumeric code, ten characters in length
#'
#' @param specialty_code `<chr>`  Medicare Specialty Code, an alphanumeric code,
#'   two characters in length
#'
#' @returns `<tibble>` of search results
#'
#' @examples
#' crosswalk_taxonomy(taxonomy_code = "103T00000X")
#'
#' crosswalk_taxonomy(taxonomy_code = c("101YM0800X", "101YP2500X"))
#'
#' @autoglobal
#'
#' @export
crosswalk_taxonomy <- function(taxonomy_code = NULL,
                               specialty_code = NULL) {

  check_nchar(taxonomy_code, 10)
  check_nchar(specialty_code, 2)

  pin <- get_pin("cross_tax")

  pin <- search_in(pin, pin[["taxonomy_code"]], taxonomy_code)
  pin <- search_in(pin, pin[["specialty_code"]], specialty_code)

  return(pin)
}

#' Medicare Specialty Crosswalk Footnotes
#'
#' @param taxonomy_code `<chr>`  Health Care Provider Taxonomy code, a unique
#'   alphanumeric code, ten characters in length
#'
#' @param specialty_code `<chr>`  Medicare Specialty Code, an alphanumeric code,
#'   two characters in length
#'
#' @returns `<tibble>` of search results
#'
#' @examples
#' crosswalk_footnotes(taxonomy_code = "251E00000X")
#'
#' crosswalk_footnotes(specialty_code = "A0")
#'
#' @autoglobal
#'
#' @export
crosswalk_footnotes <- function(taxonomy_code = NULL,
                                specialty_code = NULL) {

  check_nchar(taxonomy_code, 10)
  check_nchar(specialty_code, 2)

  pin <- get_pin("cross_notes")

  pin <- search_in(pin, pin[["taxonomy_code"]], taxonomy_code)
  pin <- search_in(pin, pin[["specialty_code"]], specialty_code)

  return(pin)
}

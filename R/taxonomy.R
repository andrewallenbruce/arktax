#' Raw Taxonomy File
#'
#' @param year `<int>` year of source file release; options are `2009:2024`
#'
#' @param version `<int>` version of source file; options are `0` or `1`
#'
#' @param taxonomy_code `<chr>` Health Care Provider Taxonomy code, a unique
#'   alphanumeric code, ten characters in length
#'
#' @returns `<tibble>` of search results
#'
#' @examples
#' taxonomy_raw(year = 2024, taxonomy_code = "101Y00000X")
#'
#' taxonomy_raw(taxonomy_code = "101Y00000X")
#'
#' taxonomy_raw(taxonomy_code = c("101YM0800X", "101YP2500X")) |> print(n = 100)
#'
#' @importFrom fuimus search_in_if
#'
#' @autoglobal
#'
#' @export
taxonomy_raw <- function(year = NULL,
                         version = NULL,
                         taxonomy_code = NULL) {

  check_nchar(taxonomy_code, 10)

  pin <- get_pin("tax_raw")

  pin <- search_in_if(pin, pin[["year"]], year)
  pin <- search_in_if(pin, pin[["version"]], version)
  pin <- search_in_if(pin, pin[["code"]], taxonomy_code)

  return(pin)
}

#' Taxonomy Sources
#'
#' @param taxonomy_code `<chr>`  Health Care Provider Taxonomy code, a unique
#'   alphanumeric code, ten characters in length
#'
#' @returns `<tibble>` of search results
#'
#' @examples
#' taxonomy_sources(taxonomy_code = "101Y00000X")
#'
#' taxonomy_sources(taxonomy_code = "103TA0400X")
#'
#' @importFrom fuimus search_in_if
#'
#' @autoglobal
#'
#' @export
taxonomy_sources <- function(taxonomy_code = NULL) {

  check_nchar(taxonomy_code, 10)

  pin <- get_pin("tax_sources")

  search_in_if(pin, pin[["code"]], taxonomy_code)
}

#' Taxonomy Change Log
#'
#' @param taxonomy_code `<chr>`  Health Care Provider Taxonomy code, a unique
#'   alphanumeric code, ten characters in length
#'
#' @returns `<tibble>` of search results
#'
#' @examples
#' taxonomy_changelog(taxonomy_code = "103GC0700X")
#'
#' taxonomy_changelog(taxonomy_code = "103G00000X")
#'
#' @importFrom fuimus search_in_if
#'
#' @autoglobal
#'
#' @export
taxonomy_changelog <- function(taxonomy_code = NULL) {

  check_nchar(taxonomy_code, 10)

  pin <- get_pin("tax_changelog")

  search_in_if(pin, pin[["code"]], taxonomy_code)
}

#' Taxonomy Hierarchy
#'
#' @param taxonomy_code `<chr>`  Health Care Provider Taxonomy code, a unique
#'   alphanumeric code, ten characters in length
#'
#' @param taxonomy_level `<chr>`  Taxonomy level; options are `"I. Section"`,
#'   `"II. Grouping"`, `"III. Classification"` and `"IV. Specialization"`
#'
#' @param taxonomy_level_title `<chr>`  Taxonomy level title
#'
#' @returns `<tibble>` of search results
#'
#' @examples
#' taxonomy_hierarchy(taxonomy_code = "101Y00000X")
#'
#' taxonomy_hierarchy(taxonomy_code = "103TA0400X")
#'
#' taxonomy_hierarchy(taxonomy_level = "I. Section")
#'
#' taxonomy_hierarchy(taxonomy_level_title = "Allopathic & Osteopathic Physicians")
#'
#' @importFrom fuimus search_in_if
#'
#' @autoglobal
#'
#' @export
taxonomy_hierarchy <- function(taxonomy_code = NULL,
                               taxonomy_level = NULL,
                               taxonomy_level_title = NULL) {

  check_nchar(taxonomy_code, 10)

  pin <- get_pin("tax_hierarchy")

  pin <- search_in_if(pin, pin[["taxonomy_code"]], taxonomy_code)
  pin <- search_in_if(pin, pin[["taxonomy_level"]], taxonomy_level)
  pin <- search_in_if(pin, pin[["taxonomy_level_title"]], taxonomy_level_title)

  return(pin)
}

#' Taxonomy Display Names
#'
#' @param taxonomy_code `<chr>`  Health Care Provider Taxonomy code, a unique
#'   alphanumeric code, ten characters in length
#'
#' @returns `<tibble>` of search results
#'
#' @examples
#' taxonomy_display(taxonomy_code = "101Y00000X")
#'
#' taxonomy_display(taxonomy_code = "103TA0400X")
#'
#' @importFrom fuimus search_in_if
#'
#' @autoglobal
#'
#' @export
taxonomy_display <- function(taxonomy_code = NULL) {

  check_nchar(taxonomy_code, 10)

  pin <- get_pin("tax_display")

  search_in_if(pin, pin[["taxonomy_code"]], taxonomy_code)
}

#' Taxonomy Definitions
#'
#' @param taxonomy_code `<chr>`  Health Care Provider Taxonomy code, a unique
#'   alphanumeric code, ten characters in length
#'
#' @returns `<tibble>` of search results
#'
#' @examples
#' taxonomy_definition(taxonomy_code = "101Y00000X")
#'
#' taxonomy_definition(taxonomy_code = "103TA0400X")
#'
#' @importFrom fuimus search_in_if
#'
#' @autoglobal
#'
#' @export
taxonomy_definition <- function(taxonomy_code = NULL) {

  check_nchar(taxonomy_code, 10)

  pin <- get_pin("tax_definition")

  search_in_if(pin, pin[["taxonomy_code"]], taxonomy_code)
}

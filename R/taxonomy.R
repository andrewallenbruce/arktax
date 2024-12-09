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
#' @autoglobal
#'
#' @export
taxonomy_raw <- function(year = NULL,
                         version = NULL,
                         taxonomy_code = NULL) {

  check_nchar(taxonomy_code, 10)

  if (!exists(".tax_raw")) .tax_raw <- get_pin("tax_raw")

  x <- search_in(.tax_raw, .tax_raw[["year"]], year)
  x <- search_in(x, x[["code"]], taxonomy_code)
  x <- search_in(x, x[["version"]], version)

  return(x)
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
#' @autoglobal
#'
#' @export
taxonomy_sources <- function(taxonomy_code = NULL) {

  check_nchar(taxonomy_code, 10)

  if (!exists(".tax_sources")) .tax_sources <- get_pin("tax_sources")

  search_in(.tax_sources, .tax_sources[["code"]], taxonomy_code)
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
#' @autoglobal
#'
#' @export
taxonomy_changelog <- function(taxonomy_code = NULL) {

  check_nchar(taxonomy_code, 10)

  if (!exists(".tax_changelog")) .tax_changelog <- get_pin("tax_changelog")

  search_in(.tax_changelog, .tax_changelog[["code"]], taxonomy_code)
}

#' Taxonomy Hierarchy
#'
#' @param taxonomy_code `<chr>`  Health Care Provider Taxonomy code, a unique
#'   alphanumeric code, ten characters in length
#'
#' @param taxonomy_level `<chr>`  Taxonomy level; options are `"I. Section"`,
#'   `"II. Grouping"`, `"III. Classification"` and `"IV. Specialization"`
#'
#' @param taxonomy_title `<chr>`  Taxonomy level title
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
#' taxonomy_hierarchy(taxonomy_title = "Allopathic & Osteopathic Physicians")
#'
#' @autoglobal
#'
#' @export
taxonomy_hierarchy <- function(taxonomy_code = NULL,
                               taxonomy_level = NULL,
                               taxonomy_title = NULL) {

  check_nchar(taxonomy_code, 10)

  if (!exists(".tax_hierarchy")) .tax_hierarchy <- get_pin("tax_hierarchy")

  x <- search_in(.tax_hierarchy, .tax_hierarchy[["taxonomy_code"]], taxonomy_code)
  x <- search_in(x, x[["taxonomy_level"]], taxonomy_level)
  x <- search_in(x, x[["taxonomy_level_title"]], taxonomy_title)

  return(x)
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
#' @autoglobal
#'
#' @export
taxonomy_display <- function(taxonomy_code = NULL) {

  check_nchar(taxonomy_code, 10)

  if (!exists(".tax_display")) .tax_display <- get_pin("tax_display")

  search_in(.tax_display, .tax_display[["taxonomy_code"]], taxonomy_code)
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
#' @autoglobal
#'
#' @export
taxonomy_definition <- function(taxonomy_code = NULL) {

  check_nchar(taxonomy_code, 10)

  if (!exists(".tax_definition")) .tax_definition <- get_pin("tax_definition")

  search_in(.tax_definition, .tax_definition[["taxonomy_code"]], taxonomy_code)
}

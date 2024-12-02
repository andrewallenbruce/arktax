source(here::here("data-raw", "pins_internal.R"))

footnotes <- dplyr::tibble(
  note = as.character(1:14),
  note_description = readr::read_lines(
    here::here(
      "data-raw",
      "raw",
      "taxonomy_notes.txt")))

pin_update(
  footnotes,
  "cross_notes",
  "Medicare Taxonomy Crosswalk Footnotes 2024",
  "Medicare Provider and Supplier Taxonomy Crosswalk Footnotes 2024"
)

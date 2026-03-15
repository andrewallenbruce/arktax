source(here::here("data-raw", "fns.R"))

x <- list_pins()

x <- purrr::map(x, get_pin) |>
  rlang::set_names(x)

pin_update(
  x$tax_raw,
  name = "tax_raw",
  title = "NUCC Taxonomy Archive 2009-2024",
  description = "Health Care Provider Taxonomy Code Set Archive 2009-2024"
)

pin_update(
  x$tax_changelog,
  "tax_changelog",
  "NUCC Taxonomy Changelog 2009-2024",
  "Health Care Provider Taxonomy Code Set Changelog 2009-2024"
)

pin_update(
  x$tax_display,
  "tax_display",
  "NUCC Taxonomy Display Names 2009-2024",
  "Health Care Provider Taxonomy Code Set Display Names 2009-2024"
)

pin_update(
  x$tax_definition,
  "tax_definition",
  "NUCC Taxonomy Definitions 2009-2024",
  "Health Care Provider Taxonomy Code Set Definitions 2009-2024"
)

pin_update(
  x$tax_hierarchy,
  name = "tax_hierarchy",
  title = "NUCC Taxonomy Hierarchy",
  description = "Health Care Provider Taxonomy Code Set Hierarchy 2009-2024"
)

pin_update(
  x$tax_sources,
  name = "tax_sources",
  title = "NUCC Taxonomy Sources",
  description = "Health Care Provider Taxonomy Code Set Sources 2009-2024"
)

pin_update(
  x$cross_raw,
  "cross_raw",
  "Medicare Taxonomy Crosswalk 2024",
  "Medicare Provider and Supplier Taxonomy Crosswalk 2024"
)

pin_update(
  x$cross_notes,
  "cross_notes",
  "Medicare Taxonomy Crosswalk Footnotes 2024",
  "Medicare Provider and Supplier Taxonomy Crosswalk Footnotes 2024"
)

pin_update(
  x$cross_tax,
  "cross_tax",
  "Medicare Taxonomy Crosswalk Taxonomy Codes 2024",
  "Medicare Provider and Supplier Taxonomy Crosswalk Taxonomy Codes 2024"
)

source(here::here("data-raw", "pins_internal.R"))

hierarchy <- get_pin("tax_hierarchy") |>
  dplyr::select(
    taxonomy_code = code,
    taxonomy_level = level,
    taxonomy_level_title = description
  )

pin_update(
  hierarchy,
  name = "tax_hierarchy",
  title = "NUCC Taxonomy Hierarchy",
  description = "Health Care Provider Taxonomy Code Set Hierarchy 2009-2024"
)

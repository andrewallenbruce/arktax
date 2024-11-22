source(here::here("data-raw", "pins_internal.R"))

cleaned_csvs <- fs::dir_info(glue::glue("{here::here()}/data-raw/clean/csvs"))$path

tx_100 <- readr::read_csv(
  file = tools::file_path_sans_ext(cleaned_csvs[1]),
  id = "filename",
  show_col_types = FALSE,
  col_types = "c",
  name_repair = janitor::make_clean_names
  ) |>
  dplyr::reframe(
    release = basename(filename),
    version,
    release_date,
    code,
    grouping = type,
    classification,
    specialization,
    definition,
    notes
    )

pin_update(
  tx_100,
  name = "tax_v_10.0",
  title = "Taxonomy Codeset v10.0",
  description = "Health Care Provider Taxonomy Code Set, Version 10.1, Released 2010-01-01",
  force = TRUE
)

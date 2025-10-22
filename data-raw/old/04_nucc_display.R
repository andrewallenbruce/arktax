source(here::here("data-raw", "pins_internal.R"))

raw_display <- arktax::taxonomy_raw() |>
  dplyr::select(code, year, version, display_name)

no_display <- raw_display |>
  dplyr::filter(is.na(display_name)) |>
  dplyr::pull(code) |>
  fuimus::uniq_rmna()

raw_display |>
  dplyr::filter(!is.na(display_name)) |>
  # dplyr::filter(code %in% no_display) |>
  dplyr::filter(.by = code,
                year == max(year),
                version == max(version)) |>
  dplyr::count(code, sort = TRUE)

tax_display <- get_pin("tax_display") |>
  dplyr::select(
    taxonomy_code = code,
    taxonomy_display = display_name)

pin_update(
  tax_display,
  "tax_display",
  "NUCC Taxonomy Display Names 2009-2024",
  "Health Care Provider Taxonomy Code Set Display Names 2009-2024"
)

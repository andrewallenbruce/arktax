source(here::here("data-raw", "pins_internal.R"))

raw_definition <- arktax::taxonomy_raw() |>
  dplyr::select(code, year, version, definition) |>
  dplyr::mutate(definition = stringr::str_replace_all(definition, notes_regs) |>
                  stringr::str_squish())

no_definition <- raw_definition |>
  dplyr::filter(is.na(definition)) |>
  dplyr::pull(code) |>
  fuimus::uniq_rmna()

has_definition <- raw_definition |>
  dplyr::filter(code %in% no_definition) |>
  dplyr::filter(!is.na(definition)) |>
  dplyr::pull(code) |>
  fuimus::uniq_rmna()

vctrs::vec_slice(no_definition, vctrs::vec_in(no_definition, has_definition))
vctrs::vec_slice(has_definition, vctrs::vec_in(has_definition, no_definition))

raw_definition |>
  dplyr::filter(.by = code,
                !is.na(definition),
                year == max(year),
                version == max(version)) |>
  dplyr::arrange(code, year, version) |>
  dplyr::filter(year < 2024)
  print(n = 200)
  dplyr::filter(is.na(definition))
  dplyr::select(code, definition)



definitions <- get_pin("tax_definitions") |>
    dplyr::reframe(
      taxonomy_code = code,
      taxonomy_definition = dplyr::if_else(definition == "None", NA_character_, definition)
    )


pin_update(
  definitions,
  "tax_definition",
  "NUCC Taxonomy Definitions 2009-2024",
  "Health Care Provider Taxonomy Code Set Definitions 2009-2024"
)

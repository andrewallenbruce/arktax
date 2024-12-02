get_pin("cross_raw") |>
  dplyr::select(
    taxonomy_code,
    specialty_code,
    specialty_description) |>
  tidyr::nest(data = taxonomy_code) |>
  dplyr::mutate(
    taxonomy_codes = purrr::map_chr(data,
    function(x)
      glue::glue("{codex::delist(x)}") |>
      glue::glue_collapse(sep = ", ")),
    data = NULL) |>
  tidyr::separate_longer_delim(
    cols = specialty_description,
    delim = stringr::fixed("/")) |>
  dplyr::mutate(
    specialty_description = stringr::str_squish(specialty_description)) |>
  dplyr::arrange(specialty_code) |>
  dplyr::mutate(
    .group = dplyr::row_number(),
    .by = c(specialty_code),
    .after = 1) |>
  print(n = 200)

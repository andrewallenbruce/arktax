source(here::here("data-raw", "pins_internal.R"))

na_squish <- \(x) stringr::str_squish(fuimus::na_if_common(x))

xwalk <- provider::taxonomy_crosswalk(tidy = FALSE) |>
  janitor::clean_names() |>
  dplyr::tibble() |>
  dplyr::mutate(
    dplyr::across(dplyr::everything(), na_squish),
    .id = dplyr::row_number()) |>
  dplyr::rename(
    taxonomy_code = provider_taxonomy_code,
    taxonomy_type = provider_taxonomy_description_type_classification_specialization,
    specialty_code = medicare_specialty_code,
    specialty_type = medicare_provider_supplier_type_description) |>
  dplyr::mutate(
    type_note = str_extract(specialty_type, "(\\[)(.*?)(\\])$", group = 2),
    code_note = str_extract(specialty_code, "(\\[)(.*?)(\\])$", group = 2),
    specialty_type = str_remove(specialty_type, "\\[.*\\]"),
    specialty_code = str_remove(specialty_code, "\\[.*\\]"))

xwalk

#----------taxonomy
taxonomy <- xwalk |>
  dplyr::select(.id, taxonomy_code, taxonomy_type) |>
  tidyr::separate_longer_delim(
    cols = taxonomy_type,
    delim = stringr::regex("[\\/|,]")) |>
  dplyr::mutate(
    taxonomy_type = dplyr::if_else(
      codex::sf_detect(
        taxonomy_type,
        "Urban Indian Health \\(I"),
      "Urban Indian Health [ITU] Pharmacy",
      str_squish(taxonomy_type)),
    dlim = NULL,
    n = NULL) |>
  dplyr::filter(
    sf_ndetect(
      taxonomy_type,
      "^T$|U\\)\\sPharmacy")
  ) |>
  dplyr::mutate(
    .group = dplyr::row_number(),
    .by = c(taxonomy_code, .id),
    .after = .id) |>
  tidyr::pivot_wider(
    names_from = .group,
    values_from = taxonomy_type,
    names_prefix = "tax")

taxonomy

taxonomy |>
  hacksaw::count_split(
    tax1,
    tax2,
    tax3,
    tax4,
    tax5,
    tax6
  )

#----------specialty
### Medicare Footnotes
footnotes <- dplyr::tibble(
  note = as.character(1:14),
  note_description = readr::read_lines(
    here::here(
      "data-raw",
      "raw",
      "taxonomy_notes.txt")))

specialty <- xwalk |>
  dplyr::select(
    .id,
    specialty_code,
    specialty_type,
    type_note,
    code_note) |>
  dplyr::left_join(footnotes,
                   by = dplyr::join_by(type_note == note)) |>
  dplyr::left_join(footnotes,
                   by = dplyr::join_by(code_note == note)) |>
  fuimus::combine(
    name = note,
    columns = c(
      "type_note",
      "code_note"),
    sep = ", ") |>
  fuimus::combine(
    name = note_description,
    columns = c(
      "note_description.x",
      "note_description.y"),
    sep = " ")


specialty |>
  dplyr::mutate(.id = as.character(.id)) |>
  tidyr::nest(data = .id) |>
  dplyr::mutate(.id = map_chr(
    data, function(x)
      glue::glue("{delist(x)}") |>
      glue::glue_collapse(sep = ", ")),
    data = NULL) |>
  tidyr::separate_longer_delim(
    cols = specialty_type,
    delim = stringr::fixed("/")) |>
  dplyr::mutate(specialty_type = str_squish(specialty_type))

source(here::here("data-raw", "pins_internal.R"))

na_squish <- \(x) stringr::str_squish(fuimus::na_if_common(x))

xwalk <- provider::taxonomy_crosswalk(tidy = FALSE) |>
  janitor::clean_names() |>
  dplyr::tibble()

walk <- xwalk |>
  dplyr::mutate(
    dplyr::across(dplyr::everything(), na_squish),
    .id = dplyr::row_number()) |>
  dplyr::rename(
    taxonomy_code = provider_taxonomy_code,
    taxonomy_type = provider_taxonomy_description_type_classification_specialization,
    specialty_code = medicare_specialty_code,
    specialty_type = medicare_provider_supplier_type_description) |>
  dplyr::mutate(
    type_note = stringr::str_extract(specialty_type, "(\\[)(.*?)(\\])$", group = 2),
    code_note = stringr::str_extract(specialty_code, "(\\[)(.*?)(\\])$", group = 2),
    specialty_type = stringr::str_remove(specialty_type, "\\[.*\\]"),
    specialty_code = stringr::str_remove(specialty_code, "\\[.*\\]"))

footnotes <- arktax::get_pin("cross_notes")

raw <- walk |>
  dplyr::left_join(footnotes, by = dplyr::join_by(type_note == note)) |>
  dplyr::left_join(footnotes, by = dplyr::join_by(code_note == note)) |>
  tidyr::unite("footnote", c("type_note", "code_note"), sep = ", ", na.rm = TRUE) |>
  tidyr::unite("footnote_description", c("note_description.x", "note_description.y"), sep = " ", na.rm = TRUE) |>
  dplyr::mutate(footnote = dplyr::na_if(footnote, ""),
                footnote_description = dplyr::na_if(footnote_description, "")) |>
  dplyr::select(
    taxonomy_code,
    taxonomy_description = taxonomy_type,
    specialty_code,
    specialty_description = specialty_type,
    footnote,
    footnote_description) |>
  dplyr::arrange(taxonomy_code)

pin_update(
  raw,
  "cross_raw",
  "Medicare Taxonomy Crosswalk 2024",
  "Medicare Provider and Supplier Taxonomy Crosswalk 2024"
)

#----------specialty
specialty <- walk |>
  dplyr::select(
    .id,
    specialty_code,
    specialty_type,
    type_note,
    code_note) |>
  dplyr::left_join(footnotes, by = dplyr::join_by(type_note == note)) |>
  dplyr::left_join(footnotes, by = dplyr::join_by(code_note == note)) |>
  fuimus::combine(name = note, columns = c("type_note", "code_note"), sep = ", ") |>
  fuimus::combine(name = note_description, columns = c("note_description.x", "note_description.y"), sep = " ")

specialty |>
  # dplyr::filter(codex::not_na(note) | codex::not_na(note_description)) |>
  dplyr::mutate(.id = as.character(.id)) |>
  tidyr::nest(data = .id) |>
  dplyr::mutate(.id = purrr::map_chr(data, function(x) glue::glue("{codex::delist(x)}") |> glue::glue_collapse(sep = ", ")),
                data = NULL) |>
  tidyr::separate_longer_delim(cols = specialty_type, delim = stringr::fixed("/")) |>
  dplyr::mutate(specialty_type = stringr::str_squish(specialty_type))

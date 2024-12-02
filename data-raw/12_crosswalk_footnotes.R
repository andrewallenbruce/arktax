source(here::here("data-raw", "pins_internal.R"))

footnotes <- dplyr::tibble(
  note = as.character(1:14),
  note_description = readr::read_lines(
    here::here(
      "data-raw",
      "raw",
      "taxonomy_notes.txt")))


notes <- walk |>
  dplyr::left_join(footnotes, by = dplyr::join_by(type_note == note)) |>
  dplyr::left_join(footnotes, by = dplyr::join_by(code_note == note)) |>
  dplyr::filter(!is.na(type_note) | !is.na(code_note)) |>
  dplyr::rename(
    type_note_description = note_description.x,
    code_note_description = note_description.y) |>
  dplyr::select(-.id)


notes <- vctrs::vec_rbind(
  notes |>
    dplyr::select(
      taxonomy_code,
      specialty_code,
      # specialty_type,
      type_note,
      type_note_description) |>
    dplyr::filter(!is.na(type_note) | !is.na(type_note_description)) |>
    dplyr::mutate(
      footnote = stringr::str_glue("({type_note}) {type_note_description}"),
      type_note = NULL,
      type_note_description = NULL),
  notes |>
    dplyr::select(
      taxonomy_code,
      specialty_code,
      code_note,
      code_note_description) |>
    dplyr::filter(!is.na(code_note) | !is.na(code_note_description)) |>
    dplyr::mutate(
      footnote = stringr::str_glue("({code_note}) {code_note_description}"),
      code_note = NULL,
      code_note_description = NULL)
)


pin_update(
  notes,
  "cross_notes",
  "Medicare Taxonomy Crosswalk Footnotes 2024",
  "Medicare Provider and Supplier Taxonomy Crosswalk Footnotes 2024"
)

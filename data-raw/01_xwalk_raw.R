source(here::here("data-raw", "fns.R"))

# Define XWALK directory path
xwalk_dir        <- fs::path_abs("data-raw/xwalk/")
xwalk_dir_csv    <- fs::dir_ls(fs::path(xwalk_dir, "csvs"))
xwalk_path_notes <- xwalk_dir_csv[stringr::str_detect(xwalk_dir_csv, "note")]
xwalk_path_csvs  <- xwalk_dir_csv[stringr::str_detect(xwalk_dir_csv, "note", negate = TRUE)]

# Read XWALK footnotes
# All years contain the same footnotes
# Use the most recent
# read_csv_list(xwalk_path_notes, col_names = "note") |> rlang::set_names(xwalk_path_notes |> tools::file_path_sans_ext() |> basename()) |> purrr::list_rbind(names_to = "file")
xwalk_notes <- readr::read_csv(
  file        = xwalk_path_notes[length(xwalk_path_notes)],
  col_types   = readr::cols(),
  num_threads = 4L,
  col_names   = "note")


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

footnotes <- footnotes <- dplyr::tibble(
  note = as.character(1:14),
  note_description = readr::read_lines(
    here::here(
      "data-raw",
      "raw",
      "taxonomy_notes.txt")))

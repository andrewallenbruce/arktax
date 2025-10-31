source(here::here("data-raw", "fns.R"))

# Define xwalk directory path
xwalk_dir        <- fs::path_abs("data-raw/xwalk/")
xwalk_dir_csv    <- fs::dir_ls(fs::path(xwalk_dir, "csvs"))
xwalk_path_notes <- xwalk_dir_csv[stringr::str_detect(xwalk_dir_csv, "note")]
xwalk_path_csvs  <- xwalk_dir_csv[stringr::str_detect(xwalk_dir_csv, "note", negate = TRUE)]


#### FOOTNOTES
# Read xwalk footnotes -> Use the most recent
xwalk_notes <- readr::read_csv(
  file        = xwalk_path_notes[length(xwalk_path_notes)],
  col_types   = readr::cols(),
  num_threads = 4L,
  col_names   = "note") |>
  purrr::modify_if(is.character, clean_columns)

xwalk_notes <- xwalk_notes |>
  collapse::mtt(
    foot = 1L:nrow(xwalk_notes),
    note = stringr::str_remove_all(note, "^\\[[0-9]{1,2}\\]\\s*"))

xwalk_notes |>
  _$note |>
  cat(sep = "\n")

#### CSVS
# Read xwalk csvs
xwalk_csvs <- read_csv_list(xwalk_path_csvs) |>
  rlang::set_names(basename_sans_ext(xwalk_path_csvs)) |>
  purrr::list_rbind(names_to = "file_name") |>
  janitor::clean_names() |>
  collapse::sbt(!is.na(medicare_specialty_code) & stringr::str_detect(medicare_specialty_code, "^\\[", negate = TRUE)) |>
  collapse::mtt(
    medicare_specialty_code = dplyr::if_else(stringr::str_length(medicare_specialty_code) == 1, paste0("0", medicare_specialty_code), medicare_specialty_code),
    order = stringr::str_extract(file_name, "(?<=crosswalk[_]|list[_]).*$"),
    order = stringr::str_extract(order, months_regex),
    order = cheapr::val_match(order, "dec" ~ 12L, "jan" ~ 1L, "october" ~ 10L, "july" ~ 7L, "september" ~ 9L, .default = 1L),
    order = as.integer(order),
    year = extract_year(file_name),
    year = as.integer(year),
    file_name = NULL) |>
  collapse::roworder(year, order) |>
  collapse::colorder(year, order) |>
  fastplyr::f_group_by(year) |>
  fastplyr::f_mutate(order = fastplyr::f_consecutive_id(order)) |>
  fastplyr::f_ungroup()

xwalk_csvs |>
  # collapse::sbt(provider_taxonomy_code %in% c("229N00000X", "224P00000X", "224P00000X,229N00000X")) |> dplyr::glimpse()
  collapse::fcount(year, order) |>
  # collapse::roworder(year, order) |>
  print(n = Inf)

colnames(xwalk_csvs)

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

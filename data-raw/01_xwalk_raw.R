source(here::here("data-raw", "fns.R"))

# Define xwalk directory path
xwalk_dir <- fs::path_abs("data-raw/xwalk/")
xwalk_dir_csv <- fs::dir_ls(fs::path(xwalk_dir, "csvs"))
xwalk_path_notes <- xwalk_dir_csv[stringr::str_detect(xwalk_dir_csv, "note")]
xwalk_path_csvs <- xwalk_dir_csv[stringr::str_detect(
  xwalk_dir_csv,
  "note",
  negate = TRUE
)]


#### FOOTNOTES
# Read xwalk footnotes -> Use the most recent
xwalk_notes <- readr::read_csv(
  file = xwalk_path_notes[length(xwalk_path_notes)],
  col_types = readr::cols(),
  num_threads = 4L,
  col_names = "note"
) |>
  purrr::modify_if(is.character, clean_columns) |>
  collapse::mtt(
    foot = 1:14,
    note = stringr::str_remove_all(note, "^\\[[0-9]{1,2}\\]\\s*")
  )

cat(xwalk_notes$footnote, sep = "\n")

xwalk_csvs <- read_csv_list(xwalk_path_csvs) |>
  rlang::set_names(basename_sans_ext(xwalk_path_csvs))

xwalk <- xwalk_csvs$Y2025_1_medicare_provider_and_supplier_taxonomy_crosswalk_october_2025 |>
  rlang::set_names(c("spec", "spec_description", "txn", "txn_description")) |>
  collapse::mtt(
    foot = cheapr::case(
      stringr::str_length(spec) == 5L ~ strtoi(substr(spec, 4L, 4L)),
      stringr::str_length(spec) == 6L ~ strtoi(substr(spec, 4L, 5L)),
      .default = NA_integer_
    ),
    spec = substr(spec, 1L, 2L)
  )

xwalk[!cheapr::is_na(xwalk$foot), ]

xwalk <- collapse::join(
  xwalk,
  xwalk_notes[cheapr::counts(xwalk$foot)$key[-1], ],
  on = "foot"
) |>
  collapse::mtt(
    isNA = cheapr::is_na(note),
    footnote = ifelse(isNA, glue::as_glue("-"), glue::glue("[{foot}]: {note}")),
    isNA = NULL,
    foot = NULL,
    note = NULL
  )

cheapr::counts(xwalk$footnote)

usethis::use_data(xwalk, overwrite = TRUE)

#### CSVS
# Read xwalk csvs
xwalk_csvs <- read_csv_list(xwalk_path_csvs) |>
  rlang::set_names(basename_sans_ext(xwalk_path_csvs)) |>
  collapse::rowbind(idcol = "file", fill = TRUE) |>
  janitor::clean_names() |>
  collapse::sbt(
    !cheapr::is_na(medicare_specialty_code) &
      stringr::str_detect(medicare_specialty_code, "^\\[", negate = TRUE)
  ) |>
  collapse::mtt(
    medicare_specialty_code = cheapr::if_else_(
      stringr::str_length(medicare_specialty_code) == 1L,
      paste0("0", medicare_specialty_code),
      medicare_specialty_code
    ),
    order = stringr::str_extract(file, "(?<=crosswalk[_]|list[_]).*$"),
    order = stringr::str_extract(order, months_regex),
    order = cheapr::val_match(
      order,
      "dec" ~ 12L,
      "jan" ~ 1L,
      "october" ~ 10L,
      "july" ~ 7L,
      "september" ~ 9L,
      .default = 1L
    ),
    order = as.integer(order),
    year = extract_year(file),
    year = as.integer(year),
    file = NULL
  ) |>
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

walk <- xwalk_csvs |>
  provider:::replace_nz() |>
  dplyr::mutate(.id = dplyr::row_number()) |>
  dplyr::rename(
    taxonomy_code = provider_taxonomy_code,
    taxonomy_type = provider_taxonomy_description_type_classification_specialization,
    specialty_code = medicare_specialty_code,
    specialty_type = medicare_provider_supplier_type_description
  ) |>
  dplyr::mutate(
    type_note = stringr::str_extract(
      specialty_type,
      "(\\[)(.*?)(\\])$",
      group = 2
    ),
    code_note = stringr::str_extract(
      specialty_code,
      "(\\[)(.*?)(\\])$",
      group = 2
    ),
    specialty_type = stringr::str_remove(specialty_type, "\\[.*\\]"),
    specialty_code = stringr::str_remove(specialty_code, "\\[.*\\]")
  )

walk |>
  collapse::slt(-year, -order, -.id) |>
  collapse::funique()

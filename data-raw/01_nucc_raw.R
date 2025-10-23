source(here::here("data-raw", "fns.R"))

# Define csv directory & paths
csv_dir   <- here::here("data-raw/raw/csvs/")
csv_paths <- fs::dir_ls(csv_dir)

# NUCC Info Table Spec
spec_info <- readr::cols(
  release_date = readr::col_date(format = ""),
  version      = readr::col_double(),
  major        = readr::col_integer(),
  minor        = readr::col_integer(),
  file_name    = readr::col_character(),
  download_url = readr::col_character())

# Read NUCC file info
nucc_info <- readr::read_csv(
  file      = here::here("data-raw/raw/nucc_file_info.csv"),
  col_types = spec_info)

# csv 1-22 : nucc_taxonomy_100 - 220 [22]
spec_1.22 <- readr::cols(
  Code           = readr::col_character(),
  Grouping       = readr::col_character(),
  Classification = readr::col_character(),
  Specialization = readr::col_character(),
  Definition     = readr::col_character(),
  Notes          = readr::col_character())

nucc_1.22 <- readr::read_csv(
  file           = csv_paths[1:22],
  id             = "file_name",
  show_col_types = FALSE,
  col_types      = spec_1.22,
  num_threads    = 4L) |>
  janitor::clean_names() |>
  collapse::mtt(
    file_name = basename(file_name),
    acr(janitor::make_clean_names(names(spec_1.22$cols)), clean_cols)) |>
  collapse::sbt(stringr::str_detect(code, "^Copy", negate = TRUE))

# code: 863
# grouping: 29
# classification: 251
# specialization: 482
# definition: 740
# notes: 472


# csv 23 : nucc_taxonomy_210
spec_23 <- readr::cols(
  Code           = readr::col_character(),
  Grouping       = readr::col_character(),
  Classification = readr::col_character(),
  Specialization = readr::col_character(),
  Definition     = readr::col_character(),
  Notes          = readr::col_character(),
  `Display Name` = readr::col_character())

nucc_23 <- readr::read_csv(
  file           = csv_paths[23],
  id             = "file_name",
  show_col_types = FALSE,
  col_types      = spec_23,
  num_threads    = 4L) |>
  janitor::clean_names() |>
  collapse::mtt(
    file_name = basename(file_name),
    acr(janitor::make_clean_names(names(spec_23$cols)), clean_cols)) |>
  collapse::sbt(stringr::str_detect(code, "^Copy", negate = TRUE))

# code: 863
# grouping: 29
# classification: 244
# specialization: 466
# definition: 556
# notes: 348
# display_name: 865


# csv 24-25 : nucc_taxonomy_211 & 220
spec_24.25 <- readr::cols(
  Code           = readr::col_character(),
  Grouping       = readr::col_character(),
  Classification = readr::col_character(),
  Specialization = readr::col_character(),
  Definition     = readr::col_character(),
  Notes          = readr::col_character(),
  `Display Name` = readr::col_character(),
  Section        = readr::col_character())

nucc_24.25 <- readr::read_csv(
  file           = csv_paths[24:25],
  id             = "file_name",
  show_col_types = FALSE,
  col_types      = spec_24.25,
  num_threads    = 4L) |>
  janitor::clean_names() |>
  collapse::mtt(
    file_name = basename(file_name),
    acr(janitor::make_clean_names(names(spec_24.25$cols)), clean_cols)) |>
  collapse::sbt(stringr::str_detect(code, "^Copy", negate = TRUE))

# code: 868
# grouping: 29
# classification: 245
# specialization: 468
# definition: 559
# notes: 352
# display_name: 868
# section: 2 [Individual/Non-Individual]


# csv 26 : nucc_taxonomy_221
spec_26 <- readr::cols(
  Code                 = readr::col_character(),
  Grouping             = readr::col_character(),
  Classification       = readr::col_character(),
  Specialization       = readr::col_character(),
  Definition           = readr::col_character(),
  `Effective Date`     = readr::col_character(),
  `Deactivation Date`  = readr::col_character(),
  `Last Modified Date` = readr::col_character(),
  Notes                = readr::col_character(),
  `Display Name`       = readr::col_character(),
  Section              = readr::col_character())

nucc_26 <- readr::read_csv(
  file           = csv_paths[26],
  id             = "file_name",
  show_col_types = FALSE,
  col_types      = spec_26,
  num_threads    = 4L) |>
  janitor::clean_names() |>
  collapse::mtt(
    file_name = basename(file_name),
    acr(janitor::make_clean_names(names(spec_26$cols)), clean_cols),
    acr(c(effective_date, deactivation_date, last_modified_date), parsedate)) |>
  collapse::sbt(stringr::str_detect(code, "^Copy", negate = TRUE))

# code: 868
# grouping: 29
# classification: 245
# specialization: 468
# definition: 559
# effective_date: 34
# deactivation_date: 5
# last_modified_date: 22
# notes: 352
# display_name: 868
# section: 2 [Individual/Non-Individual]

spec_27.32 <- readr::cols(
  Code           = readr::col_character(),
  Grouping       = readr::col_character(),
  Classification = readr::col_character(),
  Specialization = readr::col_character(),
  Definition     = readr::col_character(),
  Notes          = readr::col_character(),
  `Display Name` = readr::col_character(),
  Section        = readr::col_character())

nucc_27.32 <- readr::read_csv(
  file           = csv_paths[27:32],
  id             = "file_name",
  show_col_types = FALSE,
  col_types      = spec_27.32,
  num_threads    = 4L) |>
  janitor::clean_names() |>
  collapse::mtt(
    file_name = basename(file_name),
    acr(janitor::make_clean_names(names(spec_27.32$cols)), clean_cols)) |>
  collapse::sbt(stringr::str_detect(code, "^Copy", negate = TRUE))

# code: 868
# grouping: 29
# classification: 245
# specialization: 468
# definition: 559
# notes: 352
# display_name: 868
# section: 2 [Individual/Non-Individual]
nucc_26 |>
  collapse::sbt(
    !is.na(section)
    # & stringr::str_detect(definition, "^Definition to come", negate = TRUE)
  ) |>
  collapse::fcount(section) |>
  collapse::roworder(-N)

spec_33.34 <- readr::cols(
  Code           = readr::col_character(),
  Grouping       = readr::col_character(),
  Classification = readr::col_character(),
  Specialization = readr::col_character(),
  Definition     = readr::col_character(),
  Notes          = readr::col_character())

nucc_33.34 <- readr::read_csv(
  file           = csv_paths[33:34],
  id             = "file_name",
  show_col_types = FALSE,
  col_types      = spec_33.34,
  num_threads    = 4L) |>
  janitor::clean_names() |>
  collapse::mtt(
    file_name = basename(file_name),
    acr(janitor::make_clean_names(names(spec_33.34$cols)), clean_cols)) |>
  collapse::sbt(stringr::str_detect(code, "^Copy", negate = TRUE))

vctrs::vec_rbind(
  nucc_1.22,
  nucc_23,
  nucc_24.25,
  nucc_26,
  nucc_27.32,
  nucc_33.34)


notes_regs <- c(
  "http[s]?:" = "",
  "//"        = "",
  "<br/>"     = " ",
  "<br><br>"  = " "
)


parse_raw_nucc_csvs <- function(path) {

  raw <- suppressWarnings(
    readr::read_csv(
      file = path,
      id = "filename",
      show_col_types = FALSE,
      col_types = "c",
      name_repair = janitor::make_clean_names)
  )

  if (codex::sf_ndetect(raw[["code"]][1], "^[A-Z0-9]{9}X$")) {
    raw <- dplyr::slice(raw, -1)
  }

  raw |>
    dplyr::mutate(
      filename = basename(filename),
      dplyr::across(dplyr::everything(), clean_cols),
      notes = stringr::str_replace_all(notes, notes_regs) |> stringr::str_squish(),
      definition = stringr::str_replace(definition, "Definition to come[\\.]{1,5}", "Definition to come.")
      ) |>
    dplyr::left_join(infotable, by = "filename") |>
    dplyr::mutate(
      year = lubridate::year(release_date) |> as.integer(),
      version = dplyr::if_else(lubridate::month(release_date) == 7, 1, 0) |> as.character()
      ) |>
    dplyr::select(
      # dplyr::any_of(sel_cols),
      # dplyr::everything(),
      -c(filename, file_url, release_date)
      ) |>
    readr::write_csv(
      file = glue::glue(
        "{here::here()}/data-raw/clean/{tools::file_path_sans_ext(basename(path))}.csv"
        ),
      num_threads = 4L)
}

purrr::walk(raw_paths, parse_raw_nucc_csvs)

# ARCHIVE
archive::archive_write_files(
  archive = here::here("data-raw/raw/raw_nucc_taxonomy.tar.xz"),
  files = c(
    glue::glue("{here::here()}/data-raw/raw/infotable.csv"),
    fs::dir_info(glue::glue("{here::here()}/data-raw/raw/csvs"))$path
  )
)

# DELETE
fs::dir_delete(glue::glue("{here::here()}/data-raw/raw/csvs"))

archive::archive(file = here::here("data-raw/raw/nucc_taxonomy.tar.xz"))

readr::read_csv(
  file = archive::archive_read(archive = here::here("data-raw/raw/nucc_taxonomy.tar.xz"), file = 20L),
  show_col_types = FALSE,
  col_types = "c",
  name_repair = janitor::make_clean_names)

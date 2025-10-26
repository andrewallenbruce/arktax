source(here::here("data-raw", "fns.R"))

# Define NUCC csv directory & paths
nucc_csv_dir   <- fs::path_abs("data-raw/nucc/csvs")
nucc_csv_paths <- fs::dir_ls(nucc_csv_dir)

# Read NUCC file info
nucc_info <- readr::read_csv(
  file      = fs::path_abs("data-raw/nucc/nucc_file_info.csv"),
  col_types = readr::cols()) |>
  collapse::mtt(major = as.integer(major), minor = as.integer(minor))

nucc_list <- purrr::map(nucc_csv_paths, read_nucc) |>
  rlang::set_names(basename(fs::path_ext_remove(nucc_csv_paths)))

# nucc_taxonomy_211 & 220
# display_name & section first appear
# section: 2 [Individual/Non-Individual]

# nucc_taxonomy_221
# dates first appear: effective_date, deactivation_date, last_modified_date
nucc_list$nucc_taxonomy_221 |>
  collapse::mtt(acr(
    c(effective_date, deactivation_date, last_modified_date),
    parse_mdY
  )) |>
  collapse::sbt(
    # !is.na(deactivation_date)
    !is.na(last_modified_date)
    )

# nucc_taxonomy_230 - 251
# dates are now gone

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

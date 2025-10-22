archive::archive_extract(
  archive = here::here("data-raw/raw/nucc_taxonomy.tar.xz"),
  dir = here::here("data-raw/raw"))

infotable  <- readr::read_csv(glue::glue("{here::here()}/data-raw/raw/infotable.csv"), show_col_types = FALSE, col_types = "ccDc")
raw_paths  <- fs::dir_info(glue::glue("{here::here()}/data-raw/raw/csvs"))$path

clean_cols <- \(x) fuimus::remove_quotes(stringr::str_squish(dplyr::na_if(x, "")))

sel_cols <- c(
  "year",
  "version",
  # "release_date",
  "code",
  "section",
  "display_name",
  "grouping",
  "grouping" = "type",
  "classification",
  "specialization",
  "definition",
  "notes"
)

notes_regs <- c(
  "http[s]?:" = "",
  "//" = "",
  "<br/>" = " ",
  "<br><br>" = " ",
  # "([0-9]{1,2})//([0-9]{1,2})//([0-9]{4})" = "",
  "�" = ""
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

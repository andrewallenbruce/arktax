source(here::here("data-raw", "pins_internal.R"))

cleaned_csvs <- fs::dir_info(glue::glue("{here::here()}/data-raw/clean/csvs"))$path

cols <- c(
  "version",
  "release_date",
  "code",
  "grouping",
  "grouping" = "type",
  "classification",
  "specialization",
  "definition",
  "notes"
)

read_clean_csvs <- function(x) {
  readr::read_csv(
    file = tools::file_path_sans_ext(x),
    show_col_types = FALSE,
    col_types = "c",
    name_repair = janitor::make_clean_names) |>
    dplyr::select(
      dplyr::any_of(cols))
}

ark_taxonomy <- purrr::map(cleaned_csvs, read_clean_csvs) |>
  purrr::list_rbind() |>
  dplyr::arrange(release_date) |>
  dplyr::mutate(definition = stringr::str_replace(definition, "Definition to come[\\.]{1,5}", "Definition to come."))

pin_update(
  ark_taxonomy,
  name = "ark_taxonomy",
  title = "NUCC Taxonomy Archive 2009-2024",
  description = "Health Care Provider Taxonomy Code Set Archive 2009-2024"
)




# ARCHIVE
archive::archive_write_files(
  archive = here::here("data-raw/clean/nucc_taxonomy.tar.xz"),
  files = c(
    glue::glue("{here::here()}/data-raw/raw/infotable.csv"),
    fs::dir_info(glue::glue("{here::here()}/data-raw/clean/csvs"))$path
  )
)

fs::dir_delete(glue::glue("{here::here()}/data-raw/clean/csvs"))

archive::archive(file = here::here("data-raw/clean/nucc_taxonomy.tar.xz"))

readr::read_csv(
  file = archive::archive_read(archive = here::here("data-raw/clean/nucc_taxonomy.tar.xz"), file = 2L),
  show_col_types = FALSE,
  col_types = "c",
  name_repair = janitor::make_clean_names)

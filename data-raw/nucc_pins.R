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

ark_taxonomy <- purrr::map(cleaned_csvs[1:20], read_clean_csvs) |>
  purrr::list_rbind()

pin_update(
  ark_taxonomy,
  name = "ark_taxonomy",
  title = "NUCC Taxonomy Archive",
  description = "Health Care Provider Taxonomy Code Set Archive"
)

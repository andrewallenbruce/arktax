source(here::here("data-raw", "pins_internal.R"))

cleaned_paths <- fs::dir_info(glue::glue("{here::here()}/data-raw/clean/"))$path

read_clean_csvs <- function(x) {
  readr::read_csv(
    file = x,
    show_col_types = FALSE,
    col_types = "c",
    name_repair = janitor::make_clean_names)
}

ark_taxonomy <- purrr::map(
  cleaned_paths,
  read_clean_csvs) |>
  purrr::list_rbind() |>
  dplyr::reframe(
    year,
    version = as.integer(version),
    code,
    display_name,
    section,
    type,
    grouping,
    classification,
    specialization,
    definition,
    notes,
    modified = lubridate::mdy(last_modified_date),
    effective = lubridate::mdy(effective_date),
    deactivated = lubridate::mdy(deactivation_date)
  )

ark_grp <- ark_taxonomy |> dplyr::mutate(grpNA = as.integer(codex::na(grouping)))

ark_g <- collapse::GRP(ark_grp, ~ grpNA)

ark_spt <- collapse::rsplit(ark_grp, ark_g) |>
  setNames(c("N", "Y"))

ark_spt$Y <- ark_spt$Y |>
  dplyr::select(-grpNA, -grouping) |>
  dplyr::rename(grouping = type) |>
  dplyr::mutate(definition = dplyr::if_else(definition == "Definition to come.", NA_character_, definition)) |>
  dplyr::arrange(code, year, version)

ark_spt$N <- ark_spt$N |>
  dplyr::select(-grpNA, -type) |>
  dplyr::mutate(definition = dplyr::if_else(definition == "Definition to come.", NA_character_, definition)) |>
  dplyr::arrange(code, year, version)

ark_spt <- vctrs::vec_rbind(ark_spt$Y, ark_spt$N)

pin_update(
  ark_spt,
  name = "ark_taxonomy",
  title = "NUCC Taxonomy Archive 2009-2024",
  description = "Health Care Provider Taxonomy Code Set Archive 2009-2024"
)

# ARCHIVE
archive::archive_write_files(
  archive = here::here("data-raw/raw/nucc_clean.tar.xz"),
  files = c(fs::dir_info(glue::glue("{here::here()}/data-raw/clean"))$path)
)

fs::dir_delete(glue::glue("{here::here()}/data-raw/clean"))

archive::archive(file = here::here("data-raw/raw/nucc_clean.tar.xz")) |> print(n = 50)

readr::read_csv(
  file = archive::archive_read(archive = here::here("data-raw/raw/nucc_clean.tar.xz"), file = 1L),
  show_col_types = FALSE,
  col_types = "c",
  name_repair = janitor::make_clean_names)

deactivated <- ark_spt |>
  dplyr::filter(
    codex::not_na(deactivated)
    ) |>
  dplyr::pull(code)

ark_spt

ark_long <- ark_spt |>
  dplyr::select(
    year,
    version,
    code,
    section,
    grouping,
    classification,
    specialization) |>
  dplyr::mutate(
    section_level = 0,
    grouping_level = 1,
    classification_level = 2,
    specialization_level = 3) |>
  fuimus::combine(section, c("section", "section_level"), "_") |>
  fuimus::combine(grouping, c("grouping", "grouping_level"), "_") |>
  fuimus::combine(classification, c("classification", "classification_level"), "_") |>
  fuimus::combine(specialization, c("specialization", "specialization_level"), "_") |>
  tidyr::pivot_longer(
    section:specialization,
    names_to = "level",
    values_to = "description") |>
  dplyr::filter(!description %in% c("0", "3")) |>
  tidyr::separate_wider_delim(description, delim = "_", names = c("description", "group")) |>
  dplyr::mutate(
    group = NULL,
    version = NULL,
    level = factor(
      level,
      levels = c("section", "grouping", "classification", "specialization"),
      labels = c("I. Section", "II. Grouping", "III. Classification", "IV. Specialization"),
      ordered = TRUE)
    ) |>
  dplyr::distinct()


ark_long2 <- ark_long |>
  dplyr::arrange(year, code) |>
  dplyr::distinct(year, code, level) |>
  dplyr::mutate(nlevels = dplyr::consecutive_id(level), .by = c(year, code)) |>
  dplyr::group_by(code) |>
  dplyr::summarise(
    nlevels = max(nlevels),
    first_year = as.integer(min(year)),
    last_year = as.integer(max(year)),
    .groups = "drop") |>
  dplyr::arrange(code) |>
  dplyr::mutate(
    last_year = dplyr::if_else(code %in% deactivated, 2022L, last_year),
    interval = ivs::iv(first_year, last_year),
    nyears = as.integer(last_year - first_year)) |>
  dplyr::select(-first_year, -last_year) |>
  dplyr::mutate(year = ivs::iv_start(interval)) |>
  dplyr::select(
    year,
    code,
    nlevels,
    interval,
    nyears
  )

ark_long <- ark_long |>
  dplyr::full_join(ark_long2) |>
  dplyr::arrange(code, level, year) |>
  dplyr::select(-interval) |>
  tidyr::fill(nlevels, nyears)


ark_long |>
  dplyr::filter(code == "101Y00000X") |>
  dplyr::arrange(year) |>
  print(n = 100)

# ark_long <- get_pin("ark_long") |>
#   dplyr::distinct(code, level, description)

pin_update(
  ark_long,
  name = "ark_long",
  title = "NUCC Taxonomy Archive 2009-2024 (Long)",
  description = "Health Care Provider Taxonomy Code Set Archive 2009-2024 (Long)"
)

ark_long |>
  dplyr::group_by(code) |>
  dplyr::mutate(years = ivs::iv(min(year), max(year))) |>
  dplyr::arrange(code, level, year) |>
  dplyr::filter(code == "133VN1201X") |>
  print(n = 100)

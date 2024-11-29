source(here::here("data-raw", "pins_internal.R"))

wide <- arktax::retrieve_ark(year = 2024, which = "wide") |>
  dplyr::select(-modified, -effective, -deactivated)

base <- wide |>
  dplyr::select(code, notes) |>
  dplyr::distinct(code, notes, .keep_all = TRUE) |>
  dplyr::mutate(
    .id = dplyr::row_number(),
    updates = stringr::str_extract_all(notes, "\\[.*\\]"),
    sources = stringr::str_remove_all(notes, "\\s?\\[.*\\]") |> dplyr::na_if(""),
    notes = NULL) |>
  tidyr::unnest(updates, keep_empty = TRUE)

updates <- base |>
  dplyr::select(-sources) |>
  dplyr::filter(not_na(updates)) |>
  tidyr::separate_longer_delim(
    cols = updates,
    delim = stringr::fixed("; ")) |>
  dplyr::mutate(
    updates = stringr::str_remove_all(updates, "(^\\[)|(\\]$)"),
    first = stringr::str_extract_all(updates, ", \\d{1,2}")) |>
  tidyr::unnest(first, keep_empty = TRUE) |>
  dplyr::mutate(
    first = str_remove(first, ", "),
    multi = str_count(updates, ", \\d{1}/\\d{1}/\\d{4}"))

updates <- vctrs::vec_rbind(
  updates |> dplyr::filter(multi == 0),
  updates |>
    dplyr::filter(multi > 0) |>
    tidyr::separate_longer_delim(
      cols = updates,
      delim = stringr::regex(", \\d{1,2}")) |>
    dplyr::mutate(updates = dplyr::if_else(
      stringr::str_detect(updates, "^[/]"),
      stringr::str_glue("{first}{updates}"), updates))
) |>
  dplyr::select(-first, -multi) |>
  dplyr::mutate(
    dates = stringr::str_extract_all(updates, "\\d{1,2}[/]\\d{1,2}[/]\\d{4}"),
    updates = stringr::str_remove_all(updates, "\\d{1,2}[/]\\d{1,2}[/]\\d{4}[:, ]\\s?")) |>
  tidyr::unnest(dates, keep_empty = TRUE) |>
  dplyr::mutate(dates = clock::date_parse(dates, format = "%m/%d/%Y"))

updates |>
  dplyr::mutate(
    date_type = dplyr::case_when(
      stringr::str_detect(updates, "[Nn]ew") ~ "effective",
      stringr::str_detect(updates, "inactive") ~ "deactivated",
      .default = "modified") |> forcats::as_factor()) |>
  dplyr::arrange(code, dates) |>
  dplyr::count(updates, sort = TRUE) |>
  print(n = 50)

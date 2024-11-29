source(here::here("data-raw", "pins_internal.R"))

# Use wide version
wide <- arktax::retrieve_ark(
  year = 2024,
  version = 1,
  which = "wide") |>
  dplyr::select(-year, -version) |>
  fuimus::remove_quiet()

#------------ BASE
base <- wide |>
  dplyr::select(code, notes) |>
  dplyr::distinct(
    code,
    notes,
    .keep_all = TRUE) |>
  dplyr::filter(codex::not_na(notes)) |>
  dplyr::mutate(
    .id = dplyr::row_number(),
    updates = stringr::str_extract_all(notes, "\\[.*\\]"),
    sources = stringr::str_remove_all(notes, "\\s?\\[.*\\]") |> dplyr::na_if(""),
    notes = NULL) |>
  tidyr::unnest(updates, keep_empty = TRUE)

#--------- SOURCES
sources <- base |>
  dplyr::select(-updates, -.id) |>
  dplyr::filter(codex::not_na(sources)) |>
  dplyr::distinct() |>
  dplyr::mutate(
    sources = dplyr::case_when(
    code == "2085U0001X" ~ stringr::str_glue(
      "{sources}. Additional Resources: See 2085R0202X. ",
      "The American Osteopathic Board of Radiology no longer offers a certificate in this specialty ",
      "(Diagnostic Ultrasound is part of the scope of a Diagnostic Radiologist)."),
    .default = sources)) |>
  dplyr::reframe(
    code,
    type = "primary",
    source = stringr::str_remove(sources, "^[Ss]ources?: "),
    addition = stringr::str_detect(sources, " Additional Resources: "))

sources <- vctrs::vec_rbind(
  sources |>
    dplyr::filter(!addition),
  sources |>
    dplyr::filter(addition) |>
    tidyr::separate_longer_delim(
      cols = source,
      delim = stringr::fixed(" Additional Resources: ")) |>
    dplyr::mutate(
      id = dplyr::row_number(),
      .before = 1,
      .by = code) |>
    dplyr::mutate(
      type = dplyr::if_else(
        id == 1,
        "primary",
        "additional"),
      id = NULL)) |>
  dplyr::select(-addition) |>
  dplyr::mutate(
    type = factor(type,
    levels = c("primary", "additional"), ordered = TRUE)) |>
  dplyr::arrange(code, type)

# 2085U0001X
# 2008-07-01
# Additional Resources: The American Osteopathic Board of Radiology no longer offers a certificate in this specialty.
# Note: In medical practice, Diagnostic Ultrasound is part of the scope of training and practice of a Diagnostic Radiologist - see Taxonomy Code 2085R0202X.

pin_update(
  sources,
  "sources",
  "NUCC Taxonomy Sources 2009-2024",
  "Health Care Provider Taxonomy Code Set Sources 2009-2024"
)


#----------------------------- UPDATES
updates <- base |>
  dplyr::select(-sources) |>
  dplyr::filter(codex::not_na(updates)) |>
  tidyr::separate_longer_delim(
    cols = updates,
    delim = stringr::fixed("; ")) |>
  dplyr::mutate(
    updates = stringr::str_remove_all(updates, "(^\\[)|(\\]$)"),
    first = stringr::str_extract_all(updates, ", \\d{1,2}")) |>
  tidyr::unnest(first, keep_empty = TRUE) |>
  dplyr::mutate(
    first = stringr::str_remove(first, ", "),
    multi = stringr::str_count(updates, ", \\d{1,2}/\\d{1,2}/\\d{2,4}"))

updates <- vctrs::vec_rbind(
  updates |> dplyr::filter(multi == 0),
  updates |>
    dplyr::filter(multi > 0) |>
    tidyr::separate_longer_delim(
      cols = updates,
      delim = stringr::regex(", \\d{1,2}")) |>
    dplyr::mutate(updates = dplyr::if_else(
      stringr::str_detect(updates, "^[/]"),
      stringr::str_glue("{first}{updates}"), updates))) |>
  dplyr::select(-multi, -first) |>
  dplyr::mutate(
    dates = stringr::str_extract_all(updates, "\\d{1,2}[/]\\d{1,2}[/]\\d{2,4}"),
    updates = stringr::str_remove_all(updates, "\\d{1,2}[/]\\d{1,2}[/]\\d{2,4}[:]\\s?"),
    updates = dplyr::if_else(updates == "New", "new", updates),
    updates = stringr::str_remove_all(updates, "\\d{1}[/]\\d{1}[/]\\d{4},?\\s?"),
    updates = dplyr::if_else(updates == "42 U.S.C. 1396d(1)(3)(B)] [added definition", "added definition", updates)) |>
  tidyr::unnest(dates, keep_empty = TRUE) |>
  dplyr::mutate(
    dates = dplyr::if_else(dates == "7/1/24", "7/1/2024", dates),
    dates = clock::date_parse(dates, format = "%m/%d/%Y"),
    updates = dplyr::case_when(
      code == "207RX0202X" & dates == "2007-07-01" ~ "added definition, added source",
      code == "207RX0202X" & dates == "2007-11-05" ~ "corrected definition",
      code == "320600000X" & dates == "2003-07-01" ~ "new",
      code == "320600000X" & dates == "2021-01-01" ~ "modified title and definition",
      code == "2085U0001X" & dates == "2008-07-01" ~ "definition added, source added",
      .default = updates)) |>
  dplyr::distinct() |>
  dplyr::mutate(
    category = dplyr::case_when(
      stringr::str_detect(updates, "new") ~ "effective",
      stringr::str_detect(updates, "inactive") ~ "deactivated",
      .default = "modified"),
    category = factor(
      category,
      levels = c("effective", "modified", "deactivated"), ordered = TRUE)
    ) |>
  dplyr::arrange(code, dates, category) |>
  dplyr::reframe(
    code,
    date_type = category,
    date = dates,
    change = stringr::str_replace(updates, "^marked inactive, use value ", "marked inactive, use "))

pin_update(
  updates,
  "changelog",
  "NUCC Taxonomy Changelog 2009-2024",
  "Health Care Provider Taxonomy Code Set Changelog 2009-2024"
)

#--------- Comparing raw dates to the updates
updates |> dplyr::filter(type == "modified")

arktax::retrieve_ark(which = "wide") |>
  dplyr::select(code, modified) |>
  dplyr::filter(codex::not_na(modified)) |>
  dplyr::distinct() |>
  print(n = 200)

updates |> dplyr::filter(type == "effective")

arktax::retrieve_ark(which = "wide") |>
  dplyr::select(code, effective) |>
  dplyr::filter(codex::not_na(effective)) |>
  dplyr::distinct()

updates |>
  dplyr::filter(type == "deactivated") |>
  print(n = 30)

arktax::retrieve_ark(which = "wide") |>
  dplyr::select(code, deactivated) |>
  dplyr::filter(codex::not_na(deactivated)) |>
  dplyr::distinct()

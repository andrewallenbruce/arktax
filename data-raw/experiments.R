tax_split <- arktax::taxonomy_raw() |>
  collapse::fselect(code) |>
  collapse::funique() |> # 875 unique codes
  collapse::mtt(code = kit::psort(code, nThread = 4L)) |>
  collapse::fmutate(
    `12` = stringr::str_sub(code, 1, 2) |> as.integer(),
    `123` = stringr::str_sub(code, 1, 3) |> as.integer(),
    `1` = stringr::str_sub(code, 1, 1) |> as.integer(),
    `2` = stringr::str_sub(code, 2, 2) |> as.integer(),
    `3` = stringr::str_sub(code, 3, 3) |> as.integer(),
    `4` = stringr::str_sub(code, 4, 4),
    `5` = stringr::str_sub(code, 5, 5),
    `6` = stringr::str_sub(code, 6, 6) |> as.integer(),
    `7` = stringr::str_sub(code, 7, 7) |> as.integer(),
    `8` = stringr::str_sub(code, 8, 8) |> as.integer(),
    `9` = stringr::str_sub(code, 9, 9) |> as.integer(),
    `10` = stringr::str_sub(code, 10, 10))

split_count <- hacksaw::count_split(
  tax_split,
  # `12`,
  # `123`,
  `1`,
  `2`,
  `3`,
  `4`,
  `5`,
  `6`,
  `7`,
  `8`,
  `9`,
  `10`
)

# Regex sketch
split_count |>
  purrr::map(\(x) {
  x <- dplyr::pull(x, 1)
  x <- x[collapse::radixorder(x)]
  glue::glue("{paste0(x)}") |>
    glue::glue_collapse()
}) |>
  purrr::map(\(x) glue::glue("[{x}]")) |>
  unlist(use.names = FALSE) |>
  paste0(collapse = "")

# Final regex
"^[1-4][0-9]{2}[0-9A-HJ-NP-Z][0A-IL-NP-X][0-4][0-9][0-69][0-9][X]$"

tax_split |>
  collapse::fcount(`123`) |>
  collapse::roworder(`123`) |>
  print(n = 50)

tax_split |>
  collapse::slt(-code, -`10`) |>
  as.matrix()

arktax::taxonomy_raw() |>
  collapse::fselect(code) |>
  collapse::funique() |>
  glue::glue_data('"{code}", ')
  _$code |>
  cat(sep = ", ")

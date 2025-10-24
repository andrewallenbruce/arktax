nucc_url_prefix <- function(x) {
  glue::glue("https://www.nucc.org/images/stories/CSV/{x}")
}

clean_columns <- function(x) {
  fuimus::remove_quotes(stringr::str_squish(dplyr::na_if(x, "")))
}

parse_mdy <- function(x) {
  readr::parse_date(x, format = "%m/%d/%y")
}

parse_mdY <- function(x) {
  readr::parse_date(x, format = "%m/%d/%Y")
}

clean_nucc_info <- function(html_path) {

  html <- brio::read_lines(html_path)

  rexprs <- c(
    "[\"']" = "",
    "<li><a href=/images/stories/CSV/|</a></li>|," = "",
    ">" = " ",
    "[^\x20-\x7E]" = "" # remove non-ASCII characters
  )

  x <- html[stringr::str_which(html, "Version")] |>
    stringr::str_replace_all(rexprs) |>
    stringr::str_split(" ") |>
    purrr::list_transpose() |>
    rlang::set_names(c("file_name", "TXT", "version", "release_date"))

  # List -> tibble, cleanse, add download URL prefix
  fastplyr::new_tbl(
    release_date = parse_mdy(x$release_date),
    file_name    = x$file_name,
    version      = x$version,
    download_url = nucc_url_prefix(x$file_name)
  ) |>
    collapse::mtt(
      major = as.integer(stringr::str_c(
        "20",
        stringr::str_pad(
          stringr::str_extract(version, "^.*(?=[.])"),
          width = 2,
          pad = "0"
        )
      )),
      minor = as.integer(stringr::str_extract(version, "(?<=[.]).*$")),
      version = as.double(version)
    ) |>
    collapse::slt(release_date, version, major, minor, file_name, download_url)

}

# Pin management functions
pin_update <- function(x, name, title, description, force = FALSE) {
  board <- pins::board_folder(here::here("inst/extdata/pins"))

  board |>
    pins::pin_write(
      x,
      name        = name,
      title       = title,
      description = description,
      type        = "qs",
      force_identical_write = force)

  board |> pins::write_board_manifest()
}

delete_pins <- function(pin_names) {
  board <- pins::board_folder(here::here("inst/extdata/pins"))
  pins::pin_delete(board, names = pin_names)
}

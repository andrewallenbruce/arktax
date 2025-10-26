nucc_url_prefix <- \(x) glue::glue("https://www.nucc.org/images/stories/CSV/{x}")

clean_columns <- function (x) {
  x <- iconv(x, "", "UTF-8", sub = "")
  x <- gsub("[^\x20-\x7E]", "", x, perl = TRUE)
  # x <- gsub("\\x96", "", x, perl = TRUE)
  x <- gsub("[\"']", "", x, perl = TRUE)
  x <- trimws(x)
  x <- gsub("  ", " ", x, perl = TRUE)
  dplyr::na_if(x, "")
}

parse_mdy <- \(x) readr::parse_date(x, format = "%m/%d/%y")
parse_mdY <- \(x) readr::parse_date(x, format = "%m/%d/%Y")
parse_Ymd <- \(x) readr::parse_date(x, format = "%Y-%m-%d")

read_nucc <- function(path) {
  readr::read_csv(
    file = path,
    id = "file_name",
    show_col_types = FALSE,
    col_types = readr::cols(),
    num_threads = 4L) |>
    collapse::sbt(stringr::str_detect(Code, "^Copy", negate = TRUE)) |>
    collapse::mtt(file_name = basename(file_name)) |>
    janitor::clean_names() |>
    # cheapr::sset(318) |> _$specialization
    purrr::modify_if(is.character, clean_columns)
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

get_xwalk_api <- function() {

  ss_3NA <- \(x) cheapr::sset(x, cheapr::which_(cheapr::row_na_counts(x) < 3L))

  x <- RcppSimdJson::fload(json = "https://data.cms.gov/data.json", query = "/dataset")
  x <- collapse::sbt(x, stringr::str_which(title, "[Tt]axonomy"))

  temp <- x |>
    collapse::get_elem("distribution", DF.as.list = TRUE) |>
    collapse::rowbind(fill = TRUE) |>
    collapse::fcompute(
      year       = stringr::str_extract(title, "[12]{1}[0-9]{3}") |> as.integer(),
      title      = stringr::str_remove(title, " : [0-9]{4}-[0-9]{2}-[0-9]{2}([0-9A-Za-z]{1,3})?$"),
      format     = kit::iif(!is.na(description), description, format, nThread = 4L),
      modified   = parse_Ymd(modified),
      identifier = accessURL,
      download   = cheapr::lag_(downloadURL, n = -1L),
      resources  = resourcesAPI
    ) |>
    collapse::roworder(title, -year)

  temp <- ss_3NA(temp)

  base <- x |>
    collapse::mtt(
      modified    = parse_Ymd(modified),
      periodicity = accrualPeriodicity,
      references  = unlist(references, use.names = FALSE),
      dictionary  = describedBy,
      site        = landingPage
    ) |>
    collapse::join(
      collapse::sbt(temp, format == "latest", c("title", "download", "resources")),
      on = "title",
      verbose = 0,
      multiple = TRUE
    ) |>
    collapse::roworder(title) |>
    collapse::colorder(title, description)

  base <- ss_3NA(base)

  collapse::sbt(temp, format != "latest", -format) |>
    collapse::roworder(title, -year) |>
    collapse::join(
      collapse::slt(
        base,
        c(
          "title",
          "description",
          "periodicity",
          "dictionary",
          "site",
          "references"
        )
      ),
      on = "title",
      verbose = 0,
      multiple = TRUE
    ) |>
    fastplyr::as_tbl()
}

get_xwalk_src <- function(x) {
  purrr::map(x, \(x) RcppSimdJson::fload(json = x, query = "/data")) |>
    purrr::list_rbind() |>
    collapse::mtt(
      year = as.integer(stringr::str_extract(name, "[12]{1}[0-9]{3}")),
      file = gsub("  ", " ", gsub(" [0-9]{4}|[0-9]{4} ", "", name, perl = TRUE), perl = TRUE),
      size = fs::as_fs_bytes(fileSize),
      ext = tolower(fs::path_ext(downloadURL)),
      download = downloadURL,
      .keep = c("year", "file", "size", "ext")) |>
    fastplyr::f_fill(year) |>
    fastplyr::as_tbl() |>
    collapse::mtt(year = ifelse(is.na(year), as.integer(stringr::str_extract(download, "[12]{1}[0-9]{3}")), year))
}

get_xwalk_info <- function(x) {
  x |>
    collapse::sbt(ext == "csv") |>
    collapse::mtt(file_name = gsub("__", "_", gsub(" ", "_", tolower(
      URLdecode(basename(download))
    )))) |>
    collapse::gby(file_name) |>
    collapse::mtt(id = collapse::seqid(year)) |>
    collapse::fungroup() |>
    collapse::mtt(file_name = glue::glue("Y{year}_{id}_{file_name}"),
                  id = NULL)

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

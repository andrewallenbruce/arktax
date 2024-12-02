# "https://www.nucc.org/index.php/code-sets-mainmenu-41/provider-taxonomy-mainmenu-40/csv-mainmenu-57"

urls <- paste0("https://www.nucc.org",
               paste0("https://www.nucc.org",
                      rvest::session("https://www.nucc.org") |>
                        rvest::session_follow_link("Code Sets") |>
                        rvest::session_follow_link("Taxonomy") |>
                        rvest::session_follow_link("CSV") |>
                        rvest::html_elements("a") |>
                        rvest::html_attr("href") |>
                        stringr::str_subset("taxonomy") |>
                        stringr::str_subset("csv")) |>
                 rvest::read_html() |>
                 rvest::html_elements("a") |>
                 rvest::html_attr("href") |>
                 stringr::str_subset("nucc_taxonomy"))

infotable <- readLines(paste0(here::here(), "/data-raw/raw/nucc_csv_titles_dates.txt")) |>
  stringr::str_split("/CSV", simplify = TRUE) |>
  as.data.frame() |>
  dplyr::select(V2) |>
  dplyr::mutate(
    V2 = stringr::str_remove(V2, '/') |>
      stringr::str_remove('"') |>
      stringr::str_replace('>', " ") |>
      stringr::str_remove("</a></li>") |>
      stringr::str_remove(",")) |>
  tidyr::separate_wider_regex(
    V2,
    c(filename = "nucc_taxonomy_[0-9]{2,3}.csv",
      ' Version ',
      version = "[0-9]{1,2}[.][0-9]{1}",
      " ",
      release_date = "[0-9][/][0-9][/][0-9]{2}")) |>
  dplyr::mutate(
    release_date = readr::parse_date(release_date, format = "%m/%d/%y"),
    file_url = urls)

fs::dir_create(glue::glue("{here::here()}/posts/taxonomy/data/csvs"))

curl::multi_download(
  urls = infotable$file_url,
  destfile = glue::glue("{here::here()}/posts/taxonomy/data/csvs/{infotable$filename}"),
  resume = TRUE)

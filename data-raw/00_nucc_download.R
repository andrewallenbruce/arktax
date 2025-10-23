source(here::here("data-raw", "pins_internal.R"))

nucc_url_prefix <- function(x) glue::glue("https://www.nucc.org/images/stories/CSV/{x}")
nucc_url_info   <- "https://www.nucc.org/index.php/code-sets-mainmenu-41/provider-taxonomy-mainmenu-40/csv-mainmenu-57"
nucc_html_path  <- here::here("data-raw/raw/nucc_html.txt")

# Download NUCC taxonomy HTML page
xml2::download_html(url = nucc_url_info, file = nucc_html_path)

# Read NUCC taxonomy HTML
nucc_html <- brio::read_lines(nucc_html_path)

# Extract NUCC csv file information into list
x <- nucc_html[stringr::str_which(nucc_html, "Version")] |>
  stringr::str_replace_all(c("[\"']" = "", "<li><a href=/images/stories/CSV/|</a></li>" = "", ">" = " ", "," = "")) |>
  stringr::str_split(" ") |>
  purrr::list_transpose() |>
  rlang::set_names(c("file_name", "VTXT", "version", "release_date"))

# List -> tibble, cleanse, add download URL
nucc_info <- fastplyr::new_tbl(
  file_name    = x$file_name,
  version      = x$version,
  release_date = readr::parse_date(x$release_date, format = "%m/%d/%y"),
  download_url = nucc_url_prefix(x$file_name)) |>
  collapse::mtt(
    major      = as.integer(stringr::str_c("20", stringr::str_pad(stringr::str_extract(version, "^.*(?=[.])"), width = 2, pad = "0"))),
    minor      = as.integer(stringr::str_extract(version, "(?<=[.]).*$")),
    version    = as.double(version)) |>
  collapse::slt(release_date, version, major, minor, file_name, download_url)

# Save NUCC file info csv
readr::write_csv(nucc_info, here::here("data-raw/raw/nucc_file_info.csv"))

# Define csv directory path
csv_dir <- here::here("data-raw/raw/csvs/")

# Create csv directory if it doesn't exist
if (!fs::dir_exists(csv_dir)) {
  fs::dir_create(csv_dir)
}

# Create vector of destination file paths
dest_files <- glue::glue("{csv_dir}/{nucc_info$file_name}")

# Download NUCC taxonomy csv files
curl::multi_download(
  urls     = nucc_info$download_url,
  destfile = dest_files,
  resume   = TRUE)

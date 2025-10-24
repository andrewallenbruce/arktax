source(here::here("data-raw", "fns.R"))

# Define NUCC directory path
nucc_dir <- fs::path_abs("data-raw/nucc/")

# Create nucc directory if it doesn't exist
if (!fs::dir_exists(nucc_dir)) {
  fs::dir_create(nucc_dir)
}

# NUCC URL with csv download URLs & file path
nucc_url_info   <- "https://www.nucc.org/index.php/code-sets-mainmenu-41/provider-taxonomy-mainmenu-40/csv-mainmenu-57"
nucc_html_path  <- fs::path(nucc_dir, "nucc_html.txt")
nucc_html_csv   <- fs::path(nucc_dir, "nucc_file_info.csv")

# Download NUCC taxonomy HTML
xml2::download_html(url = nucc_url_info, file = nucc_html_path)

# Extract NUCC csv file information into tibble
nucc_info <- clean_nucc_info(nucc_html_path)

# Save NUCC file info csv
readr::write_csv(x = nucc_info, file = nucc_html_csv, num_threads = 4L)

# Define csv directory path
csv_dir <- fs::path(nucc_dir, "csvs")

# Create csv directory if it doesn't exist
if (!fs::dir_exists(csv_dir)) {
  fs::dir_create(csv_dir)
}

# Create file path destinations
dest_files <- fs::path(csv_dir, nucc_info$file_name)

# Download NUCC taxonomy csv files
curl::multi_download(
  urls     = nucc_info$download_url,
  destfile = dest_files,
  resume   = TRUE)

# Archive NUCC csv files into tar.xz
archive::archive_write_dir(
  archive = fs::path(nucc_dir, "nucc_csv.tar.xz"),
  dir     = csv_dir
)

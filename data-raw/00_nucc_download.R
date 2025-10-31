source(here::here("data-raw", "fns.R"))

# Create NUCC directory
nucc_dir <- fs::path_abs("data-raw/nucc/")

if (!fs::dir_exists(nucc_dir)) {
  fs::dir_create(nucc_dir)
}

# Define NUCC info URL & file path
nucc_info_url  <- "https://www.nucc.org/index.php/code-sets-mainmenu-41/provider-taxonomy-mainmenu-40/csv-mainmenu-57"
nucc_info_path <- fs::path(nucc_dir, "nucc_info.txt")

# Download NUCC taxonomy HTML
xml2::download_html(url = nucc_info_url, file = nucc_info_path)

# Clean NUCC html info
nucc_info_clean <- nucc_clean_info(nucc_info_path)

# Save NUCC file info csv
readr::write_csv(x = nucc_info_clean, file = fs::path(nucc_dir, "nucc_info.csv"), num_threads = 4L)

# Create NUCC csv directory
nucc_dir_csv <- fs::path(nucc_dir, "csvs")

if (!fs::dir_exists(nucc_dir_csv)) {
  fs::dir_create(nucc_dir_csv)
}

# Download NUCC csvs
curl::multi_download(
  urls     = nucc_info_clean$download_url,
  destfile = fs::path(nucc_dir_csv, nucc_info_clean$file_name),
  resume   = TRUE)

# Archive NUCC csvs
archive::archive_write_dir(
  archive = fs::path(nucc_dir, "nucc_csv.tar.xz"),
  dir     = nucc_dir_csv
)

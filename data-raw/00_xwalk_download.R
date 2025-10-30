source(here::here("data-raw", "fns.R"))

xwalk_api  <- get_xwalk_api()
xwalk_src  <- get_xwalk_src(xwalk_api$resources)
xwalk_info <- get_xwalk_info(xwalk_src)

# Define XWALK directory path
xwalk_dir <- fs::path_abs("data-raw/xwalk/")

# Create XWALK directory if it doesn't exist
if (!fs::dir_exists(xwalk_dir)) {
  fs::dir_create(xwalk_dir)
}

# Save XWALK file info csv
readr::write_csv(
  x           = xwalk_api,
  file        = fs::path(xwalk_dir, "xwalk_api.csv"),
  num_threads = 4L
)
readr::write_csv(
  x           = xwalk_src,
  file        = fs::path(xwalk_dir, "xwalk_src.csv"),
  num_threads = 4L
)
readr::write_csv(
  x           = xwalk_info,
  file        = fs::path(xwalk_dir, "xwalk_info.csv"),
  num_threads = 4L
)

# Define XWALK csv directory path
xwalk_csv_dir <- fs::path(xwalk_dir, "csvs")

# Create csv directory if it doesn't exist
if (!fs::dir_exists(xwalk_csv_dir)) {
  fs::dir_create(xwalk_csv_dir)
}

# Create file path destinations
xwalk_dest_files <- fs::path(xwalk_csv_dir, xwalk_info$file_name)

# Download XWALK csv files
curl::multi_download(
  urls     = xwalk_info$download,
  destfile = xwalk_dest_files,
  resume   = TRUE)

# Archive XWALK csv files into tar.xz
archive::archive_write_dir(
  archive = fs::path(xwalk_dir, "xwalk_csv.tar.xz"),
  dir     = xwalk_csv_dir
)

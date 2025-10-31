source(here::here("data-raw", "fns.R"))

xwalk_api  <- xwalk_get_api()
xwalk_src  <- xwalk_get_src(xwalk_api$resources)
xwalk_info <- xwalk_get_info(xwalk_src)

# Create XWALK directory
xwalk_dir <- fs::path_abs("data-raw/xwalk/")

if (!fs::dir_exists(xwalk_dir)) fs::dir_create(xwalk_dir)

# Save XWALK info files
readr::write_csv(x = xwalk_api, file = fs::path(xwalk_dir, "xwalk_api.csv"), num_threads = 4L)
readr::write_csv(x = xwalk_src, file = fs::path(xwalk_dir, "xwalk_src.csv"), num_threads = 4L)
readr::write_csv(x = xwalk_info, file = fs::path(xwalk_dir, "xwalk_info.csv"), num_threads = 4L)

# Create XWALK csv directory
xwalk_csv_dir <- fs::path(xwalk_dir, "csvs")

if (!fs::dir_exists(xwalk_csv_dir)) fs::dir_create(xwalk_csv_dir)

# Download XWALK csvs
curl::multi_download(
  urls = xwalk_info$download,
  destfile = fs::path(xwalk_csv_dir, xwalk_info$file_name),
  resume = TRUE
)

# Archive XWALK csvs
archive::archive_write_dir(
  archive = fs::path(xwalk_dir, "xwalk_csv.tar.xz"),
  dir = xwalk_csv_dir
)

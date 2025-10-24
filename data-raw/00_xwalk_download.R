data <- "https://data.cms.gov/data.json" |>
  httr2::request() |>
  httr2::req_perform() |>
  httr2::resp_body_string() |>
  RcppSimdJson::fparse(query = "/dataset")

dist <- data |>
  providertwo:::get_distribution(DF.as.list = TRUE) |>
  collapse::rowbind(fill = TRUE) |>
  collapse::fcompute(
    year       = providertwo:::extract_year(title),
    title      = providertwo:::gremove(title, " : [0-9]{4}-[0-9]{2}-[0-9]{2}([0-9A-Za-z]{1,3})?$"),
    format     = kit::iif(!is.na(description), description, format, nThread = 4L),
    modified   = providertwo:::as_date(modified),
    identifier = accessURL,
    download   = cheapr::lag_(downloadURL, n = -1L),
    resources  = resourcesAPI) |>
  collapse::roworder(title, -year)

dist <- cheapr::sset(dist, cheapr::which_(cheapr::row_na_counts(dist) < 3L))

base <- data |>
  collapse::mtt(
    uuid        = providertwo:::uuid_from_url(identifier),
    modified    = providertwo:::as_date(modified),
    periodicity = accrualPeriodicity,
    references  = unlist(references, use.names = FALSE),
    title       = providertwo:::clean_title(title),
    description = providertwo:::clean_title(description),
    dictionary  = describedBy,
    site        = landingPage,
    .keep       = c("identifier", "references")
  ) |>
  providertwo:::join_on_title(
    collapse::sbt(dist, format == "latest", c("title", "download", "resources"))) |>
  collapse::roworder(title) |>
  collapse::colorder(title, description)

base <- cheapr::sset(base, cheapr::which_(cheapr::row_na_counts(base) < 3L))

dist <- collapse::sbt(dist, format != "latest", -format) |>
  collapse::roworder(title, -year) |>
  providertwo:::f_nest(by = c("title", "download_only")) |>
  providertwo:::join_on_title(collapse::slt(base, c("title", "description", "periodicity", "dictionary", "site", "references"))) |>
  collapse::colorder(endpoints, pos = "end")

xwalk_urls <- dist[
  stringr::str_which(dist$title, "[Tt]axonomy"), ] |>
  _$endpoints |>
  purrr::pluck(1) |>
  _$resources

xwalk_resources <- xwalk_urls |>
  purrr::map(httr2::request) |>
  httr2::req_perform_parallel(on_error = "continue") |>
  httr2::resps_successes() |>
  httr2::resps_data(function(resp)
    httr2::resp_body_string(resp) |>
    RcppSimdJson::fparse(query = "/data")) |>
  collapse::mtt(
    year     = as.integer(stringi::stri_extract_first_regex(name, "[12]{1}[0-9]{3}")),
    file     = gsub("  ", " ", gsub(" [0-9]{4}|[0-9]{4} ", "", name, perl = TRUE), perl = TRUE),
    size     = fs::as_fs_bytes(fileSize),
    ext      = tolower(fs::path_ext(downloadURL)),
    download = downloadURL,
    .keep = c("year", "file", "size", "ext")
  ) |>
  fastplyr::f_fill(year) |>
  fastplyr::as_tbl() |>
  collapse::mtt(year = ifelse(
    is.na(year),
    as.integer(
      stringi::stri_extract_first_regex(download, "[12]{1}[0-9]{3}")
    ),
    year
  ))

xwalk_info <- xwalk_resources |>
  collapse::sbt(ext == "csv") |>
  collapse::mtt(file_name = gsub("__", "_", gsub(" ", "_", tolower(URLdecode(basename(download)))))) |>
  collapse::gby(file_name) |>
  collapse::mtt(id = collapse::seqid(year)) |>
  collapse::fungroup() |>
  collapse::mtt(file_name = glue::glue("Y{year}_{id}_{file_name}"), id = NULL)

# Define XWALK directory path
xwalk_dir <- fs::path_abs("data-raw/xwalk/")

# Create XWALK directory if it doesn't exist
if (!fs::dir_exists(xwalk_dir)) {
  fs::dir_create(xwalk_dir)
}

# XWALK URLs with csv download URLs & file path
xwalk_info_api <- fs::path(xwalk_dir, "xwalk_info_api.csv")

# Save XWALK file info csv
readr::write_csv(x = xwalk_resources, file = xwalk_info_api, num_threads = 4L)

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

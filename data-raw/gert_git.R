files_to_stage <- gert::git_status() |>
  dplyr::filter(!staged) |>
  dplyr::pull(file)

files_to_stage |>
  gert::git_add()

gert::git_commit_all("Add data-raw files")

gert::git_push()

.onLoad <- function(libname, pkgname) {

  board <- pins::board_folder(
    fs::path_package(
      "extdata/pins",
      package = "arktax")
    )

  .tax_raw        <<- pins::pin_read(board, "tax_raw")
  .tax_sources    <<- pins::pin_read(board, "tax_sources")
  .tax_changelog  <<- pins::pin_read(board, "tax_changelog")
  .tax_hierarchy  <<- pins::pin_read(board, "tax_hierarchy")
  .tax_display    <<- pins::pin_read(board, "tax_display")
  .tax_definition <<- pins::pin_read(board, "tax_definition")

}

.onUnload <- function(libpath) {

  remove(
    list = c(
      ".tax_raw",
      ".tax_sources",
      ".tax_changelog",
      ".tax_hierarchy",
      ".tax_display",
      ".tax_definition"
    ),
    envir = .GlobalEnv
  )

}

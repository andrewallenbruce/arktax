.onLoad <- function(libname, pkgname) {

  board   <- pins::board_folder(
    fs::path_package(
      "extdata/pins",
      package = "arktax")
    )

  tax_raw <<- pins::pin_read(board, "tax_raw")

}

.onUnload <- function(libpath) {

  rm(tax_raw, envir = .GlobalEnv)

}

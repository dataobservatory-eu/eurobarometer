#' @keywords internal
copy_to_tempdir_test <- function(sys_file) {

  if (!dir.exists(file.path(tempdir(), "test"))) {
    dir.create(file.path(tempdir(), "test"))
  }
  dir.exists(file.path(tempdir(), "test"))
  file.copy(system.file("extdata", sys_file ,
                        package = "eurobarometer"),
            file.path(tempdir(), "test", sys_file),
            overwrite = TRUE)
  file.exists(file.path(tempdir(), "test", sys_file))
}

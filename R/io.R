#' Read and validate GTFS files
#'
#' Reads GTFS text files from either a local \code{.zip} file or an URL and
#' validates them against GTFS specifications.
#'
#' @param path The path to a GTFS \code{.zip} file.
#' @param files A character vector containing the text files to be read from the
#'   GTFS (without the \code{.txt} extension). If \code{NULL} (the default) all
#'   existing files are read.
#' @param quiet Whether to hide log messages and progress bars (defaults to TRUE).
#' @param ... Can be used to pass on arguments to [gtfsio::import_gtfs()]. The parameters
#'            \code{files} and \code{quiet} are passed on by default.
#'
#' @return A tidygtfs object: a list of tibbles in which each entry represents a
#'         GTFS text file. Additional tables are stored in the \code{.} sublist.
#'
#' @seealso \code{\link{validate_gtfs}}
#'
#' @examples \dontrun{
#' local_gtfs_path <- system.file("extdata", "google_transit_nyc_subway.zip", package = "tidytransit")
#' gtfs <- read_gtfs(local_gtfs_path)
#' summary(gtfs)
#'
#' gtfs <- read_gtfs(local_gtfs_path, files = c("trips", "stop_times"))
#' names(gtfs)
#' }
#' @importFrom gtfsio import_gtfs new_gtfs
#' @export
read_gtfs <- function(path, files = NULL, quiet = TRUE, ...) {
  g = gtfsio::import_gtfs(path, files = files, quiet = quiet, ...)
  
  tidygtfs = gtfs_to_tidygtfs(g, files = files)
  
  return(tidygtfs)
}

#' Write a tidygtfs object to a zip file
#' 
#' @note Auxilliary tidytransit tables (e.g. \code{dates_services}) are not exported.
#' 
#' @param gtfs_obj gtfs feed (tidygtfs object)
#' @param zipfile path to the zip file the feed should be written to
#' @param compression_level a number between 1 and 9.9, passed to zip::zip
#' @param as_dir if TRUE, the feed is not zipped and zipfile is used as a directory path. 
#'               Files within the directory will be overwritten.
#' @return Invisibly returns gtfs_obj
#' 
#' @importFrom gtfsio export_gtfs
#' @export
write_gtfs <- function(gtfs_obj, zipfile, compression_level = 9, as_dir = FALSE) {
  stopifnot(inherits(gtfs_obj, "tidygtfs"))
  
  # convert sf tables
  gtfs_out = sf_as_tbl(gtfs_obj)
  
  # convert NA to empty strings
  gtfs_out <- na_to_empty_strings(gtfs_out)
  
  # data.tables
  gtfs_out <- gtfs_out[names(gtfs_out) != "."]
  gtfs_out <- lapply(gtfs_out, as.data.table)
  class(gtfs_out) <- list("gtfs")
  
  # convert dates/times to strings
  gtfs_out <- convert_dates(gtfs_out, date_as_gtfsio_char)
  gtfs_out <- convert_hms_to_char(gtfs_out)
  
  gtfsio::export_gtfs(gtfs_out, zipfile, 
                      standard_only = FALSE,
                      compression_level = compression_level, 
                      as_dir = as_dir, overwrite = TRUE)
  invisible(gtfs_obj)
}

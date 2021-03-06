# Adapted from
# https://stackoverflow.com/questions/28248457

fix_unicode <- function(char) {
  m <- gregexpr("<U\\+[0-9a-fA-F]{4}>", char)
  codes <- regmatches(char, m)
  chars <- lapply(codes, make_utf8)
  regmatches(char, m) <- chars
  enc2utf8(char)
}

make_utf8 <- function(x) {
  if (length(x) < 1) {
    return(x)
  } else {
    digits <- substring(x, 4, 7)
    integers <- strtoi(sprintf("0x%s", digits))
    purrr::map_chr(integers, intToUtf8)
  }
}

is_windows <- function() {
  tolower(Sys.info()[["sysname"]]) == "windows"
}

#' Fix unicode histograms on Windows
#' 
#' This functions changes your session's locale to address issues with printing
#' histograms on Windows.
#' 
#' There are known issues with printing the spark-histogram characters when
#' printing a data frame, appearing like this: "<U+2582><U+2585><U+2587>".
#' This longstanding problem originates in the low-level code for printing
#' dataframes.
#' @export

fix_windows_histograms <- function() {
  message("This function will change your system locale. It may have other ",
          "unintended effects.")
  response <- readline("Continue? (Y/n)")
  if (tolower(response) != "n") Sys.setlocale("LC_CTYPE", "Chinese")
  else message("Locale was not changed.")
  invisible(NULL)
}

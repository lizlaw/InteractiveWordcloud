#' generate_wordcloud
#'
#' A function to download data, clean and prepare, and plot the wordcloud, from the specified file and question.
#'
#' @param .file_name A chr string of the name of the survey response google sheet file (as in the Google Drive)
#' @param .file_path A chr string of the file location the google sheet will be downloaded to locally. (Needs ".csv")
#' @param .column_name A chr string denoting the question/column name of the responses to be integrated into the wordcloud.
#' @param .stopwords Options for cleaning common words. For further options, see ?tm::stopwords
#' @param .return A chr string, either "wordcloud" for plotting wordcloud output, or "data" for outputting the frequency table.
#' @param ... Further arguments passed to wordcloud2::wordcould2()
#'
#' @return Either a wordcloud plot, or a frequency table
#' @importFrom magrittr "%>%"
#' @export
#'
#' @examples
#' ## not run
#' # generate_wordcloud(size = 0.5)
#' # generate_wordcloud(.return = "data")

generate_wordcloud <- function(.file_name = "Interactive wordcloud (Responses)",
                               .file_path = "temp_wordcloud_responses.csv",
                               .column_name = "What is your favourite colour?",
                               .stopwords = "english",   # for options for cleaning common words see ?stopwords
                               .return = "wordcloud",    # alternatively, the frequency "data"
                               ...){                     # further arguments passed to wordcloud2()

  # download the file
  suppressMessages(
    googledrive::drive_download(
      .file_name,
      path = .file_path,
      overwrite = TRUE
    ))

  # import and process (converts into a 'corpus' format used by the tm package)
  wc_data <- suppressMessages(readr::read_csv(.file_path))

  stopifnot(nrow(wc_data) > 0)

  wc_data <- wc_data %>%
    dplyr::pull(!!dplyr::sym(.column_name)) %>%
    tm::VectorSource() %>%
    tm::VCorpus() %>%
    tm::tm_map(tm::content_transformer(tolower)) %>%
    tm::tm_map(tm::content_transformer(tm::removeNumbers)) %>%
    tm::tm_map(tm::content_transformer(tm::removePunctuation)) %>%
    tm::tm_map(function(x) tm::removeWords(x, tm::stopwords(.stopwords))) %>%
    tm::tm_map(tm::content_transformer(tm::stripWhitespace))

  # convert to frequency matrix
  wc_m <- tm::TermDocumentMatrix(wc_data) %>%
    as.matrix()
  wc_v <- sort(rowSums(wc_m), decreasing = TRUE)
  wc <- data.frame(word = names(wc_v), freq = wc_v)

  # plot (use set.seed) using wordcloud2
  if(.return == "wordcloud") return(wordcloud2::wordcloud2(wc, ...))
  if(.return == "data") return(wc)
}



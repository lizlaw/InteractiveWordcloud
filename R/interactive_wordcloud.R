#' interactive_wordcloud
#'
#' Iterates generate_wordcloud() for live audience participation
#'
#' @param .minutes A number of minutes that the function will iterate for
#' @param .freqsec A number of seconds denoting the iteration frequency
#' @param ... Further arguments passed to generate_wordcloud()
#'
#' @return A sequence of outputs from generate_wordcloud() (i.e. wordcloud plots or frequency tables)
#' @importFrom magrittr "%>%"
#' @export
#'
#' @examples
#' ## Not run
#' # interactive_wordcloud(.minutes = 0.1, .freqsec = 1, size = 0.5)

interactive_wordcloud <- function(.minutes = 1, .freqsec = 5, ...){
  .times = .minutes*60/.freqsec %>% round()
  for(i in 1:.times) {
    Sys.sleep(.freqsec)
    print(generate_wordcloud(...))
  }
}


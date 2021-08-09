#' Get Rankings
#'
#' Retrieve a list of all the sites in a particular project
#'
#' @param keywordid The keyword id (required)
#' @param fromdate Default is 100 most recent results (optional) Format is a string YYYY-MM-DD
#' @param todate Default is most recent ranking day (optional) Format is a string YYYY-MM-DD
#' @param start The default is 0 (zero indexed). The starting result for paginated requests
#' @param results The default is 100
#' @param subdomain The account subdomain
#' @param apikey The api key from the account
#'
#'
#' @import httr tidyr jsonlite
#' @importFrom glue glue
#' @importFrom purrr map_df
#'
#' @export
#'
ssar_rankings <- function(keywordid = NULL,
                         fromdate = NULL,
                         todate = NULL,
                         start = 0,
                         results = 100,
                         subdomain = Sys.getenv('SSAR_SUBDOMAIN'),
                         apikey = Sys.getenv('SSAR_APIKEY')) {
#siteid check
  if(is.null(keywordid)) stop ("The argument 'keywordid' is required. Please include 'keywordid' as an argument.")

  #add valid params
  params <- list(keyword_id = keywordid, from_date = fromdate, to_date = todate, start = start, results = results, format = 'json')
  #collect non NULL params into a list
  valid_params <- Filter(Negate(is.null), params)
  #make that list into a parameter string
  urlparams <- paste0(names(valid_params),'=',valid_params, collapse = '&')
  # build request url
  baseurl <- glue::glue('https://{subdomain}.getstat.com/api/v2/{apikey}/')
  endpoint <- 'rankings/list'

  requrl <- glue::glue('{baseurl}{endpoint}?{urlparams}')


 rankings <- httr::GET(requrl)

 #check the status for the call and return errors or don'te
 httr::stop_for_status(rankings, glue::glue('get the rankings. \n {httr::content(rankings)$Result}'))
  #if 200 but no results due to an error
 if(is.null(httr::content(rankings)$Response)) {
  stop(httr::content(rankings)$Result)
}

 rank <- httr::content(rankings)$Response$Result

 df <-  purrr::map_df(rank, unlist)

 return(df)

}

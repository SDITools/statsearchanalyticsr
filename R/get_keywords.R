#' Get Keywords
#'
#' Retrieve a list of all the keywords in a particular site
#'
#' @param siteid The site id (required)
#' @param start The default is 0 (zero indexed)
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
ssar_keywords <- function(siteid = NULL,
                         start = 0,
                         results = 2000,
                         subdomain = Sys.getenv('STATR_SUBDOMAIN'),
                         apikey = Sys.getenv('STATR_APIKEY')) {
#siteid check
  if(is.null(siteid)) stop ("The argument 'siteid' is required. Please include 'siteid' as an argument.")

  #add valid params
  params <- list(site_id = siteid, start = start, results = results, format = 'json')
  #collec non NULL params into a list
  valid_params <- Filter(Negate(is.null), params)
  #make that list into a parameter string
  urlparams <- paste0(names(valid_params),'=',valid_params, collapse = '&')
  # build request url
  baseurl <- glue::glue('https://{subdomain}.getstat.com/api/v2/{apikey}/')
  endpoint <- 'keywords/list'

  requrl <- glue::glue('{baseurl}{endpoint}?{urlparams}')


 keywords <- httr::GET(requrl)

 #check the status for the call and return errors if found
 httr::stop_for_status(keywords, glue::glue('get the keywords. \n {httr::content(keywords)$Result}'))
 #if 200 but no results due to an error
 if(is.null(httr::content(keywords)$Response)) {
   stop(httr::content(keywords)$Result)
 }

 keyw <- httr::content(keywords)$Response$Result

 df <-  purrr::map_df(keyw, unlist)

 return(df)

}

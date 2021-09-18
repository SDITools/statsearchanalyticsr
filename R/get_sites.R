#' Get Sites
#'
#' Retrieve a table of all the sites and metadata in a specified project
#'
#' @param projectid The project id. If not provided then all sites will be returned.
#' @param start If more than `results` are available use `start` as pagination. Index starts at 0 (default).
#' @param results Default is 100. Max is 5000.
#' @param subdomain The account subdomain
#' @param apikey The api key from the account
#'
#' @return A table of the site information within a project
#' 
#' @examples 
#' \dontrun{
#' ssar_sites(projectid = {project_id}, #replace with your project id
#'            results = 300)
#' }
#'
#' @import httr tidyr jsonlite
#' @importFrom glue glue
#' @importFrom purrr map_df
#'
#' @export
#'
ssar_sites <- function( projectid = NULL,
                         start = NULL,
                         results = 100,
                         subdomain = Sys.getenv('SSAR_SUBDOMAIN'),
                         apikey = Sys.getenv('SSAR_APIKEY')) {
#add valid params
  params <- list(project_id = projectid, start = start, results = results, format = 'json')
#collec non NULL params into a list
  valid_params <- Filter(Negate(is.null), params)
#make that list into a parameter string
  urlparams <- paste0(names(valid_params),'=',valid_params, collapse = '&')
  # build request url
  baseurl <- glue::glue('https://{subdomain}.getstat.com/api/v2/{apikey}/')

  endpoint <- if(!is.null(projectid)){
    'sites/list'
  } else {
    'sites/all'
  }

  requrl <- glue::glue('{baseurl}{endpoint}?{urlparams}&format=json')

 sites <- httr::GET(requrl)

#check the status for the call and return errors or don't
 httr::stop_for_status(sites, glue::glue('get the sites list. \n {httr::content(sites)$Result}'))
 #if 200 but no results due to an error
 if(is.null(httr::content(sites)$Response)) {
   stop(httr::content(sites)$Result)
 }

 #return the results
 sites <- httr::content(sites)[[1]]$Result

 df <-  purrr::map_df(sites, unlist)

return(df)
}

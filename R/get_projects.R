#' Get Projects
#'
#' Receive a list of all the projects on an account accessible through the provided api key
#'
#' @param subdomain The account subdomain
#' @param apikey The api key from the account
#'
#' @import httr tidyr jsonlite
#' @importFrom glue glue
#' @importFrom purrr map_df
#'
#' @return A dataframe of available project data your authentication has access to
#' 
#' @examples
#' \dontrun{
#' projects(subdomain = Sys.getenv('SSAR_SUBDOMAIN'),
#'          apikey = Sys.getenv('SSAR_APIKEY'))
#' }
#' 
#' @export
#' 
#'
ssar_projects <- function(subdomain = Sys.getenv('SSAR_SUBDOMAIN'),
                            apikey = Sys.getenv('SSAR_APIKEY')) {

# add valid params
  params <- list(format = 'json')

#collec non NULL params into a list
  valid_params <- Filter(Negate(is.null), params)

#make that list into a parameter string
  urlparams <- paste0(names(valid_params),'=',valid_params, collapse = '&')
# build request url
  baseurl <- glue::glue('https://{subdomain}.getstat.com/api/v2/{apikey}/')
  endpoint <- 'projects/list'

  requrl <- glue::glue('{baseurl}{endpoint}?{urlparams}&format=json')

  projects <- httr::GET(requrl)

  #check the status for the call and return errors if found
  httr::stop_for_status(projects, glue::glue('get the projects. \n {httr::content(projects)$Result}'))
  #if 200 but no results due to an error
  if(is.null(httr::content(projects)$Response)) {
    stop(httr::content(projects)$Result)
  }

 projs <- httr::content(projects)[[1]]$Result

 df <-  purrr::map_df(projs, unlist)

 return(df)

}

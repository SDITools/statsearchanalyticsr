#' Get Sites Ranking Distribution
#'
#' This request returns all ranking distribution records for Google and Bing for a site with the specified id. The maximum date range can be no greater than 31 days.
#'
#' @param siteid *Required* The site id.
#' @param from_date *Required* Character string in the 'YYYY-MM-DD' format. Default is -31 days from today
#' @param to_date *Required* Character string in the 'YYYY-MM-DD' format. Default is yesterday.
#' @param subdomain The account subdomain
#' @param apikey The api key from the account
#'
#' @return The dataframe with Google, GoogleBaseRank, and Bing ranking distributions by date
#' 
#' @import httr tidyr jsonlite
#' @importFrom glue glue
#' @importFrom purrr map_df
#' @importFrom tibble as_tibble
#'
#' @export
#'
ssar_sites_ranking_dist <- function( siteid = NULL,
                        from_date = as.character(Sys.Date()-31),
                        to_date = as.character(Sys.Date()-1),
                        subdomain = Sys.getenv('STATR_SUBDOMAIN'),
                        apikey = Sys.getenv('STATR_APIKEY') ) {
  
#siteid must be included
  if(is.null(siteid)) {
    stop('\'siteid\' must be provided')
  }
#add valid params
  params <- list(id = siteid, from_date = from_date, to_date = to_date, format = 'json')
#collec non NULL params into a list
  valid_params <- Filter(Negate(is.null), params)
#make that list into a parameter string
  urlparams <- paste0(names(valid_params),'=',valid_params, collapse = '&')
  # build request url
  baseurl <- glue::glue('https://{subdomain}.getstat.com/api/v2/{apikey}/')

  endpoint <- 'sites/ranking_distributions'

  requrl <- glue::glue('{baseurl}{endpoint}?{urlparams}&format=json')

 sites_res <- httr::GET(requrl)

#check the status for the call and return errors or don't
 httr::stop_for_status(sites, glue::glue('get the sites list. \n {httr::content(sites)$Result}'))
 #if 200 but no results due to an error
 if(is.null(httr::content(sites)$Response)) {
   stop(httr::content(sites))
 }

 #return the results
 sites <- httr::content(sites_res)$Response$RankDistribution

 dists <- function(x = 1:2){
    google <- as_tibble(c(date = sites[[x]]$date, type ='Google', sites[[x]]$Google ))
    googlebaserank <- as_tibble(c(date = sites[[x]]$date, type ='GoogleBaseRank', sites[[x]]$GoogleBaseRank))
    bing <- as_tibble(c(date = sites[[x]]$date, type ='Bing', sites[[x]]$Bing))
    
    rbind(google, googlebaserank, bing)
 }
 
df <- map_df(1:3, dists)
 
return(df)
}

#' Get Sites Ranking Distribution
#'
#' This function returns all ranking distribution records for Google and Bing for a site with the specified id. The maximum date range can be no greater than 31 days.
#'
#' @param siteid *Required* The site id.
#' @param fromdate *Required* Character string in the 'YYYY-MM-DD' format. Default is -31 days from today since the maximum date range can be no greater than 31 days.
#' @param todate *Required* Character string in the 'YYYY-MM-DD' format. Default is yesterday.
#' @param subdomain The account subdomain
#' @param apikey The api key from the account
#'
#' @return A table with Google, GoogleBaseRank, and Bing ranking distributions by date
#' 
#' @examples  
#' \dontrun{
#' ssar_sites_ranking_dist(siteid = {site_id}, #replace is your site id
#'                        fromdate = '2021-04-01',
#'                        todate = '2021-05-31')
#' }
#' 
#' @import httr tidyr jsonlite
#' @importFrom glue glue
#' @importFrom lubridate date
#' @importFrom purrr map_df
#'
#' @export
#'
ssar_sites_ranking_dist <- function( siteid = NULL,
                        fromdate = as.character(Sys.Date()-31),
                        todate = as.character(Sys.Date()-1),
                        subdomain = Sys.getenv('SSAR_SUBDOMAIN'),
                        apikey = Sys.getenv('SSAR_APIKEY') ) {
  
#siteid must be included
  if(is.null(siteid)) {
    stop('\'siteid\' must be provided')
  }
#add valid params
  params <- list(id = siteid, from_date = fromdate, to_date = todate, format = 'json')
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
 httr::stop_for_status(sites_res, glue::glue('get the sites list. \n {httr::content(sites_res)$Result}'))
 #if 200 but no results due to an error
 if(is.null(httr::content(sites_res)$Response$RankDistribution)) {
   stop("The request did not return any results. Make sure you used the correct Site ID.")
 }

 #return the results
 sites <- httr::content(sites_res)$Response$RankDistribution

 dists <- function(x){
   google <- tidyr::as_tibble(c(date = sites[[x]]$date, type ='Google', sites[[x]]$Google ))
   googlebaserank <- tidyr::as_tibble(c(date = sites[[x]]$date, type ='GoogleBaseRank', sites[[x]]$GoogleBaseRank))
   bing <- tidyr::as_tibble(c(date = sites[[x]]$date, type ='Bing', sites[[x]]$Bing))
   
   rbind(google, googlebaserank, bing)
 }
 
days = as.numeric(lubridate::date(todate)-lubridate::date(fromdate))
df <- purrr::map_df(seq(days), dists)
 
return(df)
}

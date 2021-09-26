# statsearchanalyticsr

The statsearchanalyticsr makes it easy to pull [STAT Search Analytics](https://getstat.com) data into R for visualization, integration, and analysis by enabling you to retrieve keyword ranking data in a tidy way. 

## Installation

You can install the development version of statsearchanalyticsr from github with:

``` r
install.packages('remotes')
remotes::install_github('searchdiscovery/statsearchanalyticsr')
```

## Define global variables with account information

Add both of these variables to your .Renviron file and restart the R session.

```r
SSAR_APIKEY = '{apikey}'  
SSAR_SUBDOMAIN = '{subdomain}'
```
Once completed, then the API is ready to start pulling data.

### Getting an API Key

The API Key can be acquired following these steps:

1. Under the Options menu, click Account Management.
2. In the Account Management pop-up, select Account Settings.
3. Click on the New API Key button.
4. In the pop-up, click Yes to generate a new API key and deactivate the old one.

*[More information.](https://help.getstat.com/knowledgebase/api-services/#generating-an-api-key)*

### Getting the subdomain

The subdomain is easy to find. It is the first part of the 'getstat.com' URL. For example, if your STAT login URL is `demonstration.getstat.com` then your STAT subdomain is `demonstration`.

*** 
### Rate Limits

The default daily limit for API calls is 1,000 calls per day. The daily count resets every night at midnight UTC. If you need to exceed the daily limit, you will need to talk to STAT Searh Analytics support.

If you are attempting to pull more than 1,000 keywords at a time, then consider using the ssar_bulk_rankings() function. This function enables you to pull all the rankings by day for all keywords. This option can be more time efficient, saving you a 24 hour wait for next data pull, but note it will likely include much more data than necessary.

## Examples

This is a basic example showing the process of pulling data for the first time:

``` r
## Get all available projects
projects <- ssar_projects()

## Get the sites for a specific project
sites <- ssar_sites(projectid = {project_id}) #replace {project_id} with a specific project id found in the `projects` object

## Get the keywords for a site
keywords <- ssar_keywords(siteid = {site_id}) #replace {site_id} with a specific site id found in the 'sites' object

## Get the rankings for a keyword
rankings <- ssar_rankings(keywordid = {keyword_id}, #replace {keyword_id} with a specific keyword id  found in the `keywords` object
                          fromdate = {created_at}, 
                          todate = Sys.Date()-1) 

## Get the bulk rankings report
all_rankings <- ssar_bulk_rankings(date = Sys.Date()-2, 
                                  siteid = {site_id}, 
                                  ranktype = 'highest', 
                                  engines = 'google', 
                                  currentlytracked = 'true', 
                                  crawledkeywords = 'true')
```


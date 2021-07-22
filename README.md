# statsearchanalytisr

The goal of statsearchanalyticsr is to create an easy to use library to access STAT Search Analytics data in R for visualization, integration, and analysis.

## Installation

You can install the development version of statsearchanalyticsr from github with:

``` r
## Load the development version of the package via github
remotes::install_github('searchdiscovery/statsearchanalyticsr')
```

## Define global variables with account information

### Add both of these variables to your .Renviron file and restart the R session.

SSAR_APIKEY = '{alphanuemricstring}'  
SSAR_SUBDOMAIN = '{accountsubdomain}'

### Getting an API Key

The api key can be acquired using following these steps:

1. Under the Options menu, click Account Management.
2. In the Account Management pop-up, select Account Settings.
3. Click on the New API Key button.
4. In the pop-up, click Yes to generate a new API key and deactivate the old one.

### Getting the subdomain

The subdomain is easy to find. It is the first part of the 'getstat.com' URL. For example, if your STAT login URL is demonstration.getstat.com then your STAT subdomain is demonstration.

*** 

Once this has been completed then the API is ready to start pulling data.  

**Important note:**

The default daily limit for API calls is 1,000 calls per day. The daily count resets every night at midnight UTC. If you need to exceed the daily limit, just talk to STAT support.

If you are attempting to pull more than 1,000 keywords then consider using the Bulk Rankings report. This feature enables you to pull all the rankings by day for all keywords. It is a lot of data and may be way more than necessary but if needed it can be a much better decision to use this option than having to wait 24 hours for another data pull.

## Examples

This is a basic example showing the process of pulling data:

``` r
library(statsearchanalyticsr)

## Get all available projects
projects <- ssar_projects()

## Get the sites for a specific project
sites <- ssar_sites(projectid = 2343)

## Get the keywords for a site
keywords <- ssar_keywords(siteid = 2353)

## Get the rankings for a keyword
rankings <- ssar_rankings(keywordid = 123123, fromdate = {created_at}, todate = Sys.Date()-1)
```


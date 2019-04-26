# This code is needed in order to run 
# the get_vins on Digital Ocean. Problems
# occured when trying to read in the initial 
# webpage. This fix makes use of a connection 
# and then preforms the read 
library(rvest)
library(stringr)

# test url 
url <- 'https://www.cars.com/for-sale/searchresults.action/?page=1&perPage=100&rd=50&searchSource=PAGINATION&shippable-dealers-checkbox=true&showMore=false&sort=relevance&stkTypId=28881&zc=72019&localVehicles=false'

website <- html_session(url)

webpage <- website %>% read_html()

interesting_text <- html_nodes(webpage, "script") %>% 
  html_text()

vin_pattern <- '"vin":"\\w+"'
vin_pattern02 <- '\\b[A-Z0-9]{17}'

vins <- str_extract_all(interesting_text[2], vin_pattern)
vins <- unlist(str_extract_all(unlist(vins), vin_pattern02))

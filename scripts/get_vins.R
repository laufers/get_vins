library(rvest)
library(stringr)

# test url 
url <- 'https://www.cars.com/for-sale/searchresults.action/?page=1&perPage=100&rd=50&searchSource=PAGINATION&shippable-dealers-checkbox=true&showMore=false&sort=relevance&stkTypId=28881&zc=72019&localVehicles=false'

# first regular expression pattern to pull from the webpage the vin 
# first is to pull the correct metadata field 
# second to pull the actulal vin 
vin_pattern <- '"vin":"\\w+"'
vin_pattern02 <- '\\b[A-Z0-9]{17}'


# Define a function to pull the vins from a single url 
get_vins <- function(url) {
  webpage = read_html(url)

  # after inspecting cars.com, content is returned via a script segment
  # so the node to serach is script
  # after investigating, it was determined the second script call contains the vins
  interesting_text <- html_nodes(webpage, "script") %>% 
    html_text()

  # parse the section with an regular expression extract
  vins <- str_extract_all(interesting_text[2], vin_pattern)
  vins <- str_extract_all(unlist(vins), vin_pattern02)
  
  return(vins)
}

# get vins from url and create character vector
vins <- unlist(get_vins(url))


# Build url for searching based looping over the number of pages 
# paramters to consider are zip code and number of retruns per page
num_per_page <- 100
num_pages <- 20
zipcode <- 73019

# initialize empty vinslist dataframe
vinslist <- data.frame(stringsAsFactors=FALSE)

for (page in 1:num_pages) {

  url <- paste('https://www.cars.com/for-sale/searchresults.action/?page=',page,'&perPage=',num_per_page,
               '&rd=50&searchSource=PAGINATION&shippable-dealers-checkbox=true&showMore=false&sort=relevance&stkTypId=28881&',
               'zc=',zipcode,'&localVehicles=false',
                sep="")
  vins <- unlist(get_vins(url))
  vinslist <- rbind(vinslist, data.frame(vins))
  
}

# Output list to csv file
write.csv(vinslist,file=paste('data_output/vins_',zipcode,'.csv',sep = ''),row.names = FALSE)

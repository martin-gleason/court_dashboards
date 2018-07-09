#Google Authorization and Spreadsheet Work
library(googlesheets)

#going to have to work on ensuring this is authenticated.
gs_auth()

c5_key <- "1SWieEZJdL0sO4IgJL8Bv5-6O1LciNAAbBFIQGI-XNRA"
c5_time_ss <- gs_key(c5_key)

c5_time <- gs_read(c5_time_ss)


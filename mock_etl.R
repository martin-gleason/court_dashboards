#Data Pipeline

library(googlesheets)
library(tidyverse)
library(lubridate)

#Authorize and load data
gs_auth()
mock_data_url <- "https://docs.google.com/spreadsheets/d/1G_ciu058rRyMlSBRwWXELFRTMV-XRwa5XKnXFmGI5fY/edit#gid=1768909298"
mock_data_key <- gs_url(mock_data_url)
mock_data <- gs_read(mock_data_key)
# ## cache data here
# ## work on processing through googlesheets

#Type cleaning
mock_data$`Client First Name` <- mock_data$`Client First Name` %>% str_to_title()
mock_data$`Client Last Name` <- mock_data$`Client Last Name` %>% str_to_title()

mock_data$`Client Birthdate` <- mdy(mock_data$`Client Birthdate`)
mock_data$`Today's Date` <- mdy(mock_data$`Today's Date` )

mock_data$Score
mock_data$Score <- mock_data$Score %>% 
  str_extract("\\d{1,2}") %>%
  as.numeric()

demographics <- mock_data %>% 
  select(`Client ID`, `Client First Name`, `Client Last Name`, `Client Zipcode`, 
         `Client Birthdate`, `Client Race`, `Client Gender`) %>%
  arrange(`Client ID`)

client_scores <- mock_data %>%
  select(`Client ID`,  `Assessment Date` = `Today's Date`, `Re-evaluation`, Score, 3, 10:ncol(mock_data)) %>%
  arrange(`Client ID`)

#for testing
reshaped_mock_data <- demographics %>% left_join(client_scores)

#client_scores$`Documented Contact with Juvenile Justice System` %>% str_extract("[^,+]") %>% as.numeric()
#^ is the basic pattern. Column as vector, extract before the comma, make sure it is numeric

#extracts score from verbage
only_scores <- function(x, ...){
  x %>%
    str_extract("[^,+]") %>%
    as.numeric()}

#new, cleaner tibble
client_scores[ ,5:ncol(client_scores)] <- sapply(client_scores[ ,5:ncol(client_scores)], only_scores)

client_zipcodes <- demographics %>% group_by(`Client Zipcode`) %>%
  summarise(`Per Zip` = n())

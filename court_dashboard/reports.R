
library(tidyverse)
library(googlesheets)
library(lubridate)
library(viridis)

source("google_sheets.R")

#Function to turn Parise into Spooner
spooner <- function(x, ...){
  if(x == "Parise" | x == "parise"){
    x <- "Spooner"
  }
  return(x)
}


emails <- c5_time$`Email Address`

c5_time$`Email Address` <- c5_time %>% select(`Email Address` ) %>% pull() %>%
  str_replace("mz.tamar@yahoo.com", "tamar.stockley@cookcountyil.gov")

c5_team_names <- c5_time$`Email Address` %>% 
  str_remove("@cookcountyil.gov") %>%  
  str_replace("\\.", " ") %>% 
  str_to_title() %>% 
  unique()

#take the email address and turn it into first and last names. Now with 100% more regex! 
c5_time <- c5_time %>% 
  mutate(first_name = str_extract(`Email Address`, "\\p{L}+(?=\\.)") %>% str_to_title()) %>% 
  mutate(last_name = str_extract(`Email Address`, "(?<=\\.)\\p{L}+") %>% str_to_title()) %>% 
  select(1, first_name, last_name, everything(), -2, -3) %>%
  rename(date_entered = Timestamp)# heavy lifting

c5_time$last_name <- c5_time$last_name %>% 
  map(spooner) %>% 
  as.character() #fixing spooner's name

#fixing dates. New quesiton: Why wont' tibbles work with lubridate?
c5_time$date_entered <- c5_time$date_entered %>% mdy_hms()
c5_time$`Date Worked On` <- c5_time$`Date Worked On` %>% mdy(tz = "UTC")


c5_tasks_hours <- c5_time %>% summarize(`Tasks Entered` = n(), 
                                        ` Total Hours` = sum(`Hours worked on project`))



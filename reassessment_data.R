#reassment sheet
library(tidyverse)
library(googlesheets)
library(lubridate)

url <- "https://docs.google.com/spreadsheets/d/1HPumDHWQLhuzn_O2TSI2gxVeQyedXkDX024hktumzJ0/edit#gid=1768909298"

sheet <- gs_url(url)

reassessment <- gs_read(sheet)

reassessment$`Client First Name` <- reassessment$`Client First Name` %>% str_to_title()
reassessment$`Client Last Name` <- reassessment$`Client Last Name`%>% str_to_title()

reassessment$`Client Birthdate` <- mdy(reassessment$`Client Birthdate`)
reassessment$`Today's Date` <- mdy(reassessment$`Today's Date` )

reassessment$`Re-evaluation` <- reassessment$`Re-evaluation` %>% 
  str_to_lower() %>%
  str_replace("no", "FALSE")

reassessment$`Re-evaluation` <- reassessment$`Re-evaluation`%>%
  str_to_lower() %>%
  str_replace("yes", "TRUE")


reassessment$`Re-evaluation` <- reassessment$`Re-evaluation`%>% as.logical()


only_scores <- function(x, ...){
  x %>%
    str_extract("[^,+]") %>%
    as.numeric()}

reassessment[ ,7:34] <- sapply(reassessment[ , 7:34], only_scores)

client_scores <- reassessment %>% 
  select(`Client ID`, 7:34) %>%
  mutate(Score = select(., 2:ncol(.)) %>%
           rowSums(na.rm = TRUE)) 



View(client_scores)
demographics <- reassessment %>% 
  select(`Client ID`, 1:6, 36:37) %>%
  rename(`Assessment Date` = `Today's Date`)

reformed <- demographics %>% left_join(client_scores)

glimpse(reformed)

max(reformed$Score)

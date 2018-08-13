library("tidyverse")
library("knitr")
library("kableExtra")
library("markdown")
library("viridis")
library("viridisLite")
library("stringr")
library("stringi")
library("readxl")


##loading the excell data
april_july_CFO_attendance <- read_xlsx("/Users/marty/Dropbox (Personal)/JAC Files/CFO/CFO Referal Data/MasterAttendanceList.xlsx", 
                                      sheet = 2, col_names = T)

april_july_chicago_crime <- read_xlsx("/Users/marty/Downloads/Crimes_-_2001_to_present.xlsx", 
                                        col_names =  T)
##future version: For auto-cleaning!
#april_july_CFO_attendance <- april_july_CFO_attendance %>%
#  distinct(JEMSID, .keep_all = T)

##In Demo cleaning
april_july_CFO_attendance$Attended <- str_to_title(april_july_CFO_attendance$Attended)
april_july_CFO_attendance$Attended <- str_replace(april_july_CFO_attendance$Attended, "Na", "Not Invited")

#ToTitle
april_july_CFO_attendance[, c(1:5, 10:11)] <-str_to_title(c(april_july_CFO_attendance$FNAME, april_july_CFO_attendance$LNAME, 
                                                            april_july_CFO_attendance$Address, april_july_CFO_attendance$APRTNO,
                                                            april_july_CFO_attendance$CITY,april_july_CFO_attendance$POFNAME, 
                                                            april_july_CFO_attendance$POLNAME))


##attendance types
invited <- april_july_CFO_attendance %>% filter(CFO == "Y")
uncleaned_invited <- length(invited$JEMSID)
not_invited <-april_july_CFO_attendance %>% filter(CFO == "N")
true_invited <- length(unique(invited$JEMSID))


##Filterin Excel data to get total unique youth


##changing crime data for just date, lat, long
crime_latlong <- april_july_chicago_crime %>%
  select(Date, Latitude, Longitude)

##histogram of zip/attenance with Viridis color
viridis_zip_plot <- ggplot(invited, aes(x = factor(ZIP), fill = Attended)) + 
        geom_histogram(stat = "count", bins = length(unique(invited$ZIP))) +
        labs(x = "CFO Zipcodes", 
             y = "Number of youth referred", 
             title = "May 2017-July 2017 CFO Data") +
        theme(axis.text.x = element_text(angle = -90)) + 
        scale_fill_viridis(discrete = T) +
        coord_flip() + 
        facet_grid(.~SEX)

##histogram of zip/attenance
trad_zip_plot <- ggplot(invited, aes(x = factor(ZIP), fill = Attended)) + 
        geom_histogram(stat = "count", bins = length(unique(invited$ZIP))) +
        labs(x = "CFO Zipcodes", 
                         y = "Number of youth referred", 
                         title = "May 2017-July 2017 CFO Data") +
        theme(axis.text.x = element_text(angle = -90)) + 
        coord_flip() + 
        facet_grid(.~SEX)

##Histogram of zipdata
april_july_CFO_attendance %>%
filter(Attended != "Not Invited") %>%
       ggplot(aes(x = Attended, fill = factor(ZIP))) + 
       geom_histogram(stat = "count") +
       scale_fill_viridis(discrete = TRUE, name = "Zipcode") +
       labs(x = "Attendance Code",
                       y = "Total per Code",
                       title = "April - July 2017 CFO Data")


invited_by_zip <- invited %>% 
       group_by(ZIP) %>%
       summarize(youth_per_zip = n())

zip_sex_attendance <- invited %>% 
       group_by(ZIP, SEX, Attended) %>%
       arrange((ZIP))

attended <- zip_sex_attendance %>%
       filter(Attended == "Y") %>%
       group_by(ZIP) %>%
       summarise(Attended = n())

attended_total <- sum(attended$Attended)

total_invited <- zip_sex_attendance %>%
  group_by(ZIP) %>%
  summarize(Invited = n())

absent <- zip_sex_attendance %>%
  filter(Attended != "Y") %>%
  group_by(ZIP) %>%
  summarise(Absent = n())

by_po <- zip_sex_attendance %>%
  filter(Attended == "Y") %>%
  group_by(POLNAME) %>%
  summarize(ypp = n()) %>% 
  arrange(desc(ypp)) %>%
  rename("Youth Per PO" = ypp)

by_po_zip <-  zip_sex_attendance %>%
  group_by(ZIP, POLNAME) %>%
  summarize(ypp = n()) %>% 
  arrange(desc(ypp)) %>%
  rename("Youth Per PO Per Zipcode" = ypp)

attendance_by_zip <- attended %>%
       left_join(absent, by = "ZIP") %>%
       left_join(total_invited, by = "ZIP") %>%
       mutate("Attendance Rate" = scales::percent(Attended/Invited))

abz_PO <- attended %>%
  left_join(absent, by = "ZIP") %>%
  left_join(total_invited, by = "ZIP") %>%
  left_join(by_po_zip, by = "ZIP") %>%
  select(-6) %>%
  mutate("Attendance Rate" = scales::percent(Attended/Invited))

abz_PO <- abz_PO[c(5,1, 2, 3, 4, 6)]


##Gender propotions
invited %>%
  group_by(SEX) %>%
  summarise(Number_by_Gender = n()) %>%
  mutate(gender_proportion = scales::percent(Number_by_Gender/true_invited))

#map file locations, uses knitr

cfo_map_file <- "/Users/marty/Dropbox (Personal)/codingProjects/cfoData/cfo_map_pointsBlack.jpg"
crime_contour <- "/Users/marty/Dropbox (Personal)/codingProjects/cfoData/crime_contour.jpg"


#Age functions
require(tidyverse)
source("mock_etl.R")

demographics <- demographics %>% 
  mutate(Age = year(today()) - year(`Client Birthdate`))


age_race_plot <- ggplot(demographics, aes(x = Age, fill = `Client Race`))

age_race_plot + 
  geom_density(stat= "count", position = position_dodge(width = .2)) +
  facet_grid( ~ `Client Gender`)


age_race_plot + geom_histogram() 
demographics %>% group_by(`Client Race`) %>%
  summarise(total = n())

ggplot(demographics, aes(x = `Client Race`, fill = `Client Race`)) + geom_histogram(stat = "count")

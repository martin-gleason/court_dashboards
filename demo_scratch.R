#demo_scratch. No wifi.


library(dplyr)
total_numbers <- demographics %>% left_join(client_scores)

new_score <- total_numbers %>% mutate(`New Score` = select(., 11:38) %>%
                                        rowSums(na.rm = TRUE))

View(new_score)

View(new_score %>% mutate(diff = Score - `New Score`))


mtcars %>% 
  mutate(cg = case_when(carb <= 2 ~ "low",
                        carb <= 2  ~ "high",
                        carb >= 3 ~ "WHAT"))

client_scores %>% 
  mutate(`New Score` = select(., 11:38) %>%
                           rowSums(na.rm = TRUE)) %>% 
  mutate(`Risk Level` = case_when(`New Score` <=12 ~ "Low",
                                  `New Score` <=13 | `New Score` <=18 ~ "Mod",
                                  `New Score` < 18 ~ "High",
                                  TRUE ~ as.character(x)))



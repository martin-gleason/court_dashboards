#demo_scratch. No wifi.


library(dplyr)
total_numbers <- demographics %>% left_join(client_scores)

new_score <- total_numbers %>% mutate(`New Score` = select(., 11:38) %>%
                                        rowSums(na.rm = TRUE))

View(new_score)

View(new_score %>% mutate(diff = Score - `New Score`))
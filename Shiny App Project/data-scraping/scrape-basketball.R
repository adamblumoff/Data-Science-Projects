# Work by Helen
# Scrape basketball statistics
library(tidyverse)
library(robotstxt) 
library(rvest) 

url <- "https://www.basketball-reference.com/leagues/NBA_2020_per_game.html#per_game_stats"

# Checks if website is accessible for scraping
paths_allowed(url)

# Grab table from website
basketball_table <- url %>%
  read_html() %>%
  html_table() %>%
  purrr::pluck(1) %>%
  janitor::clean_names()

# Writes table to csv file
write_csv(basketball_table, "data/basketball.csv")
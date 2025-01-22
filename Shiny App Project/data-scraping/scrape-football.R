#Work by Deontavious Harris
# Scrape football statistics
library(tidyverse)
library(robotstxt) 
library(rvest) 

url <- "https://www.pro-football-reference.com/years/2019/scrimmage.htm#receiving_and_rushing"

# Checks if website is accessible for scraping
paths_allowed(url, ssl_verifypeer = 0)

# Grab table from website
football_table <- url %>%
  read_html()%>%
  html_table() %>%
  purrr::pluck(1) %>%
  janitor::clean_names()

# Writes table to csv file
write_csv(football_table, "data/football.csv")



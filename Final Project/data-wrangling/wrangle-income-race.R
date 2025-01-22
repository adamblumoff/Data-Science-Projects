# Work by Deon, Adam, and Helen
library(tidyverse)
library(kableExtra)
library(robotstxt) 
library(rvest)

# Reads in csvs
state_income<- read_csv("state_income.csv", skip = 2)
state_race_population <- read_csv("state_race_population.csv", skip = 2)
hate_crime_all <- read_csv("hate-crime-all.csv")

# Removes dollar sign
state_income$`Median Annual Household Income` = 
  as.numeric(gsub("[\\$,]", "", state_income$`Median Annual Household Income`))

# Joins both datasets
state_income_race <- state_race_population %>%
  inner_join(state_income, by = "Location") %>%
  select(-Footnotes) %>%
  # Removes extra observations
  filter(!(Location %in% c("Notes", "Sources", "Puerto Rico"))) %>%
  janitor::clean_names() %>%
  # Removes Native Hawaiian/Other Pacific Islander
  select(-native_hawaiian_other_pacific_islander) %>%
  # Rename first column to match hate_crime_all dataset
  rename("state_name" = "location")

# Select variables for 2020
hate_crime_total <- hate_crime_all %>%
  select(state_name, anti_black_or_african_american_2020:percent_change_all)

state_income_race <- state_income_race %>%
  inner_join(hate_crime_total, by = "state_name")

# Write wrangled dataset into data folder
write_csv(state_income_race, "state_income_race.csv")

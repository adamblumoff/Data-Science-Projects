# Work by Helen
# Wrangling data for first dataset
library(tidyverse)
library(kableExtra)
library(robotstxt) 
library(rvest) 
library(dplyr)

hate_crime_raw <- read_csv("hate_crime/hate_crime.csv")

# Select variables and filter for single bias and year
hate_crime <- hate_crime_raw %>%
  filter(MULTIPLE_BIAS == "S") %>%
  select(DATA_YEAR, STATE_ABBR, STATE_NAME, BIAS_DESC) %>%
  filter(DATA_YEAR == c(2019, 2020)) %>%
  filter(BIAS_DESC %in% c("Anti-American Indian or Alaska Native", "Anti-Arab",
                          "Anti-Asian", "Anti-Black or African American",
                          "Anti-Hispanic or Latino", "Anti-Multiple Races, Group",
                          "Anti-Native Hawaiian or Other Pacific Islander",
                          "Anti-Other Race/Ethnicity/Ancestry", "Anti-White"))

# Counts specific hate crimes by state in 2019
hate_crime_2019 <- hate_crime %>%
  filter(DATA_YEAR == 2019) %>%
  group_by(STATE_NAME, BIAS_DESC) %>%
  summarize(
    COUNT = n()
  ) %>%
  pivot_wider(names_from = BIAS_DESC,
              values_from = COUNT) %>%
  janitor::clean_names() %>%
  rename_with(~str_c(., "_2019"), starts_with("anti")) %>%
  # Changes all the N/A values to 0
  mutate_all(~replace(., is.na(.), 0)) %>%
  dplyr::rowwise() %>%
  mutate(all_hate_crimes_2019 = sum(c_across(starts_with("anti"))))

# Counts specific hate crimes by state in 2020
hate_crime_2020 <- hate_crime %>%
  filter(DATA_YEAR == 2020) %>%
  group_by(STATE_NAME, BIAS_DESC) %>%
  summarize(
    COUNT = n()
  ) %>%
  pivot_wider(names_from = BIAS_DESC,
              values_from = COUNT) %>%
  janitor::clean_names() %>%
  rename_with(~str_c(., "_2020"), starts_with("anti")) %>%
  # Changes all the N/A values to 0
  mutate_all(~replace(., is.na(.), 0)) %>%
  dplyr::rowwise() %>%
  mutate(all_hate_crimes_2020 = sum(c_across(starts_with("anti"))))

# Joins specific hate crimes of both years by state
# Only for states that are present in both datasets
hate_crime_all <- inner_join(hate_crime_2019, hate_crime_2020, by = "state_name") %>%
# Create variables that find percent change over 2019-2020
  mutate(percent_change_all = 100 * ((all_hate_crimes_2020-all_hate_crimes_2019)/(all_hate_crimes_2019))) %>%
  janitor::adorn_totals("row") %>%
  filter(state_name != "Federal")

# Renaming last total row
hate_crime_all[51, 1] <- "United States"

# Write wrangled dataset into data folder
write_csv(hate_crime_all, "hate-crime-all.csv")

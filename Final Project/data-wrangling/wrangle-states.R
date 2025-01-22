library(tidyverse)
library(kableExtra)
library(robotstxt) 
library(rvest)
        
state_income<- read_csv("Final Project/data-wrangling/state_incnome.csv,skip = 2")
state_race_population <- read_csv("Final Project/data-wrangling/state_race_population.csv,skip = 2")

head(state_income)
head(state_race_population)


state_income_race <- state_race_population %>%
  inner_join(state_income, by = "Location") %>%
  select(-Footnotes)

state_income_race
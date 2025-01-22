# Work by Adam
# Wrangling data for baseball
library(tidyverse)
library(kableExtra)
library(robotstxt) 
library(rvest) 
library(Lahman)

f <- function(x){
  if(is.numeric(x))
    sum(x)
  else if(any(x[-1] != x[1]))
    paste(x, collapse = "+")
  else x[1]
}

# Table for baseball player names
baseball_names <- People %>%
  mutate(playerName = paste(nameFirst, nameLast)) %>%
  select(playerID, playerName)

# Table for batting
baseball_batting <- Batting %>%
  select(-c(stint, lgID, SH, SF, GIDP)) %>%
  filter(yearID == 2019)  %>%
  left_join(baseball_names, by = "playerID") %>%
  select(playerName, everything()) %>%
  group_by(playerID) %>%
  summarize(across(everything(), f))

# Table for pitching
baseball_pitching <- Pitching %>%
  select(-c(stint, lgID, GF, SH, SF, GIDP)) %>%
  filter(yearID == 2019)  %>%
  left_join(baseball_names, by = "playerID") %>%
  select(playerName, everything()) %>%
  group_by(playerID) %>%
  summarize(across(everything(), f))

# Table for fielding
baseball_fielding <- Fielding %>%
  select(-c(stint, lgID)) %>%
  filter(yearID == 2019) %>%
  left_join(baseball_names, by = "playerID") %>%
  select(playerName, everything()) %>%
  group_by(playerID) %>%
  summarize(across(everything(), f))

# Write wrangled dataset into data folder
write_csv(baseball_batting, "batting-wrangled.csv")
write_csv(baseball_pitching, "pitching-wrangled.csv")
write_csv(baseball_fielding, "fielding-wrangled.csv")



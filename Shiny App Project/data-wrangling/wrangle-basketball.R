# Work by Helen
# Wrangling data for basketball
library(tidyverse)
library(kableExtra)
library(robotstxt) 
library(rvest) 

# Read raw datafile in
basketball <- read_csv("data/basketball.csv")

# Wrangle dataset
basketball_wrangled <- basketball %>%
  select(player, pos, tm, age, g, gs, mp, fg, x3p, x2p, ft, trb, ast, stl, blk,
         tov, pf, pts) %>%
  mutate(across(age:pts, ~ as.numeric(.))) %>%
  # Finds weighted average for the players' stats
  group_by(player, age) %>%
  summarize(
    across(mp:pts, ~ sum(.x * g)/sum(g)),
    g = sum(g),
    gs = sum(gs)
  ) %>%
  # Reorders columns
  select(player, age, g, gs, mp:pts)

# Write wrangled dataset into data folder
write_csv(basketball_wrangled, "data/basketball-wrangled.csv")

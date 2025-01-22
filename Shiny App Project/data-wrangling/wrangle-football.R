#Work by Deontavious Harris
# Wrangling data for football
library(tidyverse)
library(kableExtra)
library(robotstxt) 
library(rvest) 
library(dplyr)


#Read raw data
football <- read_csv("data/football.csv")

#Change variable names because there are 5 duplicate variables
colnames(football) <- c("Rk","Player","Team","Age","Position","Games",
                        "Games_D_A", "Pass_Targets", "Receptions", "Receiving_Yards",
                        "Receiving_Yards_per_Reception", "Receiving_Touch_Downs",
                        "First_Down_Receiving", "Longest_Reception",
                        "Receptions_per_Game", "Receiving_Yards_per_Game", "Catch_Perc",
                        "Receiving_Yards_Target", "Rushing_Attempts",
                        "Rushing_Yards_Gained", "Rushing_Touch_Downs",
                        "First_Down_Rushing", "Longest_Rushing_Attempt",
                        "Rushing_Yards_Attempt", "Rushing_Yards_per_Game", 
                        "Rushing_Attempts_per_Game","Total_Yards",
                        "Scrimmage_Yards_Touch","Yards_from_Scrimmage",
                        "Total_Touchdowns","Fumbles")

#Choose desired variables
football_wrangled <- football[-1,] %>%
  select("Player","Team","Position","Age","Games","Receptions_per_Game", 
         "Receiving_Yards_per_Game", "Rushing_Yards_per_Game",
          "Rushing_Attempts_per_Game") %>%
  

#Order players by alphabetical order
  arrange(Player) %>%
  
#Remove special characters
  gsub("\\*.*","",as.character(football_wrangled$Player))


#Change certain variables to numeric
  mutate(across(Age:Rushing_Attempts_per_Game, ~ as.numeric(.))) 


 #Write wrangled data into data folder
write_csv(football_wrangled, "data/football-wrangled.csv")
 









# Tab 1 & 5 by Helen, Tab 2 by Deon, Tab 3 & 4 by Adam
# This code reproduces the scatterplot panel for the Basketball dataset

# Load necessary packages
library(shiny)
library(tidyverse)
library(ggrepel)
library(bslib)

# Import data
basketball <- read_csv("data/basketball-wrangled.csv")
football <- read_csv("data/football-wrangled.csv")
fielding <- read_csv("data/fielding-wrangled.csv")
batting <- read_csv("data/batting-wrangled.csv")
pitching <- read_csv("data/pitching-wrangled.csv")

## For basketball functions
basketball_choice_values <- c("g", "gs", "mp", "fg", "x3p", "x2p", "ft", "trb",
                              "ast", "stl", "blk", "tov", "pf", "pts")
basketball_choice_names <- c("Games", "Games Started", "Minutes Played per game", 
                             "Field Goal per game", "3point Field Goal per game",
                             "2point Field Goal per game", "Free Throws per game",
                             "Total Rebounds per game", "Assists per game", 
                             "Steals per game", "Blocks per game", 
                             "Turnovers per game", "Personal Fouls per game",
                             "Points per game")
names(basketball_choice_values) <- basketball_choice_names
basketball_name_choices <- unique(basketball$player)

## For football functions
football_variable_values <- c("Games","Receptions_per_Game", 
                              "Receiving_Yards_per_Game", "Rushing_Yards_per_Game", 
                              "Rushing_Attempts_per_Game")
football_variable_names <- c("Games","Receptions per Game", 
                             "Receiving Yards per Game", "Rushing Yards per Game",
                             "Rushing Attempts per Game")
names(football_variable_values) <- football_variable_names
football_name_choices <- unique(football$Player)

## For batting functions
batting_choice_values <- c("G", "AB", "R", "H", "X2B", "X3B", "HR", "RBI", 
                           "SB", "CS", "BB", "SO", "IBB", "HBP")
batting_choice_names <- c("Games", "At Bats", "Runs", 
                          "Hits", "Doubles",
                          "Triples", "Homeruns",
                          "Runs Batted In", "Stolen Bases", 
                          "Caught Stealing", "Walks", 
                          "Strikeouts", "Intentional Walks",
                          "Hit By Pitch")
names(batting_choice_values) <- batting_choice_names
batting_name_choices <- unique(batting$playerName)

## For fielding functions
fielding_choice_values <- c("G", "GS", "InnOuts", "PO", "A", "E", "DP", "PB", 
                            "WP",  "SB", "CS", "ZR")
fielding_choice_names <- c("Games", "Games Started", "Innings Played", 
                           "Put Outs", "Assists",
                           "Errors", "Double Plays",
                           "Wild Pitches", 
                           "Stolen Bases", "Caught Stealing", 
                           "Zone Rating")
names(fielding_choice_values) <- fielding_choice_names
fielding_name_choices <- unique(fielding$playerName)

## For pitching functions
pitching_choice_values <- c("W", "L", "G", "GS", "CG", "SHO", "SV", "IPouts", 
                            "H", "ER", "HR", "BB", "SO", "BAOpp", "ERA", "IBB",
                            "WP", "HBP", "BK", "BFP", "R")
pitching_choice_names <- c("Wins", "Losses", "Games", "Games Started", 
                           "Complete Games", "Shutouts", "Saves", "Outs Pitched",
                           "Hits", "Earned Runs", "Homeruns", "Walks", 
                           "Strikeouts", "Opponent's Batting Average", 
                           "Earned Run Average", "Intentional Walks", 
                           "Wild Pitches", "Batters Hit by Pitch", "Balks", 
                           "Batters faced by Pitcher", "Runs Allowed")
names(pitching_choice_values) <- pitching_choice_names
pitching_name_choices <- unique(pitching$playerName)

############
#    ui    #
############
ui <- navbarPage(
  
  title = span("Sports Data (2019)"),
  theme = bs_theme(bootswatch = "lux",
                   bg = "white",
                   fg = "#1A2641"),
  
  # Tab 1: Basketball
  tabPanel(
    title = "Basketball",
    
    sidebarLayout(
      
      sidebarPanel(
        selectInput(inputId = "basketball_x",
                    label = "Choose the x axis",
                    basketball_choice_values,
                    selected = basketball_choice_values[1]),
        
        selectInput(inputId = "basketball_y",
                    label = "Choose the y axis",
                    basketball_choice_values,
                    selected = basketball_choice_values[2]),
        
        selectizeInput(inputId = "basketball_id_name",
                       label = "Identify player(s) in the scatterplot:",
                       choices = basketball_name_choices,
                       selected = NULL,
                       multiple = TRUE)
      ),
      
      mainPanel(plotOutput(outputId = "basketball_scatter"))
    )
  ),
  
  # Tab 2: Football
  tabPanel(
    
    title = "Football",
    
    sidebarLayout(
      
      sidebarPanel(
        selectInput(inputId = "football_x",
                    label = "Choose the x axis",
                    football_variable_values,
                    selected = football_variable_values[1]),
        
        selectInput(inputId = "football_y",
                    label = "Choose the y axis",
                    football_variable_values,
                    selected = football_variable_values[2]),
        
        selectizeInput(inputId = "football_id_name",
                       label = "Identify player(s) in the scatterplot:",
                       choices = football_name_choices,
                       selected = NULL,
                       multiple = TRUE)
      ),
      mainPanel(plotOutput(outputId = "football_scatter"))
    )
  ),
  
  # Tab 3: Baseball - Batting
  tabPanel(
    title = "Baseball - Batting",
    
    sidebarLayout(
      
      sidebarPanel(
        selectInput(inputId = "batting_x",
                    label = "Choose the x axis",
                    batting_choice_values,
                    selected = batting_choice_values[1]),
        
        selectInput(inputId = "batting_y",
                    label = "Choose the y axis",
                    batting_choice_values,
                    selected = batting_choice_values[2]),
        
        selectizeInput(inputId = "batting_id_name",
                       label = "Identify player(s) in the scatterplot:",
                       choices = batting_name_choices,
                       selected = NULL,
                       multiple = TRUE)
      ),
      
      mainPanel(plotOutput(outputId = "batting_scatter"))
     )
    ),
    
    # Tab 4: Baseball - Fielding
    tabPanel(
      title = "Baseball - Fielding",
      
      sidebarLayout(
        
        sidebarPanel(
          selectInput(inputId = "fielding_x",
                      label = "Choose the x axis",
                      fielding_choice_values,
                      selected = fielding_choice_values[1]),
          
          selectInput(inputId = "fielding_y",
                      label = "Choose the y axis",
                      fielding_choice_values,
                      selected = fielding_choice_values[2]),
          
          selectizeInput(inputId = "fielding_id_name",
                         label = "Identify player(s) in the scatterplot:",
                         choices = fielding_name_choices,
                         selected = NULL,
                         multiple = TRUE)
        ),
        
        mainPanel(plotOutput(outputId = "fielding_scatter"))
      )
    ),
    
    # Tab 5: Baseball - Pitching
    tabPanel(
      title = "Baseball - Pitching",
      
      sidebarLayout(
        
        sidebarPanel(
          selectInput(inputId = "pitching_x",
                      label = "Choose the x axis",
                      pitching_choice_values,
                      selected = pitching_choice_values[1]),
          
          selectInput(inputId = "pitching_y",
                      label = "Choose the y axis",
                      pitching_choice_values,
                      selected = pitching_choice_values[2]),
          
          selectizeInput(inputId = "pitching_id_name",
                         label = "Identify player(s) in the scatterplot:",
                         choices = pitching_name_choices,
                         selected = NULL,
                         multiple = TRUE)
        ),
        
        mainPanel(plotOutput(outputId = "pitching_scatter"))
      )
    )
)

############
# server   #
############
server <- function(input, output){
  
  # Tab 1: Basketball
  output$basketball_scatter <- renderPlot({
    basketball %>%
      ggplot(aes_string(x = input$basketball_x, y = input$basketball_y)) +
      geom_point(color = "#FF8D33") +
      labs(title = "Basketball Data (2019)", 
           subtitle = "Data from NBA Statistics",
           x = basketball_choice_names[basketball_choice_values == input$basketball_x], 
           y = basketball_choice_names[basketball_choice_values == input$basketball_y]) +
      geom_label_repel(data = filter(basketball, player %in% input$basketball_id_name),
                       aes(label = player), show.legend = FALSE)
    
  })
  
  # Tab 2: Football
  output$football_scatter <- renderPlot({
    football %>%
      ggplot(aes_string(x = input$football_x, y = input$football_y)) +
      geom_point(color = "#6E2C00") +
      labs(title = "Football Data (2019)", 
           subtitle = "Data from 2019 NFL Football Stats",
           x = football_variable_names[football_variable_values == input$football_x], 
           y = football_variable_names[football_variable_values == input$football_y]) + 
      geom_label_repel(data = filter(football, Player %in% input$football_id_name),
                       aes(label = Player), show.legend = FALSE) 
    
  })
  
  # Tab 3: Baseball - Batting
  output$batting_scatter <- renderPlot({
    batting %>%
      ggplot(aes_string(x = input$batting_x, y = input$batting_y)) +
      geom_point(color = "#FF5B33") +
      labs(title = "Baseball Batting Data (2019)", 
           subtitle = "Data from MLB Statistics (Lahman Package)",
           x = batting_choice_names[batting_choice_values == input$batting_x], 
           y = batting_choice_names[batting_choice_values == input$batting_y]) +
      geom_label_repel(data = filter(batting, playerName %in% input$batting_id_name),
                       aes(label = playerName), show.legend = FALSE)
    
  })
  
  # Tab 4: Baseball - Fielding
  output$fielding_scatter <- renderPlot({
    fielding %>%
      ggplot(aes_string(x = input$fielding_x, y = input$fielding_y)) +
      geom_point(color = "#C133FF") +
      labs(title = "Fielding Data (2019)", 
           subtitle = "Data from MLB Statistics (Lahman Package)",
           x = fielding_choice_names[fielding_choice_values == input$fielding_x], 
           y = fielding_choice_names[fielding_choice_values == input$fielding_y]) +
      geom_label_repel(data = filter(fielding, playerName %in% input$fielding_id_name),
                       aes(label = playerName), show.legend = FALSE)
    
  })
  
  # Tab 5: Baseball - Pitching
  output$pitching_scatter <- renderPlot({
    pitching %>%
      ggplot(aes_string(x = input$pitching_x, y = input$pitching_y)) +
      geom_point(color = "#1E8449") +
      labs(title = "Baseball Pitching Data (2019)", 
           subtitle = "Data from MLB Statistics (Lahman Package)",
           x = pitching_choice_names[pitching_choice_values == input$pitching_x], 
           y = pitching_choice_names[pitching_choice_values == input$pitching_y]) +
      geom_label_repel(data = filter(pitching, playerName %in% input$pitching_id_name),
                       aes(label = playerName), show.legend = FALSE)
    
  })
}

####################
# call to shinyApp #
####################
shinyApp(ui = ui, server = server)

# Link to published app: https://r.amherst.edu/apps/hmak24/SportsStatistics2019/

# Work by Helen
# This code reproduces the scatterplot panel for the Pitching dataset

# Load necessary packages
library(shiny)
library(tidyverse)
library(ggrepel)

# Import data
pitching <- read_csv("data/pitching-wrangled.csv")

## For selectInput
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

## For selectizeInput choices for player name, pull directly from data
pitching_name_choices <- unique(pitching$playerName)


############
#    ui    #
############
ui <- navbarPage(
  
  title = "Sports Data (2019)",
  
  # Tab 5: Pitching
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
      
      mainPanel(plotOutput(outputId = "scatter"))
    )
  )
  
)

############
# server   #
############
server <- function(input, output){
  
  # Outputs plot
  output$scatter <- renderPlot({
    pitching %>%
      ggplot(aes_string(x = input$pitching_x, y = input$pitching_y)) +
      geom_point(color = "#2c7fb8") +
      labs(title = "Baseball Pitching Data (2019)", 
           subtitle = "Data from MBL Statistics",
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
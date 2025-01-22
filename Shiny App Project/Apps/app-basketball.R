# Work by Helen
# This code reproduces the scatterplot panel for the Basketball dataset

# Load necessary packages
library(shiny)
library(tidyverse)
library(ggrepel)

# Import data
basketball <- read_csv("data/basketball-wrangled.csv")

## For selectInput
basketball_choice_values <- c("g", "gs", "mp", "fg", "x3p", "x2p", "ft", "trb", "ast", 
                     "stl", "blk", "tov", "pf", "pts")
basketball_choice_names <- c("Games", "Games Started", "Minutes Played per game", 
                  "Field Goal per game", "3point Field Goal per game",
                  "2point Field Goal per game", "Free Throws per game",
                  "Total Rebounds per game", "Assists per game", 
                  "Steals per game", "Blocks per game", 
                  "Turnovers per game", "Personal Fouls per game",
                  "Points per game")
names(basketball_choice_values) <- basketball_choice_names

## For selectizeInput choices for player name, pull directly from data
basketball_name_choices <- unique(basketball$player)


############
#    ui    #
############
ui <- navbarPage(
  
  title = "Sports Data (2019)",
  
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
      
      mainPanel(plotOutput(outputId = "scatter"))
    ),
    # Tab 2: Football
  )
  
  
)

############
# server   #
############
server <- function(input, output){
  
  # Outputs plot
  output$scatter <- renderPlot({
    basketball %>%
      ggplot(aes_string(x = input$basketball_x, y = input$basketball_y)) +
      geom_point(color = "#2c7fb8") +
      labs(title = "Basktball Data (2019)", 
           subtitle = "Data from NBA Statistics",
           x = basketball_choice_names[basketball_choice_values == input$basketball_x], 
           y = basketball_choice_names[basketball_choice_values == input$basketball_y]) +
      geom_label_repel(data = filter(basketball, player %in% input$basketball_id_name),
                       aes(label = player), show.legend = FALSE)
    
  })
}

####################
# call to shinyApp #
####################
shinyApp(ui = ui, server = server)
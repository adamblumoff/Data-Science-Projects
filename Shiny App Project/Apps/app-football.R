# This code reproduces only the scatterplot panel from the electric skateboards app

# Load necessary packages
library(shiny)
library(tidyverse)
library(ggrepel)

# Import data
football <- read_csv("data/football-wrangled.csv")

football_variable_values <- c("Games","Receptions_per_Game", 
                            "Receiving_Yards_per_Game", "Rushing_Yards_per_Game", 
                            "Rushing_Attempts_per_Game")

football_variable_names <- c("Games","Receptions per Game", 
                             "Receiving Yards per Game", "Rushing Yards per Game",
                              "Rushing Attempts per Game")

names(football_variable_values) <- football_variable_names

## For selectizeInput choices for player name, pull directly from data
football_name_choices <- unique(football$Player)

ui <- navbarPage(
  
  title = "Sports Data (2019)",
  
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
  mainPanel(plotOutput(outputId = "scatter"))
)
)
)

server <- function(input, output) {
 #Makes scatterplot
  output$scatter <- renderPlot({
    football %>%
      ggplot(aes_string(x = input$football_x, y = input$football_y)) +
      geom_point(color = "#2c7fb8") +
      labs(title = "Football Data (2019)", 
           subtitle = "Data from 2019 NFL Football Stats",
           x = football_variable_names[football_variable_values == input$football_x], 
           y = football_variable_names[football_variable_values == input$football_y]) + 
       geom_label_repel(data = filter(football, Player %in% input$football_id_name),
                       aes(label = Player), show.legend = FALSE) 
    
  })
}

shinyApp(ui = ui, server = server)
# Work by Adam
# Load necessary packages
library(shiny)
library(tidyverse)
library(ggrepel)

# Import data
fielding <- read_csv("data/fielding-wrangled.csv")

fielding_choice_values <- c("G", "GS", "InnOuts", "PO", "A", "E", "DP", "PB", "WP",  "SB", "CS", "ZR")
fielding_choice_names <- c("Games", "Games Started", "Innings Played", 
                          "Put Outs", "Assists",
                          "Errors", "Double Plays",
                          "Wild Pitches", 
                          "Stolen Bases", "Caught Stealing", 
                          "Zone Rating")
names(fielding_choice_values) <- fielding_choice_names
fielding_name_choices <- unique(fielding$playerName)

ui <- navbarPage(
  
  title = "Sports Data (2019)",
  tabPanel(
    title = "Fielding",
    
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
      
      mainPanel(plotOutput(outputId = "scatter"))
    ),
    
  )
  
  
)

server <- function(input, output) {
  
  output$scatter <- renderPlot({
    fielding %>%
      ggplot(aes_string(x = input$fielding_x, y = input$fielding_y)) +
      geom_point(color = "#2c7fb8") +
      labs(title = "Fielding Data (2019)", 
           subtitle = "Data from Lahman Package (MLB)",
           x = fielding_choice_names[fielding_choice_values == input$fielding_x], 
           y = fielding_choice_names[fielding_choice_values == input$fielding_y]) +
      geom_label_repel(data = filter(fielding, playerName %in% input$fielding_id_name),
                       aes(label = playerName), show.legend = FALSE)
    
  })
}

shinyApp(ui = ui, server = server)
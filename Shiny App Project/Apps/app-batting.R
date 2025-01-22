# Work by Adam and Helen
# Load necessary packages
library(shiny)
library(tidyverse)
library(ggrepel)

# Import data
batting <- read_csv("data/batting-wrangled.csv")

batting_choice_values <- c("G", "AB", "R", "H", "X2B", "X3B", "HR", "RBI", "SB", "CS", "BB", "SO", "IBB", "HBP")
batting_choice_names <- c("Games", "At Bats", "Runs", 
                             "Hits", "Doubles",
                             "Triples", "Homeruns",
                             "Runs Batted In", "Stolen Bases", 
                             "Caught Stealing", "Walks", 
                             "Strikeouts", "Intentional Walks",
                             "Hit By Pitch")
names(batting_choice_values) <- batting_choice_names
batting_name_choices <- unique(batting$playerName)

############
#    ui    #
############
ui <- navbarPage(
  
  title = "Sports Data (2019)",
  
  # Tab 3: Batting
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
    batting %>%
      ggplot(aes_string(x = input$batting_x, y = input$batting_y)) +
      geom_point(color = "#2c7fb8") +
      labs(title = "Baseball Batting Data (2019)", 
           subtitle = "Data from MBL Statistics",
           x = batting_choice_names[batting_choice_values == input$batting_x], 
           y = batting_choice_names[batting_choice_values == input$batting_y]) +
      geom_label_repel(data = filter(batting, playerName %in% input$batting_id_name),
                       aes(label = playerName), show.legend = FALSE)
    
  })
}

shinyApp(ui = ui, server = server)
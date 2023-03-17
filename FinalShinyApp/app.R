library(shiny)
library(dplyr)
library(ggplot2)

# Load the mtcars dataset
data(mtcars)

current_data <- mtcars[1:10]

# Define the UI
ui <- fluidPage(
  # Title
  titlePanel("MTCars Data"),
  
  # Sidebar with input controls
  sidebarLayout(
    sidebarPanel(
      # Filter by number of cylinders
      sliderInput("cyl", "Number of cylinders:",
                  min = 4,
                  max = 8,
                  step = 2,
                  value = 4),
      
      # Filter by transmission type
      radioButtons("am", "Transmission type:",
                         choices = list("Automatic" = 0,
                                        "Manual" = 1),
                         selected = 0),
      h4("Columns"),
      tags$div(
        tags$ul(
          tags$li("mpg - Miles/(US) gallon"),
          tags$li("cyl - Number of cylinders"),
          tags$li("disp - Displacement (cu.in.)"),
          tags$li("hp - Gross horsepower"),
          tags$li("drat - Rear axle ratio"),
          tags$li("wt - Weight (1000 lbs)"),
          tags$li("qsec - 1/4 mile time"),
          tags$li("vs - Engine (0 = V-shaped, 1 = straight)"),
          tags$li("am - Transmission (0 = automatic, 1 = manual)"),
          tags$li("am - Transmission (0 = automatic, 1 = manual)"),
        )
      )
    ),
    
    # Show the filtered data
    mainPanel(
      h3("Summarize Data"),
      tableOutput("mtcars_table"),
      h3("Plot"),
      plotOutput("histogram")
      
    )
  )
)

# Define the server
server <- function(input, output) {  
  # Filter the mtcars dataset based on input values
  filtered_mtcars <- reactive({
    current_data %>%
      filter(cyl == input$cyl, am == input$am)
  })
  
  # Show the filtered data in a table
  output$mtcars_table <- renderTable({
    filtered_mtcars()
  })
  
  output$histogram <- renderPlot({
    ggplot(filtered_mtcars(), aes(x = hp)) +
      geom_histogram(bins = 30, fill = "blue", alpha = 0.5) +
      labs(x = "Horse Power", y = "Frequency")
  })
}

# Run the app
shinyApp(ui = ui, server = server)

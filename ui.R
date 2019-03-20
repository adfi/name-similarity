library(shiny)
library(shinyjs)

shinyUI(fluidPage(
  shinyjs::useShinyjs(),
  # Application title
  titlePanel("That's not my name!"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      HTML("Provide your own name below to generate a new graph. <br>
    You can move the slider to allow for more/less similar names."),
      br(), 
      br(),
       textInput("name", "Name", value = "Adnan"),
       sliderInput("threshold",
                   "Similarity Threshold",
                   min = 0.5,
                   max = 1,
                   value = 0.6),
       HTML("For more information on how the graph is created see 
            this <a href=https://adfi.gitlab.io>blogpost</a>."),
      br(),
      br(),
      actionButton(inputId="twitter_share",
                   label = "Share",
                   icon = icon("twitter"),
                   style="background-color: #55acee;")
       
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("simPlot")
    )
  )
))

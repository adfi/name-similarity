library(shiny)
library(dplyr)
library(tidygraph)
library(ggraph)
library(stringdist)
library(babynames)

all_names <- babynames %>% 
  select(name) %>%
  distinct()

shinyServer(function(input, output) {
  
  myPlot <- reactive({
    input_name <- input$name
    threshold <- input$threshold
    
    all_names %>% 
      mutate(LV=stringsim(input_name, name, method='lv'), 
             from=input_name, to=name) %>%
      filter(LV>threshold, LV != 1.0) %>% 
      as_tbl_graph() %>%
      ggraph(layout='kk', weight=1/igraph::E(.)$LV) +
      geom_edge_link(aes(start_cap = label_rect(node1.name), 
                         end_cap = label_rect(node2.name))) + 
      geom_node_label(aes(label=name)) +
      theme_void()
  })
  
   
  output$simPlot <- renderPlot({
    myPlot()
  })
  
  output$tweetButton <- renderUI({
    
    actionButton("twitter_share",
                 label = "Share",
                 icon = icon("twitter"),
                 onclick = sprintf("window.open('%s')", "https://twitter.com/intent/tweet?text=Hello%20world"),
                 style="background-color: #55acee;") 
    
  })
  
})

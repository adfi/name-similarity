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
  
  observeEvent(input$twitter_share, {
    p <- myPlot()
    ggsave("name_similarity.png", p, width=4, height=4)
    
    # upload to imgur
    img_url <- knitr::imgur_upload("name_similarity.png")
    unlink("name_similarity.png")
    
    # compose tweet
    text = "These are the names that are most similar to my own, created using R and the babynames package"
    tweet = sprintf("window.open('https://twitter.com/intent/tweet?text=%s&url=%s&hashtags=rstats')",  
                    text, img_url)
    
    shinyjs::runjs(tweet)
  })
  
})

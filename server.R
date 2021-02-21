library(rvest)
library(stringr)
library(janitor)
library(here)
library(showtext)
library(polite)
library(shiny)
library(glue)
library(tidyverse)
library(assertthat)
library(quanteda)

# font_add_google("Ewert", "ewert", regular.wt = 400, bold.wt = 700,)
# font_add_google("Brygada 1918", "brygada", regular.wt = 400, bold.wt = 700,)
# showtext_auto()

page_url <- "https://en.wikipedia.org/wiki/List_of_American_Civil_War_generals_(Union)"
# from the polite package, we properly identify ourselves and respect any explicit limits
my_session <- bow(page_url, force = TRUE)
# scrape the page contents
generals_page <- scrape(my_session)

change_names <- function(x) {
 assert_that(inherits(x, "data.frame"))
 names(x) <- c("image", "name", "substantive_rank", "brevet_rank", "notes")
 x
}

# extract the tables
gens <- generals_page %>% 
 html_nodes("table") %>% 
 html_table() %>% # returns a list of tables
 keep(function(x) length(x) == 5 & nrow(x) > 0) %>% 
 map(change_names) %>% 
 bind_rows() %>% # combine all into single table
 as_tibble()

bases <- tibble(
 base = c("Camp Beauregard", "Fort Polk", "Fort Benning", "Fort Gordon", "Fort Bragg",
          "Fort A.P. Hill", "Fort Lee", "Fort Pickett", "Fort Rucker", "Fort Hood"),
 state = c("Louisiana", "Louisiana", "Georgia", "Georgia", "North Carolina",
           "Virginia", "Virginia", "Virginia", "Alabama", "Texas")
)

gens <- gens %>% 
 select(-image) %>% 
 separate(col = name, into = c("last_name", "first_middle_name"), extra = "merge", remove = FALSE) %>% 
 mutate(first_letter = str_extract(last_name, "^.")) %>% 
 mutate(syllables = nsyllable(last_name))


bases <- bases %>% 
 separate(col = base, into = c("type", "confederate_name"), extra = "merge", remove = FALSE) %>% 
 mutate(first_letter = str_extract(confederate_name, "^.")) %>% 
 mutate(syllables = as.integer(nsyllable(confederate_name))) %>% 
 mutate(syllables = if_else(confederate_name == "A.P. Hill", 3L, syllables))

make_components <- function(name,substantive_rank,brevet_rank) {
 
 div(
  class = "card",
  div(
   class = "name",
   name
  ),
  div(
   class = "rank",
   substantive_rank
  ),
  div(
   class = "rank",
   brevet_rank
  )
 )
 
}


shinyServer(function(input, output, session) {
  
  base_click <- reactiveValues()
  
  observeEvent(input$`Camp Beauregard`, {
    base_click$value <- "Camp Beauregard"
  })
  
  observeEvent(input$`Fort Polk`, {
    base_click$value <- "Fort Polk"
  })
  
  observeEvent(input$`Fort Benning`, {
    base_click$value <- "Fort Benning"
  })
  
  observeEvent(input$`Fort Gordon`, {
    base_click$value <- "Fort Gordon"
  })
  
  observeEvent(input$`Fort Bragg`, {
    base_click$value <- "Fort Bragg"
  })
  
  observeEvent(input$`A.P. Hill`, {
    base_click$value <- "A.P. Hill"
  })
  
  observeEvent(input$`Fort Lee`, {
    base_click$value <- "Fort Lee"
  })
  
  observeEvent(input$`Fort Pickett`, {
    base_click$value <- "Fort Pickett"
  })
  
  observeEvent(input$`Fort Rucker`, {
    base_click$value <- "Fort Rucker"
  })
  
  observeEvent(input$`Fort Hood`, {
    base_click$value <- "Fort Hood"
  })
  
  
  
  observeEvent(base_click$value, {
    
    letter <- bases %>% 
     filter(base == base_click$value) %>% 
     pull(first_letter)
    
    syls <- bases %>% 
     filter(base == base_click$value) %>% 
     pull(syllables)
    
    matched_generals <- gens %>% 
     filter(first_letter == letter & syllables == syls) %>% 
     select(-first_letter, -syllables, -last_name, -first_middle_name, -notes)
    
    output$suggest <- renderText({
     
     glue("
          {base_click$value} is named after a Confederate general. Here are all the \\
          Union generals with last names that have the same number of syllables \\
          and start with the same letter. Easy.
          ")
     
    })
    
    output$cards <- renderUI({
     
     pmap(matched_generals, make_components)
     
    })
  
  })
 
 
 
}) # end server
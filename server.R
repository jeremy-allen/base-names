library(rvest)
library(stringr)
library(janitor)
library(here)
library(showtext)
library(polite)
library(shiny)
library(tidyverse)
library(assertthat)
library(quanteda)
library(reactable)

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

theme <- reactableTheme(
 style = list(color = "#e6b800", background = "#1a1400"),
 cellStyle = list(borderColor = "#806600"),
 headerStyle = list(borderColor = "#806600"),
 paginationStyle = list(borderColor = "#806600"),
 pageButtonHoverStyle = list(background = "#1a1400"),
 pageButtonActiveStyle = list(background = "#1a1400")
)

shinyServer(function(input, output, session) {
 
 observeEvent(input$beauregard, {
  
  letter <- bases %>% 
   filter(confederate_name == "Beauregard") %>% 
   pull(first_letter)
  
  syls <- bases %>% 
   filter(confederate_name == "Beauregard") %>% 
   pull(syllables)
   
  x <- gens %>% 
   filter(first_letter == letter & syllables == syls) %>% 
   select(-first_letter, -syllables, -last_name, -first_middle_name, -notes)
  
  output$suggest <- renderText({
   base_name <- bases %>% 
    filter(confederate_name == "Beauregard") %>% 
    pull(base)
   
   str_c(base_name, "'s", " name can be replaced with one of these Union General names. Same first letter and same number syllables. Easy.")
  }) 
  
  output$table <- renderReactable({
   reactable(
    x,
    #groupBy = "name",
    filterable = FALSE,
    theme = theme,
    defaultColDef = colDef(
     headerClass = "generals-header"
    ),
    columns = list(
     #notes = colDef(minWidth = 250),   # 50% width, 200px minimum
     substantive_rank = colDef(minWidth = 225),   # 25% width, 100px minimum
     brevet_rank = colDef(minWidth = 225)  # 25% width, 100px minimum
    )
   )
   
  })
  
 })
 
 
 observeEvent(input$polk, {
  
  letter <- bases %>% 
   filter(confederate_name == "Polk") %>% 
   pull(first_letter)
  
  syls <- bases %>% 
   filter(confederate_name == "Polk") %>% 
   pull(syllables)
  
  x <- gens %>% 
   filter(first_letter == letter & syllables == syls) %>% 
   select(-first_letter, -syllables, -last_name, -first_middle_name, -notes)
  
  output$suggest <- renderText({
   base_name <- bases %>% 
    filter(confederate_name == "Polk") %>% 
    pull(base)
   
   str_c(base_name, "'s", " name can be replaced with one of these Union General names. Same first letter and same number syllables. Easy.")
  }) 
  
  output$table <- renderReactable({
   reactable(
    x,
    #groupBy = "name",
    filterable = FALSE,
    theme = theme,
    defaultColDef = colDef(
     headerClass = "generals-header"
    ),
    columns = list(
     #notes = colDef(minWidth = 250),   # 50% width, 200px minimum
     substantive_rank = colDef(minWidth = 225),   # 25% width, 100px minimum
     brevet_rank = colDef(minWidth = 225)  # 25% width, 100px minimum
    )
   )
   
  })
  
 })
 
 
 observeEvent(input$benning, {
  
  letter <- bases %>% 
   filter(confederate_name == "Benning") %>% 
   pull(first_letter)
  
  syls <- bases %>% 
   filter(confederate_name == "Benning") %>% 
   pull(syllables)
  
  x <- gens %>% 
   filter(first_letter == letter & syllables == syls) %>% 
   select(-first_letter, -syllables, -last_name, -first_middle_name, -notes)
  
  output$suggest <- renderText({
   base_name <- bases %>% 
    filter(confederate_name == "Benning") %>% 
    pull(base)
   
   str_c(base_name, "'s", " name can be replaced with one of these Union General names. Same first letter and same number syllables. Easy.")
  }) 
  
  output$table <- renderReactable({
   reactable(
    x,
    #groupBy = "name",
    filterable = FALSE,
    theme = theme,
    defaultColDef = colDef(
     headerClass = "generals-header"
    ),
    columns = list(
     #notes = colDef(minWidth = 250),   # 50% width, 200px minimum
     substantive_rank = colDef(minWidth = 225),   # 25% width, 100px minimum
     brevet_rank = colDef(minWidth = 225)  # 25% width, 100px minimum
    )
   )
   
  })
  
 })
 
 
 observeEvent(input$gordon, {
  
  letter <- bases %>% 
   filter(confederate_name == "Gordon") %>% 
   pull(first_letter)
  
  syls <- bases %>% 
   filter(confederate_name == "Gordon") %>% 
   pull(syllables)
  
  x <- gens %>% 
   filter(first_letter == letter & syllables == syls) %>% 
   select(-first_letter, -syllables, -last_name, -first_middle_name, -notes)
  
  output$suggest <- renderText({
   base_name <- bases %>% 
    filter(confederate_name == "Gordon") %>% 
    pull(base)
   
   str_c(base_name, "'s", " name can be replaced with one of these Union General names. Same first letter and same number syllables. Easy.")
  }) 
  
  output$table <- renderReactable({
   reactable(
    x,
    #groupBy = "name",
    filterable = FALSE,
    theme = theme,
    defaultColDef = colDef(
     headerClass = "generals-header"
    ),
    columns = list(
     #notes = colDef(minWidth = 250),   # 50% width, 200px minimum
     substantive_rank = colDef(minWidth = 225),   # 25% width, 100px minimum
     brevet_rank = colDef(minWidth = 225)  # 25% width, 100px minimum
    )
   )
   
  })
  
 })

 
 # bragg
 
 observeEvent(input$bragg, {
  
  letter <- bases %>% 
   filter(confederate_name == "Bragg") %>% 
   pull(first_letter)
  
  syls <- bases %>% 
   filter(confederate_name == "Bragg") %>% 
   pull(syllables)
  
  x <- gens %>% 
   filter(first_letter == letter & syllables == syls) %>% 
   select(-first_letter, -syllables, -last_name, -first_middle_name, -notes)
  
  output$suggest <- renderText({
   base_name <- bases %>% 
    filter(confederate_name == "Bragg") %>% 
    pull(base)
   
   str_c(base_name, "'s", " name can be replaced with one of these Union General names. Same first letter and same number syllables. Easy.")
  }) 
  
  output$table <- renderReactable({
   reactable(
    x,
    #groupBy = "name",
    filterable = FALSE,
    theme = theme,
    defaultColDef = colDef(
     headerClass = "generals-header"
    ),
    columns = list(
     #notes = colDef(minWidth = 250),   # 50% width, 200px minimum
     substantive_rank = colDef(minWidth = 225),   # 25% width, 100px minimum
     brevet_rank = colDef(minWidth = 225)  # 25% width, 100px minimum
    )
   )
   
  })
  
 })
 
 
 # AP Hill
 
 observeEvent(input$aphill, {
  
  letter <- bases %>% 
   filter(confederate_name == "A.P. Hill") %>% 
   pull(first_letter)
  
  syls <- bases %>% 
   filter(confederate_name == "A.P. Hill") %>% 
   pull(syllables)
  
  x <- gens %>% 
   filter(first_letter == letter & syllables == syls) %>% 
   select(-first_letter, -syllables, -last_name, -first_middle_name, -notes)
  
  output$suggest <- renderText({
   base_name <- bases %>% 
    filter(confederate_name == "A.P. Hill") %>% 
    pull(base)
   
   str_c(base_name, "'s", " name can be replaced with one of these Union General names. Same first letter and same number syllables. Easy.")
  }) 
  
  output$table <- renderReactable({
   reactable(
    x,
    #groupBy = "name",
    filterable = FALSE,
    theme = theme,
    defaultColDef = colDef(
     headerClass = "generals-header"
    ),
    columns = list(
     #notes = colDef(minWidth = 250),   # 50% width, 200px minimum
     substantive_rank = colDef(minWidth = 225),   # 25% width, 100px minimum
     brevet_rank = colDef(minWidth = 225)  # 25% width, 100px minimum
    )
   )
   
  })
  
 })
 
 
 # Lee
 
 observeEvent(input$lee, {
  
  letter <- bases %>% 
   filter(confederate_name == "Lee") %>% 
   pull(first_letter)
  
  syls <- bases %>% 
   filter(confederate_name == "Lee") %>% 
   pull(syllables)
  
  x <- gens %>% 
   filter(first_letter == letter & syllables == syls) %>% 
   select(-first_letter, -syllables, -last_name, -first_middle_name, -notes)
  
  output$suggest <- renderText({
   base_name <- bases %>% 
    filter(confederate_name == "Lee") %>% 
    pull(base)
   
   str_c(base_name, "'s", " name can be replaced with one of these Union General names. Same first letter and same number syllables. Easy.")
  }) 
  
  output$table <- renderReactable({
   reactable(
    x,
    #groupBy = "name",
    filterable = FALSE,
    theme = theme,
    defaultColDef = colDef(
     headerClass = "generals-header"
    ),
    columns = list(
     #notes = colDef(minWidth = 250),   # 50% width, 200px minimum
     substantive_rank = colDef(minWidth = 225),   # 25% width, 100px minimum
     brevet_rank = colDef(minWidth = 225)  # 25% width, 100px minimum
    )
   )
   
  })
  
 })
 
 
 # Pickett
 
 
 observeEvent(input$pickett, {
  
  letter <- bases %>% 
   filter(confederate_name == "Pickett") %>% 
   pull(first_letter)
  
  syls <- bases %>% 
   filter(confederate_name == "Pickett") %>% 
   pull(syllables)
  
  x <- gens %>% 
   filter(first_letter == letter & syllables == syls) %>% 
   select(-first_letter, -syllables, -last_name, -first_middle_name, -notes)
  
  output$suggest <- renderText({
   base_name <- bases %>% 
    filter(confederate_name == "Pickett") %>% 
    pull(base)
   
   str_c(base_name, "'s", " name can be replaced with one of these Union General names. Same first letter and same number syllables. Easy.")
  }) 
  
  output$table <- renderReactable({
   reactable(
    x,
    #groupBy = "name",
    filterable = FALSE,
    theme = theme,
    defaultColDef = colDef(
     headerClass = "generals-header"
    ),
    columns = list(
     #notes = colDef(minWidth = 250),   # 50% width, 200px minimum
     substantive_rank = colDef(minWidth = 225),   # 25% width, 100px minimum
     brevet_rank = colDef(minWidth = 225)  # 25% width, 100px minimum
    )
   )
   
  })
  
 })
 
 
 # Rucker
 
 
 observeEvent(input$rucker, {
  
  letter <- bases %>% 
   filter(confederate_name == "Rucker") %>% 
   pull(first_letter)
  
  syls <- bases %>% 
   filter(confederate_name == "Rucker") %>% 
   pull(syllables)
  
  x <- gens %>% 
   filter(first_letter == letter & syllables == syls) %>% 
   select(-first_letter, -syllables, -last_name, -first_middle_name, -notes)
  
  output$suggest <- renderText({
   base_name <- bases %>% 
    filter(confederate_name == "Rucker") %>% 
    pull(base)
   
   str_c(base_name, "'s", " name can be replaced with one of these Union General names. Same first letter and same number syllables. Easy.")
  }) 
  
  output$table <- renderReactable({
   reactable(
    x,
    #groupBy = "name",
    filterable = FALSE,
    theme = theme,
    defaultColDef = colDef(
     headerClass = "generals-header"
    ),
    columns = list(
     #notes = colDef(minWidth = 250),   # 50% width, 200px minimum
     substantive_rank = colDef(minWidth = 225),   # 25% width, 100px minimum
     brevet_rank = colDef(minWidth = 225)  # 25% width, 100px minimum
    )
   )
   
  })
  
 })
 
 
 # Hood
 
 
 observeEvent(input$hood, {
  
  letter <- bases %>% 
   filter(confederate_name == "Hood") %>% 
   pull(first_letter)
  
  syls <- bases %>% 
   filter(confederate_name == "Hood") %>% 
   pull(syllables)
  
  x <- gens %>% 
   filter(first_letter == letter & syllables == syls) %>% 
   select(-first_letter, -syllables, -last_name, -first_middle_name, -notes)
  
  output$suggest <- renderText({
   base_name <- bases %>% 
    filter(confederate_name == "Hood") %>% 
    pull(base)
   
   str_c(base_name, "'s", " name can be replaced with one of these Union General names. Same first letter and same number syllables. Easy.")
  }) 
  
  output$table <- renderReactable({
   reactable(
    x,
    #groupBy = "name",
    filterable = FALSE,
    theme = theme,
    defaultColDef = colDef(
     headerClass = "generals-header"
    ),
    columns = list(
     #notes = colDef(minWidth = 250),   # 50% width, 200px minimum
     substantive_rank = colDef(minWidth = 225),   # 25% width, 100px minimum
     brevet_rank = colDef(minWidth = 225)  # 25% width, 100px minimum
    )
   )
   
  })
  
 })
 

 
 }) # end server
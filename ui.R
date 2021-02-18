library(shiny)

shinyUI(fluidPage(
 
 # where to get CSS
 includeCSS(path = here::here("www", "styles.css")),
 
 #---- main sections ----
 div(
  class = "flex-outer-container", # container for everything except title and footer
  
  div(
   class = "col-container-base",
   
   # Application title
   div(
     class = "navbar",
     div(
       class = "title",
       "The 10X Re-Baser"
     ),
     p("The U.S. Army has to rename 10 bases."),
     p("Here is a head start.")
   ),
   
   actionLink(
    inputId = "beauregard",
    label = "Camp Beauregard",
    icon = icon("fort-awesome", class = "old", lib = "font-awesome")
   ),
   
   actionLink(
    inputId = "polk",
    label = "Fort Polk",
    icon = icon("fort-awesome", class = "old", lib = "font-awesome")
   ),
   
   actionLink(
    inputId = "benning",
    label = "Fort Benning",
    icon = icon("fort-awesome", class = "old", lib = "font-awesome")
   ),
   
   actionLink(
    inputId = "gordon",
    label = "Fort Gordon",
    icon = icon("fort-awesome", class = "old", lib = "font-awesome")
   ),
   
   actionLink(
    inputId = "bragg",
    label = "Fort Bragg",
    icon = icon("fort-awesome", class = "old", lib = "font-awesome")
   ),
   
   actionLink(
    inputId = "aphill",
    label = "A.P. Hill",
    icon = icon("fort-awesome", class = "old", lib = "font-awesome")
   ),
   
   actionLink(
    inputId = "lee",
    label = "Fort Lee",
    icon = icon("fort-awesome", class = "old", lib = "font-awesome")
   ),
   
   actionLink(
    inputId = "pickett",
    label = "Fort Pickett",
    icon = icon("fort-awesome", class = "old", lib = "font-awesome")
   ),
   
   actionLink(
    inputId = "rucker",
    label = "Fort Rucker",
    icon = icon("fort-awesome", class = "old", lib = "font-awesome")
   ),
   
   actionLink(
    inputId = "hood",
    label = "Fort Hood",
    icon = icon("fort-awesome", class = "old", lib = "font-awesome")
   ),
   
   div(
     class = "source",
     tags$a(href="https://en.wikipedia.org/wiki/List_of_American_Civil_War_generals_(Union)", "Wikipedia")
   ),
   div(
     class = "source",
     tags$a(href="https://github.com/jeremy-allen/base-names", "code")
   ),
   div(
     class = "source",
     tags$a(href="https://twitter.com/jeremy_data", "@jeremy_data")
   )
   
  ),
  
  div(
   class = "col-container-union",
   
   div(
    class = "suggestion",
    textOutput("suggest")
   ),
   
   uiOutput("cards")
   
  )
  
 )
 
 
)) # end shiny ui
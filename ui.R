# load libraries

library(shiny)
library(shinyWidgets)

fluidPage(
  titlePanel("eVision"),
  fluidRow(
    img(src='scu.png', height = '350px', width = '350px'),
    img(src='cepheid.png', height = '225px', width = '350px'),
    img(src='BioInnovation_Design_Lab_Logo.png', height = '350px', width = '350px'),
    img(src='EpicLab.png', height = '350px', width = '350px')
  ),
  
  sidebarPanel(
    
    fluidRow(
      
      column(10, selectInput("disease", h4("Select disease"), 
                             choices = list("Influenza" = "Influenza"), selected = 1)),
      
      column(1, actionButton("disease_button", "?"))
      
    ),
    
    fluidRow(
      
      column(10, selectInput("weeks", h4("# of weeks to predict"), 
                             choices = list("3" = 3, "7" = 7, "14" = 14), selected = 1)),
      
      column(1, actionButton("weeks_button", "?"))
      
    ),
    
    fluidRow(  
      
      column(10, selectInput("level", h4("Prediction Level"), 
                             choices = list("National" = "National", "State" = "State"), selected = 1)),
      
      column(1, actionButton("level_button", "?"))
      
    ),
    
    fluidRow(
      
      column(10, selectInput("main", h4("Level"), 
                             choices = list("North America" = "NA"), selected = 1)),
      
      column(1, actionButton("main_button", "?"))
      
    ),
    
    
    fluidRow(
      
      column(10, selectInput("location", h4("Sublevel"), 
                             choices = list("United States" = "USA"), selected = 1)),
      
      column(1, actionButton("location_button", "?"))
      
    ),
    
    fluidRow(
      
      column(10, textInput("keywords", h4("Insert Keywords"), value="cough, flu, tamiflu, sore throat")),
      
      column(1, actionButton("keywords_button", "?"))
      
    ),
    
    fluidRow(
      
      column(10, sliderInput("ep", h4("Epochs"),
                             min = 1, max = 200, value = 200)),
      
      column(1, actionButton("ep_button", "?"))
      
    ),
    
    h4("Granulation"),
    checkboxInput("checkbox", "Granulate Data?", value = FALSE),
    
    actionButton("test", "Predict")
    
  ),
  
  mainPanel(
    
    h4("Results"),
    plotOutput("graph"),
    
    h4("Confidence"),
    verbatimTextOutput("confidence"),
    
    h4("Parameters"),
    verbatimTextOutput("parameters")
  ),
)

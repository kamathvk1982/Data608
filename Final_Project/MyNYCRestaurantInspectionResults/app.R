#---
#title: "Data608-Final-Project-Shiny App - Visualization and Analysis for - New York City Restaurant Inspection Results"
#author: "Vinayak Kamath"
#date: "05/08/2021"
#---


# set up -----------------------------------------------------------------------
# load packages that will be used for the application
library(shiny)
library(shinythemes)

library(leaflet)
library(DT)
#library(markdown)
library(rmarkdown)

library(dplyr)
library(tidyr)
library(plotly)
library(ggplot2)
library(readr)
library(tibble)
library(stringr)


library(reshape2)
library(RColorBrewer)
library(wordcloud)


source("inspection_data.r", local = TRUE)
source("tidy_data.r", local = TRUE)
source("create_plot.r", local = TRUE)

# Set up the application ui
ui <- shinyUI(navbarPage("New York City Restaurant Inspection Results",
                         
                         theme = shinytheme("flatly"),
                         
                         # define the tabs to be used in the app ----------------------------------------
                         # introduction
                         tabPanel("Intro",
                                  includeMarkdown("./md/intro.md"),
                                  hr()),

                         # Cuisine Analysis
                         tabPanel("Cuisine",
                                  fluidRow(column(12,
                                                  h1("Borough - Cuisine Wise Analysis"),
                                                  p("Each Borough has almost similar cuisine offering; we will check here on the Violation codes by cuisine."),
                                                  br(),
                                                  h4("Instructions"),
                                                  p("Use the Options buttons on the left to chose the Borough."))),
                                  hr(),
                                  fluidRow(sidebarPanel(width = 3,
                                                        helpText("Chose the option you would like to see the analysis for."),
                                                        selectInput("boroughInput1", "Select Borough",c(name.All,name.Bronx,name.Brooklyn,name.Manhattan, name.Queens,name.StatenIsland)),
                                                        br(),
                                                        selectInput("cuisineInput1", "Select Cuisine",list.cuisine),
                                                        ),
                                           mainPanel(tabsetPanel(
                                               tabPanel("Plot", plotOutput("chartViolation", height = 2500))
                                               , tabPanel("WordCloud", plotOutput("wordViolation", height = 500))
                                               , tabPanel("2018 vs 2019 vs 2020", plotOutput("chartYears", height = 500))
                                               , id = "idCuisine"
                                           )))
                         ),

                         # VIOLATION Analysis
                         tabPanel("Violation",
                                  fluidRow(column(12,
                                                  h1("Violation Wise Analysis"),
                                                  p("There are almost 98 unique violations; we will check here on each Violation codes and dig more into it."),
                                                  br(),
                                                  h4("Instructions"),
                                                  p("Use the Options buttons on the left to chose the Violation"))),
                                  hr(),
                                  fluidRow(sidebarPanel(width = 3,
                                                        helpText("Chose the option you would like to see the analysis for."),
                                                        selectInput("violationInput1", "Select Violation",list.violation),
                                  ),
                                  mainPanel(tabsetPanel(
                                      tabPanel("Details", DT::dataTableOutput("chartDetails"))
                                      , tabPanel("Borough", plotOutput("chartBorough"))
                                      , tabPanel("Cuisine", plotOutput("chartCuisine"))
                                      , id = "idViolation"
                                  )))
                         ),

                         # Business Analysis
                         tabPanel("Business",
                                  fluidRow(column(12,
                                                  h1("Business Wise Analysis"),
                                                  p("There are almost 25,590 business in our dataset; we will check here on each Business and dig more into it."),
                                                  br(),
                                                  h4("Instructions"),
                                                  p("Use the Options buttons on the left to chose the Violation"))),
                                  hr(),
                                  fluidRow(sidebarPanel(width = 3,
                                                        helpText("Chose the option you would like to see the analysis for."),
                                                        selectInput("businessInput1", "Select Business",list.business),
                                  ),
                                  mainPanel(tabsetPanel(
                                      tabPanel("Details", DT::dataTableOutput("chartBusiness"))
                                      , tabPanel("Citations", DT::dataTableOutput("chartCitations"))
                                      , tabPanel("Chart", plotlyOutput("chartGroup"))
                                      , tabPanel("Map", leafletOutput("drawMap"))
                                      , id = "idBusiness"
                                  )))
                         ),                         
                         # introduction sentiment analysis
                         tabPanel("About",
                                  includeMarkdown("./md/about.md"),
                                  hr())
                         
                         # close the UI definition
))

# Define server logic required to draw a histogram ----
server <- shinyServer(function(input, output) {
    
    # Expression that generates a histogram. The expression is
    # wrapped in a call to renderPlot to indicate that:
    #
    #  1) It is "reactive" and therefore should be automatically
    #     re-executed when inputs change
    #  2) Its output type is a plot
    

    
    output$chartViolation <- renderPlot({
        createHistPlot( input$boroughInput1 , input$cuisineInput1)
    })
    
    output$wordViolation <- renderPlot({
        createWordCloud( input$boroughInput1 , input$cuisineInput1)
    })

    output$chartYears <- renderPlot({
        createHistPlotYears( input$boroughInput1 , input$cuisineInput1)
    })

    
    output$chartDetails <- DT::renderDataTable(DT::datatable({
        data <- data.violation
        if (input$violationInput1 != name.All) {
            data <- data[data$VIOLATION_CODE == input$violationInput1,]
        }
        data
    }))
    
    output$chartBorough <- renderPlot({
        createChartBorough( input$violationInput1)
    })
    
    output$chartCuisine <- renderPlot({
        createChartCuisine( input$violationInput1)
    })

    output$chartBusiness <- DT::renderDataTable(DT::datatable({
        data <- data.business
        if (input$businessInput1 != name.All) {
            data <- data[data$CAMIS == input$businessInput1,]
        }
        data
    }))

    output$chartCitations <- DT::renderDataTable(DT::datatable({
        data <- data.citations
        if (input$businessInput1 != name.All) {
            data <- data[data$CAMIS == input$businessInput1,]
        }
        data
    }))
    
    output$drawMap <- renderLeaflet({
        createMap( input$businessInput1)
    })
    
    output$chartGroup <- renderPlotly({
        createGrpHistPlot( input$businessInput1)
    })
    
})

# Create Shiny app ----
shinyApp(ui = ui, server = server)

#---
#title: "Data608-MOduel 03-Shiny App - Mortality Rate : 1999-2010"
#author: "Vinayak Kamath"
#date: "03/06/2021"
#---


# set up -----------------------------------------------------------------------
# load packages that will be used for the application

library(ggplot2)
library(dplyr)
library(shiny)
library(shinythemes)


df <- read.csv('https://raw.githubusercontent.com/kamathvk1982/Data608/main/Module_03/data/cleaned-cdc-mortality-1999-2010-2.csv')


ui <- shinyUI(navbarPage("Mortality Rate : 1999-2010",
  theme = shinytheme("flatly"),
  
  # introduction 
  tabPanel("Intro",
           h3("Module 3 : A Shiny App - Mortality Rate : 1999-2010 "),
           br(),
           p("Data about mortality from all 50 states and the District of Columbia."),
           p("Please access it at https://raw.githubusercontent.com/kamathvk1982/Data608/main/Module_03/data/cleaned-cdc-mortality-1999-2010-2.csv")
           
  ),

  # Q1. Crude mortality rate, across all States
  tabPanel("Q1. Crude Mortality Rate, Across All States",
           fluidRow(column(12,
                           h3("Crude Mortality Rate, Across All States"),
                           p("Question 1:"),
                           p("As a researcher, you frequently compare mortality rates from particular causes across different States. You need a visualization that will let you see (for 2010 only) the crude mortality rate, across all States, from one cause (for example, Neoplasms, which are effectively cancers). Create a visualization that allows you to rank States by crude mortality for each cause of death."),
                           br(),
                           h4("Instructions"),
                           p("Use the Drop Down Options on the left to choose from."))),
           hr(),
           fluidRow(sidebarPanel(width = 3,
                                 helpText("Chose the Cause Of Death and Year you would like to see the analysis for."),
                                 selectInput('CauseOfDeath1', 'Cause Of Death', unique(df$ICDChapter), selected='Neoplasms'),
                                 selectInput('Year1', 'Year', unique(df$Year), selected='2010')
           ),
                    mainPanel(
                      plotOutput('plot1')
                    )
  )),
  
  # Q2. mortality rates (per cause)
  tabPanel("Q2. Mortality Rates (Per Cause)",
           fluidRow(column(12,
                           h3("Mortality Rates (Per Cause)"),
                           p("Question 2:"),
                           p("Often you are asked whether particular States are improving their mortality rates (per cause) faster than, or slower than, the national average. Create a visualization that lets your clients see this for themselves for one cause of death at the time. Keep in mind that the national average should be weighted by the national population."),
                           br(),
                           h4("Instructions"),
                           p("Use the Drop Down Options on the left to choose from."))),
           hr(),
           fluidRow(sidebarPanel(width = 3,
                                 helpText("Chose the Cause Of Death and State you would like to see the analysis for."),
                                 selectInput('CauseOfDeath2', 'Cause Of Death', unique(df$ICDChapter), selected='Certain infectious and parasitic diseases'),
                                 selectInput('State2', 'State', unique(df$State), selected='AL'),
           ),
           mainPanel(
             plotOutput('plot2')
           )
  ))
) )

server <- shinyServer(function(input, output, session) {
  

  output$plot1 <- renderPlot({
    
    dfSlice1 <- df %>%
      filter(ICDChapter == input$CauseOfDeath1,   Year == input$Year1)
    
    title_label <- input$CauseOfDeath1
    
    ggplot(dfSlice1, aes(x = CrudeRate, y = reorder(State, CrudeRate), color= State) ) +
      geom_bar(stat = "identity") + 
      labs(title = title_label, x = "Crude Rate", y = "State")
  })
  
  output$plot2 <- renderPlot({
    
    dfSlice2 <- df %>%
      filter(ICDChapter == input$CauseOfDeath2, State == input$State2)
    
    title_label <- input$CauseOfDeath2
    
    dfNatioanlAverage <- df %>%
      filter(ICDChapter == input$CauseOfDeath2) %>%
      group_by(ICDChapter, Year) %>%
      summarise(SumDeaths = sum(Deaths),SumPopulation = sum(Population)) %>%
      mutate(AvgCrudeRate = ((SumDeaths /SumPopulation ) * 100000 ) )
    
    ggplot(dfSlice2, aes(x = Year, y = CrudeRate, color= State)) +
      geom_line(aes(colour = State), linetype = 5)+
      geom_line(data = dfNatioanlAverage, aes(x=Year, y=AvgCrudeRate, colour="National Average"), linetype = 5) + 
      labs(title = title_label, x = "Year", y = "Crude Rate")
    
  })
  
})

shinyApp(ui = ui, server = server)

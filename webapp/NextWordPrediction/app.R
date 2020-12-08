#
# Shiny Web App for next word predictions.
#
# author: Riccardo Finotello
# date:   08/10/2020
#
library(shiny)
library(quanteda)
library(data.table)
library(parallel)
library(markdown)

setDTthreads(threads=detectCores())
quanteda_options("threads" = detectCores())
quanteda_options("verbose" = FALSE)
source("./predictions.R")

# Define UI for application that draws a histogram
ui <- fluidPage(
    
        titlePanel("Next Word Predictions"),
        sidebarLayout(
            sidebarPanel(
                helpText("Write you sentence and choose the number of predictions to display."),
                textInput("str", label = h3("Enter some text:"), value = ""),
                numericInput("n", label = h3("No. of predictions:"), min = 1, max = 10, value = 5, step = 1),
                submitButton("Go!")
            ),
            mainPanel(
                tabsetPanel(type = "tabs",
                            tabPanel("Main",
                                     h3("Predictions:"),
                                     h4(textOutput("predict", container = pre)
                                    )
                            ),
                            tabPanel("Help", includeMarkdown("./help.md"))
                            
                )
            )
        )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$predict <- renderText({
        if(input$str=="")
            return("Enter few words.")
        predictions <- getNext(input$str, input$n)
        return(paste(1:input$n, ") ", predictions, "\n", sep=""))
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

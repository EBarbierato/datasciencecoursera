library(shiny)
library(stringr)
library(dplyr)


#' Load pre-defined function
source("./generate_n_grams.r")

#' Build the user interface
ui <- fluidPage(
    
    # Give a title
    titlePanel("A model for Text Prediction"),
    p("The purpose of this app consists of predicting a word following an initial (incomplete) sentence introduced by the user."),
    
    # Instuctions 
    sidebarLayout(
        sidebarPanel(
            h2("Work as follows:"), 
            h5("1. Introduce a sentence (or event just one word) in the box;"),
            h5("2. The app will predict the next word in a different colour (blue). It is not necessary to hit the carriage-return key;"),
            h5("3. A typo in your phrase (or word) will inhibit the prediction step (you will see only a question mark);"),
            br(),
            a("Source Code", href = "https://github.com/theatomicrembrandt/generate_n_grams")
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(
                tabPanel("predict",
                         textInput("user_input", h3("Introduce one or more words:"), 
                                   value = "What you have introduced"),
                         h3("Prediction: the next word could be:"),
                         h4(em(span(textOutput("ngram_output"), style="color:blue"))))
            )   
        )
    )
)
#' Define server logic required to draw a histogram
server <- function(input, output) {
    
    output$ngram_output <- renderText({
        gram_n(input$user_input)
    })
    
}

#' Run the application 
shinyApp(ui = ui, server = server)
library(shiny)
library(leaflet)
library(maps)
library(mapdata)

# Define UI ----
ui <- fluidPage(titlePanel(title = h1("Municipal MeterReader Route Optimisation")) 
                , sidebarLayout
                    ( position = "right"
                      ,sidebarPanel("Specify App requirements"
                                    #, actionButton("action", "Action")
                                    , br() 
                                    , selectInput("CurrentUser", h3("Select current App User"), 
                                                  choices = list("Hanju", "Wilhelm",
                                                                 "Mark" = 3), selected = 1)
                                    , br()
                                    , dateInput("date", 
                                                h3("Date input"), 
                                                value = Sys.Date())
                                    #, dateRangeInput("dates", h3("Date range"))
                                    #, br()
                                    # , helpText("Note: help text isn't a true widget,", 
                                    #            "but it provides an easy way to add text to",
                                    #            "accompany other widgets.")
                                    , br()
                                    , sliderInput("ClusterAmount"
                                                  , h3("Specify the number of Clusters")
                                                  , min = 0
                                                  , max = 100
                                                  , value = 50)
                                    , br()
                                    ,numericInput("CurrentCluster"
                                                  , h3("Current Cluster route to show:")
                                                  , value = 1)
                                    , br()
                                    # , radioButtons("radio", h3("Radio buttons"),
                                    #              choices = list("Choice 1" = 1, "Choice 2" = 2,
                                    #                             "Choice 3" = 3),selected = 1)
                                    # , br() 
                                    , submitButton("Submit")
                                   )
                              
                      ,mainPanel(
                                    h2("Route Information", align = "center")
                                    , br()
                                    # , p("Add information on the current selection"
                                    #     ,span("with style"
                                    #           , style = "color:blue"),"and it continues")
                                    , br()
                                    , textOutput("AuditInfo")
                                    , br()
                                    , leafletOutput(outputId = "PlotClusters")
                    #,
                    # h3("Third level title"),
                    # h4("Fourth level title"),
                    # h5("Fifth level title"),
                    # h6("Sixth level title")
                                )
                )
)

# Define server logic ----
server <- function(input, output) {
  output$AuditInfo <- renderText({
    paste(" User: ",input$CurrentUser, " is using the App on: ",input$date )
    # paste("Amount of routes/clusters" , input$ClusterAmount)
    # paste("The current cluster", input$CurrentCluster)
  })
  output$PlotClusters <- renderLeaflet({
    basicMap(input$CurrentCluster)
  })
}

# Run the app ----
shinyApp(ui = ui, server = server)
   
 
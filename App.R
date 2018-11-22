#Shiny conversion

#install.packages("shiny")
#library(shiny)
#library (leaflet)


ui <- fluidPage(
  
  titlePanel("K-Means Clustering"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      sliderInput(inputId = "clusters",
                  label = "Number of Clusters:",
                  min = 1,
                  max = 8,
                  value = 5)
      
    ),
    
    mainPanel(
      
      leafletOutput(outputId = "mapPlot")
      
    )
  )
)

server <- function(input, output) {
  
  locations <- read.csv("locations.csv")

  output$mapPlot <- renderLeaflet({
    
    kmeans.result <- kmeans (locations, input$clusters)
    df = as.data.frame(cbind(Easting = locations$Easting, Northing = locations$Northing, cluster = kmeans.result$cluster)) 
    
    getColor <- function(df) {
      sapply(df$cluster, function(cluster) {
        if(cluster == 1) {
          "green"
        } else if(cluster == 2) {
          "black"
        }
        else if(cluster == 3) {
          "purple"
        }
        else if(cluster == 4) {
          "blue"
        }
        else if(cluster == 5) {
          "gray"
        }
        else if(cluster == 6) {
          "pink"
        }
        else if(cluster == 7) {
          "white"
        }
        
        else {
          "red"
        } })
    }
    
    icons <- awesomeIcons(
      icon = 'beer',
      iconColor = 'black',
      library = 'ion',
      markerColor = getColor(df)
    )
    
    
    leaflet(df) %>% addTiles() %>%
      addAwesomeMarkers(~Easting, ~Northing, icon=icons, label = ~as.character(cluster))
  
    
  })
  
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)
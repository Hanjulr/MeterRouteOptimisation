#CurrentNum <- 2
basicMap <- function(ClusterNum) {
  Current_Cluster <-  filter(all_tour_info, cluster == ClusterNum)
  m <- leaflet() %>%
    addTiles() %>%  # Add default OpenStreetMap map tiles
    addMarkers(lng=19.44309
               , lat=-33.64394
               , label = "Municipal"
               #, labelOptions = labelOptions(noHide = TRUE, offset=c(0,-12), textOnly = TRUE) #, 
    ) %>%
  
  # addMarkers(lng=Current_Cluster$Easting
  #            , lat=Current_Cluster$Northing
  #            , label = as.character(Current_Cluster$visit_no)
  #            # , popup=paste(sep = "<br/>","Erf No: ",Current_Cluster$lables
  #            #               , "Visit no:", Current_Cluster$visit_no)
  #            , labelOptions = labelOptions(noHide = TRUE, offset=c(0,-12))
  #            )
  

  addCircleMarkers(lng=Current_Cluster$Easting
                   , lat=Current_Cluster$Northing
                   , label = as.character(Current_Cluster$visit_no)                 #, label = Current_Cluster$lables
                   , labelOptions = labelOptions(noHide = TRUE)
                   , color = "blue"
                   , radius = 2
                   , fillOpacity = 1)

  # addPopups(lng=Current_Cluster$Easting
  #           , lat=Current_Cluster$Northing
  #           #, label = Current_Cluster$lables
  #           , label = Current_Cluster$visit_no
  #           , color = "blue")
  
  return(m)
}  
#basicMap(2)
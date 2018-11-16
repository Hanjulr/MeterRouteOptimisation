
locations <- select (meters_geopoints ,Easting, Northing, ERFNO = B105_ERFNO)


#K-means
kmeans.result <- kmeans (locations[c("Easting", "Northing")], numb)
#plot (locations[c("Easting", "Northing")], col = kmeans.result$cluster)

locations_clustered = as.data.frame(cbind(locations, cluster = kmeans.result$cluster)) 

  #leaflet clustering
  # leaflet(locations) %>% 
  #   addTiles() %>% 
  #   addMarkers(~Easting, ~Northing,    clusterOptions = markerClusterOptions()  )
  # 

#Plot Clusters
   icons <- awesomeIcons(
    icon = 'beer',  #'home', #
    iconColor = 'black',
    library = 'ion',
    markerColor = getColor(locations_clustered)
    #text = locations_clustered$ERFNO
  )
  
  leaflet(locations_clustered) %>% addTiles() %>%
    addAwesomeMarkers(~Easting, ~Northing, icon=icons, label = ~as.character(cluster))

rm(locations,kmeans.result,icons)
  
  
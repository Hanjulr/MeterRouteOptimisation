head(locations_clustered)

count(filter(locations_clustered,cluster == 1))
count(filter(locations_clustered,cluster == 2))
count(filter(locations_clustered,cluster == 3))
count(filter(locations_clustered,cluster == 4))

 
t2_GeoPoints <- dplyr::select(filter(locations_clustered,cluster == 1), Easting, Northing, ERFNO) #, B105_ERFNO
t1_GeoPoints <- data.frame(rbind(municipal_geo,t2_GeoPoints))
#sapply(t2_GeoPoints, class)
#sapply(t1_GeoPoints, class)

t1_GeoPoints[,1] <- as.numeric(t1_GeoPoints[,1])
t1_GeoPoints[,2] <- as.numeric(t1_GeoPoints[,2])

DistMatrix <- matrix("NA", nrow = nrow(t1_GeoPoints), ncol = nrow(t1_GeoPoints)) 

rownames(DistMatrix) <- c(t1_GeoPoints$ERFNO)
colnames(DistMatrix) <- c(t1_GeoPoints$ERFNO)

DistMatrix[1,] <- 0
DistMatrix[,1] <- 0

# t1_GeoPoints
# t1_GeoPoints[rn,]
#DistMatrix2 <- DistMatrix

rn = 2
cn = 2
while (rn <= nrow(t1_GeoPoints))
{
  while (cn <= nrow(t1_GeoPoints))
  { 
    DistMatrix[rn,cn] <- distCosine(t1_GeoPoints[rn,1:2],t1_GeoPoints[cn,1:2])
    #DistMatrix2[rn,cn] <- paste("Distance Between ERF:",t1_GeoPoints[rn,3]," and ERF:",t1_GeoPoints[cn,3])
    #print(paste("Currently at element: ", rn,":",cn))
    #print(paste("Distance Between ERF:",t1_GeoPoints[rn,3]," and ERF:",t1_GeoPoints[cn,3], " = ",DistMatrix[rn,cn]))
    
    cn <- cn + 1 
  }
  cn <- 2
  rn <- rn + 1
  #print(paste("Distance Between element:",rn," and elemet:",cn))
}

#TSP_DistMatrix <- as.TSP(DistMatrix)
#class(as.TSP(DistMatrix))


tour2 <- solve_TSP(as.TSP(DistMatrix), TSP_methods = "nn", start='Municipal')

class(tour2)#Class TOUR represents a solution to a TSP by an integer permutation vector containing the ordered indices and labels of the cities to visitIn addition, it stores an attribute indicating the length of the tour. 

print(tour2)
tour_length(tour2)
as.integer(tour2)

n_of_cities(as.TSP(DistMatrix))


 tour2_vst <- data.frame(cbind(t1_GeoPoints, visitno = as.integer(tour2)))
 #sapply(tour2_vst, class)
 tour2_vst[,4] <- as.numeric(tour2_vst[,4])
 
 route2 <- arrange(tour2_vst,as.integer(visitno))

 #Cutting the tour
 head(tour2,13)
 path2 <- cut_tour(tour2,'Municipal',exclude_cut = FALSE)
 head(labels(path2),14)
 
  
 
 
 


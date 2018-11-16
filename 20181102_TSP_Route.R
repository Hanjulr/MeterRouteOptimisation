head(locations_clustered)

count(filter(locations_clustered,cluster == 1))
count(filter(locations_clustered,cluster == 2))
count(filter(locations_clustered,cluster == 3))
count(filter(locations_clustered,cluster == 4))


t2_GeoPoints <- dplyr::select(filter(locations_clustered,cluster == 1), Easting, Northing, ERFNO) #, B105_ERFNO

DistMatrix <- matrix("NA", nrow = nrow(t2_GeoPoints), ncol = nrow(t2_GeoPoints)) 

rownames(DistMatrix) <- t2_GeoPoints$ERFNO
colnames(DistMatrix) <- t2_GeoPoints$ERFNO

rn = 1
cn = 1
while (rn <= nrow(t2_GeoPoints))
{
  while (cn <= nrow(t2_GeoPoints))
  { 
    DistMatrix[rn,cn] <- distCosine(t2_GeoPoints[rn,1:2],t2_GeoPoints[cn,1:2])
    #print(paste("Distance Between element:",rn," and elemet:",cn, " = ",DistMatrix[rn,cn]))
    cn <- cn + 1 
  }
  cn <- 1
  rn <- rn + 1
  #print(paste("Distance Between element:",rn," and elemet:",cn))
}

#TSP_DistMatrix <- as.TSP(DistMatrix)
class(as.TSP(DistMatrix))

#Find out how to assign labels to Matrix/TSP Class
#labels(DistMatrixLables) <- t2_GeoPoints[,3]
tour2 <- solve_TSP(as.TSP(DistMatrix), TSP_methods = "nn")

class(tour2)#Class TOUR represents a solution to a TSP by an integer permutation vector containing the ordered indices and labels of the cities to visitIn addition, it stores an attribute indicating the length of the tour. 

print(tour2)
tour_length(tour2)
as.integer(tour2)

n_of_cities(as.TSP(DistMatrix))


 tour2_vst <- data.frame(cbind(t2_GeoPoints, visitno = as.integer(tour1)))
 #sapply(tour2_vst, class)
 tour2_vst[,4] <- as.numeric(tour2_vst[,4])
 
 route2 <- head(arrange(tour2_vst,as.integer(visitno)))
  
 
 
 


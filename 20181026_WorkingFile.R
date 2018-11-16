#check aggregate function https://www.miskatonic.org/2012/09/24/counting-and-aggregating-r/
m_tst1 <- meters_f2 %>%
  distinct(B105_LA,B105_SUBURB,B105_ERFNO) %>%
  count(B105_ERFNO)  
group_by(meters_f2,B105_LA,B105_SUBURB,B105_ERFNO)
meters_f2$rank <- NA
meters_f2$rank[B105_ERFNO] <- 1:5101

m2_tst1 <-  (count(meters_f2, c("B105_SUBURB")))

m_tst2 <- filter(m_tst1,n >= 2)


#Looking to get a count on each ERFNO in order to make sure we dont have duplicates
meters_f3     %>%
    #distinct(B105_LA,B105_SUBURB,B105_ERFNO) %>% count()
    group_by(B105_LA,B105_SUBURB,B105_ERFNO) %>%
    count(B105_ERFNO) %>%
    arrange(desc(n)) %>%
    distinct()
#Alot of duplicates of the below ERFNO with multiple meter numbers
filter(meters_f3,B105_ERFNO == 13912)



#looking for the highest featureId


#filter(cadastral_f1,Label == 23745) %>% 

cadastral_join <- cadastral_f1  %>% 
    select(EnglishName,featureId, Label, Easting, Northing) %>%
    distinct(EnglishName,featureId, Label, Easting, Northing) %>%
    group_by(EnglishName, Label) %>%
    mutate(rank = order(desc(featureId))) %>%
    filter(rank == 1)
    #rank()
    

cadastral_f1$rank <- NA
cadastral_f1$rank <- rank(cadastral_f1$featureId)
c_tst1 <- filter(count(cadastral_f1,Label),n >= 2)

c_tst2 <- filter(cadastral_f1, Label == 23745) 

#Note the above cadastral daa contains some duplicate Labels (erfno) with different Geopoints
#Might need to apply a rank to data in order to get distinct lables


#############################################
#Getting the Map Limits into a Matrix automatically
##Eventually did not go through with it as it is already a dataframe
#############################################

#Working with Dataframe of MapLimits

#Create DataFrame from Geopoints
BoundsCoord <- rbind(MaxNorthingCoord,MinNorthingCoord,MaxEastingCoord,MinEastingCoord)

#Create List from DataFrame
BoundsCoord$index <- 1:nrow(BoundsCoord)
BoundsList <- by(BoundsCoord[,c("index","Easting","Northing")],1:nrow(BoundsCoord),function(x){return(list(x))})

#Create a matrix from DataFrame
#Creating a n:1 matrix and  1:n matrix
matrix(BoundsCoord$Easting, nrow = nrow(BoundsCoord), ncol = 1) /
matrix(BoundsCoord$Easting, nrow = 1, ncol = nrow(BoundsCoord))

dim(BoundsMatrix) <- c(4,4)

#Check out functions in the example
lower.tri(BoundsList)

##################################################################################
##Get a matrix of distances
##############################################################################

BoundsCoord

BoundsCoord[1,]
BoundsCoord[2,]

distCosine(c(BoundsCoord[1,1], BoundsCoord[1,2]), cbind(BoundsCoord[2,1], BoundsCoord[2,2]))
distHaversine(c(BoundsCoord[1,1], BoundsCoord[1,2]), cbind(BoundsCoord[2,1], BoundsCoord[2,2]))
distVincentySphere(c(BoundsCoord[1,1], BoundsCoord[1,2]), cbind(BoundsCoord[2,1], BoundsCoord[2,2]))

distCosine(BoundsCoord[1,],BoundsCoord[2,])

nrow(BoundsCoord)

#Define 4x1 matrix for values to be assined to
BoundsDistMatrix <- matrix("NA", nrow = nrow(BoundsCoord), ncol = 1) 

n = 1
while (n <= nrow(BoundsCoord)){ 
                #  print(distCosine(BoundsCoord[1,],BoundsCoord[n,]))
                BoundsDistMatrix[n,1] <- distCosine(BoundsCoord[1,],BoundsCoord[n,])
                  #print(paste("1",n))
                n <- n+1
              }


#Define 4x4 matrix for values to be assined to
BoundsCoord <- rbind(MaxNorthingCoord,MinNorthingCoord,MaxEastingCoord,MinEastingCoord)
BoundsDistMatrix2 <- matrix("NA", nrow = nrow(BoundsCoord), ncol = nrow(BoundsCoord)) 

rn = 1
cn = 1
while (rn <= nrow(BoundsCoord))
{
  while (cn <= nrow(BoundsCoord))
  { 
  BoundsDistMatrix2[rn,cn] <- distCosine(BoundsCoord[rn,],BoundsCoord[cn,])
  print(paste("Distance Between element:",rn," and elemet:",cn, " = ",BoundsDistMatrix2[rn,cn]))
  cn <- cn + 1 
  }
  cn <- 1
  rn <- rn + 1
  #print(paste("Distance Between element:",rn," and elemet:",cn))
}


######################################################################################
#Using the full dataset
######################################################################################
#detach("package:gdistance", unload=TRUE)
#Define matrix for data points
#class(t2)
t2_GeoPoints <- head(dplyr::select(t2, Easting, Northing, B105_ERFNO),100) #, B105_ERFNO

DistMatrix <- matrix("NA", nrow = nrow(t2_GeoPoints), ncol = nrow(t2_GeoPoints)) 

rownames(DistMatrix) <- t2_GeoPoints$B105_ERFNO
colnames(DistMatrix) <- t2_GeoPoints$B105_ERFNO

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
tour1 <- solve_TSP(as.TSP(DistMatrix), TSP_methods = "nn")

class(tour1)#Class TOUR represents a solution to a TSP by an integer permutation vector containing the ordered indices and labels of the cities to visitIn addition, it stores an attribute indicating the length of the tour. 

print(tour1)
tour_length(tour1)
as.integer(tour1)
labels(tour1)
n_of_cities(as.TSP(DistMatrix))



  
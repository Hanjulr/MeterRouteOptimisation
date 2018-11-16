
meters_f3 <- filter(meters, B05_SSTYPE == "W", B105_LA == "WMUN", B105_BDATE > 201700)

meters_join <-  meters_f3     %>% 
  distinct(B105_LA,B105_SUBURB,B105_ERFNO)

#Get a subset of the Cadastral data to be joined
cadastral_f1 <- filter(cadastral, EnglishName == "WORCESTER")

#Get distinct values to be joined
cadastral_join <- cadastral_f1  %>% 
  select(EnglishName,featureId, Label, Easting, Northing) %>%
  distinct(EnglishName,featureId, Label, Easting, Northing) %>%
  group_by(EnglishName, Label) %>%
  mutate(rank = order(desc(featureId))) %>%
  filter(rank == 1) %>%
  ungroup(cadastral_join)
   
meters_join$B105_ERFNO <- as.character(meters_join$B105_ERFNO)
cadastral_join$Label <- as.character(cadastral_join$Label)
 

#t1 <- left_join(meters_join,cadastral_join,by = c("B105_ERFNO"="Label"))
meters_geopoints <- inner_join(meters_join,cadastral_join,by = c("B105_ERFNO"="Label"))
#t3 <- semi_join(meters_join,cadastral_join,by = c("B105_ERFNO"="Label"))
#t4 <- anti_join(meters_join,cadastral_join,by = c("B105_ERFNO"="Label"))

rm(meters_f3,meters_join,cadastral_f1,cadastral_join,meters,cadastral)
#rm(meters_t1,meters_join2,meters_f2)


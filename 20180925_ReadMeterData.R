
f <- file("meters_v2.txt", "rb")  ##"meters_v2.txt"
meters_l <- readLines (f)
meters_data <- read.csv(textConnection(meters_l), sep = "$" , encoding = "UTF-8" , quote = "")

rm(f,meters_l) 

meters <- select(meters_data
                 , B105_LA
                 , B105_SKEYID
                 , B105_BDATE
                 , B105_RDATE
                 , B05_SSTYPE
                 , B105_SUBURB 
                 , B105_ERFNO
                 , B105_METERNO 
                 , B105_SUBDIV
                 , B105_SUBSECT
                 , B105_SGROUP
                 , B105_DACCOUN
                 , B05_LOCMET
                 , B105_USERNAM
                 , B40_ROUTENO )

rm(meters_data)
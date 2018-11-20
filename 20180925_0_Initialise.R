# setwd(choose.dir())
# getwd()

setwd("C:/Users/lerouxh01/Desktop/OneDrive - Altron Group/R_Programming/Project")
source("20180925_LoadPackages.R") 

cadastral <- read.delim("Worcestor_ErvenData.txt", header = TRUE, ';')
 
source("20180925_ReadMeterData.R")  
source("20181025_JoinMetersToCadastral.R")
source("20181114_LoadFunctions.R")

municipal_geo <- c(19.4430873,-33.6439385,"Municipal") 
numb <- readinteger()
99

source("20181115_Clustering.R")


#The below presents a popup box for user input
####install.packages("svDialogs")
####library(svDialogs)
## user.input <- dlgInput("Enter a number", Sys.info()["user"])$res

readinteger <- function()
{ 
  n <- readline(prompt="Enter an digit between 1 and 9: ")
  n <- as.integer(n)
  if (is.na(n) || n > 9 || n < 1){
    n <- readinteger()
  }
  return(n)
}

getColor <- function(locations_clustered) {
  sapply(locations_clustered$cluster, function(cluster) {
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
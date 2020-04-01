#!/usr/bin/env R

#-----------
# databike class
#------------
setClass("bike.data", 
         slots = c(bike = "character",
                   weight = "numeric",
                   fuel = "numeric")
         )

# methods
setMethod("inspectscooter",
          signature(),
          function(){inspectscooter})

#-------
# component classes
#-----------

# bike
setClass("bike", slots = c(type = "character",
                           tires = "character",
                           body = "character",
                           engine = "character"),
         contains = "scooter"
         )



#----------------
# bike components
#----------------



inspectscooter <- function(){
  # returns statuses for scooter and components
}
#!/usr/bin/env R

# Defines "scooter" and its subclasses

inspectscooter <- function(){
  # returns statuses for scooter and components
}

#-----------
# scooter class
#------------
setClass("scooter", 
         slots = c(bike = "character",
                   weight = "numeric",
                   fuel = "numeric")
         )

# methods
setMethod("inspect", function(){inspectscooter()})

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
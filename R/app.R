#!/usr/bin/env R

# https://stackoverflow.com/questions/46116614/taking-inputs-through-pop-up-window-in-r/46116803

# pre-ride
# 1. ride duration (animation loops)
# 2. obstacles and obstacle intervals

# prep ride data
ride.dur <- 100
ride.seq <- seq(1, ride.dur, 1)

# get obstacle data
max.o <- 10
o.num <- sample(max.o, 1)
o.seq <- sample(ride.seq, o.num)

# ride function
ride <- function("ride", framevector){
  for(c in ride.seq){
    if(c %in% o.seq){
      
    } else{
      
    }
  }
}

ride.normal <- function(scenelabel = "ride: normal", framevector, 
                            ssint = 0.1, loops = 100){
  grid.newpage()
  c = 1
  while(c < loops){
    for(f in fv){
      framewithlabel <- paste0(c(scenelabel,
                                 f), collapse = "\n")
      grid.newpage()
      grid.text(framewithlabel)
      Sys.sleep(sleepint)
    }
    c = c + 1
  }
}

ride.obstacle <- function(scenelabel = "ride: obstacle!", 
                          framevector, ssint = 0.3, 
                          loops = 10){
  grid.newpage()
  c = 1
  while(c < loops){
    for(f in fv){
      # print ride animation
      framewithlabel <- paste0(c(scenelabel,
                                 f), 
                               collapse = "\n")
      grid.newpage()
      grid.text(framewithlabel)
      # print obstacle animation
      grid.text()
      
      Sys.sleep(sleepint)
    }
    c = c + 1
  }
}

















scene.withlabel <- function(scenelabel, framevector, 
                            ssint = 0.1, loops = 100){
  grid.newpage()
  c = 1
  while(c < loops){
    for(f in fv){
      framewithlabel <- paste0(c(scenelabel,
                                 f), collapse = "\n")
      grid.newpage()
      grid.text(framewithlabel)
      Sys.sleep(sleepint)
    }
    c = c + 1
  }
}

seqscene <- c()







# ride

# 0. calculate num obstacles (sample) and obstacle interval (sample)
# 1. bike idle
# 2. bike ride
# 3. 









# Data for app
# Manage scene sequences for rides
# Manage probs for app engine

# Game sequence
# A. "inspect bike"
# A1. "maintain"
# A2. ""
# B. "ride"
# B1. "obstacle encounter"

# score
# num rides - (num "crashes" * 0.5 num "stops")

# A. tune?
# B. ride?

# 

# vars for "ride sequence"
# time (cycles in animation)
# bike wear (change chance of "breakdown")
# tire wear

#------------
# user prompt
#------------
install.packages("svDialogs")

library(svDialogs)

user.input <- dlgInput("Continue?", 
                       Sys.info()[""])$res
if (!length(user)){}

ui <- dlgInput("The bike looks damaged. Continue ride?",
               )

  
  
  
#--------------------
# animation sequences
#--------------------
# sequence for "normal ride"
# 1. idle
# 2. ride

# sequence for "obstacle"
# 0. (normal ride)
# 1. ride + obstacle
# 2. idle
# 3. player option (continue, or "stop")


# test

#-----------
# obstacles
#----------

# at start of ride, calculate obstacles

# grid.text() overlay frames
# use sample to assess obstacle presence
get_omod <- function(set.omod = 2){
  if(is.null(set.omomd)){
    # assess things and get modified omod
  }
  return(omod)
}
o.mod <- get_omod(2)
o.chance <- sample(c(1, o.mod), 1)

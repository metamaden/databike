#!/usr/bin/env R


# https://stackoverflow.com/questions/46116614/taking-inputs-through-pop-up-window-in-r/46116803






# pre-ride
# 1. drive duration (animation loops)
# 2. obstacles and obstacle intervals

drive.dur <- 100
drive.seq <- seq(1, drive.dur, 1)

max.o <- 10
o.num <- sample(max.o, 1)
o.seq <- sample(drive.seq, o.num)

# ride function

ride <- function("ride", framevector, )


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
# 2. bike drive
# 3. 









# Data for app
# Manage scene sequences for drives
# Manage probs for app engine

# Game sequence
# A. "inspect bike"
# A1. "maintain"
# A2. ""
# B. "drive"
# B1. "obstacle encounter"

# score
# num drives - (num "crashes" * 0.5 num "stops")

# A. tune?
# B. drive?

# 

# vars for "drive sequence"
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
# sequence for "normal drive"
# 1. idle
# 2. drive

# sequence for "obstacle"
# 0. (normal drive)
# 1. drive + obstacle
# 2. idle
# 3. player option (continue, or "stop")


# test

#-----------
# obstacles
#----------

# at start of drive, calculate obstacles

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

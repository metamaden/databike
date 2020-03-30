#!/usr/bin/env R

# app start
library(svDialogs)
library(grid)

# 0. load "cache" data
fv.idle <- ascii_idle_fv()
fv.drive <- ascii_drive_fv()
fv.obstacle <- ascii_obstacle_fv()
fvl <- ascii_fvl(fv.drive, fv.idle, fv.obstacle)

# main app
# 1. bikevar prompt
bike <- asciibike()
# 2. main app loop
# 2A. rideseq var prompt
get_ride.seq <- function(ride.dur){
  # parses ride durations into c lengths and indices
  opt1 <- "shrt"; opt2 <- "medium"; opt3 <- "loooong"
  ride.options <- c(opt1, opt2, opt3)
  rt <- sample(ride.options) # short, medium, long
  ride.type <- rt
  ride.dur <- ifelse(rt == opt1, 30, 
                     ifelse(rt == opt2, 50, 
                            ifelse(rt == opt3, 100, "NA")))
  ride.seq <- seq(1, ride.dur, 1)
  return(ride.seq)
}
# 2B. idle var prompt
do_idle()
# 2C. do ride
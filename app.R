#!/usr/bin/env R

# app.R
# Main code for `databike` app.

# external dependencies
require(svDialogs)
require(grid)


fp.org <- "./org.R"
source(fp.org)

#dn <- "."
#functions.fn <- "functions.Rdata"
#data.fn <- "data.Rdata"
#path.functions <- paste(c(dn, functions.fn), collapse = "/")
#path.data <- paste(c(dn, data.fn), collapse = "/")
# load game data and functions
#load(path.functions)
#load(path.data)

# bike ascii frames
bike <- asciibike()
fv.idle <- ascii_idle_fv(bike)
fv.drive <- ascii_drive_fv(bike)
fv.obstacle <- ascii_obstacle_fv()
fvl <- ascii_fvl(fv.drive, fv.idle, 
                   fv.obstacle)
while(bcond > 0){
  do_idle(mprob, rprob, bcond)
  # retrieve ride duration
  rt <- sample(optl, 1) 
  ride.dur <- get_ride.dur(rt, ru)
  # new ride sequence data
 
   ride.seq <- seq(1, ride.dur, 1)
  n.obstacles <- sample(10, 1)
  o.seq <- sample(ride.seq, 
                  n.obstacles)
  # run ride
  ride(ride.seq, ride.dur, 
       o.seq, bcond, tdist, onum)
}
message("Game over <3 (quit procrastinating and get to work!)",
        "mileage: ", tdist,
        "obstacles: ", onum)





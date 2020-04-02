#!/usr/bin/env R



# app.R
# runs `databike` 



# tagsforplb: app; game; simulator
# Databike game

# app start
require(svDialogs)
require(grid)




dn <- "."
functions.fn <- "functions.Rdata"
data.fn <- "data.Rdata"
path.functions <- paste(c(dn, functions.fn), collapse = "/")
path.data <- paste(c(dn, data.fn), collapse = "/")





# load(path.data) # load.data()
load(path.functions) # load.uscorestart()
load(path.data) # load.functions()
#log_errors()

# main app # maintain bcond > 0, also show score.... ... 
# load "cache" data

# bike datatt
bike <- asciibike()
fv.idle <- ascii_idle_fv(bike)
fv.drive <- ascii_drive_fv(bike)
fv.obstacle <- ascii_obstacle_fv()
fvl <- ascii_fvl(fv.drive, fv.idle, 
                   fv.obstacle)
while(bcond > 0){
  do_idle(mprob, rprob)
  ride.dur <- get_ride.dur(optl)
  ride.seq <- seq(1, ride.dur, 1)
  n.obstacles <- sample(10, 1)
  o.seq <- sample(ride.seq, 
                  n.obstacles)
  # run ride
  ride(ride.seq, ride.dur, 
       o.seq, bcond, tdist, onum)
}
message("process finished. ",
        "mileage: ", tdist,
        "obstacles: ", onum,
        "amount repaired: ", nrepair)
# end options endgame ...
# play again?
# other stuff

# adds check on bcond





# ride loop improvements
. option to quit#  option to quit
# 











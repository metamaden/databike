#!/usr/bin/env R
# app; game; simulator
# Databike game

# app start
require(svDialogs)
require(grid)

# app.R
# runs `databike`
dn <- "R"
#path.data <- paste0(dn, "data.RData", collapse = "/")
{
  path.functions <- paste(c(dn, "functions.RData"), 
                          collapse = "/")
  path.userscorestart <- paste(c(dn, "data.RData"), 
                               collapse = "/")
}

# load(path.data) # load.data()
load(path.userscorestart) # load.uscorestart()
load(path.functions) # load.functions()
#log_errors()

# main app # maintain bcond > 0, also show score.... ... 
# load "cache" data
fv.idle <- ascii_idle_fv()
fv.drive <- ascii_drive_fv()
fv.obstacle <- ascii_obstacle_fv()
fvl <- ascii_fvl(fv.drive, fv.idle, 
                 fv.obstacle)
while(bcond > 0){
  bike <- asciibike()
  do_idle(mprob, rprob)
  ride.dur <- get_ride.dur()
  ride.seq <- seq(1, ride.dur, 1)
  n.obstacles <- sample(10, 1)
  o.seq <- sample(ride.seq, 
                  n.obstacles)
  # run ride
  ride(ride.seq, o.seq, 
       bcond, tdist, onum)
}
message("process finished")
# end options endgame ...
# play again?
# other stuff




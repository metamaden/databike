#!/usr/bin/env R

# Main app script, to be run from command line

#-------------
# dependencies
#-------------
require(svDialogs) # manages usr dialogues
require(grid) # prints char strings for ani
require(jpeg) # for loading databike logo

rdata.dir <- "."
dn <- "R"
fn.fun <- "functions"
fn.params <- "params"
fp.fun <- paste0(c(dn, paste0(fn.fun, ".R")), 
                 collapse = "/")
fn.params <- paste0(c(dn, paste0(fn.params, ".R")), 
                    collapse = "/")
source(fp.fun); source(fn.params)

#-----------------
# ani char strings
#-----------------
bike <- asciibike()
fv.idle <- ascii_idle_fv(bike)
fv.drive <- ascii_drive_fv(bike)
fv.obstacle <- ascii_obstacle_fv()
fvl <- list("drive" = fv.drive, 
            "idle" = fv.idle)

#---------------
# main app loop
#---------------
while(bcond > 0 & stopoption == "no"){
  su.ride <- app.fun(fv.idle, logo, mprob, 
                     rprob, bcond, nobst)
  stopoption <- su.ride[["stopoption"]]
  bcond <- su.ride[["su.ride"]][["bcond"]]
  nobst <- su.ride[["su.ride"]][["onum"]]
  tdist <- su.ride[["su.ride"]][["tdist"]]
  nride = nride + 1
}

#------------------
# end-of-game stuff
#------------------
dlg_message(paste0("Game over!", " mileage = ", 
                   tdist, ", obstacles = ", 
                   onum, ", num. rides = ",
                   nride), "ok")

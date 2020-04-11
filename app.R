#!/usr/bin/env R

# Main app script, to be run from command line

#-------------
# dependencies
#-------------
require(svDialogs) # manages usr dialogues
require(grid) # prints char strings for ani
require(jpeg) # for loading databike logo
# require(here) # gets path

rdata.dir <- "."
dn <- "R"
fn.fun <- "functions"
fn.params <- "params"
fp.fun <- paste0(c(dn, paste0(fn.fun, ".R")),
                 collapse = "/")
fn.params <- paste0(c(dn, paste0(fn.params, ".R")),
                    collapse = "/")
#source(here(fp.fun))
#source(here(fn.params))
source(fp.fun)
source(fn.params)

#-----------------
# ani char strings
#-----------------
bike <- asciibike()
fv.idle <- ascii_idle_fv(bike)
fv.drive <- ascii_drive_fv(bike)
fv.obstacle <- ascii_obstacle_fv()
fvl <- list("drive" = fv.drive,
            "idle" = fv.idle)

#--------------
# main app loop
#--------------
stopoption <- "no"
while(bcond > 0 & stopoption == "no"){
  if(nride = 0){
    su.ride <- app.fun(fv.idle = fv.idle, logo = logo, # data for ani
                       mprob = mprob.start, rprob = rprob.start, # idle params
                       bcond = bcond.start, onum = onum.start) # usr stats
  } else{
    su.ride <- app.fun(fv.idle = fv.idle, logo = logo, # data for ani
                       mprob = mprob, rprob = rprob, # idle params
                       bcond = bcond, onum = onum, nride = nride) # usr stats
  }
  # eval bcond second, jumps to end if 0
  bcond <- su.ride[["su.ride"]][["bcond"]]
  # eval so first, jumps to end if `yes`
  stopoption <- su.ride[["stopoption"]]
  # track remaining stats before gameplay loop
  nobst <- su.ride[["su.ride"]][["onum"]]
  tdist <- su.ride[["su.ride"]][["tdist"]]
  nride = nride + 1
}

#------------------
# end-of-game stuff
#------------------
dlg_message(paste0("Game over!",
                   " mileage = ", tdist,
                   ", obstacles = ", onum,
                   ", num. rides = ", nride),
            "ok")

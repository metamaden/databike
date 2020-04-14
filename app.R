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

# source functions scripts
fun.fnv <- c("ani_fun", "ride_fun", "idle_fun", 
             "difficulty_fun", "app_fun")
for(funfn in fun.fnv){
  fnpath <- paste0(c(dn, paste0(funfn, ".R")),
                   collapse = "/")
  source(fnpath)
}

# source params script
fn.params <- "params"
fn.params <- paste0(c(dn, paste0(fn.params, ".R")),
                    collapse = "/")
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
# first ride
su.ride <- app.fun(fv.idle = fv.idle, logo = logo.jpg, # data for ani
                   minobst = minobst, onum = onum, nride = 1,
                   tdist = tdist, verbose = TRUE) # usr stats
# eval bcond second, jumps to end if 0
bcond <- su.ride[["su.ride"]][["bcond"]]
# eval so first, jumps to end if `yes`
stopoption <- su.ride[["stopoption"]]
# track remaining stats before gameplay loop
nobst <- su.ride[["su.ride"]][["onum"]]
tdist <- su.ride[["su.ride"]][["tdist"]]
# second ride and beyond
while(bcond > 0 & stopoption == "no"){
  su.ride <- app.fun(fv.idle = fv.idle, logo = logo.jpg, # data for ani
                     minobst = minobst, mprob = mprob, rprob = rprob, # idle params
                     bcond = bcond, onum = onum, nride = nride,
                     verbose = TRUE) # usr stats
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

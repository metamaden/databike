#!/usr/bin/env R

# dependencies
require(svDialogs)
require(grid)
require(jpeg)

rdata.dir <- "."
dn <- "data"
fn.fun <- "functions"
fn.params <- "params"
fp.fun <- paste0(c(dn, paste0(fn.fun, ".R")), collapse = "/")
fn.params <- paste0(c(dn, paste0(fn.params, ".R")), collapse = "/")
# load data scripts (use source())
source(fp.fun)
source(fn.params)

# external dependencies
fp.org <- "./org.R"
source(fp.org)

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
  su.ride <- app.fun(fv.idle, logo, 
                     mprob, rprob, 
                     bcond, nobst)
}

#------------------
# end-of-game stuff
#------------------
dlg_message(paste0("Game over!", " mileage = ", 
                   tdist, ", obstacles = ", 
                   onum), "ok")

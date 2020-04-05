#!/usr/bin/env R

require(svDialogs)
require(grid)
require(jpeg)

# app.R
# Main code for `databike` app.

# external dependencies
fp.org <- "./org.R"
source(fp.org)

# bike ascii frames
bike <- asciibike()
fv.idle <- ascii_idle_fv(bike)
fv.drive <- ascii_drive_fv(bike)
fv.obstacle <- ascii_obstacle_fv()
fvl <- list("drive" = fv.drive, 
            "idle" = fv.idle)
stopoption <- "no"
logo <- readJPEG("databike_logo.jpg")
while(bcond > 0 & stopoption == "no"){
  
  su.ride <- app.fun(fv.idle, logo, 
                     mprob, rprob, 
                     bcond, nobst)
  
  #if(nride==0){
  #  
  #} else{
  #  app.fun()
  #}
  
}
# end game message
dlg_message(paste0("Game over!", " mileage = ", 
                   tdist,
                   ", obstacles = ", onum), 
            "ok")
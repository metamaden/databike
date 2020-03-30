#!/usr/bin/env R

# app start
library(svDialogs)
library(grid)

# load usrscores
{
  # starting stats
  tdist <- 0 # total mileage
  onum <- 0 # obstacle number
  bcond <- 0.5 # bike condition
  mprob <- 0.5 # maintenance
  rprob <- 0.5 # repair
  bdi <- 0.1 # bcond change increment
  rpm <- 1.5 # repair prob modifier to bdi
}
# load "cache" data
{
  fv.idle <- ascii_idle_fv()
  fv.drive <- ascii_drive_fv()
  fv.obstacle <- ascii_obstacle_fv()
  fvl <- ascii_fvl(fv.drive, fv.idle, fv.obstacle)
}

# main app
# 1. bikevar prompt
bike <- asciibike()
# 2. main app loop
# 2B. idle var prompt
do_idle(mprob, rprob)
# 2C. do ride
ride(ride.seq, o.seq, bcond, 
     tdist, onum)
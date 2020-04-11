#!/usr/bin/env R

# script to store data for scootsim
# called with load() in app.R

# starting values
tdist <- 0 # total mileage
onum <- 0 # obstacle number
bcond <- 0.5 # bike condition
mprob <- 0.5 # maintenance probability "fix"
rprob <- 0.5 # repair probability "fix"
bdi <- 0.1 # bcond change increment
rpm <- 1.5 # repair prob modifier to bdi
ssint <- 0.15 # frame interval (game speed)
stopoption <- "no"

logo <- readJPEG("databike_logo.jpg")

nride = 0 # ride quantity
nobst = 0 # num obstacles

# "frame speed" settings (sleepintts)
si.stationary <- 0.05
si.idle <- 0.05
si.ridenorm <- 0.12
si.rideobst <- 0.1

# possible obstacle symbols (randomize on encounter)
ossl <- c("#", "$", "@", ".", "")# ascii chars

# possible ride durations (ascending length)
optl = c("short", "medium", "long")

# ride duration "units" (num. loops/value c)
ru <- c(20, 50, 100)

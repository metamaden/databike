#!/usr/bin/env R

# script to store data for scootsim
# called with load() in app.R

# system path separator symbol
sys.sep <- "/"

# main logo image
graphics.dir = "graphics"
logo.jpg <- readJPEG(paste(c(graphics.dir,
                             "databike_logo.jpg"),
                           collapse = sys.sep))
# logo.gif <- readGIF()

#--------------------
# starting usr stats (normal)
#--------------------
# base stats to start
# note, these may be modified by setting not-normal difficulty
# see get_difficulty()

# modifier for difficulty, modifies bcond, mstart, rstart
# e.g. easy -> metric + metric*mod.scale
# difficult -> metric - metric*mod.scale
mod.scale = 0.25

# bike values
bcond.start <- 0.5 # bike condition
mprob.start <- 0.5 # maintenance probability "fix"
rprob.start <- 0.5 # repair probability "fix"

# usr start metrics, parsed by difficulty functions
lstart <- list("bcond" = bcond.start,
               "mprob" = mprob.start,
               "rprob" = rprob.start)

# modifiers
bdi <- 0.1 # bcond change increment
rpm <- 1.5 # repair prob modifier to bdi
ssint <- 0.15 # frame interval (game speed)
minobst <- 6 # min obst, decreases as nrides increase ("experience mechanic)
stopoption <- "no"

# mileage, rides, and obstacle params
tdist <- 0 # total mileage
nride = 0 # ride quantity
minobst = 10 # num obstacles
onum = 0 # num obstacles encountered

# sys.slepp intervals,
# controls ani frmaerate
si.stationary <- 0.05
si.idle <- 0.05
si.ridenorm <- 0.12
si.rideobst <- 0.1

# possible obstacle symbols (randomize on encounter)
# ossl <- c("###", "$&*()", "@@@", "^^^", "((((")# ascii chars
ossl <- paste(sample(c("@","#","$","^","&","*"),4), collapse = "")

# possible ride durations (ascending length)
optl = c("short", "medium", "long")

# ride duration "units" (num. loops/value c)
ru <- c(20, 50, 100)

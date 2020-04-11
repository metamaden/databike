#!/usr/bin/env R

# script to store data for scootsim
# called with load() in app.R

sys.sep <- "/"

# main logo image
graphics.dir = ""
logo.jpg <- readJPEG(paste(c(graphics.dir,
                             "databike_logo.jpg"),
                           collapse = sys.sep))
# logo.gif <- readGIF()

# bike values
tdist <- 0 # total mileage
bcond <- 0.5 # bike condition

# idle task params
mprob <- 0.5 # maintenance probability "fix"
rprob <- 0.5 # repair probability "fix"

# modifiers
bdi <- 0.1 # bcond change increment
rpm <- 1.5 # repair prob modifier to bdi
ssint <- 0.15 # frame interval (game speed)
minobst <- 6 # min obst, decreases as nrides increase ("experience mechanic)
stopoption <- "no"

# rides and obstacles
nride = 0 # ride quantity
nobst = 0 # num obstacles
onum = 0 # num obstacles encountered

# sys.slepp intervals,
# controls ani frmaerate
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

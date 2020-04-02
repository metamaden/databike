#!/usr/bin/env R

# script to store data for scootsim
# called with load() in app.R


# load usrscores
# starting stats
tdist <- 0 # total mileage
onum <- 0 # obstacle number
bcond <- 0.5 # bike condition
mprob <- 0.5 # maintenance
rprob <- 0.5 # repair
bdi <- 0.1 # bcond change increment
rpm <- 1.5 # repair prob modifier to bdi

# possible ride durations (ascending length)
optl = c("short", "medium", "long")
# ride duration "units" (num. loops/value c)
ru <- c(20, 50, 100)

save.image("data.Rdata")
#!/usr/bin/env R

# load usrscores
# starting stats
tdist <- 0 # total mileage
onum <- 0 # obstacle number
bcond <- 0.5 # bike condition
mprob <- 0.5 # maintenance
rprob <- 0.5 # repair
bdi <- 0.1 # bcond change increment
rpm <- 1.5 # repair prob modifier to bdi

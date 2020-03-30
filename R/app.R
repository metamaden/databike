#!/usr/bin/env R

# Main code for scootsim app
# Beta: 
# 1. bike condition modifies obstacles
# 2. mileage modifies maintenance -> bcond
# 3. between rides, either "maintain" or "repair"

# planned updates
# define "bike" and "component" classes
# introduce "components" as classes

# classes
# bike -> component
# possible components: component1, component2

library(svDialogs)
library(grid)

#---------
# main app
#---------
# starting stats
tdist <- 0 # total mileage
onum <- 0 # obstacle number
bcond <- 0.5 # bike condition
mprob <- 0.5 # maintenance
rprob <- 0.5 # repair
bdi <- 0.1 # bcond change increment
rpm <- 1.5 # repair prob modifier to bdi

# idle/maintenance -- can only repair or maintain
# repair? 
# maintain?

do_repair <- function(bcond, rpm){
  new.bcond <- ifelse(outcome == "fix",
                      bcond + bdi*rpm,
                      bcond - bdi*rpm)
  return(new.bcond)
}

get_task_outcome <- function(task.prob){
  v <- 10*task.prob
  s1 = rep("fix", v)
  s2 = rep("break", 100 - v)
  outcome <- sample(c(s1, s2), 1)
  return(outcome)
}

do_idle <- function(mprob, rprob){
  # idle.task
  itask <- dlg_message("maintain?", "yesno")$res
  if(itask == "yes"){
    outcome <- get_task_outcome()
    bcond = ifelse(outcome == "fix",
                   bcond + bdi, )
  } else{
   itask <- dlg_message("repair?", "yesno")$res
   if(itask == "yes"){
     bcond <- ifelse(outcome == "fix",
                     bcond + bdi*rpm,
                     bcond - bdi*rpm)
   }
  }
  return()
}

# random bonus
# 1. inc. bike condition
# 2. improve repair
# 3. improve maintain

bprob <- 0.5
100 * bprob

bonustype <- sample(c(), 1)


# get rideseq and oseq
ride.seq <- get_rideseq()
o.seq <- get_oseq(ride.seq)
ride(ride.seq, o.seq)

#---------------
# prep ride data
#---------------
rt <- "short" # short, medium, long
ride.type <- rt
ride.dur <- ifelse(rt == "short", 30, 
                   ifelse(rt == "medium", 50, 
                          ifelse(rt == "long", 100, "NA")))
ride.seq <- seq(1, ride.dur, 1)

#---------------------
# ride duration prompt
#---------------------
get_rideseq <- function(ride.options = c("short", "medium", "long")){
  # randomize ride len
  rand.ridedur <- sample(ride.options, 1)
  # offer ride
  ui.msg <- dlg_message(paste0("Offer for a ride of ", 
                               rand.ridedur," duration. ",
                               "Accept ride offer?"), 
                        "yesno")$res
  ui.ridedur <- ifelse(ui.msg == "yes", rand.ridedur, "NA")
  # return ride.seq
  ride.seq <- get_rideseq(ui.ridedur)
  return(ride.seq)
}

{
  ride.options <- c("short", "medium", "long")
  get.ridedur <- sample(ride.options, 1)
  ui.msg <- dlg_message(paste0("Offer for a ride of ", get.ride," duration. ",
                               "Accept ride offer?"), 
                        "yesno")$res
  ui.ridedur <- ifelse(ui.msg, ridedur, "NA")
  
  # triggers ride sequences
  get_rideseq <- function(rt = ui.ridedur){
    ride.dur <- ifelse(rt == "short", 30, 
                       ifelse(rt == "medium", 50, 
                              ifelse(rt == "long", 100, "NA")))
    ride.seq <- seq(1, ride.dur, 1)
    return(ride.seq)
  }
  
  ride.prompt <- function(){
    ui.msg <- dlg_message("accept ride?", "yesno")$res
  }
  
}

# get obstacle data
get_oseq <- function(ride.seq, max.o = 10){
  o.num <- sample(max.o, 1)
  o.seq <- sample(ride.seq, o.num)
  return(o.seq)
}
{
  max.o <- 10
  o.num <- sample(max.o, 1)
  o.seq <- sample(ride.seq, o.num)
  
}

# get rideseq and oseq
ride.seq <- get_rideseq()
o.seq <- get_oseq(ride.seq)

#---------------
# ride functions
#---------------

obstacle.uifun <- function(){
  ui.msg <- dlg_message("cancel ride?", "yesno")$res
  return(ifelse(ui.msg == "yes", 0, 1))
}

endride.uifun <- function(msgstr){
  ui.msg <- dlg_message(msgstr, "ok")
}

ride.normal <- function(alabel = "ride: normal", msgperc,
                        framevector = fv.drive, ssint = 0.1, loops = 1){
  grid.newpage()
  c = 1
  while(c <= loops){
    for(f in framevector){
      framewithlabel <- paste0(c(alabel, f, msgperc), 
                               collapse = "\n")
      grid.newpage()
      grid.text(framewithlabel)
      Sys.sleep(ssint)
    }
    c = c + 1
  }
}

ride.obstacle <- function(alabel = "ride: obstacle!", msgperc,
                          framevector1 = fv.drive, 
                          framevector2 = fv.obstacle, 
                          ssint = 0.5, loops = 2){
  grid.newpage()
  c = 1
  while(c <= loops){
    for(i in 1:length(framevector1)){
      grid.newpage()
      # print ride animation
      fs <- framevector1[i]
      frame1 <- paste0(c(alabel, fs, msgperc), 
                               collapse = "\n")
      grid.text(frame1)
      # print obstacle animation
      fo <- framevector2[i]
      frame2 <- paste0(c(" ", fo),
                       collapse = "\n")
      grid.text(frame2)
      Sys.sleep(ssint)
    }
    c = c + 1
  }
}

ride <- function(ride.seq, o.seq, bc,
                 tdist, onum, bcond){
  
  # global stats
  # tdist # global mileage
  # onum # global obstacle count
  # bcond # bike condition
  
  require(grid)
  # add bike condition stuff
  grid.newpage()
  # baseline stats for ride
  ride.finished <- 0; ride.status <- 1
  perc.finished <- 0
  oride <- 0
  # bcchange <- bc # bike condition
  while(ride.status > 0){
    for(c in ride.seq){
      perc.finished <- 100*(c/length(ride.seq))
      msgperc <- paste0("ride progress: ", perc.finished, "%")
      ride.finished <- ifelse(c == max(ride.seq),
                              1, 0)
      if(c %in% o.seq){
        ride.obstacle(msgperc = msgperc)
        ride.status <- obstacle.uifun()
      } else{
        ride.normal(msgperc = msgperc)
      }
      if(ride.status == 0){
        msgstr <- "ride over!"
        msgstr <- ifelse(ride.finished == 1,
                         paste0(msgstr, 
                                " the ride has ended!! \n",
                                "mileage = ", tdist + c,
                                ""),
                         paste0(msgstr,
                                " the ride has ended!! \n",
                                "mileage = ", tdist + c,
                                "obstacles = ", onum + oride)
                         )
        # get running stats
        lr <- list("tot.dist",
                   "tot.obstacles",
                   "bike.condition")
        
        endride.uifun(msgstr)
        return(NULL)
      }
    }
  }
  grid.newpage()
  return(bc)
}

ride(ride.seq, o.seq)


scene.withlabel <- function(scenelabel, framevector, 
                            ssint = 0.1, loops = 100){
  grid.newpage()
  c = 1
  while(c < loops){
    for(f in fv){
      framewithlabel <- paste0(c(scenelabel,
                                 f), collapse = "\n")
      grid.newpage()
      grid.text(framewithlabel)
      Sys.sleep(sleepint)
    }
    c = c + 1
  }
}

seqscene <- c()







# ride

# 0. calculate num obstacles (sample) and obstacle interval (sample)
# 1. bike idle
# 2. bike ride
# 3. 









# Data for app
# Manage scene sequences for rides
# Manage probs for app engine

# Game sequence
# A. "inspect bike"
# A1. "maintain"
# A2. ""
# B. "ride"
# B1. "obstacle encounter"

# score
# num rides - (num "crashes" * 0.5 num "stops")

# A. tune?
# B. ride?

# 

# vars for "ride sequence"
# time (cycles in animation)
# bike wear (change chance of "breakdown")
# tire wear

#------------
# user prompt
#------------
install.packages("svDialogs")

library(svDialogs)

user.input <- dlgInput("Continue?", 
                       Sys.info()["Y/N"])$res

# obstacle ui
oui <- function(){
  ui <- dlgInput("Cancel ride?",
                 Sys.info()["Y/N"])$res
  if(!length(ui)){
    ride.on <- 0
    message("ride cancelled")
  } else{
    ride.on <- 1
    message("continuing ride...")
  }
  return(ride.on)
}

ui <- dlgInput("Cancel ride?",
               Sys.info()["Y/N"])$res
if(!length(ui)){
  ride.on <- 0
  message("ride cancelled")
  } else{
    ride.on <- 1
    message("continuing ride...")
  }

ui.fun <- function(){
  ui.msg <- dlg_message("cancel ride?", "yesno")$res
  return(ifelse(ui.msg == "yes", 0, 1))
}

ui <- dlg_message("Cancel ride?",
               Sys.info()["Y/N"])$res
if(!length(ui)){
  ride.on <- 0
  message("ride cancelled")
} else{
  ride.on <- 1
  message("continuing ride...")
}
  
  
#--------------------
# animation sequences
#--------------------
# ascii seqs for "normal ride"
# 1. idle
# 2. ride

# ascii seqs for "obstacle"
# 0. (normal ride)
# 1. ride + obstacle
# 2. idle
# 3. player option (continue, or "stop")


# test

#-----------
# obstacles
#----------

# at start of ride, calculate obstacles

# grid.text() overlay frames
# use sample to assess obstacle presence
get_omod <- function(set.omod = 2){
  if(is.null(set.omomd)){
    # assess things and get modified omod
  }
  return(omod)
}
o.mod <- get_omod(2)
o.chance <- sample(c(1, o.mod), 1)


{
  # options (ascending ride "length" c)
  opt1 <- "shrt"; opt2 <- "medium"; opt3 <- "loooong"
  ride.options <- c(opt1, opt2, opt3)
  rt <- sample(ride.options) # short, medium, long
  ride.type <- rt
  ride.dur <- ifelse(rt == opt1, 30, 
                     ifelse(rt == opt2, 50, 
                            ifelse(rt == opt3, 100, "NA")))
  ride.seq <- seq(1, ride.dur, 1)
}



# prep ride data
{
  rt <- "short" # short, medium, long
  ride.type <- rt
  ride.dur <- ifelse(rt == "short", 30, 
                     ifelse(rt == "medium", 50, 
                            ifelse(rt == "long", 100, "NA")))
  ride.seq <- seq(1, ride.dur, 1)
}


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
# possibly not useful code? 
# old versions of functions, etc.
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


#--------
# old app.R
#---

#!/usr/bin/env R
# dependencies


library(svDialogs)
library(grid)


#===============

#-----
# app
#-----
# features
# 1. customize ride

rounds <- 0
ustats <- get_usrstats(tdist, onum, bcond, 
                       mprob, rprob, bdi, rpm){
  # retrieves user stats
  # tdist : total mileage
  # onum : obstacle number
  # bcond : bike condition
  # mprob : maintenance
  # rprob : repair
  # bdi : bcond change increment
  # rpm : repair prob modifier to bdi
  if(round == 0){
    tdist <- 0; onum <- 0; bcond <- 0.5; mprob <- 0.5
    rprob <- 0.5; bdi <- 0.1; rpm <- 1.5
  } else{
    tdist <- tdist; onum <- onum; bcond <- bcond
    mprob <- mprob; rprob <- rprob; bdi <- bdi
    rpm <- rpm
  }
  lr <- list("tdist" = tdist, "onum" = onum, "bcond" = bcond,
             "mprob" = mprob, "rprob" = rprob, "bdi" = bdi,
             "rpm" = rpm)
  return(lr)
}

do_idle(mprob = ustats[["mprob"]], 
        rprob = ustats[["rprob"]])
ustats[["bcond"]] <- do_idle()

ride(ride.seq, o.seq, 
     bcond , tdist, onum)



#-------
#-------


get_usrstats(tdist, onum, bcond, mprob, rprob, bdi, rpm){
  if(round == 0){
    tdist <- 0 # total mileage
    onum <- 0 # obstacle number
    bcond <- 0.5 # bike condition
    mprob <- 0.5 # maintenance
    rprob <- 0.5 # repair
    bdi <- 0.1 # bcond change increment
    rpm <- 1.5 # repair prob modifier to bdi
  } else{
    tdist <- tdist
    onum <- onum
    bcond <- bcond
    mprob <- mprob
    rprob <- rprob
    bdi <- bdi
    rpm <- rpm
  }
  lr <- list("tdist" = tdist,
             "onum" = onum,
             "bcond" = bcond,
             "mprob" = mprob,
             "rprob" = rprob,
             "bdi" = bdi,
             "rpm" = rpm)
  return(lr)
}

#------
# idle task section

# show idle animation
# present usr option
# goto ride randomizer...
# ...

{
  # main app
  #---------
  # idle/maintenance -- can only repair or maintain
  # repair? 
  # maintain?
  
  rungame <- function(){
    # garage time
    do_idle()
    # get rideseq and oseq
    ride.seq <- get_rideseq()
    o.seq <- get_oseq(ride.seq)
    ride(ride.seq, o.seq)
  }
  
  # trigger idle -> do task
  
  # returns modified bcond
  do_idle <- function(mprob, rprob){
    itask <- dlg_message("maintain?", "yesno")$res
    # parse idle task
    if(itask == "yes"){
      outcome <- get_task_outcome(mprob)
      bcond.new = ifelse(outcome == "fix",
                         bcond + bdi, 
                         bcond - bdi)
    } else{
      itask <- dlg_message("repair?", "yesno")$res
      # parse repair task
      if(itask == "yes"){
        outcome <- get_task_outcome(mprob)
        bcond.new <- ifelse(outcome == "fix",
                            bcond + bdi*rpm,
                            bcond - bdi*rpm)
      }
    }
    return(bcond.new)
  }
  
  do_task <- function(bcond, rpm){
    new.bcond <- ifelse(outcome == "fix",
                        bcond + bdi*rpm,
                        bcond - bdi*rpm)
    return(new.bcond)
  }
  
  get_task_outcome <- function(task.prob){
    # parses maintenance and repair tasks
    v <- 10*task.prob
    s1 = rep("fix", v)
    s2 = rep("break", 100 - v)
    outcome <- sample(c(s1, s2), 1)
    if(outcome == "fix"){
      dlg_message("the bike was successfully maintained", "ok")
    } else{
      dlg_message("attempt to maintain bike failed", "ok")
    }
    return(outcome)
  }
  
}
# planned updates
# define "bike" and "component" classes
# introduce "components" as classes

# classes
# bike -> component
# possible components: component1, component2

#-------------
# dependencies
#-------------

# starting stats
tdist <- 0 # total mileage
onum <- 0 # obstacle number
bcond <- 0.5 # bike condition
mprob <- 0.5 # maintenance
rprob <- 0.5 # repair
bdi <- 0.1 # bcond change increment
rpm <- 1.5 # repair prob modifier to bdi

# event data and functions
{
  # prep ride functions
  
  # ridseq
  rt <- "short" # short, medium, long
  ride.type <- rt
  ride.dur <- ifelse(rt == "short", 30, 
                     ifelse(rt == "medium", 50, 
                            ifelse(rt == "long", 100, "NA")))
  ride.seq <- seq(1, ride.dur, 1)
  # get obstacle data
  get_oseq <- function(ride.seq, max.o = 10){
    o.num <- sample(max.o, 1)
    o.seq <- sample(ride.seq, o.num)
    return(o.seq)
  }
  
  # oseq
  
  stationary <- c("_______\n  =__% \n__0 0__")
  blink <- c("_______\n       \n__   __")
  fv.idle <- c(stationary, blink)
  
  drive1 <- c("     **\n `=__% \n__O o_-")
  drive2 <- c("   ** *\n`=__%  \n__o O__")
  drive3 <- c("***     \n `=__% \n_-o o__")
  drive4 <- c("       \n `=__% \n-_0 0__")
  fv.drive <- c(drive1, drive2, drive3, drive4)
  
  osym <- "#"
  otop <- paste0(rep(" ", 7), collapse = "")
  omid <- paste0(rep(" ", 7), collapse = "")
  o1 <- paste0(c(otop, omid, c("      ", osym)), collapse = "\n")
  o2 <- paste0(c(otop, omid, c("    ", osym, " ")), collapse = "\n")
  o3 <- paste0(c(otop, omid, c("     ", osym, " ")), collapse = "\n")
  o4 <- paste0(c(otop, omid, c("    ", osym, "  ")), collapse = "\n")
  fv.obstacle <- c(o1, o2, o3, o4)
  
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
  
  ride <- function(ride.seq, o.seq,
                   bcond, tdist, onum){
    # global stats
    # tdist # global mileage
    # onum # global obstacle count
    # bcond # bike condition
    require(grid)
    # add bike condition stuff
    grid.newpage()
    # baseline stats for ride
    ride.finished <- 0
    ride.status <- 1
    perc.finished <- 0
    oride <- 0
    # bcchange <- bc # bike condition
    while(ride.status > 0){
      for(c in ride.seq){
        perc.finished <- round(100*(c/length(ride.seq)), 0)
        msgperc <- paste0("ride progress: ", perc.finished, "%")
        ride.finished <- ifelse(c == max(ride.seq), 1, 0)
        if(c %in% o.seq){
          ride.obstacle(msgperc = msgperc)
          ride.status <- obstacle.uifun()
        } else{
          ride.normal(msgperc = msgperc)
        }
        if(ride.status == 0){
          # tdist updates
          tdnew <- tdist + c
          onew <- onum + oride
          msgstr <- paste0("the ride has ended!! \n",
                           "your current usr stats:\n",
                           "mileage = ", tdnew, "\n", 
                           "obstacles = ", onew, "\n",
                           "bike.cond = ", bcond, "\n")
          # update user stats
          tdist = tdnew
          onum = onew
          endride.uifun(msgstr)
          return(NULL)
        }
      }
    }
    grid.newpage()
    return(bc)
  }
  
}




do_garage()
check_ride()
do_ride()



# onstattr
# load dependancies
# load bikedata
# get uscores


# update uscoress
# do idle
# do ride select
# run ride
# loop



#=================

# game pre-load
# ascii data for bike animations
{
  stationary <- c("_______\n  =__% \n__0 0__")
  blink <- c("_______\n       \n__   __")
  fv.idle <- c(stationary, blink)
  
  drive1 <- c("     **\n `=__% \n__O o_-")
  drive2 <- c("   ** *\n`=__%  \n__o O__")
  drive3 <- c("***     \n `=__% \n_-o o__")
  drive4 <- c("       \n `=__% \n-_0 0__")
  fv.drive <- c(drive1, drive2, drive3, drive4)
  
  osym <- "#"
  otop <- paste0(rep(" ", 7), collapse = "")
  omid <- paste0(rep(" ", 7), collapse = "")
  o1 <- paste0(c(otop, omid, c("      ", osym)), collapse = "\n")
  o2 <- paste0(c(otop, omid, c("    ", osym, " ")), collapse = "\n")
  o3 <- paste0(c(otop, omid, c("     ", osym, " ")), collapse = "\n")
  o4 <- paste0(c(otop, omid, c("    ", osym, "  ")), collapse = "\n")
  fv.obstacle <- c(o1, o2, o3, o4)
  
  
  
  ascii_blink_fv_old <- function(bike = "`=__%"){
    stationary <- c("_______\n  =__% \n__0 0__")
    blink <- c("_______\n       \n__   __")
    fv <- c(stationary, blink)
    return(fv)
  }
  
  
  ascii_drive_fv_old <- function(bike = "`=__%"){
    drive1 <- c("     **\n `=__% \n__O o_-")
    drive2 <- c("   ** *\n`=__%  \n__o O__")
    drive3 <- c("***     \n `=__% \n_-o o__")
    drive4 <- c("       \n `=__% \n-_0 0__")
    fv <- c(drive1, drive2, drive3, drive4)
    return(fv)
  }
  
  
}

#--------
# appdoc
#----------
# databike

# customize bike
# edit bike data
asciibike <- function(msg = "customize your ride!", bike = "`=__%"){
  bike.ascii <- dlg_input(msg, default = bike)$res
  return(bike.ascii)
}

# name bike
# bikename <- function(msg = "name bike!", bike = "databike"){
#   bike.name <- dlg_input(msg, default = bike)$res
#   return(bike.name)
# }
# bike.name <- bikename()


# 1. load game data
# 1A. load frame data
# 1A1. bike data and "customize"
# 1A1A. prompt bike inof
asciibike <- function(msg = "customize your ride!", 
                      bike = "`=__%"){
  bike <- dlg_input(msg, default = bike)$res
  return(bike)
}
# 1B. "scene " data
# 1B1. idle
ascii_idle_fv <- function(bike = "`=__%"){
  stationary <- paste0(c("_______\n  ", bike," \n__0 0__"), collapse = "")
  blink <- "_______\n       \n__   __"
  fv <- c(stationary, blink)
  return(fv)
}
# 1B2. drive
ascii_drive_fv <- function(bike = "`=__%"){
  drive1 <- paste0("     **\n ", bike, " \n__O o_-", collapse = '')
  drive2 <- paste0("   ** *\n", bike, "  \n__o O__", collapse = '')
  drive3 <- paste0("***     \n ", bike, " \n_-o o__", collapse = '')
  drive4 <- paste0("       \n ", bike, " \n-_0 0__", collapse = '')
  fv <- c(drive1, drive2, drive3, drive4)
  return(fv)
}
# 1BC. 'obstacle'
ascii_obstacle_fv <- function(osym = "#"){
  # osym <- "#"
  otop <- paste0(rep(" ", 7), collapse = "")
  omid <- paste0(rep(" ", 7), collapse = "")
  o1 <- paste0(c(otop, omid, c("      ", osym)), collapse = "\n")
  o2 <- paste0(c(otop, omid, c("    ", osym, " ")), collapse = "\n")
  o3 <- paste0(c(otop, omid, c("     ", osym, " ")), collapse = "\n")
  o4 <- paste0(c(otop, omid, c("    ", osym, "  ")), collapse = "\n")
  fv <- c(o1, o2, o3, o4)
  return(fv)
}
# 1C. organize "scene" data
ascii_fvl <- function(drive, idle, obstacle){
  fvl <- list("idle" = idle, 
              "drive" = drive, 
              "obstacle" = obstacle)
  return(fvl)
}
fvl <- ascii_fvl(fv.drive, fv.idle, fv.obstacle)

# 2. ride duration function
get_ride.dur <- function(optl = c("short", "medium", "long")){
  # defines ride durations# 
  # optl # list ascending mileage labels
  # mileage pertains to c # of loops in ride
  ride.options <- c(optl[1], optl[2], optl[3])
  rt <- sample(ride.options) # short, medium, long
  ride.type <- rt
  ride.dur <- ifelse(rt == opt1, 30, 
                     ifelse(rt == opt2, 50, 
                            ifelse(rt == opt3, 100, "NA")))
  return(ride.dur)
}

















#!/usr/bin/env R

# 1. load game data
# 1A. load frame data
# 1A1. bike data customization
# 1A1A. prompt bike info
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
  fvl <- list("idle" = idle, "drive" = drive, 
              "obstacle" = obstacle)
  return(fvl)
}

# 2. ride duration function
get_ride.dur <- function(optl = c("short", "medium", "long")){
  # defines ride durations# 
  # optl # list ascending mileage labels
  # mileage pertains to c # of loops in ride
  rt <- sample(optl, 1) # short, medium, long
  ride.type <- rt
  ride.dur <- ifelse(rt == optl[1], 30, 
                     ifelse(rt == optl[2], 50, 
                            ifelse(rt == optl[3], 100, 
                                   "NA")))
  return(ride.dur)
}

obstacle.uifun <- function(mx.dmg.extent = 0.2){
  # variable dmg chance
  # damage extent
  # mx.dmg.extent : max possible numeric amt by which to reduce bcond
  # default 0.2
  dmg.extent <- sample(seq(mx.dmg.extent, 0.01), 1) # possible amt to reduce bcond
  dmg.message <- ifelse(dmg.extent > 0.1, "heavy", "light")
  ui.msg <- dlg_message(paste0("Cancel your ride?",
                               " If `no`, your bike could sustain ", 
                               dmg.message, " damage..."), "yesno")$res
  if(ui.msg == "no"){
    # whether damaged (50% default)
    dmg.roll <- sample(c("damaged", "undamaged"), 1)
    obstacle.outcome <- sample(dmg.roll, 1)
    if(obstacle.outcome == "damaged"){
      bcond <- bcond - dmg.extent
      ooutcome.msg <- paste0("Your bike sustained some damage.",
                             " new bike condition: ", bcond)
      dlg_message(ooutcome.msg, "ok")
      return(1) # continues ride
    }
  } else{
    return(0) # ends ride
  }
  return(NULL)
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
ride <- function(ride.seq, o.seq, bcond, tdist, onum){
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
  while(perc.finished < 100 & 
        ride.status > 0){
    for(c in ride.seq){
      perc.finished <- round(100*(c/length(ride.seq)), 0)
      msgperc <- paste0("ride progress: ", 
                        perc.finished, "%")
      ride.finished <- ifelse(c == max(ride.seq), 
                              1, 0)
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
                         "your current usr stats:\n ",
                         "mileage = ", tdnew, "\n ", 
                         "obstacles = ", onew, "\n ",
                         "bike.cond = ", bcond, "\n ")
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

# 3. do_idle function
# 3A . task
do_task <- function(bcond, rpm){
  new.bcond <- ifelse(outcome == "fix",
                      bcond + bdi*rpm,
                      bcond - bdi*rpm)
  return(new.bcond)
}

# 3B 
get_task_outcome <- function(task.prob){
  # parses maintenance and repair tasks
  v <- 100*task.prob
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
# 3C 
do_idle <- function(mprobability, rprob){
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

save.image("functions")
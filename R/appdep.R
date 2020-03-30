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
  fvl <- list("idle" = idle, 
              "drive" = drive, 
              "obstacle" = obstacle)
  return(fvl)
}

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
# 3C.
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
#!/usr/bin/env R

# Main app functions, called by org.R in app.R

#' asciibike
#'
#' Customize ride (enter character string)
#' @param msg
#' @param bike 
#' @return Bike char string
asciibike <- function(msg = "customize your ride (in 5 chars)", 
                      bike = "`=__%"){
  bike <- dlg_input(msg, default = bike)$res
  return(bike)
}

#' Idle animation data
#' 
#' Data for idle, shown on obstacle encounter.
#' @param bike Char string for bike
#' @return Bike frames (char strings)
ascii_idle_fv <- function(bike = "`=__%"){
  stationary <- paste0(c("_______\n  ", 
                         bike," \n__0 0__"), collapse = "")
  blink <- "_______\n       \n__   __"
  fv <- c(stationary, blink)
  return(fv)
}

#' ascii_drive_fv
#'
#' Char strings for drive animation, shown during normal ride mode.
#' @param bike
#' @return Frame vector (char strings) for drive
ascii_drive_fv <- function(bike = "`=__%"){
  drive1 <- paste0("     **\n ", bike, " \n__O o_-", collapse = '')
  drive2 <- paste0("   ** *\n", bike, "  \n__o O__", collapse = '')
  drive3 <- paste0("***     \n ", bike, " \n_-o o__", collapse = '')
  drive4 <- paste0("       \n ", bike, " \n-_0 0__", collapse = '')
  fv <- c(drive1, drive2, drive3, drive4)
  return(fv)
}

#' ascii_obstacle_fv
#'
#' Obstacle animation (char strings), shown during ride.
#' @param osym Obstacle symbol, randomized from ossl.
#' @return Obstacle char strings for ride encounter
ascii_obstacle_fv <- function(osym = sample(ossl, 1)){
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

# main idle functions

#' get_task_outcome
#'
#' Parse repair/maintain task.
#' @param task.prob Probability of task success (else "break")
#' @param bcond Bike condition
#' @param dmssg Message first strings
#' @return Task outcome
get_task_outcome <- function(task.prob, bcond, dmmsg = ""){
  # parses maintenance and repair tasks
  v <- 100*task.prob
  s1 = rep("fix", v)
  s2 = rep("break", 100 - v)
  outcome <- sample(c(s1, s2), 1)
  if(outcome == "fix"){
    dmssg <- paste0(dmssg, " Bike condition has increased :)")
    dmssg <- paste0(dmssg, " , new bcond = ", bcond)
  } else{
    dmssg <- paste0(dmssg, " Bike condition has decreased :(")
    dmssg <- paste0(dmssg, " , new bcond = ", bcond)
  }
  dlgMessage(dmssg, "ok")
  return(outcome)
}

#' idle_ani
#'
#' Idle animation to play on obstacle encounter during ride.
#' @param fv.idle Frame vector char strings for loop iters.
#' @param logo Game logo JPEG.
#' @param alabel Main label.
#' @param loops Total loop iters.
#' @param ssint Sleep interval for frames.
#' @return (none)
idle_ani <- function(fv.idle, logo, 
                     alabel = "idle mode", 
                     loops = 10, ssint = 0.12){
  for(l in 1:loops){
    grid.newpage()
    grid.raster(logo, width = 0.35, height = 0.25, 
                hjust = -0.2, vjust = 1.7)
    for(f in framevector){
      grid.newpage()
      
      
      Sys.sleep(ssint)
    }
  }
}

#' manages idle mode options
#'
#' Main function for idle mode. Manages repair and maintain dialogs.
#'
#' @param framevector Char string data for graphic
#' @param logo Game logo for graphic
#' @param mprob Maintenance probability (likelihood to fix vs. break)
#' @param rprob Repair probability (likelihood to fix vs. break)
#' @param bcond Bike condition
#' @param ssint Sleep interval for graphic
#' @param alabel Main label for graphic
#' @return bcond, or modified bcond if task outcome is "break"
#' @example 
#' bcond <- do_idle(framevector = fv.idle, logo = logo, mprob, rprob, bcond)
do_idle <- function(framevector, logo, mprob, 
                    rprob, bcond, ssint = 1, 
                    alabel = "mode: idle"){
  grid.newpage()
  grid.raster(logo, width = 0.35, height = 0.25, 
              hjust = -0.2, vjust = 1.7)
  framewithlabel <- paste0(c(alabel, framevector[1]), 
                           collapse = "\n")
  grid.text(framewithlabel)
  Sys.sleep(ssint)
  # add logo
  idlechoice <- 0
  while(idlechoice == 0){
    itask <- dlg_message("maintain?", 
                         "yesno")$res
    # parse maintenance task
    if(itask == "yes"){
      outcome <- get_task_outcome(mprob, bcond)
      bcond = ifelse(outcome == "fix",
                         bcond + bdi, 
                         bcond - bdi)
      break
    } else{
      itask <- dlg_message("repair?", "yesno")$res
      # parse repair task
      if(itask == "yes"){
        outcome <- get_task_outcome(rprob, bcond)
        bcond <- ifelse(outcome == "fix",
                            bcond + bdi*rpm,
                            bcond - bdi*rpm)
        idlechoice <- 1
        break
      }
      else{
        return(bcond)
      }
    }
    idlechoice <- 1
    break
  }
  return(bcond)
}

#' get_ride.dur
#' 
#' Returns ride length/duration (tdist units in ride loop).
#' @param rt
#' @param ru
#' @return Returns ride.dur, or total tdist for ride "completion".
get_ride.dur <- function(rt, ru){
  ride.dur <- ifelse(rt == optl[1], ru[1], 
                     ifelse(rt == optl[2], ru[2], 
                            ifelse(rt == optl[3], ru[3], 
                                   "NA")))
  return(ride.dur)
}

# obstacle encounter functions

#' obstacle.uifun
#'
#' Handles dialogue and ride options.
#' @param mx.dmg.extent Maximum possible damage for oencounter (default = 0.2).
#' @return If ride canceled, returns 0, else returns 1 after bcond modified
obstacle.uifun <- function(mx.dmg.extent = 0.2){
  dmg.extent <- sample(seq(mx.dmg.extent, 0.01), 1)
  dmg.message <- ifelse(dmg.extent > 0.1, 
                        "heavy", "light")
  ui.msg <- dlg_message(paste0("Cancel your ride?",
                               " If `no`, your bike could sustain ", 
                               dmg.message, " damage..."), "yesno")$res
  if(ui.msg == "no"){
    dmg.roll <- sample(c("damaged", 
                         "undamaged"), 1)
    obstacle.outcome <- sample(dmg.roll, 1)
    if(obstacle.outcome == "damaged"){
      bcond <- bcond - dmg.extent
    }
    ooutcome.msg <- paste0("Your bike sustained some damage. ",
                           "(bcond reduced by ", dmg.extent,
                           " to ", bcond, ").")
    dlg_message(ooutcome.msg, "ok")
    return(list("ridestatus" = 1, 
                "bcond" = bcond)) # continues ride
  } else if(ui.msg == "yes"){
    return(list("ridestatus" = 0)) # stops ride
  } else{
    stop("Error with obstacle encounter eval")
  }
  return()
}

#' ride.normal
#'
#' Handles normal ride mode animation.
#' @param alabel Main title.
#' @param msgperc Percent ride completed.
#' @param framevector Frames for drive mode.
#' @param ssint Sleep duration for animation frames.
#' @param loops Animation loop iterations.
#' @return NULL
ride.normal <- function(alabel = "ride mode: normal", 
                        ride.dur, mssgperc,
                        framevector = fv.drive, 
                        sleepint = 0.1, loops = 1){
  # this is code 
  # for normal ride seq animation
  # append ride dur to alabel
  alabel <- paste0(alabel, "\nride duration: ", ride.dur)
  grid.newpage()
  c = 1
  while(c <= loops){
    for(f in framevector){
      framewithlabel <- paste0(c(alabel, f, mssgperc), 
                               collapse = "\n")
      grid.newpage()
      grid.text(framewithlabel)
      Sys.sleep(sleepint)
    }
    c = c + 1
  }
  return(NULL)
}

#' ride.obstacle
#'
#' Handles ridle obstacle encounter (dialogues and animations).
#' @param alabel Main title.
#' @param msgperc Percent ride completed.
#' @param framevector1 Frame vector for idle animation.
#' @param ssint Sleep interval
#' @param loops Number of animation loops.
#' @return NULL
ride.obstacle <- function(alabel = "ride mode: obstacle",
                          msgperc, framevector1 = fv.idle, 
                          ssint = ssint, loops = 2){
  # sequences the obstacle encounter animation
  fv.obstacle <- ascii_obstacle_fv()
  grid.newpage()
  c = 1
  # grab obstacle data
  framevector1 <- rep(fv.idle, 2)
  framevector2 <- ascii_obstacle_fv()
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
  return(NULL)
}

#' Main ride function
#'
#' Handles ride sequence and assesses for o.seq or ride end.
#' @param ride.seq Ride sequence (numeric vector)
#' @param ride.dur Ride duration in tdist units
#' @param o.seq Numeric vector of obstacle encounter indices
#' @param bcond Bike condition
#' @param tdist Distance traveled/mileage
#' @param onum Total obstacles encountered
#' @return Updated usr stats
ride <- function(ride.seq, ride.dur, o.seq, 
                 bcond, tdist, onum){
  require(grid)
  # message ride duration
  rd.message <- paste0("Beginning ride of ", rt, 
                       " duration!")
  dlg_message(rd.message, "ok")
  # add bike condition stuff
  grid.newpage()
  # baseline stats for ride
  ride.finished <- 0; ride.status <- 1
  perc.finished <- 0; oride <- 0
  while(perc.finished < 100 & 
        ride.status > 0){
    for(c in ride.seq){
      # get ride progress
      tdist <- tdist + 1
      perc.finished <- round(100*(c/length(ride.seq)), 0)
      rc.mssgperc <- paste0("ride progress = ", 
                        perc.finished, "%\n",
                        "mileage = ", tdist)
      ride.finished <- ifelse(c == max(ride.seq), 1, 0)
      if(c %in% o.seq){
        ride.obstacle(mssgperc = rc.mssgperc, 
                      ride.dur = rt)
        ofun <- obstacle.uifun()
        ride.status <- ofun[[1]]
        bcond <- ofun[[2]]
      } else{
        ride.normal(msgperc = msgperc, ride.dur = rt)
      }
    }
    stop("How did we get here?", 
         "Stopped inside while loop on ride")
  }
  # update usr stats
  tdist <- tdist + c
  onum <- onum + oride
  # end-of-ride message
  messagestr <- paste0("the ride has ended!! \n",
                       "your current usr stats:\n ",
                       "mileage = ", tdist, "\n ", 
                       "obstacles = ", onew, "\n ",
                       "bike.cond = ", bcond, "\n ")
  dlg_message(messagestr, 
              type = "ok")
  grid.newpage()
  lr <- list("tdist" = tdist,
             "onum" = onum,
             "bcond" = bcond)
  return(lr)
}

#' app function
#'
#' This does main app calls for idle phase and ride phase.
#' @param fv.idle Frame vector for idle mode animation
#' @param logo Logo JPEG for idle mode display
#' @param mprob Maintenance probability success
#' @param rprob Repair probability success
#' @param bcond Bike condition
#' @param nobst Number of obstacles
#' @return su.ride, list of updated usrstats
app.fun <- function(fv.idle, logo,
                    mprob = 0.1, rprob = 0.2, 
                    bcond = 0.5, nobst = 10){
  bcond <- do_idle(fv.idle, logo, mprob, 
                   rprob, bcond)
  rt <- sample(optl, 1) # ride time
  ride.dur <- get_ride.dur(rt, ru)
  ride.seq <- seq(1, ride.dur, 1)
  n.obstacles <- sample(nobst, 1)
  o.seq <- sample(ride.seq, n.obstacles)
  su.ride <- ride(ride.seq, ride.dur,
                  o.seq, bcond, tdist, 
                  onum)
  # stop option
  so <- dlg_message("Do you want to ",
                    "stop the game?",
                    "yesno")$res
  return(list("stopoption" = so, "su.ride" = su.ride))
}

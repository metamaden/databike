#!/usr/bin/env R

require(svDialogs) # manages usr dialogues
require(grid) # prints char strings for ani

# Main ride management functions

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

#' obstacle.ui
#'
#' Handles dialogue and ride options.
#' @param mx.dmg.extent Maximum possible damage for oencounter (default = 0.2).
#' @param mindmg.extent Min damage possible (decreases with nride, experience mechanic)
#' @param rstat Ride status, current.
#' @return If ride canceled, returns 0, else returns 1 after bcond modified
obstacle.ui <- function(bcond, max.dmg.extent = 0.3,
                        mindmg.extent = 0.2, rstat = 1){
  dmg.range <- seq(mindmg.extent, max.dmg.extent, 0.01)
  dmg.extent <- sample(dmg.range, 1)
  dmg.message <- ifelse(dmg.extent > 0.1,
                        "heavy", "light")
  ui.msg <- dlg_message(paste0("Cancel your ride?",
                               " If `no`, your bike could sustain ",
                               dmg.message, " damage..."), "yesno")$res
  bcond.new <- bcond
  if(ui.msg == "no"){
    dmg.roll <- sample(c("damaged",
                         "undamaged"), 1)
    obstacle.outcome <- sample(dmg.roll, 1)
    if(obstacle.outcome == "damaged"){
      bcond.new <- bcond - dmg.extent
    }
    ooutcome.msg <- paste0("Your bike sustained some damage. ",
                           "(bcond reduced by ", dmg.extent,
                           " to ", bcond.new, ").")
    dlg_message(ooutcome.msg, "ok")
    # eval bcond, if 0, ride ends
    if(bcond.new == 0){rstat <- 0}
    return(list("ridestatus" = rstat,
                "bcond" = bcond.new)) # continues ride
  } else{
    return(list("ridestatus" = 0,
                "bcond" = bcond.new)) # stops ride
  }
  return(list("ridestatus" = rstat,
              "bcond" = bcond.new))
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
ride.ani.normal <- function(alabel = "ride mode: normal",
                            ride.dur, mssgperc,
                            framevector = fv.drive,
                            sleepint = si.ridenorm, loops = 1){
  # this is code
  # for normal ride seq animation
  # append ride dur to alabel
  alabel <- paste0(alabel, "\nride duration: ", ride.dur)
  grid.newpage()
  c = 1
  while(c <= loops){
    for(f in framevector){
      framewithlabel <- paste0(c(f, alabel, mssgperc),
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
#' @param alabel Main title and status text.
#' @param mssgperc Percent ride completed (numeric).
#' @param ride.dur Ride duration (char string).
#' @param fv.idle Frame vector for idle animation.
#' @param sleepint Sleep interval for obstacle animation.
#' @param loops Total loops for animation (repeats).
#' @return NULL
ride.enc.obstacle <- function(alabel = "ride mode: obstacle",
                              mssgperc, ride.dur, fv.idle, bcond=bcond,
                              sleepint = si.rideobst, loops = 3,
                              verbose = TRUE){
  # sequences the obstacle encounter animation
  # append ride info to alabel
  alabel <- paste0(alabel, "\nride duration: ", ride.dur)
  c = 1
  # grab obstacle data
  if(verbose){message("Getting idle frames with alabel, mssgperc")}
  fx <- paste0(fv.idle[1], "\n", alabel, "\n", mssgperc)
  fx <- c(fx, paste0(fv.idle[2], "\n", alabel, "\n", mssgperc))
  fv1.idle <- rep(fx, 2)
  fv2.obst <- ascii_obstacle_fv()
  grid.newpage()
  if(verbose){message("Printing animation frames")}
  for(c in 1:loops){
    for(i in 1:length(fv1.idle)){
      grid.newpage()
      # print ride animation
      if(verbose){"Printing idle frames"}
      fs <- fv1.idle[i]
      grid.text(fs)
      # print obstacle animation
      if(verbose){message("Printing obst frames")}
      fo <- fv2.obst[i]
      f2.obst <- paste0(c(" ", fo),
                        collapse = "\n")
      grid.text(f2.obst)
      Sys.sleep(sleepint)
    }
  }
  if(verbose){message("Returning from ride.enc.obstacle")}
  return(NULL)
}

#' Main ride function
#'
#' Handles ride sequence and assesses for o.seq or ride end.
#' @param ride.seq Ride sequence (numeric vector)
#' @param ride.dur Ride duration in tdist units
#' @param rt Ride time (category drawn from optl)
#' @param o.seq Numeric vector of obstacle encounter indices
#' @param bcond Bike condition
#' @param tdist Distance traveled/mileage
#' @param onum Total obstacles encountered
#' @param fv.idle Frame vector for idle animation (played on obst enc)
#' @return Updated usr stats
ride <- function(ride.seq, ride.dur, rt, rstat = 1,
                 o.seq, num.rides, bcond,
                 tdist, onum, fv.idle){
  # message ride duration
  rd.message <- paste0("Beginning ride of ", rt,
                       " duration!")
  dlg_message(rd.message, "ok")
  # add bike condition stuff
  grid.newpage()
  # baseline stats for ride
  ride.finished <- 0
  perc.finished <- 0
  oride <- 0
  while(perc.finished < 100 &
        rstat > 0){
    for(c in ride.seq){
      # get ride progress
      tdist <- tdist + 1
      perc.finished <- round(100*(c/length(ride.seq)),0)
      rc.mssgperc <- paste0("ride progress = ",
                            perc.finished, "%\n",
                            "mileage = ", tdist)
      if(c %in% o.seq){
        ride.enc.obstacle(mssgperc = rc.mssgperc, bcond=bcond,
                          ride.dur = rt, fv.idle = fv.idle,
                          verbose = TRUE)
        ostat <- obstacle.ui(bcond = bcond,
                             rstat = rstat)
        bcond <- ostat[["bcond"]] # eval bcond
        # eval ride.status, quits ride if bcond = 0
        rstat <- ostat[["ridestatus"]]
      } else{
        ride.ani.normal(mssgperc = rc.mssgperc,
                        ride.dur = rt)
      }
      ride.status <- ifelse(c == max(ride.seq), 0, 1)
    }
    #stop("How did we get here?",
    #     "Stopped inside while loop on ride")
  }
  # update mileage
  #tdist <- tdist + c
  onum <- onum + oride
  # end-of-ride message
  messagestr <- paste0("the ride has ended!! \n",
                       "your current usr stats:\n ",
                       "mileage = ", tdist, "\n ",
                       "obstacles = ", onum, "\n ",
                       "bike.cond = ", bcond, "\n ")
  dlg_message(messagestr, type = "ok")
  grid.newpage()
  lr <- list("tdist" = tdist,
             "onum" = onum,
             "bcond" = bcond)
  return(lr)
}

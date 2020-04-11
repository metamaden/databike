#!/usr/bin/env R

require(svDialogs) # manages usr dialogues
require(grid) # prints char strings for ani

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
  drive4 <- paste0("*      \n ", bike, " \n-_0 0__", collapse = '')
  fv <- c(drive1, drive2, drive3, drive4)
  return(fv)
}

#' ossl
#'
#' Code for obstacle symbol. Makes random obstacle symbol of 4 chars.
#' @param symlist Symbols list to draw from.
ossl <- function(symlist = c("@","#","$",
                             "^","&","*")){
  return(paste(sample(symlist, 4), collapse = ""))
}

#' ascii_obstacle_fv
#'
#' Obstacle animation (char strings), shown during ride.
#' @param symlist Symbols list for obstacle draw.
#' @param osym Obstacle symbol, randomized from ossl (NULL)
#' @param boffset Bottom lines offset (num. bottom labels - 1)
#' @return Obstacle char strings for ride encounter
ascii_obstacle_fv <- function(symlist = c("@","#","$",
                                          "^","&","*"),
                              osym = NULL){
  if(is.null(osym)){osym <- ossl(symlist)}
  otop <- omid <- "\n"
  # xaxis movement
  sline1 <- paste0(c(rep(" ", 5), osym, rep(" ", 0)), collapse = "")
  sline2 <- paste0(c(rep(" ", 4), osym, rep(" ", 1)), collapse = "")
  sline3 <- paste0(c(rep(" ", 2), osym, rep(" ", 3)), collapse = "")
  sline4 <- paste0(c(rep(" ", 1), osym, rep(" ", 4)), collapse = "")
  # yaxis movement
  #ymint <- 1; ymrate <- 0.2; nframes <- 4; nbufftot <- 10
  f1 <- paste0(c(rep("\n", 6), sline1, rep("\n", 1)), collapse = "")
  f2 <- paste0(c(rep("\n", 4), sline2, rep("\n", 3)), collapse = "")
  f3 <- paste0(c(rep("\n", 3), sline3, rep("\n", 4)), collapse = "")
  f4 <- paste0(c(rep("\n", 2), sline4, rep("\n", 5)), collapse = "")
  return(c(f1, f2, f3, f4))
}

# main idle functions

#' get_task_outcome
#'
#' Parse repair/maintain task.
#' @param task.prob Probability of task success (else "break")
#' @param bcond Bike condition
#' @param dmssg Message first strings
#' @param binc Increment of bcond change
#' @return Task outcome
get_task_outcome <- function(task.prob, bcond, dmssg = "",
                             binc = 0.1){
  # parses maintenance and repair tasks
  v <- 100*task.prob
  s1 = rep("fix", v)
  s2 = rep("break", 100 - v)
  outcome <- sample(c(s1, s2), 1)
  # update bcond
  if(outcome == "fix"){
    bcond.new <- bcond + binc
    dmssg <- paste0(dmssg, " Bike condition has increased :)")
    dmssg <- paste0(dmssg, " , old bcond = ", bcond)
    dmssg <- paste0(dmssg, ", new bcond = ", bcond.new)
  } else{
    bcond.new <- bcond - binc
    dmssg <- paste0(dmssg, " Bike condition has decreased :(")
    dmssg <- paste0(dmssg, " , old bcond = ", bcond)
    dmssg <- paste0(dmssg, ", new bcond = ", bcond.new)
  }
  dlgMessage(dmssg, "ok")
  return(bcond.new)
}

#' idle_ani
#'
#' Idle animation to play on obstacle encounter during ride.
#' @param fv.idle Frame vector char strings for loop iters.
#' @param logo Game logo JPEG.
#' @param alabel Main label.
#' @param nloop Total loop iters.
#' @param ssint Sleep interval for frames.
#' @return NULL
idle_ani <- function(fv.idle, logo,
                     alabel = "\nidle mode",
                     nloop = 5, sleepint = si.idle){
  # frame for print
  pf2 <- fv.idle[1]
  pf1 <- paste0(c(pf2, alabel),
                collapse = "")
  # do "blink"
  for(l in 1:nloop){
    grid.newpage()
    grid.text(pf1, gp = gpar(col = "black"))
    grid.raster(logo, width = 0.35, height = 0.25,
                hjust = -0.2, vjust = 1.7)
    Sys.sleep(sleepint)
  }
  #for(l in 1:loops){
  #  grid.text(pf1, gp = gpar(col = "black"))
  #  Sys.sleep(sleepint)
  #  grid.text(pf2, gp = gpar(col = "white"))
  #  Sys.sleep(sleepint)
  #}
  #grid.text(pf1, gp = gpar(col = "black"))
  return(NULL)
}

#' manages idle mode options
#'
#' Main function for idle mode. Manages repair and maintain dialogs.
#'
#' @param fv.idle Idle animation char string data.
#' @param logo Game logo for graphic
#' @param mprob Maintenance probability (likelihood to fix vs. break)
#' @param rprob Repair probability (likelihood to fix vs. break)
#' @param bcond Bike condition
#' @param sleepint Sleep interval for stationary graphic
#' @param alabel Main label for graphic
#' @return bcond, or modified bcond if task outcome is "break"
#' @example
#' bcond <- do_idle(framevector = fv.idle, logo = logo, mprob, rprob, bcond)
do_idle <- function(fv.idle, logo, mprob, rprob,
                    sleepint = si.stationary,
                    bcond, alabel = "mode: idle"){
  # displays idle animation "intro"
  # freezes on bike stationary, with logo
  idle_ani(fv.idle, logo)
  Sys.sleep(sleepint) # allows stationary graphic to load
  # handle main idle options
  idlechoice <- 0
  while(idlechoice == 0){
    itask <- dlg_message("maintain?",
                         "yesno")$res
    # parse maintenance task
    if(itask == "yes"){
      bcond <- get_task_outcome(mprob, bcond)
      break
    } else{
      itask <- dlg_message("repair?", "yesno")$res
      # parse repair task
      if(itask == "yes"){
        bcond <- get_task_outcome(rprob, bcond)
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

#' app function
#'
#' This does main app calls for idle phase and ride phase.
#' @param fv.idle Frame vector for idle mode animation
#' @param logo Logo JPEG for idle mode display
#' @param minobst function of rider "experience" (nrides), decreases as nrides increase.
#' @param mprob Maintenance probability success
#' @param rprob Repair probability success
#' @param bcond Bike condition
#' @param onum Number of obstacles encountered on rides
#' @param tdist Distance bike has traveled
#' @param maxobst Number of obstacles (static at 10)
#' @param verbose Whether to print verbose status messages.
#' @return su.ride, list of updated usrstats
app.fun <- function(fv.idle, logo, minobst,
                    mprob = NULL, rprob = NULL,
                    bcond = NULL, onum = 0,
                    tdist = 0, maxobst = 10,
                    nride = 0, verbose = TRUE){
  # main app management
  if(verbose){message("Starting app.fun")}
  # parse difficulty, get starting metrics
  if(verbose){message("Evaluating difficulty")}
  if(nride == 0){
    dopt <- get_difficulty()
    lstart <- parse_difficulty(usr.start = lstart, dopt = dopt)
    bcond <- lstart[["bcond"]]
    mprob <- lstart[["mprob"]]
    rprob <- lstart[["rprob"]]
  }
  # show stats
  dlg_message(paste0("Current bike stats: ",
                     "bcond = ", bcond,
                     ", mrpob = ", mprob,
                     ", rprob = ", rprob), "ok")
  if(verbose){message("Doing idle phase")}
  bcond <- do_idle(fv.idle, logo, mprob, rprob,
                   sleepint = si.stationary,
                   bcond, alabel = "mode: idle")
  # stop option
  if(verbose){message("Doing cancel option")}
  so <- dlg_message(paste0("Do you want to ",
                           "stop the game?"),
                    "yesno")$res
  if(so == "no"){
    if(verbose){message("Doing ride sequence")}
    rt <- sample(optl, 1) # ride time
    ride.dur <- get_ride.dur(rt, ru)
    ride.seq <- seq(1, ride.dur)
    # eval obstacles for ride
    obstq.range <- seq(minobst, maxobst)
    obstq.ridenum <- sample(obstq.range, 1)
    o.seq <- sample(ride.seq, obstq.ridenum)
    if(verbose){message("Running main ride sequence")}
    su.ride <- ride(ride.seq=ride.seq, ride.dur=ride.dur, rt=rt,
                    o.seq=o.seq, bcond=bcond, tdist=tdist, onum=onum,
                    fv.idle=fv.idle)
    return(list("stopoption" = so, "su.ride" = su.ride))
  } else{
    return(list("stopoption" = so))
  }
  stop("How did we get here? ",
       "Processed finished outside of ifelse")
}

#-----------------------
# new functions, to test
#-----------------------

#' save option
#'
#' Handles save option
#' @param rname Ride name (corresponds to save file)
#' @param overwrite Whether to overwrite existing save file
#' @return Stuff
save_ride <- function(rname, overwrite){
}

#---------------------------
# handle difficulty settings
#---------------------------

#' dopt
#'
#' @param dmssg Dialogue message
#' @param opts Difficulty options
#' @return dopt, difficulty options dialogue
dopt <- function(dmssg = "Enter a game difficulty: ", opts){
  uimsg <- paste0(dmssg, paste(opts, collapse = ", "))
  dopt <- dlg_input(uimsg, default = "normal")$res
  return(dopt)
}

#' copt
#'
#' @param cmssg Message for cancel game dialogue
#' @return cancelopt, dialogue with option to cancel game
copt <- function(cmssg = "Please enter a valid option, or click `cancel` to quit"){
  cancelopt <- dlg_message(cmssg)$res
  return(cancelopt)
}

#' get_difficulty()
#'
#' Difficulty options
#' @param opts Difficulty options to be entered/parsed
#' @param dopt Difficulty option selected
#' @param cancelopt Option to cancel
#' @return dopt difficulty option, or NULL
get_difficulty <- function(opts = c("easy", "normal", "difficult"),
                           dopt = "", cancelopt = FALSE){
  while(!dopt %in% opts){
    dopt <- dopt(opts = opts)
    if(dopt %in% opts){break}
    copt <- copt()
    if(copt == "cancel"){break}
  }
  if(dopt %in% opts){
    return(dopt)
  } else{return(NULL)}
}

#' parse_difficulty
#'
#' Parse difficulty (if not "normal")
#' @param usr.start Starting user stats
#' @param dopt Difficulty option
#' @param mod.scale Scale modifier (for 'easy' and 'difficult')
#' @return User starting stats
parse_difficulty <- function(usr.start, dopt, mod.scale = 0.25){
  if(dopt == "easy"){
    usr.start <- lapply(usr.start, function(x){x + (x*0.25)})
    return(usr.start)
  }
  if(dopt == "difficult"){
    usr.start <- lapply(usr.start, function(x){x - (x*0.25)})
    return(usr.start)
  }
  return(usr.start)
}

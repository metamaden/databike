#!/usr/bin/env R

require(svDialogs) # manages usr dialogues
require(grid) # prints char strings for ani

# Main app functions, called by org.R in app.R

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

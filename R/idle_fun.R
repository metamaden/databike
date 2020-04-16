#!/usr/bin/env R

require(svDialogs) # manages usr dialogues
require(grid) # prints char strings for ani

# Main idle functions

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
      bcond <- get_task_outcome(task.prob = mprob, bcond)
      break
    } else{
      itask <- dlg_message("repair?", "yesno")$res
      # parse repair task
      if(itask == "yes"){
        bcond <- get_task_outcome(task.prob = rprob, bcond)
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
#!/usr/bin/env R

require(grid) # prints char strings for ani

# Animation frames and print functions

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


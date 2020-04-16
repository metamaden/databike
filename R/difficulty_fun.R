#!/usr/bin/env R

require(svDialogs) # manages usr dialogues
require(grid) # prints char strings for ani

# Handle difficulty settings

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

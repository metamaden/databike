#!/usr/bin/env R

# Save and load bike data

getbikename <- function(msg = "name your ride",
                      bike = "databike"){
  bikename <- dlg_input(msg, default = bike)$res
  return(bikename)
}

sopt <- function(mstr = "Save your progress?"){
  return(dlg_message(mstr, "yesno")$res)
}

sdat <- function(fn, dn = "inst/extdata", 
                 dpath = paste0(dn, "/", fn)){
  save.image(dpath)
}


smanage <- function(bikename){
  svar <- sopt()
  if(svar == "yes"){
    message("saving data for ", bikename)
    sdat(bikename)
  } else{
    message("continuing without saving data for ", 
            bikename)
  }
  return(NULL)
}


itask <- dlg_message("maintain?",
                     "yesno")$res
# parse maintenance task
if(itask == "yes"){
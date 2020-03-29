#!/usr/bin/env R

require(grid)

# Graphics for scootsim

# scene labels
labtag <- "mode: "
lab.idle <- "idle"
lab.maintenance <- "maintenance"
lab.inspect <- "inspect"
lab.drive <- "driving"

# 

# obstacle data
otop <- paste0(rep(" ", 7), collapse = "")
omid <- paste0(rep(" ", 7), collapse = "")
o1 <- paste0(c(otop, omid, "      #"), collapse = "\n")
o2 <- paste0(c(otop, omid, "    #  "), collapse = "\n")
o3 <- paste0(c(otop, omid, "  ,    "), collapse = "\n")
o4 <- paste0(c(otop, omid, ",      "), collapse = "\n")

fv <- c(o1, o2, o3, o4)

for(i in seq(1, 10, 1)){
  for(f in fv){
    grid.newpage()
    grid.text(f)
    Sys.sleep(0.2)
  }
}

sleepint <- 0.1

#--------
# bike ani data
#--------
stationary <- c("_______\n  =__% \n__0 0__")
blink <- c("_______\n       \n__   __")
fv.idle <- c(stationary, blink)

drive1 <- c("     **\n `=__% \n__O o_-")
drive2 <- c("   ** *\n`=__%  \n__o O__")
drive3 <- c("***     \n `=__% \n_-o o__")
drive4 <- c("       \n `=__% \n-_0 0__")
fv.drive <- c(drive1, drive2, drive3, drive4)

#----------
# scenes data
#---------
fv <- c(drive1, drive2, drive3, drive4)
s.drive <- scene(fv)

fv <- c(stationary, blink)
s.idle <- scene(fv)

sl.idle <- scene.withlabel(lab.idle, fv.idle, loops = 10)

sl.drive <- scene.withlabel(lab.drive, fv.drive, loops = 10)

#-------
# scene function
#-------
scene.withlabel <- function(scenelabel, framevector, 
                  ssint = 0.1, loops = 100){
  grid.newpage()
  c = 1
  while(c < loops){
    for(f in fv){
      framewithlabel <- paste0(c(scenelabel,
                                 f), collapse = "\n")
      grid.newpage()
      grid.text(framewithlabel)
      Sys.sleep(sleepint)
    }
    c = c + 1
  }
}
  
#---------
# old misc
#---------
scene <- function(fv, sleepint = 0.1, 
                  cycles = 100){
  grid.newpage()
  c = 1
  while(c < cycles){
    for(f in fv){
      grid.newpage()
      grid.text(f)
      Sys.sleep(sleepint)
    }
    c = c + 1
  }
}
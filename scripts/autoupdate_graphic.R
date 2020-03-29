#!/usr/bin/env R

# =__%
# O O


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

#-------
# scene function
#--------
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

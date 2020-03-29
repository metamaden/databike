#!/usr/bin/env R

# =__%
# O O


# obstacles
# grid.text() overlay frames
# use sample to assess obstacle presence
get_omod <- function(set.omod = 2){
  if(is.null(set.omomd)){
    # assess things and get modified omod
  }
  return(omod)
}
o.mod <- get_omod(2)
o.chance <- sample(c(1, o.mod), 1)


# obstacle data
otop <- paste0(rep(" ", 7), collapse = "")
omid <- paste0(rep(" ", 7), collapse = "")
o1 <- paste0(c(otop, omid, "      #"), collapse = "\n")
o2 <- paste0(c(otop, omid, "    #  "), collapse = "\n")
o3 <- paste0(c(otop, omid, "  ,    "), collapse = "\n")
o4 <- paste0(c(otop, omid, ",      "), collapse = "\n")

fv <- c(o1, o2, o3, o4)

for(i in seq(1,10,1)){
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

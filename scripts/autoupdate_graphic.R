#!/usr/bin/env R

# =__%
# O O

# notes

space.char <- "_"

# frame dims: 10 cols, 3 rows
blank <- c(rep(space.char, 10),
           rep(space.char, 10),
           rep(space.char, 10))

# make viewport

vp <- function(){
  plot.new()
  legend("center", 
         legend = c(blank[1], blank[2], blank[3]))
}


# scooter moving

frame <- function(l1, l2, l3){
  legend("center", legend = c(l1, l2, l3))
}

vp()

frame(f1.l1, f1.l2, f1.l3)

# frames and lines
f1.l1 <- rep(" ", 10)
f1.l2 <- paste0(" ", "=__%", rep(" ", 5))
f1.l3 <- paste0(" ", "0 0", rep(" ", 6))



bikemove <- function(frame1, frame2){
  legend("center",legend = frame1)
}

# scooter stationary
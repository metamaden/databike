#!/usr/bin/env R

# =__%
# O O

grid.newpage()

sky1 <- paste0(c(rep(" ", 7), "-"))
sky2 <- paste0(c(rep(" ", 4), "-", rep(" ", )))
sky3 <- c(rep(" ", 7), "-")

exhaust1 <- "-~"
exhaust2 <- "~-"
bikespace <- "  "
bike1 <- paste0(exhaust1, "=__%", bikespace)
bike2 <- paste0(exhaust2, "=__%", bikespace)


wheels <- "__00_"
frame1 <- paste0(c(bike, 
                   wheels), 
                 collapse = "\n")

grid.text(frame1, 
          x = 0.5, y = 0.5,
          gp = gpar(fontsize = 20, 
                    col = "black")
          )


# notes

blank.sym <- "_"
f1.l1 <- rep(blank.sym, 10)
f1.l2 <- c(blank.sym, "=__%", 
           rep(blank.sym, 5))
f1.l3 <- c(blank.sym, "0 0", 
           rep(blank.sym, 6))
grid.newpage()

vv <- "____"
txtv <- paste(c(f1.l1, f1.l2, f1.l3), 
              sep = "\n")
grid.text(txtv, x = 0.5, y = 0.5,
          gp = gpar(fontsize = 20, 
                    col = "black"))


# frame dims: 10 cols, 3 rows

# make viewport
vp <- function(){
  plot.new()
  legend("center", 
         legend = c(blank.sym[1], 
                    blank.sym[2], 
                    blank.sym[3]),
         text.width = 10)
}

#----------------
# scooter moving
#----------------
# frame1 
f1.l1 <- rep(blank.sym, 10)
f1.l2 <- paste0(blank.sym, "=__%", rep(blank.sym, 5))
f1.l3 <- paste0(blank.sym, "0 0", rep(blank.sym, 6))

frame <- function(f1.l1, f1.l2, f1.l3){
  # prints a single frame
  # l1 = first line
  plot.new()
  legend("center", 
         legend = c(f1.l1, f1.l2, 
                    f1.l3),
         text.width = 10)
}

vp()
frame(f1.l1, f1.l2, f1.l3)

bikemove <- function(frame1, frame2){
  legend("center", legend = frame1)
}

# scooter stationary
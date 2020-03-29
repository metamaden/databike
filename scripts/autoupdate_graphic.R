#!/usr/bin/env R

# =__%
# O O


sleepint <- 0.1

#----------------
# frame with vars
#----------------
sym.blank <- "_"
# len.line = 10
# len.bike = 3
# len.wheels = 2
cloud = "-"
bike = " *=__%_"


{
  i = 1
  while(i < 100){
    grid.newpage()
    l1 <- paste0(c(rep(sym.blank, 6), cloud), collapse = "")
    l2 <- paste0(c(bike), collapse = "")
    
    f1 <- paste0(c(l1, l2), collapse = "\n")
    
    grid.text("______-\n *=__%_\n__O o__")
    Sys.sleep(sleepint)
    
    grid.newpage()
    grid.text("___-___\n*.=__%_\n__o O__")
    Sys.sleep(sleepint)
    
    grid.newpage()
    grid.text("-______\n. =__%_\n__o o__")
    Sys.sleep(sleepint)
    
    grid.newpage()
    grid.text("_______\n  =__%_\n__0 0__")
    Sys.sleep(sleepint)
    
    i = i + 1
  }
}


#---------------
# frame novars
#---------------
while(i < 100){
  grid.newpage()
  grid.text("______-\n *=__%_\n__O o__")
  Sys.sleep(sleepint)
  
  grid.newpage()
  grid.text("___-___\n*.=__%_\n__o O__")
  Sys.sleep(sleepint)
  
  grid.newpage()
  grid.text("-______\n. =__%_\n__o o__")
  Sys.sleep(sleepint)
  
  grid.newpage()
  grid.text("_______\n  =__%_\n__0 0__")
  Sys.sleep(sleepint)
  
  i = i + 1
}



sleepint <- 0.1
i = 1
while(i < 100){
  grid.newpage()
  grid.text("______-\n *=__%_\n__O o__")
  Sys.sleep(sleepint)
  
  grid.newpage()
  grid.text("___-___\n*.=__%_\n__o O__")
  Sys.sleep(sleepint)
  
  grid.newpage()
  grid.text("-______\n. =__%_\n__o o__")
  Sys.sleep(sleepint)
  
  grid.newpage()
  grid.text("_______\n  =__%_\n__0 0__")
  Sys.sleep(sleepint)
  
  i = i + 1
}


# skyline animation
sky1 <- c(rep(sym.blank, 
              len.line - 1), 
          cloud)
sky2 <- c(rep(sym.blank, 
              len.line - 4),
          cloud, 
          rep(sym.blank, 3))
sky3 <- c(cloud, 
          rep(sym.blank,
              len.line - 1))
f1 <- sky1; f2 <- sky2; f3 <- sky3
fl <- list(f1, f2, f3)

for(i in seq(1, 100, 1)){
  for(f in fl){
    grid.newpage()
    fp <- paste0(f)
    grid.text(fp, x = 0.5, y = 0.5,
              gp = gpar(fontsize = 20, 
                        col = "black"))
    Sys.sleep(0.1)
  }
}


sleepint <- 0.1
fl = list(f1 = "_____-",
          f2 = "~=_%__",
          f3 = "__oo__")

f1 = "_____-"
f2 = "~=_%__"
f3 = "__oo__"
fr <- paste(c(f1, f2, f3), 
            collapse = "\n")
fl <- list(fr)

for(i in seq(1, 100, 1)){
  for(f in fl){
    grid.newpage()
    grid.text(f)
    Sys.sleep(sleepint)
  }
}









grid.newpage()
grid.text("___\n___")

sky2 <- paste0(c(rep(" ", 3), "-", rep(" ", 4)))
sky3 <- paste0(c("-", rep(" ", 7)))

exhaust2 <- "*-"
bikespace <- rep(" ", )
bike2 <- paste0(exhaust2, "=---%o", bikespace)
wheels2 <- "__oo_"

# frame 1
sky1 <- paste0(c(rep(" ", 7), "-"))
exhaust1 <- "-*"
bike1 <- c(exhaust1, "=___%o", 
           rep(bikespace, 10))
wheels1 <- "__00_"
fe1 <- c(sky1, bike1, wheels1)
f1 <- paste0(fe1, collapse = "\n")

# frame 2




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
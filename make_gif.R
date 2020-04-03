#!/usr/bin/env R

require(magick)

# make gif from text animations

fp.org <- "./org.R"
source(fp.org)


fv.ride <- ascii_drive_fv()
jfile.vector <- c()

for(i in 1:length(fv.ride())){
  f <- fv.ride[i]
  jn <- paste0("ride",i,".jpg")
  jfile.vector <- c(jfile.vector, jn)
  jpeg(jn, 5, 5, units = "in")
  grid.newpage()
  grid.text(f)
  dev.off()
}

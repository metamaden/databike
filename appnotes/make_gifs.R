#!/usr/bin/env R

# Make gifs from static images
# links
# https://cran.r-project.org/web/packages/magick/vignettes/intro.html

library(magick)
library(gifski)

#---------
# logo gif
#---------

gifname <- "logo.gif"; dn <- "imgs"
img.path <- "./imgs/logo.jpg"
fps = 1.2

logo1 <- image_scale(image_read(img.path))
logo2 <- image_negate(logo1)
img <- c(logo1, logo2)
# static frames
#img.gif <- image_animate(image_scale(img, "500x500"), fps = 0.5, dispose = "previous")
#image_write_gif(img.gif, path = paste0(dn, "/", gifname), delay = 1)
# with morph
image_resize(c(logo1, logo2, logo1), '500x500') %>%
  image_morph() %>%
  image_animate(optimize = TRUE, fps = 2) %>%
  image_write_gif(path = paste0(dn, "/", gifname), delay = 1)

#---------------------
# bike normal ride gif
#---------------------
# main drive data (touse: databike::ascii_drive_fv())

gif.delay = 1/3
gifname <- "drive.gif"
ascii_drive_fv <- function(bike = "`=__%"){
  drive1 <- paste0("     **\n ", bike, " \n__O o_-", collapse = '')
  drive2 <- paste0("   ** *\n", bike, "  \n__o O__", collapse = '')
  drive3 <- paste0("***     \n ", bike, " \n_-o o__", collapse = '')
  drive4 <- paste0("*       \n ", bike, " \n-_0 0__", collapse = '')
  fv <- c(drive1, drive2, drive3, drive4)
  return(fv)
}
fv <- ascii_drive_fv()
fpv <- c()
for(i in 1:length(fv)){
  fpi <- paste0("imgs/drive",i,".jpg")
  jpeg(fpi, 5, 5, units = "in", res = 500)
  grid.newpage(); grid.text(fv[i])
  dev.off()
  fpv <- c(fpv, fpi)
}

img1 <- image_trim(image_scale(image_read(fpv[1])))
img2 <- image_trim(image_scale(image_read(fpv[2])))
img3 <- image_trim(image_scale(image_read(fpv[3])))
img4 <- image_trim(image_scale(image_read(fpv[4])))
# trimmed gif
image_animate(c(img1, img2, img3, img4), fps = 2) %>%
  image_write_gif(path = paste0(dn, "/", gifname), delay = gif.delay)


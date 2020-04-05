#!/usr/bin/env R

# Make gifs from static images
# links
# https://cran.r-project.org/web/packages/magick/vignettes/intro.html

library(magick)
library(gifski)


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



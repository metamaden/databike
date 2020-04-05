#!/usr/bin/env R

# Developer code gists for app improvements

# Notes
# aesthetic stuff
# . draw background with grobs (lib grid)
# . do image effects (lib magick)
# . do some cool animations for transitions (lib magick)

# animation improvements
# . print animation slides as JPEG frames
# . manage JPEG frame loads with magick

# helpful links for graphics modifications
# https://www.rdocumentation.org/packages/multipanelfigure/versions/2.0.2
# https://cran.r-project.org/web/packages/magick/vignettes/intro.html
# https://stackoverflow.com/questions/48922873/how-to-change-color-to-a-textgrob-item

#-------
# magick
#-------
# image_annotate(img.logo, f, location = "+200+100")
# image_annotate(img.logo, f, location = "center")

#img.frame <- image_read(grid.text(f))
#image_resize(grid.raster(logo), "200x300")
#image_append(grid.text(f), 
#             grid.raster(logo, width = 0.35, 
#                         height = 0.25, hjust = -0.2, 
#                         vjust = 1.7))

#--------------
# grid and grob
#--------------
#grid.newpage()
#gtf <- grid.text(f)
#gtl <- grid.raster(logo, width = 0.35, height = 0.25, 
#                   hjust = -0.2, vjust = 1.7)
#grid.draw(grid.text(f), grid.raster(logo, width = 0.35, height = 0.25, 
#                                    hjust = -0.2, vjust = 1.7))
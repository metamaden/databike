library(grid)

# https://stackoverflow.com/questions/20281140/grid-text-and-positioning-in-viewports



grid.newpage()

pushViewport(viewport(layout = grid.layout(1,2)))

plot1 <- qplot(rnorm(100))

print(plot1, 
      vp = vplayout(1,1))

grid.text('plot1',
          x = .5, y = .95,
          vp = viewport(layout.pos.row = 1,
                        layout.pos.col = 1)
          )




grid.newpage()

vv <- "____"
txtv <- paste(c(vv, vv, vv), collapse = "\n")

grid.text(txtv, 
          x = 0.5, y = 0.5,
          gp = gpar(fontsize = 20, 
                    col = "black"))






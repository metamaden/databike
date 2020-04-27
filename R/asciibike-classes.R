#!/usr/bin/env R

# defining classes

# Set S4 classes
getcomponent <- setClass("component", 
                      slots = list(brand = "character", cond = "numeric",
                                   nrides = "numeric"))

makevehicle <- setClass("vehicle", 
                        slots = list(wheels = "component", body = "component",
                                     engine = "component", name = "character", 
                                     asciibike = "character"))

# get new entities
newbike <- makevehicle(wheels = getcomponent(brand = "", cond = 0, nrides = 0), 
                       body = getcomponent(brand = "", cond = 0, nrides = 0),
                       engine = getcomponent(brand = "", cond = 0, nrides = 0),
                       name = "", asciibike = "")



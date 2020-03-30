#--------------------
# New features queue
#--------------------

# random bonus
{
  # 1. inc. bike condition
  # 2. improve repair
  # 3. improve maintain
  bprob <- 0.5
  100 * bprob
  bonustype <- sample(c(), 1)
}


# prep ride data
{
  rt <- "short" # short, medium, long
  ride.type <- rt
  ride.dur <- ifelse(rt == "short", 30, 
                     ifelse(rt == "medium", 50, 
                            ifelse(rt == "long", 100, "NA")))
  ride.seq <- seq(1, ride.dur, 1)
}
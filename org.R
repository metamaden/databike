# app organizeation 

# info for organizing dtaa

# dirs and paths
rdata.dir <- "."

# data dir
# contains functions and data scripts
dn <- "."

fn.fun <- "functions"
fn.data <- "data"

fp.fun <- paste0(c(dn, paste0(fn.fun, ".R")), collapse = "/")
fp.data <- paste0(c(dn, paste0(fn.data, ".R")), collapse = "/")

# load data scripts (use source())

source(fp.fun)
source(fp.data)
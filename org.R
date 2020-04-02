#!/usr/bin/env R

# app organizeation 

# info for organizing dtaa
# dirs and paths
rdata.dir <- "."

# data dir
# contains functions and data scripts
dn <- "data"
fn.fun <- "functions"
fn.params <- "params"
fp.fun <- paste0(c(dn, paste0(fn.fun, ".R")), collapse = "/")
fn.params <- paste0(c(dn, paste0(fn.params, ".R")), collapse = "/")
# load data scripts (use source())
source(fp.fun)
source(fn.params)
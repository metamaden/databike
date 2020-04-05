---
layout: post
title:`databike`: coding an app about scooter upkeep, in R
categories:[simulation; app; game; reproducible_code]
tags:[R; Rstats; grid; jpeg; svDialogs; ascii]
---

# Overview

Here, I describe the process of designing `databike`, an interactive application about scooter upkeep. The app code is available at the [databike repository](https://raw.githubusercontent.com/metamaden/databike/). For myself, this was quite the novel undertaking. I will periodically share significant lessons learned as the app continues to develop.

<img src="https://raw.githubusercontent.com/metamaden/databike/vignettes/imgs/logo.jpg" align = "center" alt="drawing" width="1800"/>
**Figure 1.** <`databike` logo>

# App design

## Goals

There were several goals for the initial app. 

The goal was to create a command line-runnable application the includes user interactivity and some form of a hook  or "gameplay loop." These goals should be met while adhering to principles of reproducible application development.

## Workflow

Relatively "late" into development, I started to diagram how the overall app manages functions and data, and how individual functions run. In retrospect, this is an important early step in the design process.

<img src="https://raw.githubusercontent.com/metamaden/databike/vignettes/imgs/app_flowchart.jpg" align = "center" alt="drawing" width="1800"/>
**Figure 2.** <App flowchart>

Even if an early workflow diagram doesn't accurately reflect the ultimate product, reviewing such a diagram provides a vital opportunity to pause and reflect on the bigger picture and individual steps to take next.

I started with a vague notion of how the app would run, and I initially completed the ascii data for "animations" or image frames .

## Takeaways
Takeways from this section include: 
* bulleted list
  + keep a log for goals, ideas, bugs, etc. and meticulously organize this. It can be helpful to simply have this in a text file or physical journal.
  + draw workflow diagrams and review these frequently.
  + take breaks often

# R code

## The functions.R script

```
# generic code chunk
```

## The data.R script

```
# generic code chunk
```

## Repository and package outline

# Conclusions
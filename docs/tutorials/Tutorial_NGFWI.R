#### Next Generation Fire Weather Index System (FWI2025) Getting Started ####
# February 2025
#
# This script was designed to go with the Getting Started Tutorial to inform
# users how to use scripts associated with FWI2025. Follow along
# with the 'Getting Started Tutorial' documentation on the CFFDRS2025 webpages:
# https://cffdrs.github.io/website_en/tutorials
# This tutorial will demonstrate how to generate FWI2025 outputs based on an
# input from a .csv. The method will differ if using another source file type or
# if integrating code into existing fire management systems. This tutorial
# assumes the user has working level knowledge of R.
##############################################################################

### Load libraries - ensure you have the necessary libraries installed ###
# Run install.packages() to install any you are missing
library(lubridate)
library(data.table)
library(lutz)

### Load FWI2025 functions ###
# NG_FWI.r and util.r files contain the functions necessary to calculate FWI2025.
# For the source() function to work, the working directory must match the
# file location where these two files are stored.

# Check your current working directory
getwd()
# If the working directory is different from where you saved NG_FWI.r and util.r,
# change the working directory to the folder containing these files.
setwd('\\')

# Load the source files containing the variables and functions to calculate FWI2025.
source("NG_FWI.r")
source("util.r")

### Load the input weather station file ###
# Specify the file path if wx_prf.csv is not in working directory
data <- read.csv('wx_prf.csv')

# Print the column names, data should contain 11 columns:
# id, lat, long, yr, mon, day, hr, temp, rh, ws, prec
names(data)

### Find the timezone and UTC offset ###
# Date and Time are important to calculate the time of sunrise and sunset.
# The UTC timezone offset is a required input for the FWI2025 function.
# The 'lutz' library has functions to get the timezone of the weather station,
# based on Latitude and Longitude

# Make a dataframe with unique ID, Latitude and Longitude
stations <- cbind(data$id, data$lat, data$long)
colnames(stations) <- c("id", "lat", "long")
stations <- as.data.frame(stations)
stations <- unique(stations)
stations$lat <- as.numeric(stations$lat)
stations$long <- as.numeric(stations$long)
# Print the unique station IDs and locations. For this tutorial, one station "PRF".
stations

# Find the location based on Latitude and Longitude, this can take some time.
# (might need to download the package 'sf' for method = "accurate")
tz_loc <- tz_lookup_coords(stations$lat, stations$long, method = "accurate")
# Print timezone location, for this tutorial "PRF" is in "America/Toronto"
tz_loc

# Find the UTC offset, using the first day in the PRF dataset
utc <- tz_offset("2007-05-10", tz_loc)[[5]]
# Print utc offset, for this tutorial, "PRF" from May-August 2007 is all
# Eastern Daylight Time (EDT), so UTC -4
utc

### Calculate hourly FWI System outputs with FWI2025 ###
# hFWI() is the function that calculates hourly FWI codes in FWI2025, it is able to
# iterate over multiple stations and years/fire seasons (not used here)
# Make sure to specify the corresponding utc offsets for different stations or times
# Default starting FWI codes are: ffmc_old = 85, dmc_old = 6, dc_old = 15
data_fwi <- hFWI(data, utc)

# Output is a data TABLE, with first 11 columns being the same as input, now plus:
# percent_cured, date, timestamp, timezone, solrad, sunrise, sunset, sunlight_hours,
# ffmc, dmc, dc, isi, bui, fwi, dsr, gfmc, gsi, gfwi
# Save the output as a .csv file (overrides any data in any preexisting file)
write.csv(data_fwi, 'wx_prf_fwi.csv')

# View a simple summary of the FWI outputs.
View(summary(data_fwi[, c(20:29)]))

# Create a daily summary to determine the time of peak burn and
# the number of hours of spread potential.
report <- generate_daily_summaries(data_fwi)

# Daily report is a data frame with columns:
# wstind, year, mon, day, peak_time, duration, wind_speed_smoothed,
# peak_isi_smoothed, ffmc, dmc, dc, isi, bui, fwi, dsr, sunrise, sunset

# View a simple summary of the daily report.
View(summary(report[, c(5:15)]))

# From here, a user can convert the output data to a datatype of their choice or
# continue with further visualizations within R.

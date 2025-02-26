## How to calculate hourly FWI – the new FWI2025
This tutorial is designed to be an example of how to calculate FWI2025 with tabular data.  The data has been formatted for correct column names and is in a sequential hourly format. The data has been pre-formatted for correct column names, and is in a sequential hourly format.  

\*only R version is currently available

### What you'll need

Go to the [CFFDRS-NG repo](https://github.com/nrcan-cfs-fire/cffdrs-ng/tree/main) and fork/clone/download the following in the language of your choice: 

- [**NG_FWI.r**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/NG_FWI.r)
- [**util.r**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/util.r)
- [**wx_prf.csv**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/data/wx_prf.csv)
- [**Tutorial_NGFWI.r**](tutorials/Tutorial_NGFWI.R)📥

Prior to running this tutorial, the user should ensure they have the necessary packages and libraries installed.  Each programming language references different packages or libraries, see 
<a href="../code/#packages" target="_self">Code#Packages</a>
for more details, or look in the code files.

### Data
**wx_prf.csv** contains hourly weather recorded from the Petawawa Research Forest weather station during the 2007 field season. The data is sorted by ascending order and has no gaps. The column headers are those required for hourly FWI calculations, details can be found at 
<a href="../code/#hourly-fire-weather-index" target="_self">Code#Hourly Fire Weather Index</a>. 
There is no input for solar radiation (*sol_rad*) or curing faction (*percent_cure*) because these are optional inputs and they will be automatically estimated if they are not given.

### Code
Open the **Tutorial_NGFWI.r** code file. You can either follow the code and comments in the file or continue on this page (both include the same code and content).

#### Load libraries
Ensure you have the necessary libraries installed. Run `install.packages()` to install any you are missing.
```r
library(lubridate)
library(data.table)
library(lutz)
```
#### Check your current working directory
If the working directory is different from where you saved **NG_FWI.r**, **util.r**, and **wx_prf.csv**, change the working directory to the folder containing these files.
```r
getwd()
setwd('\\')
```

#### Load FWI2025 functions and weather station data
```r
source("NG_FWI.r")
source("util.r")
data <- read.csv('wx_prf.csv')
names(data)
```

Check the column names, data should contain 11 columns: `id`, `lat`, `long`, `yr`, `mon`, `day`, `hr`, `temp`, `rh`, `ws`, and `prec`.

#### Find the timezone and UTC offset
Date and Time are important to calculate the time of sunrise and sunset. The UTC timezone offset is a required input for the FWI2025 function. The 'lutz' library has functions to get the timezone of the weather station, based on Latitude and Longitude. First, make a dataframe with all the unique stations including ID, Latitude and Longitude.

```r
stations <- cbind(data$id, data$lat, data$long)
colnames(stations) <- c("id", "lat", "long")
stations <- as.data.frame(stations)
stations <- unique(stations)
stations$lat <- as.numeric(stations$lat)
stations$long <- as.numeric(stations$long)
```

Next, find the location for each unique ID based on Latitude and Longitude. `tz_lookup_coords()` can take some time. You may need to download the package 'sf' for method = "accurate".

```r
tz_loc <- tz_lookup_coords(stations$lat, stations$long, method = "accurate")
```

Find the UTC offset, using the first day in the PRF dataset.

```r
utc <- tz_offset("2007-05-10", tz_loc)[[5]]
```

#### Calculate hourly FWI System outputs with FWI2025
`hFWI()` is the function that calculates hourly FWI codes in FWI2025. Details about the hourly FWI function can be found at
<a href="../code/#hourly-fire-weather-index" target="_self">Code#Hourly Fire Weather Index</a>.
It is able to iterate over multiple stations and years/fire seasons (not used here). Make sure to specify the corresponding utc offsets for different stations or times. Default starting FWI codes are: ffmc_old = 85, dmc_old = 6, and dc_old = 15.

```r
data_fwi <- hFWI(data, utc)
```

Output is a data TABLE, with first 11 columns being the same as input, now plus: `percent_cured`, `date`, `timestamp`, `timezone`, `solrad`, `sunrise`, `sunset`, `sunlight_hours`, `ffmc`, `dmc`, `dc`, `isi`, `bui`, `fwi`, `dsr`, `gfmc`, `gsi`, and `gfwi`.

Save the output as a .csv file (overrides any data in any preexisting file)

```r
write.csv(data_fwi, 'wx_prf_fwi.csv')
```

View a simple summary of the FWI outputs.

```r
View(summary(data_fwi[, c(20:29)]))
```

#### Calculate daily summaries
Create a daily summary to determine the time of peak burn and the number of hours of spread potential. Details about the daily summaries function can be found at 
<a href="../code/#daily-summaries" target="_self">Code#Daily Summaries</a>.

```r
report <- generate_daily_summaries(data_fwi)
```

Daily report is a data frame with columns: `wstind`, `year`, `mon`, `day`, `peak_time`, `duration`, `wind_speed_smoothed`, `peak_isi_smoothed`, `ffmc`, `dmc`, `dc`, `isi`, `bui`, `fwi`, `dsr`, `sunrise`, `sunset`.

View a simple summary of the daily report.
```r
View(summary(report[, c(5:15)]))
```

From here, a user can convert the output data to a datatype of their choice or continue with further visualizations within R.

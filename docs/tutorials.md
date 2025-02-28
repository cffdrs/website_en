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
There is no input for solar radiation (*sol_rad*) or curing fraction (*percent_cure*) because these are optional inputs and they will be automatically estimated if they are not given.

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
```r
getwd()
```
If the working directory is different from where you saved **NG_FWI.r**, **util.r**, and **wx_prf.csv**, change the working directory with `setwd()` to the folder containing these files.

#### Load FWI2025 functions and weather station data
```r
source("NG_FWI.r")
source("util.r")
data <- read.csv('wx_prf.csv')
```

If you print the column names, data should contain 11 columns:

```r
> names(data)
 [1] "id"   "lat"  "long" "yr"   "mon"  "day"  "hr"   "temp" "rh"   "ws" 
[11] "prec"
```

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
If you print the unique stations, you should see only one for Petawawa Research Forest:

```r
> stations
   id      lat      long
1 PRF 46.01393 -77.41804
```

Next, find the location for each unique ID based on Latitude and Longitude. `tz_lookup_coords()` can take some time. You may need to download the package 'sf' for method = "accurate".

```r
tz_loc <- tz_lookup_coords(stations$lat, stations$long, method = "accurate")
```

Petawawa Research Forest is in the same timezone as Toronto:

```r
> tz_loc
[1] "America/Toronto"
```

Find the UTC offset, using the first day in the PRF dataset.

```r
utc <- tz_offset("2007-05-10", tz_loc)[[5]]
```

Printing the UTC offset for this tutorial, PRF from May-August 2007 is all in Eastern Daylight Time (EDT), which is UTC -4:

```r
> utc
[1] -4
```

#### Calculate hourly FWI System outputs with FWI2025
`hFWI()` is the function that calculates hourly FWI codes in FWI2025. Details about the hourly FWI function can be found at
<a href="../code/#hourly-fire-weather-index" target="_self">Code#Hourly Fire Weather Index</a>.
It is able to iterate over multiple stations and years/fire seasons (not used here). Make sure to specify the corresponding utc offsets for different stations or times. Default starting FWI codes are: ffmc_old = 85, dmc_old = 6, and dc_old = 15.

```r
data_fwi <- hFWI(data, utc)
```

Output is a data TABLE, with first 11 columns being the same as input, with another 18 output columns appended:

```r
> names(data_fwi)
 [1] "id"             "lat"            "long"           "yr"
 [5] "mon"            "day"            "hr"             "temp"
 [9] "rh"             "ws"             "prec"           "percent_cured"  
[13] "date"           "timestamp"      "timezone"       "solrad"
[17] "sunrise"        "sunset"         "sunlight_hours" "ffmc"
[21] "dmc"            "dc"             "isi"            "bui"
[25] "fwi"            "dsr"            "gfmc"           "gsi"
[29] "gfwi"
```

Save the output as a .csv file (overrides any data in any preexisting file)

```r
write.csv(data_fwi, 'wx_prf_fwi.csv')
```

The last two columns of `ffmc`, `dmc`, `dc`, `isi`, `bui`, `fwi`, and `dsr` are:

```r
> tail(data_fwi[, 20:26], 2)
       ffmc      dmc       dc      isi      bui      fwi       dsr  
      <num>    <num>    <num>    <num>    <num>    <num>     <num>  
1: 80.26688 10.84884 219.5169 1.642292 19.31166 2.320059 0.1206430  
2: 82.17590 11.10672 220.0533 2.146157 19.72455 3.345161 0.2305616
```

View a simple summary of the FWI outputs (columns 20-29).

```r
View(summary(data_fwi[, 20:29]))
```

#### Calculate daily summaries
Create a daily summary to determine the time of peak burn and the number of hours of spread potential. Details about the daily summaries function can be found at 
<a href="../code/#daily-summaries" target="_self">Code#Daily Summaries</a>.

```r
report <- generate_daily_summaries(data_fwi)
```

Daily report is a data frame with columns:

```r
> names(report)
 [1] "wstind"              "year"                "mon"              
 [4] "day"                 "peak_time"           "duration"         
 [7] "wind_speed_smoothed" "peak_isi_smoothed"   "ffmc"             
[10] "dmc"                 "dc"                  "isi"              
[13] "bui"                 "fwi"                 "dsr"              
[16] "sunrise"             "sunset"
```

View a simple summary of the daily report.

```r
View(summary(report[, 5:15]))
```

From here, a user can convert the output data to a datatype of their choice or continue with further visualizations within R.

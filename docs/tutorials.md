<a href="https://cffdrs.github.io/website_fr/tutoriels/" target="_self" style="float: right;"> Français </a>

# Tutorials

## Hourly FWI
This tutorial is designed to be an example of how to calculate FWI2025 with tabular data.  The data provided in **wx_prf.csv** is already formatted with the required column names and is in a sequential hourly format.  

\*only R version is currently available

### R

#### What you'll need

Go to the [CFFDRS-NG repo](https://github.com/nrcan-cfs-fire/cffdrs-ng/tree/main) and download/clone/fork the following: 

- [**NG_FWI.r**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/NG_FWI.r)
- [**util.r**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/util.r)
- [**daily_summaries.r**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/daily_summaries.R)
- [**wx_prf.csv**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/data/wx_prf.csv)
- [**Tutorial_NGFWI.r**](tutorials/Tutorial_NGFWI.R)📥

Prior to running this tutorial, the user should ensure they have the necessary packages and libraries installed.  Each programming language references different packages or libraries, see 
<a href="../code/#packages" target="_self">Code#Packages</a>
for more details, or look in the code files.

#### Data
**wx_prf.csv** contains hourly weather recorded from the Petawawa Research Forest weather station during the 2007 field season. The data is sorted by ascending order and has no gaps. The column headers are those required for hourly FWI calculations, details can be found at 
<a href="../code/#hourly-fire-weather-index" target="_self">Code#Hourly Fire Weather Index</a>. 
There is no input for solar radiation (*sol_rad*) or curing fraction (*percent_cure*) because these are optional inputs and they will be automatically estimated if they are not given.

#### Steps
Open the **Tutorial_NGFWI.r** code file. You can either follow the code and comments in the file or continue on this page (both include the same code and content).

##### Load libraries
Ensure you have the necessary libraries installed. Run `install.packages()` to install any you are missing.
```r
library(lubridate)
library(data.table)
library(lutz)
```
##### Check your current working directory
```r
getwd()
```
If the working directory is different from where you saved the NG-CFFDRS scripts, change the working directory with `setwd()` to that folder.

##### Load FWI2025 functions and weather station data
```r
source("NG_FWI.r")
source("util.r")
source("daily_summaries.r")
data <- read.csv('wx_prf.csv')
```

If you print the column names, data should contain the following 11 columns:

```r
> names(data)
 [1] "id"   "lat"  "long" "yr"   "mon"  "day"  "hr"   "temp" "rh"   "ws" 
[11] "prec"
```

##### Find the timezone
The 'lutz' library has functions to get the timezone of the weather station based on latitude and longitude. First, make a dataframe of stations with unique ID, latitude, and longitude.

```r
stations <- unique(data[c("id", "lat", "long")])
```
Printing the dataframe, the only station is at Petawawa Research Forest (PRF):

```r
> stations
   id      lat      long
1 PRF 46.01393 -77.41804
```

Next, find the timezone for each unique ID based on latitude and longitude. `tz_lookup_coords()` can take some time. You may need to download the package 'sf' for method = "accurate".

```r
tz_loc <- tz_lookup_coords(stations$lat, stations$long, method = "accurate")
```

PRF is in the same timezone as Toronto:

```r
> tz_loc
[1] "America/Toronto"
```

##### Find the UTC offset
The UTC timezone offset is a required input for the FWI2025 function. Since weather data is normally collected using standard time (not daylight time), the date is set to January 1. Using dates from the dataset (during the summer fire season) gives the UTC offset for daylight time which is off by 1.

```r
utc <- tz_offset("2007-01-01", tz_loc)[[5]]
```

Print the UTC offset, for this tutorial PRF is in Eastern Time (EST) so UTC -5:

```r
> utc
[1] -5
```

##### Calculate hourly FWI System outputs with FWI2025
`hFWI()` is the function that calculates hourly FWI codes in FWI2025. Details about the hourly FWI function can be found at
<a href="../code/#hourly-fire-weather-index" target="_self">Code#Hourly Fire Weather Index</a>.
It can handle multiple stations and years/fire seasons (not shown in this tutorial). Make sure to specify the corresponding UTC offsets for different stations or times. Default starting FWI codes are: ffmc_old = 85, dmc_old = 6, and dc_old = 15.

```r
data_fwi <- hFWI(data, utc)
```

Output is a data *table*, with FWI calculations appended after the input columns. Save the output as a .csv file (overrides any data in any preexisting file)

```r
write.csv(data_fwi, 'wx_prf_fwi.csv')
```

The last two rows of `ffmc`, `dmc`, `dc`, `isi`, `bui`, and `fwi` are:

```r
> tail(data_fwi[, c('ffmc', 'dmc', 'dc', 'isi', 'bui', 'fwi')], 2)
       ffmc      dmc       dc      isi      bui      fwi
      <num>    <num>    <num>    <num>    <num>    <num>
1: 80.26688 10.05399 212.8417 1.642292 17.98419 2.172703
2: 82.17590 10.31187 213.3781 2.146157 18.40063 3.174787
```

View a simple summary of the standard FWI components.

```r
standard_components <- c('ffmc', 'dmc', 'dc', 'isi', 'bui', 'fwi')
View(summary(data_fwi[, ..standard_components]))
```

##### Calculate daily summaries
Calculate outputs like peak burn time and number of hours of spread potential. Details about the daily summaries function can be found at 
<a href="../code/#daily-summaries" target="_self">Code#Daily Summaries</a>.

```r
report <- generate_daily_summaries(data_fwi)
```

Compare a simple summary of some daily outputs (convert values to numeric class first).

```r
> daily_components <- c('peak_time', 'duration', 'peak_isi_smoothed', 'dsr')
> summary(apply(report[daily_components], 2, as.numeric))
   peak_time        duration      peak_isi_smoothed        dsr
 Min.   :13.00   Min.   : 0.000   Min.   : 0.000001   Min.   :0.00000    
 1st Qu.:17.00   1st Qu.: 0.000   1st Qu.: 2.039376   1st Qu.:0.07124    
 Median :17.00   Median : 0.000   Median : 4.031968   Median :1.17984    
 Mean   :17.29   Mean   : 2.697   Mean   : 4.527904   Mean   :1.67124    
 3rd Qu.:18.00   3rd Qu.: 5.000   3rd Qu.: 6.495304   3rd Qu.:2.90284    
 Max.   :23.00   Max.   :14.000   Max.   :15.770692   Max.   :7.11425
```

From here, the outputs can be converted to any datatype for further analysis or plotted for visualization.

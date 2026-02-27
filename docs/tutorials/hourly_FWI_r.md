<a href="../../tutorials#hourly-fwi" target="_self" style="float: left;"> back to Tutorials </a>
<a href="https://cffdrs.github.io/website_fr/tutoriels/IFM_horaire_R" target="_self" style="float: right;"> Français </a>
<br>
<br>

# Hourly FWI Tutorial - R
*Last updated: February 27th, 2026*

## R files

The following files can be found on the [cffdrs-ng GitHub repository](https://github.com/nrcan-cfs-fire/cffdrs-ng/tree/main): 

- data/
    - [**PRF2007_hourly_wx.csv**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/data/PRF2007_hourly_wx.csv)
- FWI/
    - R/
        - tutorial/
             - [**tutorial_hourly_FWI.r**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/FWI/R/tutorial/tutorial_hourly_FWI.R)
        - [**NG_FWI.r**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/FWI/R/NG_FWI.r)
        - [**util.r**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/FWI/R/util.r)
        - [**daily_summaries.r**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/FWI/R/daily_summaries.r)

If you are unfamiliar with GitHub, there are many options for you to retrieve the code and data files:

1. *Download each file* to your computer individually. On the file's GitHub page (e.g. [**PRF2007_hourly_wx.csv**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/data/PRF2007_hourly_wx.csv)), find the "More file actions" button at the top-right side of the website (denoted "..."), and select "Download". This will begin downloading based on your browser settings. Repeat this for every file.
2. *Download the whole repository* to your computer. See the [GitHub documentation](https://docs.github.com/en/get-started/start-your-journey/downloading-files-from-github) for more information.
3. *Clone* the whole repository to your computer with Git. See the [GitHub documentation](https://docs.github.com/en/get-started/start-your-journey/downloading-files-from-github) for more information.
4. *Fork* the repository to create a new repository on GitHub. See the [GitHub documentation](https://docs.github.com/en/get-started/start-your-journey/downloading-files-from-github) for more information.

Besides the files, ensure you have the required R packages, which are listed in the <a href="../../code/FWI2025_R#packages" target="_self">code documentation</a>.

## Data
**PRF2007_hourly_wx.csv** contains hourly weather recorded from a Petawawa Research Forest (PRF) weather station during the 2007 field season. The data has no gaps and is sorted sequentially by time, which is a requirement for FWI2025 input data.

The column headers are those required for hourly FWI calculations, details of which can be found in the <a href="../../code/FWI2025_R#input-data" target="_self">code documentation</a>. Grassland fuel load (`grass_fuel_load`), grassland curing (`percent_cured`) and solar radiation (`solrad`) are not included, but these are optional inputs and they will be automatically calculated if not provided. There is a column for UTC offset (`timezone`) which will be used by default in the `hFWI()` function.

## Steps
Open the **tutorial_hourly_FWI.r** code file. You can either follow the code and comments in the file or continue on this page (both include the same code and content).

### Load libraries
Run `install.packages()` to install any you are missing
```r
library(lubridate)
library(data.table)
```

### Load functions and data
Check your current working directory
```r
getwd()
```
If the working directory is different from where you saved the FWI2025 scripts, change the working directory with `setwd()` to that folder.  

Load the files containing the functions and variables to calculate FWI2025.
```r
source("NG_FWI.r")
source("util.r")
source("daily_summaries.r")
```

Load the input weather station data file. The path below is specified based on the layout in the GitHub repository. Change the file path for **PRF2007_hourly_wx.csv** if your structure is different.
```r
data <- read.csv("../../data/PRF2007_hourly_wx.csv")
```

Print the column names, data should contain 12 columns
```r
print(names(data))
```
```r
 [1] "id"       "lat"      "long"     "timezone" "yr"       "mon"
 [7] "day"      "hr"       "temp"     "rh"       "ws"       "prec"
```

### Run FWI2025
`hFWI()` is the function that calculates hourly FWI codes in FWI2025. Details about it can be found in the <a href="../../code/FWI2025_R/#parameters" target="_self">code documentation</a>. It can handle multiple stations and years/fire seasons (not shown in this tutorial). For the arguments you can run `args()`.
```r
args(hFWI)
```
```r
function (df_wx, timezone = NA, ffmc_old = FFMC_DEFAULT, mcffmc_old = NA, 
    dmc_old = DMC_DEFAULT, dc_old = DC_DEFAULT, mcgfmc_matted_old = ffmc_to_mcffmc(FFMC_DEFAULT),
    mcgfmc_standing_old = ffmc_to_mcffmc(FFMC_DEFAULT), prec_cumulative = 0,
    canopy_drying = 0, silent = FALSE, round_out = 4)
```

For this tutorial, we will leave all the optional parameters to default.
```r
data_fwi <- hFWI(data)
```
```r
########
FWI2025 (YYYY-MM-DD)

Startup values used:
FFMC = 85.0 or mcffmc = NA %
DMC = 6.0 and DC = 15.0
mcgfmc matted = 16.3075 % and standing = 16.3075 %
cumulative precipitation = 0.0 mm and canopy drying = 0

Running PRF for 2007
########
```

Output is a data.frame (matching input class), with FWI calculations appended after the input columns. Save the output as a CSV file (overrides any preexisting file).
```r
write.csv(data_fwi, "PRF2007_hourly_FWI.csv", row.names = FALSE)
```

Print the last two rows of the standard moisture codes and fire behaviour indices.
```r
standard_components <- c("ffmc", "dmc", "dc", "isi", "bui", "fwi")
print(tail(data_fwi[standard_components], 2))
```
```r
        ffmc    dmc       dc    isi    bui    fwi
2622 80.2669 3.0924 219.5169 1.6423 5.9745 0.7650
2623 82.1759 3.3503 220.0533 2.1462 6.4550 1.2023
```

Print a simple summary of the standard FWI components.
```r
summary(data_fwi[standard_components])
```
```r
      ffmc            dmc               dc              isi
 Min.   : 0.00   Min.   : 0.000   Min.   : 15.41   Min.   : 0.0000
 1st Qu.:67.87   1st Qu.: 5.925   1st Qu.: 72.28   1st Qu.: 0.7877
 Median :79.38   Median :16.461   Median :133.06   Median : 1.3958
 Mean   :70.62   Mean   :17.487   Mean   :136.12   Mean   : 2.1582
 3rd Qu.:85.18   3rd Qu.:26.511   3rd Qu.:188.64   3rd Qu.: 2.9785
 Max.   :94.40   Max.   :50.174   Max.   :292.95   Max.   :17.5958
      bui              fwi
 Min.   : 0.000   Min.   : 0.000
 1st Qu.: 8.408   1st Qu.: 0.422
 Median :22.623   Median : 2.408
 Mean   :23.972   Mean   : 3.877
 3rd Qu.:34.605   3rd Qu.: 5.930
 Max.   :66.148   Max.   :25.135
```

Compare your outputs with our standard outputs in [**PRF2007_standard_hourly_FWI.csv**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/data/PRF2007_standard_hourly_FWI.csv).

### Calculate daily summaries
Calculate outputs like peak burn time and number of hours of spread potential. Details about the daily summaries function can be found in the 
<a href="../../code/FWI2025_R/#daily-summaries" target="_self">code documentation</a>.
```r
report <- generate_daily_summaries(data_fwi)
```
```r
########
FWI2025: Daily Summaries (YYYY-MM-DD)

Summarizing PRF to daily
########
```

Print a simple summary of the daily report.

```r
daily_components <- c("peak_hr", "duration", "isi_smooth", "dsr")
summary(report[daily_components])
```
```r
    peak_hr         duration        isi_smooth          dsr
 Min.   :13.00   Min.   : 0.000   Min.   : 0.000   Min.   :0.0000
 1st Qu.:17.00   1st Qu.: 0.000   1st Qu.: 1.234   1st Qu.:0.0338
 Median :17.00   Median : 0.000   Median : 4.032   Median :0.9913
 Mean   :17.29   Mean   : 2.697   Mean   : 4.324   Mean   :1.5533
 3rd Qu.:18.00   3rd Qu.: 5.000   3rd Qu.: 6.495   3rd Qu.:2.5940
 Max.   :23.00   Max.   :14.000   Max.   :15.771   Max.   :6.9486
```

From here, the outputs can be converted to any datatype for further analysis or plotted for visualization.

## Appendix: Timezone
This section will cover how to determine the UTC offset of a Local Standard Time (LST) based on a date and location (latitude and longitude). This only applies to datasets that are *known to be recorded using LST*, and is **not** a substitute in cases where a dataset's UTC offset is unknown. See the <a href="../../home/#why-is-timezone-required-and-how-do-i-determine-it" target="_self">FAQ</a> for an explanation.

The 'lutz' library has functions to get the timezone of the weather station based on latitude and longitude.
```r
library(lutz)
```

First, make a dataframe of stations with unique ID, latitude, and longitude.

```r
stations <- unique(data[c("id", "lat", "long")])
```

Print the unique station IDs and coordinates. For this dataset the only station is at Petawawa Research Forest (PRF).
```r
print(stations)
```
```r
   id    lat    long
1 PRF 45.996 -77.427
```

Find the timezone based on latitude and longitude, this can take some time. You may need to download the package 'sf' for method = "accurate".
```r
tz_loc <- tz_lookup_coords(stations$lat, stations$long, method = "accurate")
```

Print the timezone location. PRF is equivalent to "America/Toronto".
```r
print(tz_loc)
```
```r
[1] "America/Toronto"
```

The UTC offset can then be determined from the timezone location and a date. To guarantee the UTC offset for LST, use a date in winter (e.g. January 1st in the Northern hemisphere or July 1st in the Southern hemisphere).
```r
utc <- tz_offset("2007-01-01", tz_loc)[[5]]
```

Print the UTC offset.
```r
print(utc)
```
```r
[1] -5
```

The provided [PRF dataset](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/data/PRF2007_hourly_wx.csv) is actually not recorded in LST, but Local Daylight Time (Eastern Daylight Time). This is why the `timezone` parameter is set to -4, and why this process is not a substitute for actual information about a dataset.

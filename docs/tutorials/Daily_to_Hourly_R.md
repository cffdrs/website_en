<a href="../../tutorials#daily-to-hourly" target="_self" style="float: left;"> back to Tutorials </a>
<a href="https://cffdrs.github.io/website_fr/tutoriels/quotidien_a_horaire_R" target="_self" style="float: right;"> Français </a>
<br>
<br>

# Daily to Hourly Tutorial - R
*Last updated: February 27th, 2026*

## R files

The following files can be found on the [cffdrs-ng GitHub repository](https://github.com/nrcan-cfs-fire/cffdrs-ng/tree/main):  

- data/
    - [**PRF2007_daily_wx.csv**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/data/PRF2007_daily_wx.csv)
- FWI/
    - R/
        - tutorial/
            - [**tutorial_daily_to_hourly.r**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/FWI/R/tutorial/tutorial_daily_to_hourly.r)
        - [**make_hourly.r**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/FWI/R/make_hourly.r)
        - [**make_minmax.r**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/FWI/R/make_minmax.r)
        - [**util.r**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/FWI/R/util.r)

If you are unfamiliar with GitHub, there are many options for you to retrieve the code and data files:

1. *Download each file* to your computer individually. On the file's GitHub page (e.g. [**PRF2007_daily_wx.csv**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/data/PRF2007_daily_wx.csv)), find the "More file actions" button at the top-right side of the website (denoted "..."), and select "Download". This will begin downloading based on your browser settings. Repeat this for every file.
2. *Download the whole repository* to your computer. See the [GitHub documentation](https://docs.github.com/en/get-started/start-your-journey/downloading-files-from-github) for more information.
3. *Clone* the whole repository to your computer with Git. See the [GitHub documentation](https://docs.github.com/en/get-started/start-your-journey/downloading-files-from-github) for more information.
4. *Fork* the repository to create a new repository on GitHub. See the [GitHub documentation](https://docs.github.com/en/get-started/start-your-journey/downloading-files-from-github) for more information.

## Data
**PRF2007_daily_wx.csv** contains daily weather which was reduced from hourly data specifically for this tutorial. Temperature, relative humidity, and wind speed data are taken from noon Local Standard Time (LST), or in this case the equivalent 13:00 Local Daylight Time (LDT). Hourly precipitation is summed over 24 hours ending at the same hour as the other weather variables. The original hourly data is from a Petawawa Research Forest (PRF) weather station during the 2007 field season. The data has no gaps and is sorted sequentially by time, which are requirements for the input data.

Columns that are included and required for converting daily weather data to daily high and low (minmax) data are: year (`yr`), month (`mon`), day (`day`), temperature [°C] (`temp`), relative humidity [%] (`rh`), wind speed [km/h] (`ws`), and daily precipitation [mm] (`prec`).

Columns that are required for converting daily minmax data to hourly data are: the output columns from converting daily to minmax, latitude [DD] (`lat`), longitude [DD] (`long`), and UTC offset [hr] (`timezone`). One UTC offset value can be specified instead of the column input in the `make_hourly()` function.

A station ID (`id`) column is not required if all data is from the same station/location, but is provided in this dataset for clarity.

## Steps
Open the **tutorial_daily_to_hourly.r** code file. You can either follow the code and comments in the file or continue on this page (both include the same code and content).

### Load packages
Run `install.packages()` to install any you are missing
```r
library(data.table)
library(lubridate)
```

### Load functions and data
Check your current working directory
```r
getwd()
```
This tutorial will refer to file locations as structured in the GitHub repository. If the working directory is different from the cffdrs-ng/FWI/R folder, you can change to it with setwd(). Change the path characters to match your file layout if it is different. 

Load the files containing the functions to calculate hourly weather.
```r
source("make_minmax.r")
source("make_hourly.r")
```

Load the input daily weather data file.
```r
daily = read.csv("../../data/PRF2007_daily_wx.csv")
```

Print the column names, data should contain 11 columns.

```r
print(names(daily))
```
```r
 [1] "id"       "lat"      "long"     "timezone" "yr"       "mon"
 [7] "day"      "temp"     "rh"       "ws"       "prec"
```

### Convert daily to minmax

`daily_to_minmax()` is the function that calculates daily minmax data from daily weather data. For details you can run the help.
```r
args(daily_to_minmax)
```
```r
function (df, silent = FALSE, round_out = 4) 
NULL
```

For this tutorial, we will leave the optional `round_out` parameter to default.
```r
minmax = daily_to_minmax(daily)
```
```r
########
FWI2025: Make Min/Max Inputs (YYYY-MM-DD)

Predicting daily min/max weather
########
```

Output is a data.frame, with the following columns:
```r
print(names(minmax))
```
```r
 [1] "id"       "lat"      "long"     "timezone" "yr"       "mon"
 [7] "day"      "temp_min" "temp_max" "rh_min"   "rh_max"   "ws_min"
[13] "ws_max"   "prec"
```

Print the last two rows of the minmax weather data.

```r
print(tail(minmax[, 5:14], 2))
```
```r
      yr mon day temp_min temp_max  rh_min rh_max ws_min ws_max prec
108 2007   8  26   9.4176    22.56 46.6648    100 1.8030 15.025 10.7
109 2007   8  27  10.2418    23.59 46.8248    100 1.0134  8.445  0.0
```

You can save the daily minmax data as a CSV file (overrides any preexisting file).
```r
write.csv(minmax, "../../PRF2007_calculated_minmax_wx.csv", row.names = FALSE)
```

### Convert minmax to hourly
Finally, convert the daily minmax weather data to hourly weather data that can be used to calculate <a href="../../tutorials#hourly-fwi"; target="_self">hourly FWI</a>. Run `args()` for details about the `minmax_to_hourly()` function arguments.

```r
args(minmax_to_hourly)
```
```r
function (w, timezone = NA, prec_hr = "sunrise", skip_invalid = FALSE,
    verbose = FALSE, silent = FALSE, round_out = 4)
NULL
```

Since our minmax data includes a UTC offset (`timezone`) column, we can leave the timezone option as default. Daily precipitation is placed at one hour of each day, controlled by the `prec_hr` parameter. By default it is placed at the calculated hour of sunrise, but an integer hour can be specified instead.

```r
hourly <- minmax_to_hourly(minmax)
```
```r
########
FWI2025: Make Hourly Inputs (YYYY-MM-DD)

Predicting hourly weather at PRF for 2007
########
```

The output columns should include everything required to run `hFWI()`.

```r
print(names(hourly))
```
```r
 [1] "id"       "lat"      "long"     "timezone" "yr"       "mon"
 [7] "day"      "hr"       "temp"     "rh"       "ws"       "prec"
```

Print the first 24 hours of hourly data.

```r
print(head(hourly[, 5:12], 24))
```
```r
     yr mon day hr    temp      rh      ws prec
1  2007   5  11  0  9.0497 79.2894  6.0236  0.0
2  2007   5  11  1  8.2408 82.7490  5.5602  0.0
3  2007   5  11  2  7.5821 85.5521  5.1519  0.0
4  2007   5  11  3  7.0456 87.8233  4.7922  0.0
5  2007   5  11  4  6.6087 89.6634  4.4754  0.0
6  2007   5  11  5  6.2529 91.1543  4.1963  0.0
7  2007   5  11  6  5.2016 97.3083  3.9504  0.5
8  2007   5  11  7  7.0357 89.1380  2.9910  0.0
9  2007   5  11  8  8.8135 81.1794  6.0672  0.0
10 2007   5  11  9 10.4922 73.6335  8.9872  0.0
11 2007   5  11 10 12.0316 66.6910 11.6353  0.0
12 2007   5  11 11 13.3946 60.5271 13.9063  0.0
13 2007   5  11 12 14.5485 55.2976 15.7102  0.0
14 2007   5  11 13 15.4655 51.1346 16.9754  0.0
15 2007   5  11 14 16.1237 48.1433 17.6516  0.0
16 2007   5  11 15 16.5071 46.3991 17.7121  0.0
17 2007   5  11 16 16.6067 45.9461 17.1545  0.0
18 2007   5  11 17 16.4199 46.7958 16.0008  0.0
19 2007   5  11 18 15.9513 48.9268 14.2969  0.0
20 2007   5  11 19 15.2122 52.2851 12.1104  0.0
21 2007   5  11 20 14.2203 56.7860  9.5280  0.0
22 2007   5  11 21 11.9971 59.6863  7.7465  0.0
23 2007   5  11 22  9.2897 60.3596  6.9610  0.0
24 2007   5  11 23  7.0858 60.9049  6.2694  0.0
```

You can save the hourly weather data as a CSV file (overrides any preexisting file).
```r
write.csv(hourly, "../../PRF2007_calculated_hourly_wx.csv", row.names = FALSE)
```

## Appendix: Minmax to Hourly Parameters
The process to predict hourly weather data from daily minmax data is controlled by timing and decay parameters for each weather variable. The first, alpha (α) parameter is the typical difference in time between sunrise and minimum temperature and wind speed (and maximum relative humidity). The second, beta (β) parameter is the typical difference in time between solar noon and maximum temperature and wind speed (and minimum relative humidity). The third, gamma (γ) parameter is the typical rate of exponential decay after sunset for temperature, relative humidity, and wind speed.  

Based on an analysis of historical weather across Canada, the default values are set as follows:

| Variable \ Coefficient       | α    | β    | γ    |
| ---------------------------- | :--: | :--: | :--: |
| Temperature                  | 0.0  | 2.75 | -1.9 |
| Relative Humidity            | 0.25 | 2.75 | -2.0 |
| Wind Speed                   | 1.0  | 1.5  | -1.3 |

For more information refer to [Appendix A of *The 2025 Update to the FWI System: Structure, Changes and Interpretation* info report](https://ostrnrcan-dostrncan.canada.ca/handle/1845/347500).  

In the code, these values are specified at the top of [**make_hourly.r**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/FWI/R/make_hourly.r) in three lists (one for each weather variable). To change the values, edit these lists and save the script. Then <a href="#load-functions-and-data" target="_self"> reload the file and functions</a>.

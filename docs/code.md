<a href="https://cffdrs.github.io/website_fr/code/" target="_self" style="float: right;"> Français </a>

# Code

## Repository

The [cffdrs-ng GitHub repository](https://github.com/nrcan-cfs-fire/cffdrs-ng/tree/main) contains the up-to-date code for the CFFDRS2025 modules in three programming languages: R, C, and Python. All three languages contain the same equations and perform the same tasks, the choice is yours depending on your system requirement.

## Fire Weather Index 2025
The [Canadian Forest Fire Weather Index (FWI)](https://cwfis.cfs.nrcan.gc.ca/background/summary/fwi) is a major subsystem of the CFFDRS. FWI2025 is the next generation FWI system corresponding to the CFFDRS2025. The following describes the files, data inputs, parameters, and outputs in a general way for all three languages, noting the variations for specific languages.

### Scripts
Each programming language has two scripts that are required to generate FWI2025 outputs:

1. "NG_FWI" holds the functions and equations for generating FWI2025 outputs.

    R : **NG_FWI.r**  
    Python : **NG_FWI.py**  
    C : **NG_FWI.c**

2. "util" includes basic functions that are not part of FWI2025 equations, but generate intermediate information for the calculation of the FWI2025 components (e.g. time of sunrise and sunset, number of sunlight hours).  This script also includes the process to generate the daily summary output.

    R : **util.r**  
    Python : **util.py**  
    C : **util.c**, **util.h**

### Packages
The FWI2025 scripts require different sets of language-specific libraries or packages.  These must be installed prior to running "NG_FWI".

R : lubridate and data.table  
Python : datetime, logging, math, numpy, pandas, os.path, sys  
C : stdlib.h, stdbool.h, string.h

### Get Started
The [cffdrs-ng GitHub repository](https://github.com/nrcan-cfs-fire/cffdrs-ng/tree/main) also includes a tutorial script and test data. See the
<a href="../tutorials/#hourly-fwi" target="_self">Tutorials#Hourly FWI</a>
for a step-by-step workflow with hourly data. The documentation below goes into details about specific functions and data requirements.

### Format
FWI2025 code is written for and tested using input data in the form of a table/array, commonly imported as comma-separated value (.csv) files. Outputs are then also of the same form.  Users can configure the input and output file types to fit their individual data streams.

### Documentation
#### Hourly Fire Weather Index
The `hFWI()` function in the "NG_FWI" file is built to generate FWI System outputs one station at a time. The R and Python versions can also output multiple stations with a properly formatted input. The C version can only handle inputs of a single year for a given station.

##### Input Data
The Fire Weather Index System was originally designed to be calculated using data recorded at local *weather stations*.  As a result, descriptions below reference weather station data as input.  In reality, any collected or calculated weather data (e.g. gridded data, forecast data, etc.) that includes the standard variables required as input to the FWI System can be used. See the [Weather Guide](https://ostrnrcan-dostrncan.canada.ca/handle/1845/219568) for a description of weather data input standards for the FWI System.

The rows of the dataframe should correspond to consecutive hourly data. The columns and data types of the input dataframe are as follows:

| Column | Description |
| --- | --- |
| `id` | Weather station identifier, a unique number for the station, text or number |
| `lat` | Latitude of weather station, decimal degrees (°) (double precision) |
| `long` | Longitude of weather station, decimal degrees (°) (double precision) |
| `yr` | Year of weather station reading, number YYYY |
| `mon` | Month of weather station reading, number M or MM (must be consistent throughout the dataset) |
| `day` | Day of weather station reading, number DD or D (must be consistent throughout the dataset) |
| `hr` | Hour of weather station reading, number in military time (0-23) |
| `temp` | Temperature in degrees Celsius (°C), number |
| `rh` | Relative humidity in percent (%), number (0-100) |
| `ws` | Wind speed in kilometres per hour (km/hr), number |
| `prec` | Precipitation (rain) measured in millimetres (mm), number |
| `solrad` | Solar Radiation measured in kilowatts per square metre (kW/m^2) for grassland codes, number.  OPTIONAL input, FWI2025 will generate based on default method. ([CFFDRS2025 Solar Radiation Input (Draft)](../documents/CFFDRS2025_Draft-Solar-Radiation-as-Input.pdf)📥) |
| `percent_cured` | Percent Cured of grasses in open grassland, measured in percent for grassland codes, number (0-100). OPTIONAL input, FWI2025 will generate based on default method |

The column headers can be lower case or upper case, the output format is set to upper case.

In addition to the weather variables, the function to generate hourly FWI2025 outputs requires the timezone where the weather station is located and the start-up value for the moisture codes (e.g. FFMC of 85, DMC of 6 and DC of 15). See the next section below to see where it is specified.

##### Function Parameters
R :
```r
hFWI(df_wx, timezone, ffmc_old = 85, dmc_old = 6, dc_old = 15)
```
| Parameter | Description |
| --- | --- |
| `df_wx` | Data frame or formatted table (can have multiple years and stations, needs to be temporally sequential during a given year) |
| `timezone` | Timezone in which the weather station is located as the number of offset hours from UTC (e.g. for stations in Central Standard time the timezone is set to -6) |
| `ffmc_old` |  |
| `dmc_old` | The start-up value of the duff moisture code (e.g. 6, this is the default) |
| `dc_old` | The start-up value of the drought code (e.g. 15, this is the default) |

Python :
```python
hFWI(df_wx, ffmc_old = 85, dmc_old = 6, dc_old = 15, silent = False)
```
| Parameter | Description |
| --- | --- |
| `df_wx` | Data frame or formatted table (can have multiple years and stations, needs to be temporally sequential during a given year) |
| `timezone` | Timezone in which the weather station is located |
| `ffmc_old` | The startup value of the fine fuel moisture code (e.g. 85, this is the default)  |
| `dmc_old` | The start-up value of the duff moisture code (e.g. 6, this is the default) |
| `dc_old` | The start-up value of the drought code (e.g. 15, this is the default) |
| `silent` | Print progress messages to monitor script. True or False, False by default |

C :

The C version can be run from command line with the following arguments in order:

| Code | Description |
| --- | --- |
| `local GMToffset` | Timezone in which the weather station is located |
| `starting FFMC` | The startup value of the fine fuel moisture code (e.g. 85) |
| `starting DMC` | The start-up value of the duff moisture code (e.g. 6) |
| `starting DC` | The start-up value of the drought code (e.g. 15) |
| `input file` | Name of .csv file containing data for a single station over the course of a year |
| `output file` | Name of the file to output results into |

##### Output Description
The output is also the same format as the input data, with the following columns appended: 

| Column | Description |
| --- | --- |
| `timestamp` | Date and time of weather and FWI variable. Timestamp YYYY-MM-DD HH:MM:SS. (not in C) |
| `date` | YYYY-MM-DD Date type (without hh:mm:ss). (not in C) |
| `sunrise` | Time of sunrise based on the latitude, longitude, and date in military time (decimal time). (not in C) |
| `sunset` | Time of sunset based on the latitude, longitude, and date in military time (decimal time). (not in C) |
| `sunlight_hours` | Number of hours (hr) between sunrise and sunset (decimal time). (not in C) |
| `solrad` | Solar Radiation measured in kilowatts per square metre (kW/m^2) for grassland codes, generated automatically if missing from input (number). (needs to be calculated using **make_inputs.c** if not given) |
| `percent_cured` | Percent of cured (dead) grass fuels in grasslands, generated automatically if missing from input.  Used exclusively in the Grassland calculations.  Percentage as number (0-100). (needs to be calculated using make_inputs.c if not given) |
| `grass_fuel_load` | The standard grass fuel load is built into the Python and R code, 0.35 kg/m^2.  (needs to be calculated using make_inputs.c if not given, generates a column with the standard value) |
| `ffmc` | Fine Fuel Moisture Code (number) |
| `dmc` | Duff Moisture Code (number) |
| `dc` | Drought Code (number) |
| `isi` | Initial Spread Index (number) |
| `bui` | Buildup Index (number) |
| `fwi` | Fire Weather Index (number) |
| `dsr` | Daily Severity Rating (number) |
| `gfmc` | Grass Fuel Moisture Code, 0-101 similar to FFMC (number) |
| `gsi` | Grassland Spread Index (number) |
| `gfwi` | Grassland Fire Weather Index (number) |

#### Daily Summaries
The hourly FWI output can be summarized in a variety of ways depending on usage and requirements. These can be found within the ‘util’ file. `generate_daily_summaries()` boils down the hourly data into some daily metrics. 

##### Input Data
The only input to `generate_daily_summaries()` is the output from `hFWI()`.

##### Function Parameters
R :  

```r
generate_daily_summaries <- function(hourly_data) {}
```

Python : 

```python
def generate_daily_summaries(hourly_data): 
```

C : 
```c
hourly_data = the output dataframe generated by NG_FWI
```

##### Output Description
| Parameter | Description |
| --- | --- |
| `wstnid` | Weather station ID, or unique identifier for the weather station |
| `year` | Year, YYYY, number (e.g. 2024) |
| `mon` | Month, M, number (e.g. 3) |
| `day` | Day, D number (e.g. 8) |
| `sunrise` | Time of sunrise. HH:MM:SS timestamp format in military time (e.g. 06:30:55) |
| `sunset` | Time of sunset. HH:MM:SS timestamp format in military time (e.g. 19:45:05) |
| `peak_time` | The hour (hr) in military time (0-23),  number format. The hour where one might expect maximum fire behaviour as expressed by a modified ISI (see definitions of wind_speed_smoothed and peak_isi_smoothed below).  If the peak ISI (from peak_isi_smoothed field) is less than five, the peak_time is set to 17:00 hours |
| `duration` | Number of hours (hr), number format.  Can also be called duration of a burning window, number of hours in the day where one could expect an active fire (where a modified ISI is equal or greater than five).  If the ISI did not reach 5 or greater, the duration is zero |
| `wind_speed_smoothed` | Wind Speed in kilometres per hour (km/hr), double precision. Hourly wind speed recorded based on a 10 min average can be noisy hour-to-hour, this makes it difficult to estimate the duration of a burning window.  To estimate the duration of a burning window and peak time, the hourly windspeed is smoothed and the ISI is recalculated based on the smoothed wind speed and FFMC |
| `peak_isi_smoothed` | Maximum Initial Spread Index (ISI) recalculated based on FFMC and smoothed wind speed from ‘wind_speed_smoothed’, double precision number.  Number, double precision |
| `ffmc` | Fine Fuel Moisture Code corresponding to the FFMC at the hour of peak time. Number, double precision |
| `dmc` | Duff Moisture Code corresponding to the DMC at the hour of peak. Number, double precision |
| `dc` | Drought Code corresponding to the DC at the hour of peak time. Number, double precision |
| `isi` | Initial Spread Index corresponding to the ISI at the hour of peak time. Number, double precision |
| `bui` | Buildup Index corresponding to the BUI at the hour of peak time. Number, double precision |
| `fwi` | Fire Weather Index corresponding to the FWI at the hour of peak time. Number, double precision |
| `dsr` | Daily Severity Rating corresponding to the DSR at the hour of peak time. Number, double precision |
| `gfmc` | Grass Fuel Moisture Code corresponding to the GFMC at the hour of peak time. Number, double precision |
| `gsi` | Grassland Spread Index corresponding to the GSI at the hour of peak time. Number, double precision |
| `gfwi` | Grassland Fire Weather Index corresponding to the GFWI at the hour of peak time. Number, double precision |

## License

[GPL-2.0 License](https://github.com/nrcan-cfs-fire/cffdrs-ng/tree/main?tab=GPL-2.0-1-ov-file#readme)

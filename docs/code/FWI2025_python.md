<a href="../../code#fwi2025" target="_self" style="float: left;"> back to Code </a>
<a href="https://cffdrs.github.io/website_fr/code/IFM2025_Python" target="_self" style="float: right;"> Français </a>
<br>

# FWI2025 - Python

*Last updated: October 9th, 2025*

## Scripts
There are three scripts on the [cffdrs-ng GitHub repository](https://github.com/nrcan-cfs-fire/cffdrs-ng) that are required to generate FWI2025 outputs:

1. [**NG_FWI.py**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/FWI/Python/NG_FWI.py) holds the functions and equations for generating FWI2025 outputs.

2. [**util.py**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/FWI/Python/util.py) includes basic functions that are not part of FWI2025 equations, but generate intermediate information for the calculation of the FWI2025 components (e.g. time of sunrise and sunset, number of sunlight hours).

3. [**daily_summaries.py**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/FWI/Python/daily_summaries.py) holds the functions to generate the daily summary report.

## Packages
The FWI2025 Python scripts require the following packages which must be installed prior to running **NG_FWI.py**.

- `datetime` (built-in)
- `logging` (built-in)
- `argparse` (built-in)
- `math` (built-in)
- `numpy`
- `pandas`

## Get Started
The [GitHub repository](https://github.com/nrcan-cfs-fire/cffdrs-ng/tree/main) also includes a tutorial script and test data. See the <a href="../../tutorials/#hourly-fwi" target="_self">Tutorials#Hourly FWI</a> for a step-by-step workflow with hourly data. The documentation below goes into details about specific functions and data requirements.

## Data Format
FWI2025 code is written for and tested using input data in the form of a table/array, commonly imported as comma-separated value (.csv) files. Each row then corresponds with a single timestep (i.e. hour), in sequential order. Outputs are then also of the same table/array form, with additional columns. In Python, we use the `pandas` package and its [DataFrame data type](https://pandas.pydata.org/pandas-docs/stable/reference/frame.html#) to perform calculations. Users can configure the input file type before and output file type after calculation to fit individual data streams.

## Hourly FWI
The `hFWI()` function (case sensitive) in the **NG_FWI.py** file calculates hourly FWI moisture codes and fire behaviour indices. It can handle multiple stations (locations) and multiple years of hourly input data all at once, or just a single hour.

### Input DataFrame
The FWI system was originally designed to be calculated using data recorded at local weather stations, but any collected or calculated data (e.g. gridded data, forecast data, etc.) that includes the required weather variables can be used. See the [CFFDRS Weather Guide](https://ostrnrcan-dostrncan.canada.ca/handle/1845/219568) for a description of weather data standards for the FWI System.

The table below describes the columns and data types for the input DataFrame. Columns are required unless otherwise specified, in which case they will be set or calculated. The column names can be lower-case or upper-case, output columns are lower-case.

| Column | Description | Units | Class |
| --- | --- | --- | --- |
| `id` | Unique identifier for weather station or location | | str |
| `lat` | Latitude | DD | float |
| `long` | Longitude | DD | float |
| `timezone` | UTC offset (can be specified in `hFWI()` parameter instead, see <a href="#parameters" target="_self">below</a>) | | float |
| `yr` | Year of data point | | int |
| `mon` | Month of the year (1-12) | | int |
| `day` | Day of the month (1-31) | | int |
| `hr` | Hour of the day (0-23) | | int |
| `temp` | Air temperature | °C | float |
| `rh` | Relative humidity (0-100) | % | float |
| `ws` | 10 m open wind speed | km/hr | float |
| `prec` | Hourly precipitation | mm | float |
| `grass_fuel_load` | Density of grassland fuels (default 0.35) | kg/m^2 | float |
| `percent_cured` | Fraction of grassland fuels that is cured (0-100, default based on annual variation in the Boreal Plains region) | % | float |
| `solrad` | [Solar radiation](../documents/CFFDRS2025_Draft-Solar-Radiation-as-Input.pdf)📥 (optional) | kW/m^2 | float |

In addition to the weather variables, you can specify start-up values for moisture codes and other parameters in `hFWI()`.

### Parameters
The only required parameter for `hFWI()` is the input DataFrame, although many start-up values can be altered from default if desired. If you are performing a "live" run which is a continuation from previous FWI outputs with new data, the prior outputs need to be specified.

```python
hFWI(df_wx, ffmc_old = 85, mcffmc_old = None, dmc_old = 6, dc_old = 15, mcgfmc_matted_old = 16.31, mcgfmc_standing_old = 16.31, prec_cumulative = 0.0, canopy_drying = 0.0, silent = False, round_out = 4)
```

| Parameter | Description |
| --- | --- |
| `df_wx` | DataFrame of hourly weather stream (see <a href="#input-dataframe" target="_self">Input DataFrame</a> section above) |
| `timezone` | UTC offset (default `None`). `None` is for using a provided column in `df_wx`. Specifying a number will create/overwrite `df_wx` column. |
| `ffmc_old` | Previous value for FFMC (default 85). Set to `None` if `mcffmc_old` is specified instead |
| `mcffmc_old` | Previous value for mcffmc (default `None`) |
| `dmc_old` | Previous value for DMC (default 6) |
| `dc_old` | Previous value for DC (default 15) |
| `mcgfmc_matted_old` | Previous value for mcgfmc_matted (default 16.31) |
| `mcgfmc_standing_old` | Previous value for mcgfmc_standing (default 16.31) |
| `prec_cumulative` | Cumulative precipitation this rainfall (default 0) |
| `canopy_drying` | Consecutive hours of no rain (default 0). 5 hours or more set to 0 |
| `silent` | Suppress informative print statements (default False) |
| `round_out` | Decimal places to truncate output values to (default 4). Set to `None` for no rounding |

### Output
The result of `hFWI()` is a copy of the input DataFrame, with output columns added, described below. This means all columns from the input, even ones that are unused, are still preserved in the output. 

| Column | Description |
| --- | --- |
| `grass_fuel_load` | Density of grassland fuels (if not provided) |
| `percent_cured` | Fraction of cured grassland fuels (if not provided) |
| `solrad` | Solar radiation (if not provided) |
| `sunrise` | Hour of sunrise |
| `sunset` | Hour of sunset |
| `sunlight_hours` | Number of hours between sunrise and sunset |
| `mcffmc` | Fine fuel moisture content |
| `ffmc` | Fine Fuel Moisture Code |
| `dmc` | Duff Moisture Code |
| `dc` | Drought Code |
| `isi` | Initial Spread Index |
| `bui` | Buildup Index |
| `fwi` | Fire Weather Index |
| `dsr` | Daily Severity Rating |
| `mcgfmc_matted` | Matted grassland fuel moisture content |
| `mcgfmc_standing` | Standing grassland fuel moisture content |
| `gfmc` | Grassland Fuel Moisture Code |
| `gsi` | Grassland Spread Index |
| `gfwi` | Grassland Fire Weather Index |
| `prec_cumulative` | Cumulative precipitation this rainfall |
| `canopy_drying` | Consecutive hours of no rain. 5 hours or more set to 0 |

## Daily Summaries
Hourly FWI components can be summarized in a variety of ways depending on usage and requirements. One way is to create a daily report, the method of which can be found in the **daily_summaries.py** script. `generate_daily_summaries()` boils down the hourly data into daily metrics, which means every row in the output now represents a day.

To align more accurately with the typical daily fire behaviour cycle, the "reset hour" for a day can be redefined away from midnight (see `reset_hr` parameter below). By default, we use 05:00 (12 hours opposite 17:00), which means the 24 hours summarized are between 05:00 of the listed day and 04:00 of the next day (instead of 00:00 to 23:00). The first or last days are left out if they are represented by 12 or fewer hours of data.

### Parameters

```python
generate_daily_summaries(hourly_FWI, reset_hr = 5, silent = False, round_out = 4)
```

| Parameter | Description |
| --- | --- |
| `hourly_FWI` | DataFrame produced by `hFWI()` (see <a href="#hourly-fwi" target="_self">Hourly FWI</a> section above) |
| `reset_hr` | The boundary between days, instead of midnight (default 5) |
| `silent` | Suppress informative print statements (default False) |
| `round_out` | Decimal places to truncate output values to (default 4). Set to `None` for no rounding |

### Output

| Parameter | Description |
| --- | --- |
| `id` | Unique identifier for weather station or location |
| `yr` | Year |
| `mon` | Month of year |
| `day` | Day of month |
| `sunrise` | Hour of sunrise |
| `sunset` | Hour of sunset |
| `peak_hr` | Expected hour of daily maximum fire behaviour. Set as the hour of maximum ISI calculated using a smoothed wind speed (see `ws_smooth`), or 17:00 if daily maximum FFMC is less than 85 |
| `duration` | Expected number of hours in the daily burning window. Calculated as the number of hours (possibly discontinuous) where `isi_smooth` is greater than 5 |
| `ffmc` | Fine Fuel Moisture Code at `peak_hr` |
| `dmc` | Duff Moisture Code at `peak_hr` |
| `dc` | Drought Code at `peak_hr` |
| `isi` | Initial Spread Index at `peak_hr` |
| `bui` | Buildup Index at `peak_hr` |
| `fwi` | Fire Weather Index at `peak_hr` |
| `dsr` | Daily Severity Rating at `peak_hr` |
| `gfmc` | Grassland Fuel Moisture Code at `peak_hr` |
| `gsi` | Grassland Spread Index at `peak_hr` |
| `gfwi` | Grassland Fire Weather Index at `peak_hr` |
| `ws_smooth` | Smoothed 10 m open wind speed at `peak_hr`. Smoothing calculated as every 24 hours being passed through a [1,4,6,4,1] binomial filter |
| `isi_smooth` | ISI calculated using a smoothed wind speed at `peak_hr` |
| `gsi_smooth` | GSI calculated using a smoothed wind speed at `peak_hr` |

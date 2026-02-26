<a href="../../tutorials#daily-to-hourly" target="_self" style="float: left;"> back to Tutorials </a>
<a href="https://cffdrs.github.io/website_fr/tutoriels/quotidien_a_horaire_C" target="_self" style="float: right;"> Français </a>
<br>
<br>

# Daily to Hourly Tutorial - C

*Last updated: February 27th, 2026*

## C files

This tutorial will show you how to compile C code and run the executable in a Windows environment. This can be done in PowerShell or Command Prompt, which are included with Windows. The tutorial code and file are written in PowerShell, although the commands in this tutorial can be used for either.  

The following files can be found on the [cffdrs-ng GitHub repository](https://github.com/nrcan-cfs-fire/cffdrs-ng/tree/main):  

- data/
    - [**PRF2007_daily_wx_C-format.csv**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/data/PRF2007_daily_wx_C-format.csv)
- FWI/
    - C/
        - tutorial/
            - [**tutorial_daily_to_hourly.ps1**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/FWI/C/tutorial/tutorial_daily_to_hourly.ps1)
        - [**make_hourly.c**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/FWI/C/make_hourly.c)
        - [**make_minmax.c**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/FWI/C/make_minmax.c)
        - [**util.c**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/FWI/C/util.c)
        - [**util.h**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/FWI/C/util.h)

If you are unfamiliar with GitHub, there are many options for you to retrieve the code and data files:

1. *Download each file* to your computer individually. On the file's GitHub page (e.g. [**PRF2007_daily_wx_C-format.csv**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/data/PRF2007_daily_wx.csv)), find the "More file actions" button at the top-right side of the website (denoted "..."), and select "Download". This will begin downloading based on your browser settings. Repeat this for every file.
2. *Download the whole repository* to your computer. See the [GitHub documentation](https://docs.github.com/en/get-started/start-your-journey/downloading-files-from-github) for more information.
3. *Clone* the whole repository to your computer with Git. See the [GitHub documentation](https://docs.github.com/en/get-started/start-your-journey/downloading-files-from-github) for more information.
4. *Fork* the repository to create a new repository on GitHub. See the [GitHub documentation](https://docs.github.com/en/get-started/start-your-journey/downloading-files-from-github) for more information.

## Data
**NOTE: The C version can only handle one station for one continuous season at a time!** See the Python or R versions to be able to run multiple stations with multiple years at once.  

**PRF2007_daily_wx_C-format.csv** contains daily weather which was reduced from hourly data specifically for this tutorial. Temperature, relative humidity, and wind speed data are taken from noon Local Standard Time (LST), or in this case the equivalent 13:00 Local Daylight Time (LDT). Hourly precipitation is summed over 24 hours ending at the same hour as the other weather variables. The original hourly data is from a Petawawa Research Forest (PRF) weather station during the 2007 field season. The data has no gaps and is sorted sequentially by time, which are requirements for the input data.

Columns that are included and required for converting daily weather data to daily high and low (minmax) data are: year (`yr`), month (`mon`), day (`day`), temperature [°C] (`temp`), relative humidity [%] (`rh`), wind speed [km/h] (`ws`), and daily precipitation [mm] (`prec`).

Columns that are required for converting daily minmax data to hourly data are: the output columns from converting daily to minmax, latitude [DD] (`lat`), and longitude [DD] (`long`).

The **C-format** version differs from [**PRF2007_daily_wx.csv**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/data/PRF2007_daily_wx.csv) due to the strict requirements in the C version for column names, order, and case.

## Steps

### Open a terminal

To run the C code in Windows, it first needs to be compiled into an executable (.exe) file. This can be done in [Windows Terminal](https://aka.ms/terminal), which is a default Windows application.  

By default, it should open a Windows PowerShell tab/profile where we will run commands for the rest of the tutorial. First, notice that the path next to the prompt should be to your Windows user folder.

```ps
PS C:\Users\username>
```

Navigate from here to the folder where the .c and .h code files are located with `cd` (change directory) and `dir` (list current directory contents) commands. Otherwise, you will need to specify the location of each file every time one is called.  

Open the **tutorial_daily_to_hourly.ps1** code file. You can either follow the code and comments in the file or continue on this page (both include the same code and content).

### Compile make_minmax and make_hourly
To predict minmax weather data from daily data, the code files to compile are: **make_minmax.c** and **util.c**. The corresponding **util.h** header file needs to be in the same folder, but does not need to be invoked directly. One compiler option is [`gcc`](https://gcc.gnu.org/)
```ps
gcc -o daily_to_minmax make_minmax.c util.c
```

The prompt should return with no comments if the code was compiled successfully, and a new file should be created in the current folder named **daily_to_minmax.exe**. The name of the executable (.exe) file is specified after the `-o` option above.  

To predict hourly weather data from minmax data, the code files to compile are: **make_hourly.c** and **util.c**.
```ps
gcc -o minmax_to_hourly make_hourly.c util.c
```

### Convert daily to minmax
Details about the **daily_to_minmax.exe** file can be found by running the compiled executable with no arguments.

```ps
./daily_to_minmax.exe
```
```ps
########
help/usage:
path\to\code\folder\daily_to_minmax.exe input output [silent]

argument descriptions:
input        Input csv data file
output       Output csv file name and location
silent       Suppresses informative print statements (default false)
########
```

Now converting daily weather data to minmax.

```ps
./daily_to_minmax.exe ../../data/PRF2007_daily_wx_C-format.csv
    ../../data/PRF2007_dailyminmax_out.csv
```
```ps
########
FWI2025: Make Min/Max Inputs (YYYY-MM-DD)

Opening input file >>> ../../data/PRF2007_daily_wx_C-format.csv
Saving outputs to file >>> ../../data/PRF2007_dailyminmax_out.csv

Predicting daily min/max weather
########
```

This will place our outputs in a new CSV file called **PRF2007_dailyminmax_out.csv**.

> Tip: if the CSV data file is in a different folder than the code and executable file, you can specify a relative path with ".." indicating one folder up in the hierarchy. In the case of the [cffdrs-ng GitHub repository](https://github.com/nrcan-cfs-fire/cffdrs-ng/tree/main) structure, from the **C** folder the relative path of the data file can be specified as **../../data/PRF2007_daily_wx_C-format.csv**, which is shown above. This indicates to go up one folder to **FWI**, and then another folder to **cffdrs-ng** where the **data** folder and file resides.

### Convert minmax to hourly
Details about the **minmax_to_hourly.exe** file can be found by running the compiled executable with no arguments.

```ps
./minmax_to_hourly.exe
```
```ps
########
help/usage:
path\to\code\folder\minmax_to_hourly.exe input output timezone [prec_hr] [silent]

argument descriptions:
input        Input csv data file
output       Output csv file name and location
timezone     UTC offset
prec_hr      Hour when daily precipitation occurs (default sunrise)
silent       Suppresses informative print statements (default false)
########
```

The UTC offset for the sample PRF2007 dataset is -4 (for Eastern Daylight Time). Daily precipitation is placed at one hour of each day, controlled by the `prec_hr` parameter. By default it is placed at the calculated hour of sunrise, but an integer hour can be specified instead.

```ps
./minmax_to_hourly.exe ../../data/PRF2007_dailyminmax_out.csv
    ../../data/PRF2007_hourly_out.csv -4
```
```ps
########
FWI2025: Make Hourly Inputs (YYYY-MM-DD)

Opening input file >>> ../../data/PRF2007_hourly_out.csv   
Saving outputs to file >>> ../../data/PRF2007_hourly_out.csv

Predicting hourly weather
########
```

This will place our outputs in a new CSV file called **PRF2007_hourly_out.csv**.

## Appendix: Minmax to Hourly Parameters
The process to predict hourly weather data from daily minmax data is controlled by timing and decay parameters for each weather variable. The first, alpha (α) parameter is the typical difference in time between sunrise and minimum temperature and wind speed (and maximum relative humidity). The second, beta (β) parameter is the typical difference in time between solar noon and maximum temperature and wind speed (and minimum relative humidity). The third, gamma (γ) parameter is the typical rate of exponential decay after sunset for temperature, relative humidity, and wind speed.  

Based on an analysis of historical weather across Canada, the default values are set as follows:

| Variable \ Coefficient       | α    | β    | γ    |
| ---------------------------- | :--: | :--: | :--: |
| Temperature                  | 0.0  | 2.75 | -1.9 |
| Relative Humidity            | 0.25 | 2.75 | -2.0 |
| Wind Speed                   | 1.0  | 1.5  | -1.3 |

For more information refer to [Appendix A of *The 2025 Update to the FWI System: Structure, Changes and Interpretation* info report](https://ostrnrcan-dostrncan.canada.ca/handle/1845/347500).  

In the code, these values are specified at the top of [**make_hourly.c**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/FWI/C/make_hourly.c) in three double arrays (one for each weather variable). To change the values, edit these arrays and save the script. Then <a href="#compile-make_minmax-and-make_hourly" target="_self"> recompile **make_hourly.c**</a>.

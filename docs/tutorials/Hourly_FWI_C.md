<a href="../../tutorials#hourly-fwi" target="_self" style="float: left;"> back to Tutorials </a>
<a aria-disabled="true" target="_self" style="float: right;"> Français </a>
<br>
<br>

# Hourly FWI Tutorial - C

*Last updated: December 10th, 2025*

## C files

This tutorial will show you how to compile the FWI2025 C code and run the executable with an example hourly weather dataset in a Windows environment. This can be done in PowerShell or Command Prompt, which are included with Windows. The tutorial code and file are written in PowerShell, although the commands in this tutorial can be used for either.  

The following files can be found on the [cffdrs-ng GitHub repository](https://github.com/nrcan-cfs-fire/cffdrs-ng/tree/main):  

- data/
    - [**PRF2007_hourly_wx_C-format.csv**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/data/PRF2007_hourly_wx_C-format.csv)
- FWI/
    - C/
        - tutorial/
            - [**tutorial_hourly_FWI.ps1**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/FWI/C/tutorial/tutorial_hourly_FWI.ps1)
        - [**NG_FWI_main.c**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/FWI/C/NG_FWI_main.c)
        - [**NG_FWI.c**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/FWI/C/NG_FWI.c)
        - [**NG_FWI.h**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/FWI/C/NG_FWI.h)
        - [**util.c**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/FWI/C/util.c)
        - [**util.h**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/FWI/C/util.h)
        - [**daily_summaries.c**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/FWI/C/daily_summaries.c)

If you are unfamiliar with GitHub, there are many options for you to retrieve the code and data files:

1. *Download each file* to your computer individually. On the file's GitHub page (e.g. [**PRF2007_hourly_wx_C-format.csv**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/data/PRF2007_hourly_wx_C-format.csv)), find the "More file actions" button at the top-right side of the website (denoted "..."), and select "Download". This will begin downloading based on your browser settings. Repeat this for every file.
2. *Download the whole repository* to your computer. See the [GitHub documentation](https://docs.github.com/en/get-started/start-your-journey/downloading-files-from-github) for more information.
3. *Clone* the whole repository to your computer with Git. See the [GitHub documentation](https://docs.github.com/en/get-started/start-your-journey/downloading-files-from-github) for more information.
4. *Fork* the repository to create a new repository on GitHub. See the [GitHub documentation](https://docs.github.com/en/get-started/start-your-journey/downloading-files-from-github) for more information.

## Data
**NOTE: The C version can only handle one station for one continuous season at a time!** See the Python or R versions to be able to run multiple stations with multiple years at once.  

**PRF2007_hourly_wx_C-format.csv** contains hourly weather recorded from a Petawawa Research Forest (PRF) weather station during the 2007 field season. The data has no gaps and is sorted sequentially by time, which is a requirement for FWI2025 input data. If you would like guidance on how to fill in missing weather data for your situation, check the [CFFDRS Weather Guide](https://ostrnrcan-dostrncan.canada.ca/handle/1845/219568) or [reach out to us](../../contact)! Grassland fuel load (`grass_fuel_load`), grassland curing (`percent_cured`), and solar radiation (`solrad`) are not included, but these are optional inputs and they will be automatically set/calculated if not provided.

The **C-format** version differs from [**PRF2007_hourly_wx.csv**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/data/PRF2007_hourly_wx.csv) due to the strict requirements in the C version for column names, order, and case. Details can be found at <a href="../../code/FWI2025_C/#input-dataframe" target="_self"> FWI2025_C#input-dataframe</a>.

## Steps

### Open a terminal

To run the C code in Windows, it first needs to be compiled into an executable (.exe) file. This can be done in [Windows Terminal](https://aka.ms/terminal), which is a default Windows application.  

By default, it should open a Windows PowerShell tab/profile where we will run commands for the rest of the tutorial. First, notice that the path next to the prompt should be to your Windows user folder.

```ps
PS C:\Users\username>
```

Navigate from here to the folder where the .c and .h code files are located with `cd` (change directory) and `dir` (list current directory contents) commands. Otherwise, you will need to specify the location of each file every time one is called.  

### Compile FWI2025
To calculate hourly FWI, the code files to compile are: **NG_FWI_main.c**, **NG_FWI.c**, and **util.c**. The corresponding **NG_FWI.h** and **util.h** header files need to be in the same folder, but do not need to be invoked directly. One compiler option is [`gcc`](https://gcc.gnu.org/)
```ps
gcc -o NG_FWI NG_FWI_main.c NG_FWI.c util.c
```

The prompt should return with no comments if the code was compiled successfully, and a new file should be created in the current folder named **NG_FWI.exe**. The name of the executable (.exe) file is specified after the `-o` option above.

### Run FWI2025
The **NG_FWI.exe** file does not have to be run with all function arguments if you want to use default season startup values. The only required parameters are the input data file, an output file location/name, and timezone (UTC offset). Details can be found in the code documentation page at <a href="../../code/FWI2025_C/#parameters" target="_self"> FWI2025 - C#parameters</a> or by running the compiled executable with no arguments.

```ps
./NG_FWI.exe
```
```ps
########
help/usage:
path\to\code\folder\NG_FWI.exe input output timezone
[ffmc_old] [mcffmc_old] [dmc_old] [dc_old] [mcgfmc_matted_old] [mcgfmc_standing_old]
[prec_cumulative] [canopy_drying]

positional arguments:
input                 Input csv data file
...
```

For this tutorial, we will leave all the optional parameters to default. The UTC offset for the sample PRF2007 dataset is -4 (for Eastern Daylight Time).

```ps
./NG_FWI.exe ../../data/PRF2007_hourly_wx_C-format.csv PRF2007_hourly_FWI.csv -4
```
```ps
Opening input file >>> ../../data/PRF2007_hourly_wx_C-format.csv
Saving outputs to file >>> PRF2007_hourly_FWI.csv

########
Startup values used:
FFMC = 85.0 or mcffmc = -1.0 %
DMC = 6.0 and DC = 15.0
mcgfmc matted = 16.3075 % and standing = 16.3075 %
cumulative precipitation = 0.0 mm and canopy drying = 0
########
```

This will place our outputs in a new CSV file called **PRF2007_hourly_FWI.csv**. Compare your outputs with our standard outputs in [**PRF2007_standard_hourly_FWI.csv**](https://github.com/nrcan-cfs-fire/cffdrs-ng/blob/main/data/PRF2007_standard_hourly_FWI.csv).

> Tip: if the CSV data file is in a different folder than the code and executable file, you can specify a relative path with ".." indicating one folder up in the hierarchy. In the case of the [cffdrs-ng GitHub repository](https://github.com/nrcan-cfs-fire/cffdrs-ng/tree/main) structure, from the **C** folder the relative path of the data file can be specified as **../../data/PRF2007_hourly_wx.csv**, which is shown above. This indicates to go up one folder to **FWI**, and then another folder to **cffdrs-ng** where the **data** folder and file resides.

### Calculate daily summaries
Calculate outputs like peak burn time and number of hours of spread potential. Going through the process again, the files to compile to calculate daily summaries are: **daily_summaries.c**, **NG_FWI.c**, and **util.c**. Ensure the corresponding **NG_FWI.h** and **util.h** header files are in the same folder.

```ps
gcc -o daily_summaries daily_summaries.c NG_FWI.c util.c
```

The required parameters for **daily_summaries.exe** are the input data file (output of **NG_FWI.exe**) and an output file location/name. Details of the optional `reset_hr` parameter can be found in the code documentation page at <a aria-disabled="true" target="_self"> FWI2025 - C#daily-summaries</a>.

```ps
./daily_summaries.exe PRF2007_hourly_FWI.csv PRF2007_daily_report.csv
```

From here, the output CSV files can be opened and converted for further analysis or plotted for visualization.

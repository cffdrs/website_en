<a href="https://cffdrs.github.io/website_fr/code/" target="_self" style="float: right;"> Français </a>

# Code

## Repository
The [cffdrs-ng GitHub repository](https://github.com/nrcan-cfs-fire/cffdrs-ng) contains the up-to-date code for the CFFDRS2025 modules in three programming languages: *C*, *Python*, and *R*. These three versions are written to produce the same results so users can choose the version that fits their own software systems.

See the [repository README](https://github.com/nrcan-cfs-fire/cffdrs-ng?tab=readme-ov-file#readme) for more information about how to provide bug reports, the structure of the repository, and more. For email notifications about code updates, you can specify the type of updates to receive when you <a href="../resources/#sign-up" target="_self">join our mailing list</a>.

<img 
    style="display: block;
           width: 75px;
           padding: 5px;
           margin: 10px 25px 0px 0px;
           float: left;
           border-radius: 5px;
           background-color: #FFFFFF!important;"
    src="../img/CFFDRS logo.png" 
    alt="CFFDRS1992 logo">
</img>

The previous CFFDRS1992 code can still be found on the [CFFDRS GitHub](https://github.com/cffdrs), while the R documentation can be found on the [CFFDRS CRAN page](https://cran.r-project.org/web/packages/cffdrs/).

<br>

## Capabilities
| Programming Language                                  | C   | Python | R   |
| ----------------------------------------------------- | :-: | :----: | :-: |
| Calculate hourly FWI codes and indices                | ✔️ | ✔️     | ✔️ |
| Calculate sunrise, sunset, and solar radiation        | ✔️ | ✔️     | ✔️ |
| Calculate grassland code and indices                  | ✔️ | ✔️     | ✔️ |
| Calculate daily summaries and a peak burn time        | ✔️ | ✔️     | ✔️ |
| Convert daily noon to daily min/max weather data      | ✔️ | ✔️     | ✔️ |
| Convert daily min/max to hourly weather data          | ✔️ | ✔️     | ✔️ |
| Input multiple stations at a time                     | ❌ | ✔️     | ✔️ |
| Splitting for inputs with multiple years at a time    | ❌ | ✔️     | ✔️ |


## Documentation
### FWI2025
The [Canadian Forest Fire Weather Index (FWI)](https://cwfis.cfs.nrcan.gc.ca/background/summary/fwi) is a major system of the CFFDRS. FWI2025 is the next generation FWI system found in CFFDRS2025. Select a programming language below to see a description of the required code files and input data along with documentation of the main functions.

<div class="text-center">
	<button class="btn btn-dark" onclick="location.href='../code/FWI2025_C'">FWI2025 <br> C</button>
	&emsp;
    <button class="btn btn-dark" onclick="location.href='../code/FWI2025_Python'">FWI2025 <br> Python</button>
	&emsp;
	<button class="btn btn-dark" onclick="location.href='../code/FWI2025_R'">FWI2025 <br> R</button>
</div>

## License
The [NG-CFFDRS scripts](https://github.com/nrcan-cfs-fire/cffdrs-ng) are licensed under the GNU General Public License version 2. A copy of the license is available on the [GitHub repository](https://github.com/nrcan-cfs-fire/cffdrs-ng?tab=GPL-2.0-1-ov-file#readme).

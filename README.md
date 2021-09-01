# rWRF: Running WRF Simulation on R Console

This script is using for running WRF with R Programming Language. You should install [WRF](https://github.com/wrf-model/WRF) and [WPS](https://github.com/wrf-model/WPS) to your Linux machine. Before installing WRF, you should install dependencies package to run it, like NetCDF, mpich (*optional*), HDF5, zlib, libpng, and jasper. For tutorial, You can access this website <https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compilation_tutorial.php>

This script was tested on Windows Subsystem Linux with Ubuntu Distro

> THIS SCRIPT CAN'T RUN ON WINDOWS MACHINE, EXCEPT YOU HAVE WINDOWS SUBSYSTEM LINUX (WSL)

## How to Use?

If You have downloaded the data (e.g. GFS, ERA5, etc), follow these steps

1.  Open R with your bash terminal

    ```{bash}
    R
    ```

2.  You should edit `rWRF_dir` at **Scripts/run-simulation.R** script according to rWRF directory. In my script, I put `rWRF_dir` at **/mnt/f/rWRF**

3.  Run **Scripts/run-simulation.R**

    ```{r}
    source("Scripts/run-simulation.R")
    ```

4.  Follow some instructions that appear in your terminal

## Download GFS Data

[Global Forecast System (GFS)](https://www.emc.ncep.noaa.gov/emc/pages/numerical_forecast_systems/gfs.php) is a global numerical weather prediction system run by the U.S National Weather Service. Now, GFS has 0.25 degree spatial resolution and produces forecasts data up to 16 days. I provide R script which only used to download GFS data through Amazon Web Service (AWS) Open Data, [https://noaa-gfs-bdp-pds.s3.amazonaws.com](https://noaa-gfs-bdp-pds.s3.amazonaws.com/) or NOAA server, <https://nomads.ncep.noaa.gov>. There are two scripts: `gfs-forecast-gribfilter.R` and `gfs-forecast-aws.R`. At NOAA server, You can select the specific location You want download. It means the download file size is not too big than AWS open data. But, You can only download the data for the last 10 days. `gfs-forecast-gribfilter.R` script is suitable for automation download with `crontab`.

For `gfs-forecast-gribfilter.R`, You only type on your bash terminal like this

```{bash}
cd rWRF
START_TIME="2021-08-01 00:00:00" \
END_TIME="2021-08-10 00:00:00" \
RES="1p00" \ 
INTERVAL=6 \
ISSUED_TIME=0 \
BOTTOM_LAT=-11 \
TOP_LAT=11 \
LEFT_LON=90 \
RIGHT_LON=150 \
Rscript Scripts/gfs-forecast-realtime.R
```

And for `gfs-forecast-gribfilter.R`, You can type same as script above without `BOTTOM_LAT`, `TOP_LAT`, `LEFT_LON`, and `RIGHT_LON`. See table below for the environment variable description.

| Environment Variable |       Example        |                                           Description                                           |
|:--------------------:|:--------------------:|:-----------------------------------------------------------------------------------------------:|
|     `START_TIME`     | 2021-08-01 00:00:00  | start time (***required***) with format yyyy-mm-dd HH:MM:SS. Value of HH only 00, 06, 12, or 18 |
|      `END_TIME`      | 2021-08-03 00:00:00  |                                    end time (***required***)                                    |
|        `RES`         | 1p00 or 0p50 or 0p25 |    spatial resolution (1p00: 1 degree; 0p50: 0.5 degree; 0p25: 0.25 degree) (***required***)    |
|      `INTERVAL`      |   3, 6, 12, or 24    |            interval forecast time or temporal resolution (in hour) (***required***)             |
|    `ISSUED_TIME`     |          0           |  issued time which GFS data has been ran, must be same as HH in `START_TIME` (***required***)   |
|     `BOTTOM_LAT`     |         -11          |                              bottom latitude (***default***: -90)                               |
|      `TOP_LAT`       |          11          |                                top latitude (***default***: 90)                                 |
|      `LEFT_LON`      |          95          |                                left longitude (***default***: 0)                                |
|     `RIGHT_LON`      |         150          |                              right longitude (***default***: 360)                               |

#' This script is used for running the WRF model
#' Make sure You have installed WRF model & WRF Pre-Processing (WPS)
#' In this script, I have installed WRF model in ~/WRF directory
#' I have installed WRF-ARW with GFS input data
#' I can't provide for all WRF simulation, like WRF-Chem, WRF-Fire, and WRF-Hydro in this script
#' 

# Export library
library(glue)
library(crayon)

# rWRF Directory
rWRF_dir  <- "/mnt/f/rWRF"

# Make working directory
work_dir <- glue("{rWRF_dir}/WRF-sim")

if (!dir.exists(work_dir)) {
  dir.create(work_dir)
  print(glue("Your working directory for simulation at {work_dir}"))
}

# set working directory for WRF simulation
setwd(work_dir)



# Where is the WRF directory?
wrf_dir <- readline("Please type WRF directory:")       # /home/absen/WRF/WRF
wps_dir <- readline("Please type WPS directory:")

# Choose the specific time for simulation
cat("Type start and end time simulation with format yyyy-mm-dd HH:MM:SS (e.g. 2021-08-01 00:00:00): \n")
date_str <- readline("START time:")
date_end <- readline("END time:")

# Make your own namelist.wps for specific location
source(glue("{rWRF_dir}/Scripts/namelist-wps.R"))

# Run WPS Program
# Check if met_em* exists
if (!file.exists(list.files(pattern = "nc$")[1])) {
  source(glue("{rWRF_dir}/Scripts/runWPS.R"))
}

# Run WRF Program
# Make your own namelist.input 
source(glue("{rWRF_dir}/Scripts/namelist-input.R"))
# Linked all WRF program
system(glue("ln -sf {wrf_dir}/run/* ."))

# 1. real.exe
cat("Please wait, real.exe is running !!! \n")
system("./real.exe")

if (!file.exists("wrfbdy_d01") | !file.exists("wrfinput_d01")) {
  stop("Please check rsl.error.000* for any errors !!!")
}

# 2. wrf.exe
cat("Please wait, wrf.exe is running !!! \n")
system("./wrf.exe")

if (!file.exists(list.files(pattern = "wrfout*")[1])) {
  cat(red("Please check rsl.error.000* for any errors !!!"))
}
#' This script is used for downloading Global Forecast System data at AWS Open Data
#' https://noaa-gfs-bdp-pds.s3.amazonaws.com
#' These data were available from 26 February 2021 until present
#' If you want more historical data, You can visit https://rda.ucar.edu

require(glue, quietly = T)
require(curl, quietly = T)
require(crayon, quietly = T)

gfs_forecast_download <- function(date_str, date_end, res, interval, issued_time) {
  # convert interval class to integer
  interval <- as.integer(interval)
  
  # check data resolution
  if (res != "0p25" & res != "0p50" & res != "1p00") {
    stop(cat(red("Grid data resolution must be 0p25 (0.25 deg), 0p50 (0.50 deg), or 1p00 (1.00 deg)!", "\n")))
  }
  
  # date_str and date_end must be string with form "YYYY-MM-DD HH:MM:SS"
  if (!class(date_str) == "character" & !class(date_end) == "character") {
    stop(cat(red("date_str and date_end must be a character class!", "\n")))
  }
  
  # convert to POSIXct
  date_str <- as.POSIXct(date_str, tz="UTC")
  date_end <- as.POSIXct(date_end, tz="UTC")
  
  # format date_str and date_end form
  yy1 <- format(date_str, "%Y"); yy2 <- format(date_end, "%Y")
  mm1 <- format(date_str, "%m"); mm2 <- format(date_end, "%m")
  dd1 <- format(date_str, "%d"); dd2 <- format(date_end, "%d")
  HH1 <- format(date_str, "%H"); HH2 <- format(date_end, "%H")
  
  # check date
  if (date_end < date_str) {stop("END_DATE must be larger than START_DATE!")}
  
  # check time at start date, must be same as ISSUED_TIME 
  if (HH1 != issued_time) {
    stop(cat(red("hour at START_DATE must be same as ISSUED_TIME! (e.g. 2021-01-01 12:00:00; ISSUED_TIME=12)", "\n")))}
  
  # output folder name
  ofold <- glue("{yy1}{mm1}{dd1}")
  
  # Check folder output
  if (!dir.exists(ofold)) {
    dir.create(ofold)
    dir.create(glue("{ofold}/{HH1}"))
  } else if (dir.exists(ofold) & !dir.exists(glue("{ofold}/{HH1}"))) {
    dir.create(glue("{ofold}/{HH1}"))
  }
  
  # difference time between start date and end date for downloading forecast data
  diff_time <- difftime(date_end, date_str, units = "hours")
  if (diff_time > 384) {stop(cat(red("Maximum forecast up to 384 hours!","\n")))} 
  
  # check if forecast time > 0
  forecast <- as.integer(diff_time)
  
  if (forecast == 0 & interval != 0) {
    cat(red(glue("You just download 1 data at {date_str}"), "\n"))
    frc_range <- sprintf("%.3d", forecast)
  } else if (interval == 0) {
    stop(cat(red("interval must be 1, 3, 6, or 12!", "\n")))
  } else {
    if (res == "0p50" | res == "1p00" & interval == 1){
      stop(cat(red("interval must be 3, 6, or 12!", "\n")))
    } else {
      frc_range <- seq(0, forecast, interval)
      frc_range <- sprintf("%.3d", frc_range)
    }
  }
  
  # print
  curdir <- getwd()
  print(glue("You will download GFS data with {res} deg from {date_str} {HH1}:00 to 
             {date_end} {HH2}:00 UTC with {forecast} hours forecast time
             with issued time {issued_time}.
             
             Your download directory: {curdir}/{yy1}{mm1}{dd1}/{HH1}"))
  
  # download file
  # there are some changing with the destination folder before 23 March 2021
  url_ <- "https://noaa-gfs-bdp-pds.s3.amazonaws.com/"
  if (as.Date(date_str) <= as.Date("2021-03-22")){
    # without atmos folder
    for (frc in frc_range) {
      curl_download(glue("{url_}gfs.{yy1}{mm1}{dd1}/{issued_time}/gfs.t{issued_time}z.pgrb2.{res}.f{frc}"), 
                    glue("{yy1}{mm1}{dd1}/{HH1}/gfs.t{issued_time}z.{yy1}{mm1}{dd1}.pgrb2.{res}.f{frc}"),
                    quiet = FALSE)
    }
    # with atmos folder
  } else {
    for (frc in frc_range) {
      curl_download(glue("{url_}gfs.{yy1}{mm1}{dd1}/{issued_time}/atmos/gfs.t{issued_time}z.pgrb2.{res}.f{frc}"), 
                    glue("{yy1}{mm1}{dd1}/{HH1}/gfs.t{issued_time}z.{yy1}{mm1}{dd1}.pgrb2.{res}.f{frc}"),
                    quiet = FALSE)
    }  
  }
}

date_str    <- Sys.getenv("START_TIME")
date_end    <- Sys.getenv("END_TIME")
resolution  <- Sys.getenv("RES")
interval    <- Sys.getenv("INTERVAL")
issued_time <- Sys.getenv("ISSUED_TIME") 

# for testing
# date_str = "2021-03-02 00:00:00"
# date_end = "2021-03-03 00:00:00"

gfs_forecast_download(date_str, date_end, resolution, interval, issued_time)
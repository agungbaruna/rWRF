#' This script is used for generate namelist.wps for each parameters
#'  
#'   
#'    
namelist.wps <- function(date_str, date_end) {
  if (!file.exists("namelist.wps")){
    outfile <- file("namelist.wps")
  } else {
    system("mv namelist.wps namelist.wps.old")
    outfile <- file("namelist.wps")
  }
  
  # change date_str and date_end format
  date_str <- as.POSIXct(date_str, tz = "UTC")
  date_end <- as.POSIXct(date_end, tz = "UTC")
  
  yy1 <- format(date_str, "%Y"); yy2 <- format(date_end, "%Y")
  mm1 <- format(date_str, "%m"); mm2 <- format(date_end, "%m")
  dd1 <- format(date_str, "%d"); dd2 <- format(date_end, "%d")
  HH1 <- format(date_str, "%H"); HH2 <- format(date_end, "%H")

  writeLines(c(
         "&share",
         "wrf_core = 'ARW',",
    glue("max_dom = 2,"),
    glue("start_year  = {yy1}, {yy1},"),
    glue("start_month = {mm1}, {mm1},"),
    glue("start_day   = {dd1}, {dd1},"),
    glue("start_hour  = {HH1}, {HH1},"),
    glue("end_year    = {yy2}, {yy2},"),
    glue("end_month   = {mm2}, {mm2},"),
    glue("end_day     = {dd2}, {dd2},"),
    glue("end_hour    = {HH2}, {HH2},"),
    glue("interval_seconds = 21600,"),    # Perlu ditentukan lagi
         "io_form_geogrid = 2",
         "/",
    
         "&geogrid",
         "parent_id         =   1,   1,",
    glue("parent_grid_ratio =   1,   5,"),
    glue("i_parent_start    =   1,  39,"),
    glue("j_parent_start    =   1,  37,"),
    glue("e_we              =  90,  91,"),
    glue("e_sn              =  90,  91,"),
         "geog_data_res     = 'default','default',",
    glue("dx                = 10000,"),
    glue("dy                = 10000,"),
         "map_proj          = 'mercator',",
    glue("ref_lat           =  -1.867,"),
    glue("ref_lon           = 110.043,"),
    glue("truelat1          =  -1.867,"),
         "geog_data_path    = '/mnt/f/WRF/WPS_GEOG/'",
         "/",
    
         "&ungrib",
         "out_format = 'WPS',",
         "prefix     = 'FILE',",
         "/",
    
         "&metgrid",
         "fg_name        = 'FILE'",
         "io_form_metgrid = 2,",
         "/"), 
    outfile)
  
  close(outfile)
}

namelist.wps(date_str, date_end)
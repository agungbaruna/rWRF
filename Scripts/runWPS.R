# Linked all WPS program
# 1. Geogrid
system(glue("ln -sf {wps_dir}/geogrid && 
             ln -sf {wps_dir}/geogrid/geogrid.exe"))
# 2. Ungrib
system(glue("ln -sf {wps_dir}/ungrib/Variable_Tables/Vtable.GFS Vtable &&
             ln -sf {wps_dir}/link_grib.csh &&
             ln -sf {wps_dir}/ungrib && 
             ln -sf {wps_dir}/ungrib/ungrib.exe"))
# 3. Metgrid
system(glue("ln -sf {wps_dir}/metgrid && 
             ln -sf {wps_dir}/metgrid/metgrid.exe"))

# Run WPS Program
# 1. geogrid.exe
system("./geogrid.exe")
# 2. ungrib.exe
inp_folder <- readline("Please type GFS input file:")
system(glue("./link_grib.csh {inp_folder}/*"))
system("./ungrib.exe")
# 3. metgrid.exe
system("./metgrid.exe")
# Remove FILE*
system("rm FILE:*")
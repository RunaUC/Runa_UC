# Adding the IMOS climatology for the base period to the remapped CMIP anomalies
  # Written by Dave S for Runa
    # May 2023


# Notes -------------------------------------------------------------------

  # To complete the bias correction, we add the IMOS mean (also called a climatology - computed in step 5) back to the remapped anomalies 
  # 

# Packages ----------------------------------------------------------------

  library(tidyverse)
  library(raster)


# Folders and files -----------------------------------------------------------------

  input_folder <- "/Volumes/Runa_Disk/CMIP6_ensemble_remapannomalies" #*** Folder where masked remapped anomalies are
  output_folder <- "/Volumes/Runa_Disk/CMIP6_ensemble_addIMOS" #*** Make a new folder to put the results in
    if(!dir.exists(output_folder)) {dir.create(output_folder, recursive=TRUE)} # If the output folder doesn't exist, make it
  obs <- "/Volumes/Runa_Disk/annual_merged_IMOS/IMOS_data_timavg.nc" #*** The path and name of the IMOS mean we computed
  # Note that our IMOS data was in K, not C, so we need to convert
  obs_C <- obs %>% 
    gsub(".nc", "_Celcius.nc", .) # An ouput file name that indicates that the output is in deg C
  cdo_code <- paste0("cdo -expr,'sea_surface_temperature_day_night = sea_surface_temperature_day_night-273.15' ", obs, " ", obs_C) # Convert each value from K to C
    system(cdo_code)

# Function to do the masking -------------------------------------------

  do_add_clim <- function(f) {
    output_file <- basename(f) %>% # Get the input file name
      gsub("_remapped_masked", "", .) %>% # Remove "_remapped_masked" from the end of the file name
      gsub("_anomalies_", "_bc_", .) %>% # Replace the anomalies code in the file name with a code for bias corrected (bc)
      paste0(output_folder, "/", .) # Include the path
    cdo_code <- paste0("cdo -s -L -f nc4 -z zip ", # Zip the file up
                       "-add ", f, " ", # To the remapped regridded anomalies, add...
                       obs_C, " ", output_file) # The observed climatology (map of means)
    system(cdo_code)
  }

#  Do the work ------------------------------------------------------------

  files <- dir(input_folder, full.names = TRUE) # The files we want to process
  walk(files, do_add_clim) # Process all files at the same time
  
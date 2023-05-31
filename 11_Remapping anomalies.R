# Interpolating CMIP anomalies to the IMOS grid
  # Written by Dave S for Runa
    # May 2023


# Notes -------------------------------------------------------------------

  # Here, I use bilinear interpolation to remap the coarse CMIP data to the spatial extent and resolution of IMOS, filling missing cells with nearest neighbour.
  # This is hugely processor intensive, so I provide the results - no need to try this at home.

# Packages ---------------------------------------------------

 library(tidyverse)
 library(ncdf4)
 library(raster)
 library(furrr)

# Folders and files -----------------------------------------------------------------

  input_folder <- "/Volumes/Runa_Disk/CMIP6_ensemble_annomalies" #*** Folder where anomalies are
  output_folder <- "/Volumes/Runa_Disk/CMIP6_ensemble_remapannomalies" #*** Make a new folder to put the results in
    if(!dir.exists(output_folder)) {dir.create(output_folder, recursive=TRUE)} # If the output folder doesn't exist, make it
  msk <- "/Volumes/Runa_Disk/annual_merged_IMOS/IMOS_mask.nc" #*** The path and name of the IMOS mask we made
  # terminal_code <- paste0("ncrename -v sea_surface_temperature_day_night,tos ", msk) # Rename the SST variable in the mask to the same as the CMIP data
  #   system(terminal_code)
  

# Function to do the regridding -------------------------------------------

  do_regrid <- function(f) {
    output_file <- basename(f) %>% # Get the input file name
      gsub(".nc", "_remapped.nc", .) %>% # Add "_remapped" to the end of the file name
      paste0(output_folder, "/", .) # Include the path
    cdo_code <- paste0("cdo -s -L -f nc4 -z zip ", # Zip the file up
                       # "-mul ", msk, # Multiply the result of the lines, below by the mask to make land NA again
                       "-setmisstonn ", # Set missing values to the nearest neighbour value
                       "-remapbil,", msk, " ", f, " ", output_file) # Remap the anomaly file to the the scales of the IMOS mask using bilinear interpolation
    system(cdo_code)
  }

    
#  Do the work ------------------------------------------------------------

  files <- dir(input_folder, full.names = TRUE) # The files we want to process
  plan(multisession, workers = length(files)) # Setting up to run in parallel
    furrr::future_walk(files, do_regrid) # Process all files at the same time
  plan(sequential) # Go back to sequential (i.e., not parallel) processing
  
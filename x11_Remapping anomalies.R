# Interpolating CMIP anomalies to the IMOSS grid
  # Written by Dave S for Runa
    # May 2023


# Packages ----------------------------------------------------------------

  library(tidyverse)
  library(raster)
  library(ncdf4)
  library(furrr) # For parallel processing


# Folders and files -----------------------------------------------------------------

  input_folder <- "" #*** Folder where anomalies are
  output_folder <- "" #*** Make a new folder to put the results in
    if(!dir.exists(output_folder)) {dir.create(output_folder, recursive=TRUE)} # If the output folder doesn't exist, make it
  msk <- "" #*** The path and name of the IMOSS mask we made
  terminal_code <- paste0("ncrename -v sea_surface_temperature_day_night,tos ", msk) # Rename the SST variable in the mask to the same as the CMIP data
    system(terminal_code)
  


# Function to do the regridding -------------------------------------------

  do_regrid <- function(f) {
    output_file <- basename(f) %>% # Get the input file name
      gsub(".nc", "_remapped.nc", .) %>% # Add "_remapped" to the end of the file name
      paste0(output_folder, "/", .) # Include the path
    cdo_code <- paste0("cdo -s -L -f nc4 -z zip ", # Zip the file up
                       # "-mul ", msk, # Mutliply the result of the lines, below by the mask to make land NA again
                       "-setmisstonn ", # Set missing values to the nearest neighbour value
                       "-remapnn,", msk, " ", f, " ", output_file) # Remap the anomaly file to the the scales of the IMOS mask
    system(cdo_code)
  }

#  Do the work ------------------------------------------------------------

  files <- dir(input_folder, full.names = TRUE) # The files we want to process
  plan(multisession, workers = length(files)) # Setting up to run in parallel
    furrr::future_walk(files, do_regrid) # Process all files at the same time
  plan(sequential) # Go back to sequential (i.e., not parallel) processing
  
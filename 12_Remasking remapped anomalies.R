# Remasking the remapped CMIP anomalies using the IMOS mask
  # Written by Dave S for Runa
    # May 2023


# Notes -------------------------------------------------------------------

  # Because we filled coastal cells using nearest-neighbour SST, we need to turn land back to NA

# Packages ----------------------------------------------------------------

  library(tidyverse)
  library(raster)


# Folders and files -----------------------------------------------------------------

  input_folder <- "/Volumes/Runa_Disk/CMIP6_Anomalies_Regridded" #*** Folder where remapped anomalies are
  output_folder <- "/Volumes/Runa_Disk/CMIP6_ensemble_remask" #*** Make a new folder to put the results in
    if(!dir.exists(output_folder)) {dir.create(output_folder, recursive=TRUE)} # If the output folder doesn't exist, make it
  msk <- "/Volumes/Runa_Disk/annual_merged_IMOS/IMOS_mask.nc" #*** The path and name of the IMOS mask we made
  

# Function to do the masking -------------------------------------------

  do_mask_anomalies <- function(f) {
    output_file <- basename(f) %>% # Get the input file name
      gsub(".nc", "_masked.nc", .) %>% # Add "_remapped_masked" to the end of the file name
      paste0(output_folder, "/", .) # Include the path
    cdo_code <- paste0("cdo -s -L -f nc4 -z zip ", # Zip the file up
                       "-mul ", msk, " ", # Mutliply the result of the lines, below by the mask to make land NA again
                       f, " ", output_file) # Mask the remapped the anomaly file and save as output_file
    system(cdo_code)
  }

#  Do the work ------------------------------------------------------------

  files <- dir(input_folder, full.names = TRUE) # The files we want to process
  walk(files, do_mask_anomalies) # Process all files, one at a time
  
  
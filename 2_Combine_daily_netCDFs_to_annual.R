# Function that aggregates daily IMOS netCDFs by year and month
  # Written by Dave S
    # March 2023


# Packages ----------------------------------------------------------------

  library(tidyverse)
  library(ncdf4)
  # library(terra)
  # library(raster)


# Folders ----------------------------------------------------------------

  input_folder <- "/Volumes/BackPack/IMOS_Data"
  output_folder <- "/Volumes/BackPack/Monthly_IMOS_SST"
    if(!dir.exists(output_folder)) {dir.create(output_folder, recursive=TRUE)} # If the output folder doesn't exist, make it


# Function ----------------------------------------------------------------

  stack_IMOS_by_year_and_crop <- function(yr) {
    files <- dir(input_folder, # List all files in the input folder
                 full.names = TRUE) %>%  # Include the full path
      .[grepl(paste0(input_folder, "/", yr), .)] # Find only those with file names starting with the year we're after
    cdo_script <- paste0("cdo -s -L -f nc4 -z zip ", # Deploy cdo silently and zip the final netCDF to save space [don't forget the trailing space]
                         "-mergetime ", # Combine all the files into a single year, using their timestamp to arange them [tailing space, again]
                         "-sellonlatbox,150,160,-28,-240 ", # Crop to the bounds we selected originally when we wanted to use raster [tailing space, again]
                         "-selvar,sea_surface_temperature_day_night ", # Select ONLY the day/night SST, not forgetting the trailing space
                         paste0(files, collapse = " "), # Paste all the file names, one after another separated by spaces
                         " ", # A space, since the paste0, above didn't add a trailing space
                         paste0(output_folder, "/IMOSS_SST_", yr, ".nc")) # An output path and logical file name
    system(cdo_script) # Pass the script to the console. Note that cdo reads the code backwards, so selvar happens first, then crop, then merge
    }
  
  
# Do the work -------------------------------------------------------------

  years <- 1993:2014
  walk(years, stack_IMOS_by_year_and_crop) # For each year-month combo, run the function

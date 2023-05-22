# Function that aggregates daily IMOS netCDFs by year and month
  # Written by Dave S
    # March 2023


# Packages ----------------------------------------------------------------

  library(tidyverse)
  library(ncdf4)


# Folders ----------------------------------------------------------------

  input_folder <- "/Volumes/RunaSRPDisk/IMOS_Data"
  output_folder <- "/Volumes/RunaSRPDisk/Annual_IMOS_SST"
    if(!dir.exists(output_folder)) {dir.create(output_folder, recursive=TRUE)} # If the output folder doesn't exist, make it

# Function to make netCDFs of just the day-night SST for the study area --------

    get_ann_sst <- function(yr) { # Runs get_sst each year, setting up first and cleaning up after
      tmp_folder <- paste0(output_folder, # As new subfolder of the output folder
                           "/tmp") # Call it "tmp
      terminal_code <- paste0("mkdir ", tmp_folder) # Make a new temporary folder
        system(terminal_code) # Execute that code in terminal
      get_sst <- function(f) { # Selects just the day-night SST, crops to our extent and saves
        out_name <- paste0(output_folder, "/tmp/", basename(f)) #  An output path and logical file name
        cdo_script <- paste0("cdo -s -L -f nc4 -z zip ", # Deploy CDO silently and zip the final netCDF to save space [don't forget the trailing space]
                             "-sellonlatbox,150,160,-28,-24 ", # Crop to the bounds we selected originally when we wanted to use raster [tailing space, again]
                             "-selvar,sea_surface_temperature_day_night ", # Select ONLY the day/night SST, not forgetting the trailing space
                             f, # The file we're working with 
                             " ", # A space, since the paste0, above didn't add a trailing space
                             out_name) # Our output path and file name
          system(cdo_script) # Pass the script to the terminal Note that CDO reads the code backwards, so selvar happens first, then crop, then zip
          }
        files <- dir(input_folder, # List all files in the input folder
                     full.names = TRUE) %>%  # Include the full path
          .[grepl(paste0(input_folder, "/", yr), .)] # Find only those with file names starting with the year we're after
        walk(files, get_sst)
        day_ncs <- dir(paste0(output_folder, "/tmp/"), full.names = TRUE) %>% # List all of the new daily files we have
          paste0(., collapse = " ") # Write them one after the other separated by spaces
        cdo_code <- paste0("cdo -s -L -f nc4 -z zip ", # Deploy CDO silently and zip the final netCDF to save space [don't forget the trailing space]
                           "-mergetime ", # Combine all the files into a single year, using their timestamp to arange them [tailing space, again]
                           day_ncs, # The names of the input files, separated by spaces
                           " ", # A space
                           paste0(output_folder, "/IMOSS_DN_SST_", yr, ".nc") # An output file name, in the output folder
                           )
          system(cdo_code) # Deploy the code in terminal
        terminal_code <- paste0("rm -r ", tmp_folder) # Code to delte to temporary folder AND all files (AND empty the bin)
          system(terminal_code) # Deploy the code in terminal
      }
  
  years <- 1993:2014
  walk(years, get_ann_sst) # For each year-month combo, run the function
  
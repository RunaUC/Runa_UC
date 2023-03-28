# Function that aggregates daily IMOS netCDFs by year and month
  # Written by Dave S
    # March 2023


# Packages ----------------------------------------------------------------

  library(tidyverse)
  library(ncdf4)
  library(terra)
  library(raster)


# Folders ----------------------------------------------------------------

  input_folder <- "/Users/davidschoeman/Dropbox/Documents/Student_Documents/Ongoing_Students/SRP/Runa_Uchikune/Code_n_data/IMOS_SST"
  output_folder <- "/Users/davidschoeman/Dropbox/Documents/Student_Documents/Ongoing_Students/SRP/Runa_Uchikune/Code_n_data/Monthly_IMOS_SST"
    if(!dir.exists(output_folder)) {dir.create(output_folder, recursive=TRUE)} # If the output folder doesn't exist, make it


# Function ----------------------------------------------------------------

  get_IMOS_by_month <- function(yrmnth) {
    files <- dir(input_folder, # List all files in the input folder
                 pattern = as.character(yrmnth), # Get only those that match the year-month combo
                 full.names = TRUE) # Include the full path
    r <- raster::stack(files) # Place them all in a raster stack, in order
    e <- extent(c(150, 160, -28, -24)) # The Sunny Coast. Hopefully
    r_sc <- crop(r, e) # Crop to extent of Sunny Coast
    r_mn <- calc(r_sc, fun = mean, na.rm = TRUE) # Compute the mean
    out <- r_mn - 273.15 # Make it celcius
    out_file <- paste0(output_folder, "/",yrmnth, "_IMOS_SST_Sunny_Coast.RDS") # Make an output name, including path
    saveRDS(out, out_file) # Save te output as a native R data file
    }
  
  
# Do the work -------------------------------------------------------------

  Year_Month <- dir(input_folder) %>% # List ALL files in the input folder, WITHOUT their path
    substr(., 1, 6) %>% # For each, get just just the first 6 characters, which ARE the year-month combo
    unique() # Get JUST the unique values of each
  walk(Year_Month, get_IMOS_by_month) # For each year-month combo, run the function

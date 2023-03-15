# Function that aggregates daily IMOS netCDFs by year
  # Written by Dave S
    # March 2023


# Packages ----------------------------------------------------------------

  library(tidyverse)
  library(ncdf4)
  library(terra)


# Folders ----------------------------------------------------------------

  input_folder <- "/Users/davidschoeman/Dropbox/Documents/Student_Documents/Ongoing_Students/SRP/Runa_Uchikune/Code_n_data/IMOS_SST"
  output_folder <- "/Users/davidschoeman/Dropbox/Documents/Student_Documents/Ongoing_Students/SRP/Runa_Uchikune/Code_n_data/Annual_IMOS_SST"
    if(!dir.exists(output_folder)) {dir.create(output_folder, recursive=TRUE)} # If the output folder doesn't exist, make it


# Function ----------------------------------------------------------------

  get_IMOS_by_year <- function(yr) {
    files <- dir(input_folder,
                 pattern = as.character(yr),
                 full.names = TRUE)
    out_file <- paste0("IMOS_SST_", yr, ".RDS")
    }
  
  
# Do the work -------------------------------------------------------------

  years <- 1992:1993 # Set up some years of data to grab
  output_folder <- "/Users/davidschoeman/Dropbox/Documents/Student_Documents/Ongoing Students/SRP/Runa Uchikune/Code_n_data/IMOS_SST" # Write down a path to save to (NOT GitHub!)
  walk(years, getIMOSsst) # For each year, run the function

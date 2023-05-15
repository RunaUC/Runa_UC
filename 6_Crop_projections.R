# Crop global CMIP6 projections to the extent of the study area 
  # Written by Dave S for Runa
    # May 2023


# Notes -------------------------------------------------------------------

  # CMIP6 is the Coupled Model Intercomparison Project, which is in its sixth phase.
  # This repository, hosted by the Earth System Grid Federation (ESGF) archives model outputs by > 50 climate modelling groups from around the world.
  # Among the results archived is ScenarioMIP, which contains projections used by the IPCC in its Assessment Reports. CMIP6 was used in the recent IPCC Sixth Assessment Report
  # Dave downloaded daily data from 9 models and regridded them to a common 0.25º grid using bilinear interpolation, with missing cells filled by nearest neighbour.
  # For each model, historical data and projections were downloaded.
  # Historical data were cropped to start in 1982.
  # Projections for ssp119, ssp126, ssp245, ssp370 and ssp585 were spliced to the end of the historical data to make daily timeseries running from 1982-2100.
  # Each dataset was then masked using a common land mask, so that only data over the ocean remain.


# Packages ----------------------------------------------------------------

  library(tidyverse)
  library(raster)


# Folders ----------------------------------------------------------------

  input_folder <- "/Volumes/Stripe_Raid/CMIP_regridded_masked"
  output_folder <- "/Users/davidschoeman/Dropbox/Documents/Student_Documents/Ongoing_Students/SRP/Runa_Uchikune/Code_n_data/CMIP6"
    if(!dir.exists(output_folder)) {dir.create(output_folder, recursive=TRUE)} # If the output folder doesn't exist, make it


# Crop projections to the study area --------

    crop_cmip <- function(f) { # Is going to do the same thing to each file, with file name represented by "f"
      out_name <- paste0(output_folder, "/", basename(f)) %>%  # An output path and logical file name
        gsub("1982", "1993", .) # Given that we will limit to 1993 rather than 1982, rename the file, accordingly
      cdo_script <- paste0("cdo -s -L -f nc4 -z zip ", # Deploy CDO silently and zip the final netCDF to save space [don't forget the trailing space]
                           "-selyear,1993/2100 ", # Select just the years we need [not forgetting the trailing space]
                           "-sellonlatbox,150,160,-28,-24 ", # Crop to the bounds we selected originally when we wanted to use raster [tailing space, again]
                           "-selvar,tos ", # Select ONLY the SST, which in CMIP6 models is "tos" (temperature of the surface), not forgetting the trailing space
                           f, # The file we're working with
                           " ", # A space, since the paste0, above didn't add a trailing space
                           out_name) # Our output path and file name
      system(cdo_script) # Pass the script to the terminal Note that CDO reads the code backwards, so selvar happens first, then crop, then zip
      }
      
  ssps <- c("119", "126", "245", "370") # A list of the forcings we want to represent: 1.5C, 2C, current climate policy, business as usual (in order)
  files <- dir(input_folder, # List all files in the input folder
                   full.names = TRUE) %>%  # Include the full path
    str_subset(paste(ssps, collapse = "|")) # The paste sticks the numbers together in a single quote, each separated by "|", which in R means "OR"...so subset for any of these strings in the file name
  walk(files, crop_cmip)
      
# Crop global CMIP6 projections to the extent of the study area 
  # Written by Dave S for Runa
    # May 2023


# Notes -------------------------------------------------------------------

  # An ensemble is a collection of models exploring the same scenario for the same space and time.
  # We often use ensemble means or medians to get a "single" picture of what a scenario looks like, taking all models into consideration.


# Packages ----------------------------------------------------------------

  library(tidyverse)
  library(raster)


# Folders ----------------------------------------------------------------

  input_folder <- "/Users/davidschoeman/Dropbox/Documents/Student_Documents/Ongoing_Students/SRP/Runa_Uchikune/Code_n_data/CMIP6"
  output_folder <- "/Users/davidschoeman/Dropbox/Documents/Student_Documents/Ongoing_Students/SRP/Runa_Uchikune/Code_n_data/CMIP6_ensemble"
    if(!dir.exists(output_folder)) {dir.create(output_folder, recursive=TRUE)} # If the output folder doesn't exist, make it


# Crop projections to the study area --------

    ensemble_cmip <- function(s) { # Is going to do the same thing to each ssp, with file name represented by "s"
      files <- dir(input_folder, # List all files in the input folder
                   full.names = TRUE) %>%  # Include the full path
        str_subset(s) # The paste sticks the numbers together in a single quote, each separated by "|", which in R means "OR"...so subset for any of these strings in the file name
      n1 <- files[1] %>% # The input file name
        basename() %>% # Just the file name, not the path
        str_split("_", simplify = TRUE) %>% # Split by "_"
        as.vector() # Make the result a vector
      n2 <- n1 # Take a copy
      n2[3] <- "ensemble" # Replace the model name, which is in the third slot with "ensemble"
      out_name <- paste(n2, collapse = "_") %>%  # Build the output file name
        paste0(output_folder, "/", .) # Paste output folder at the front
      cdo_script <- paste0("cdo -s -L -f nc4 -z zip ", # Deploy CDO silently and zip the final netCDF to save space [don't forget the trailing space]
                           "-ensmedian ", # get the ensemble median across models [not forgetting the trailing space]
                           paste0(files, collapse = " "), # The file we're working with
                           " ", # A space, since the paste0, above didn't add a trailing space
                           out_name) # Our output path and file name
      system(cdo_script) # Pass the script to the terminal Note that CDO reads the code backwards, so selvar happens first, then crop, then zip
      }
      
  ssps <- c("119", "126", "245", "370") # A list of the forcings we want to represent: 1.5C, 2C, current climate policy, business as usual (in order)
  walk(ssps, ensemble_cmip)
      
# Function that aggregates annual IMOS netCDFs into a single file
  # Written by Dave S for completion by Runa
    # March 2023


# Packages ----------------------------------------------------------------

  library(tidyverse)


# Folders ----------------------------------------------------------------

  #** Add code here to set folders to something logical
  # We need an input_folder to be set
  # We need an output_folder to write to (and it needs to be created, if it does not exist)


# Combine annual files into a single overall file and clean up -----------------

  ann_files <- dir(output_folder, full.names = TRUE) # A list of the annual netCDFs in the input_folder
  cdo_code <- paste0("cdo -s -L -f nc4 -z zip -mergetime ", # Merge the annual data together
                     paste0(ann_files, collapse = " "), # The annual files, separated by spaces
                     " ", # A space
                     paste0(output_folder, "/baseline_IMOS_data.nc") # An output file path and name
                     )
  system(cdo_code) # Send the code chunk to the terminal
  
# Clean up
  terminal_code <- paste0("rm -r ", paste0(ann_files, collapse = " ")) # Code to delete the annual files and tmp folder
  system(terminal_code) # Send the code chunk to the terminal
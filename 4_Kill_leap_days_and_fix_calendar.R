# Code that removes leap days and sets calendar to 365_day
  # Written by Dave S & Runa
    # April 2023


# Packages ----------------------------------------------------------------

  library(tidyverse)


# Folders ----------------------------------------------------------------

  #** Add code here to set folders to something logical
  # We need an input_folder to be set****
  # We need an output_folder to write to (and it needs to be created, if it does not exist)****

input_folder <- "/Volumes/Runa_Disk/allIMOS" 
output_folder <- "/Volumes/Runa_Disk/annual_merged_IMOS" # create a new folder
if(!dir.exists(output_folder)) {dir.create(output_folder, recursive=TRUE)}


# Identify the file with all IMOS data together and remove leap days, then fix calendar -----------------

  fixeddays_files <- dir(input_folder, full.names = TRUE) # A list of the annual netCDFs in the input_folder****
  cdo_code <- paste0("cdo -L -setcalendar,365_day -delete,month=2,day=29 ", # First delete leap days, then set the calendar 
                     fixeddays_files, # The files with all the IMOS data together***
                     " ", # A space
                     paste0(output_folder, "/365_day_IMOS_data.nc") # An output file path and name
                     )
  system(cdo_code) # Send the code chunk to the terminal
.
  
# Function that aggregates daily IMOS netCDFs by year and month
  # Written by Dave S
    # March 2023
# Edited by Jessie with comments

# Packages ----------------------------------------------------------------

  library(tidyverse)
  library(ncdf4)
  # library(terra)
  # library(raster)


# Folders ----------------------------------------------------------------

  input_folder <- "/Volumes/OWC_STX_HDD/Volumes/Runa_SRP_SST/raw"
  output_folder <- "/Volumes/OWC_STX_HDD/Volumes/Runa_SRP_SST/annual"
    if(!dir.exists(output_folder)) {dir.create(output_folder, recursive=TRUE)} 
  # If the output folder doesn't exist, make it


# Function ----------------------------------------------------------------

  # For debugging
  #yr = 1993
  #f = "/Volumes/OWC_STX_HDD/Volumes/Runa_SRP_SST/raw/19930102092000-ABOM-L3S_GHRSST-SSTfnd-AVHRR_D-1d_dn-v02.0-fv02.0.nc"
  
  get_ann_sst <- function(yr) { # Runs get_sst each year, setting up first and cleaning up after
    
    # Make new subfolder called 'tmp' of the output folder
      tmp_folder <- paste0(output_folder, "/tmp") 
      terminal_code <- paste0("mkdir ", tmp_folder) 
        system(terminal_code) 
        
      get_sst <- function(f) { # For each SST file in a year
        
        out_name <- paste0(output_folder, "/tmp/", basename(f)) # Full file path
        cdo_script <- paste0("cdo -s -L -f nc4 -z zip ", 
                             # -s = silent mode
                             # -L = enforce thread synchronisation (what is this?)
                             # -f nc4 = format file to netCDF4
                             # -z zip = unix command to save space
                             "-sellonlatbox,150,160,-28,-24 ", 
                             # Crop to Sunshine Coast [trailing space]
                             "-selvar,sea_surface_temperature_day_night ", 
                             # Select ONLY the day/night SST [trailing space]
                             f, # The file we're working with
                             " ", 
                             out_name) # Our output path and file name
          system(cdo_script) 
      } # end of get_sst()
      
      # Full path of all files in the input folder
      # Only those with file names starting with year of interest
        files <- dir(input_folder,  full.names = TRUE) %>% 
          .[grepl(paste0(input_folder, "/", yr), .)] 
        
        #run the function, applying it to each element of the vector (i.e., each file)
        walk(files, get_sst) 
        
        # List all new daily files
        # Write them one after the other separated by spaces into a bigass vector 
        #containing one element
        day_ncs <- dir(paste0(output_folder, "/tmp/"), full.names = TRUE) %>% 
          paste0(., collapse = " ") 
        
        # Combine all files into single year, arranged by timestamp 
        # Write to output name in output folder
        cdo_code <- paste0("cdo -s -L -f nc4 -z zip ", # as above
                           "-mergetime ", 
                           day_ncs, # names of the input files, separated by spaces
                           " ", 
                           paste0(output_folder, "/IMOSS_DN_SST_", yr, ".nc"))
        system(cdo_code) 
        
        # Delete tmp folder (AND empty the bin)
        terminal_code <- paste0("rm -r ", tmp_folder) 
        system(terminal_code) 
  }
  
  years <- 1993:1993
  walk(years, get_ann_sst) # For each year-month combo, run the function
    
  
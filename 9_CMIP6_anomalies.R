# Ensemble anomalies
  # Challenge for Runa
    # May 2023


# Notes -------------------------------------------------------------------

# Anomalies are achieved by subtracting means from observations


# Packages ----------------------------------------------------------------

  library(tidyverse)


# Folders ----------------------------------------------------------------

  observations_folder <- "/Volumes/Runa_Disk/CMIP6_ensemble" # The input folder from script 8
  means_folder <- "/Volumes/Runa_Disk/CMIP6_ensemble_means" # The output folder from script 8
  output_folder <- "/Volumes/Runa_Disk/CMIP6_ensemble_" #*** Make a new folder to put the results in
    if(!dir.exists(output_folder)) {dir.create(output_folder, recursive=TRUE)} # If the output folder doesn't exist, make it


# Anomalies (subtract mean from observations)  --------
  
 do_CMIP_anomalies <- function(obs) {
    f_name <- basename(obs) # Just the input file name, which is still in standard format—we can use this to make other file names
    mn <- f_name %>% 
      gsub("_ensemble_", "_ensembleMean_", .) %>%  # Like we did last time
      paste0(means_folder, "/", .) # Add in the correct path
    output_file <- f_name %>% 
      gsub("_ensemble_", "_anomalies_", .) %>%  # Like we did last time
      paste0(output_folder, "/", .) # Add in the correct path
    cdo_code <- paste0("cdo sub ",  
                       obs, 
                       " ", 
                       mn, 
                       " ", 
                       output_file) # the format to subtract the mean from the observations is: cdo[fill in the stuff here] sub obs mn output_file
      system(cdo_code)
    }
  
files <- dir(observations_folder, pattern = "ssp", full.names = TRUE)
walk(files, do_CMIP_anomalies)
  
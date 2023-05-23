# compute mean of scenario
 # Written by Runa
  # May 2023

# Packages ----------------------------------------------------------------

library(tidyverse)
library(raster)

# Folders ----------------------------------------------------------------
# Scenario1
input_file <- "/Volumes/Runa_Disk/CMIP6_ensemble/tos_Oday_ensemble_ssp119_r1i1p1f1_rg_19930101-21001231.nc"
output_file <- "/Volumes/Runa_Disk/CMIP6_ensemble/scenario1_mean"
if(!dir.exists(output_file )) {dir.create(output_file , recursive=TRUE)}

cdo_code <- paste0("cdo timmean ",
                   input_file,
                   " ",
                   output_file )
system(cdo_code)

# Scenario2 
input_file <- "/Volumes/Runa_Disk/CMIP6_ensemble/tos_Oday_ensemble_ssp126_r1i1p1f1_rg_19930101-21001231.nc"
output_file <- "/Volumes/Runa_Disk/CMIP6_ensemble/scenario2_mean"
if(!dir.exists(output_file )) {dir.create(output_file , recursive=TRUE)}

cdo_code <- paste0("cdo timmean ",
                   input_file,
                   " ",
                   output_file )
system(cdo_code)

# Scenario3 
input_file <- "/Volumes/Runa_Disk/CMIP6_ensemble/tos_Oday_ensemble_ssp245_r1i1p1f1_rg_19930101-21001231.nc"
output_file <- "/Volumes/Runa_Disk/CMIP6_ensemble/scenario3_mean"
if(!dir.exists(output_file )) {dir.create(output_file , recursive=TRUE)}

cdo_code <- paste0("cdo timmean ",
                   input_file,
                   " ",
                   output_file )
system(cdo_code)

# Scenario4 
input_file <- "/Volumes/Runa_Disk/CMIP6_ensemble/tos_Oday_ensemble_ssp370_r1i1p1f1_rg_19930101-21001231.nc"
output_file <- "/Volumes/Runa_Disk/CMIP6_ensemble/scenario4_mean"
if(!dir.exists(output_file )) {dir.create(output_file , recursive=TRUE)}

cdo_code <- paste0("cdo timmean ",
                   input_file,
                   " ",
                   output_file )
system(cdo_code)


# Some hints from Dave ----------------------------------------------------

# Since you repeat the code on Lines 22-26 several times, it could more easily be used as a function (see Lines 58-67, below), then get a list of files and deploy the function for each file (see Lines 69-70, below):

input_folder <- "/Volumes/Runa_Disk/CMIP6_ensemble"
output_folder <- "/Volumes/Runa_Disk/CMIP6_ensemble_mean" # Specify an output folder
if(!dir.exists(output_folder)) {dir.create(output_folder, recursive=TRUE)} # Make the folder, if it doesn't exist

do_ens_mean <- function(input_file) {
  output_file <- basename(input_file) %>% # Take just the file name
    gsub("_ensemble_", "_ensembleMean_", .) %>%  # Replace the descriptor with a new descriptor
    paste0(output_folder, "/", .) # Paste the path in front of the file name
  cdo_code <- paste0("cdo timmean ",
                     input_file,
                     " ",
                     output_file )
  system(cdo_code)
  }

files <- dir("/Volumes/Runa_Disk/CMIP6_ensemble", pattern = "ssp", full.names = TRUE)
walk(files, do_ens_mean)

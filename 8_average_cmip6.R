# compute mean of scenario
 # Written by Runa
  # May 2023

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

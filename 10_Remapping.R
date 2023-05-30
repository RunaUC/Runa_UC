# Re-mapping
 # written by Runa 
  # May 2023

# packages ---------------------------------------------------------------------
library(raster)
library(tidyverse)
library(ncdf4)

# plot the raster data of the average observation SST
r <- raster("/Volumes/Runa_Disk/annual_merged_IMOS/IMOS_data_timavg.nc", var="sea_surface_temperature_day_night") 
r # dimension is 200*500*1e+05, each pixel size is small enough. 

nc_open("/Volumes/Runa_Disk/annual_merged_IMOS/IMOS_data_timavg.nc")
plot(r)

# make a mask saying "0:land, 1:ocean"
system(paste0("cdo -expr,'sea_surface_temperature_day_night = ((sea_surface_temperature_day_night>-2)) ? 1.0 : sea_surface_temperature_day_night/0.0' /Volumes/Runa_Disk/annual_merged_IMOS/IMOS_data_timavg.nc /Volumes/Runa_Disk/annual_merged_IMOS/IMOS_mask.nc")) # create a new folder ¥

# plot the mask
r <- raster("/Volumes/Runa_Disk/annual_merged_IMOS/IMOS_mask.nc") 
r
plot(r) # now white (0) area shows land, while yellow (1) shows the ocean

s <- raster("/Volumes/Runa_Disk/CMIP6_ensemble_annomalies/tos_Oday_anomalies_ssp119_r1i1p1f1_rg_19930101-21001231.nc") 
plot(s)
s # when look up the dimension, the pixel size is 16*41*656 
# This size is much bigger than the observed data. 

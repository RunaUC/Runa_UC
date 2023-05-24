# Re-mapping
 # written by Runa 
  # May 2023

# packages 
library(raster)
library(tidyverse)
library(ncdf4)

r <- raster("/Volumes/Runa_Disk/annual_merged_IMOS/IMOS_data_timavg.nc", var="sea_surface_temperature_day_night") 
r
nc_open("/Volumes/Runa_Disk/annual_merged_IMOS/IMOS_data_timavg.nc")
plot(r)

system(paste0("cdo -expr,'sea_surface_temperature_day_night = ((sea_surface_temperature_day_night>-2)) ? 1.0 : sea_surface_temperature_day_night/0.0' /Volumes/Runa_Disk/annual_merged_IMOS/IMOS_data_timavg.nc /Volumes/Runa_Disk/annual_merged_IMOS/IMOS_mask.nc")) # Make it a mask

r <- raster("/Volumes/Runa_Disk/annual_merged_IMOS/IMOS_mask.nc")
r
plot(r)

s <- raster("/Volumes/Runa_Disk/CMIP6_ensemble_annomalies/tos_Oday_anomalies_ssp119_r1i1p1f1_rg_19930101-21001231.nc")
plot(s)
s

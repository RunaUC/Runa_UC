# Plotting raw CMIP climatology vs bias-corrected, remapped

library(raster)
library(tidyverse)
library(tmap)
library(colorRamps)
library(sf)


# Get raw CMIP climatology for 2081-2100
  input_file <- "/Users/davidschoeman/Dropbox/Documents/Student_Documents/Ongoing_Students/SRP/Runa_Uchikune/Code_n_data/CMIP6_ensemble/tos_Oday_ensemble_ssp370_r1i1p1f1_rg_19930101-21001231.nc"
  output_file <- "/Users/davidschoeman/Dropbox/Documents/Student_Documents/Ongoing_Students/SRP/Runa_Uchikune/Code_n_data/tos_Oday_CMIPensemble_ssp370_r1i1p1f1_rg_19930101-21001231.nc"
  cdo_code <- paste0("cdo -L -timmean -selyear,2081/2100 ",
                     input_file,
                     " ",
                     output_file )
  system(cdo_code)
  processed_climatology <- stack(output_file)

# Make bias-corrected climatology for 2081-2100
  input_file <- "/Users/davidschoeman/Dropbox/Documents/Student_Documents/Ongoing_Students/SRP/Runa_Uchikune/Code_n_data/CMIP_Bias_corrected/tos_Oday_bc_ssp370_r1i1p1f1_rg_19930101-21001231.nc"
  output_file <- "/Users/davidschoeman/Dropbox/Documents/Student_Documents/Ongoing_Students/SRP/Runa_Uchikune/Code_n_data/tos_Oday_bcClimatology_ssp370_r1i1p1f1_rg_19930101-21001231.nc"
  cdo_code <- paste0("cdo -L -timmean -selyear,2081/2100 ",
                     input_file,
                     " ",
                     output_file )
  system(cdo_code)
  processed_climatology <- stack(output_file)
  
# Plot      
  aus <- st_read("/Users/davidschoeman/Dropbox/Documents/R Workshop 2023/Prep_stuff/AdvancedSpatialWS/2020-02-14-prof-calanoid-analysis/data-for-course/spatial-data/Aussie.shp")
  brks <- c(23:26)
  raw_map <- tm_shape(raw_climatology) +
    tm_raster(palette = matlab.like(255), 
              breaks = brks,
              title = "SST (°C)",
              style = "cont") +
  tm_shape(aus) +
    tm_polygons() +
  tm_layout(legend.outside.position = "right",
            legend.outside.size = 0.35,
            legend.outside = TRUE,
            legend.text.size = .5)
  tmap_save(raw_map, "Raw_CIMP_climatology.png")
  
  bias_corrected_map <- tm_shape(processed_climatology) +
    tm_raster(palette = matlab.like(255), 
              breaks = brks,
              title = "SST(°C)",
              style = "cont") +
    tm_shape(aus) +
      tm_polygons() +
    tm_layout(legend.outside.position = "right",
              legend.outside.size = 0.35,
              legend.outside = TRUE,
              legend.text.size = .5)
  tmap_save(bias_corrected_map, "Bias_corrected_CIMP_climatology.png")
  
  
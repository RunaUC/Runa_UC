# compute the mean in each grid cell

# package
library(tidyverse)

# folder
input_file <- "/Volumes/Runa_Disk/annual_merged_IMOS/365_day_IMOS_data.nc"
output_file <- "/Volumes/Runa_Disk/annual_merged_IMOS/IMOS_data_timavg.nc"
# if(!dir.exists(output_file )) {dir.create(output_file , recursive=TRUE)}

cdo_code <- paste0("cdo timmean ",
                   input_file,
                   " ",
                   output_file )
system(cdo_code)

library(raster)
r <- stack(output_file)
r
plot(r)
                   

# plot the results 
 # June 2023

# packages ----------------------------------------------------------------------
library(raster)
library(tmap)
library(tidyverse)
library(colorRamps)

# folders and files -------------------------------------------------------------
input_folder <- "/Volumes/Runa_Disk/BC_Cum_Int"

files <- dir(input_folder, full.names = TRUE)

# start creating maps -----------------------------------------------------------
# based on SST transition for 20 years in different sequence of years 
recent <- 2001:2020 # recent changes (2001 to 2020)
mid_cent <- 2041:2060 # mid-century changes (2041 to 2060)
end_cent <- 2081:2100 # end-century changes (2081 to 2100)
all <- 1993:2100 # entire time range between 1993 to 2100
idx <- 1:length(all) 

recent_i <- idx[all %in% recent]
mid_i <- idx[all %in% mid_cent]
end_i <- idx[all %in% end_cent]
# these lines create new vectors "recent_i, mid_i, and end_i" that contains the indices corresponding to each year in the "all" sequence. In other words, it extracts the indices of the years that belong to the recent/mid_cent/end_cent and assigned to the vectors. 

# start analyzing SST changes in the different time period -----------------------
get_rel_MHW <- function(f) {
  r <- stack(f)
    out <- stack(
      calc(subset(r, recent_i), sum), # calculate the sum of values in the raster stack "r" for three specific time periods # these time periods are all subsets of stack "r". 
      calc(subset(r, mid_i), sum),
      calc(subset(r, end_i), sum)
      )
    out1 <- stack(
      out[[2]]/out[[1]], 
      out[[3]]/out[[1]]
      ) # new raster stack "out1" by dividing the second/third layers of the "out" stack by the first layer. # first layer: recent_i, second layer: mid_i, third layer: end_i # since we do not need the actual temperature it self, but need "How much the temperature might rise compare to the recent (historical SST) period of time. Therefore, these lines divided raster layer 2 and 3 by 1; so that we are able to see the relative values of the future SST under different scenarios relative to the recent SST. 
    periods <- c("2041—2060", "2081—2100") # defines the name of layers. 
    l_names <- basename(f) %>% 
      str_split("_", simplify = TRUE) %>% 
      .[1, 4] %>% 
      paste0(., "_", periods)
    names(out1) <-  l_names
    return(out1)
    }

results <- map(files, get_rel_MHW) %>% 
  stack()


# Plot results by using tmap function ---------------------------------------------
brks <- c(0, 1, 2, 3, 5, 7.5, 10, 15, 20, 25, 30, 35, 40)
tm_shape(results) +
  tm_raster(palette = matlab.like(255), 
            breaks = brks,
            title = "Relative MHW\n°C.days",
            style = "cont") +
  tm_layout(legend.outside.position = "right",
            legend.outside.size = 0.35,
            legend.outside = TRUE,
            legend.text.size = .5)

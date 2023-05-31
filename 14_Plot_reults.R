library(raster)
library(tmap)
library(tidyverse)
library(colorRamps)

input_folder <- "/Users/davidschoeman/Dropbox/Documents/Student_Documents/Ongoing_Students/SRP/Runa_Uchikune/Code_n_data/BC_Cum_Int"

files <- dir(input_folder, full.names = TRUE)

recent <- 2001:2020
mid_cent <- 2041:2060
end_cent <- 2081:2100
all <- 1993:2100
idx <- 1:length(all)

recent_i <- idx[all %in% recent]
mid_i <- idx[all %in% mid_cent]
end_i <- idx[all %in% end_cent]

get_rel_MHW <- function(f) {
  r <- stack(f)
    out <- stack(
      calc(subset(r, recent_i), sum),
      calc(subset(r, mid_i), sum),
      calc(subset(r, end_i), sum)
      )
    out1 <- stack(
      out[[2]]/out[[1]],
      out[[3]]/out[[1]]
      )
    periods <- c("2041—2060", "2081—2100")
    l_names <- basename(f) %>% 
      str_split("_", simplify = TRUE) %>% 
      .[1, 4] %>% 
      paste0(., "_", periods)
    names(out1) <-  l_names
    return(out1)
    }

results <- map(files, get_rel_MHW) %>% 
  stack()


# Plot results
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

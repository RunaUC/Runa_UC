# Step 02: Extract daily time series from each grid-square and compute MHW stats
	# Written by Dave Schoeman (david.schoeman@gmail.com)
		# June 2022; modified May 2023


# Source the helpers -----------------------------------------------------------

	library(tidyverse)
  library(ncdf4)
  library(heatwaveR)
  library(raster)
  library(furrr)
  library(lubridate)
  library(easyNCDF)


# Folders --------------------------------------------------------

  make_folder <- function(folder) {
    if(!isTRUE(file.info(folder)$isdir)) dir.create(folder, recursive=TRUE)
    return(folder)
    }

  input_folder <- "/Users/davidschoeman/Dropbox/Documents/Student_Documents/Ongoing_Students/SRP/Runa_Uchikune/Code_n_data/CMIP_Bias_corrected"
  working_folder <- make_folder("/Users/davidschoeman/Dropbox/Documents/Student_Documents/Ongoing_Students/SRP/Runa_Uchikune/Code_n_data/tmp")
	output_folder <- make_folder("/Users/davidschoeman/Dropbox/Documents/Student_Documents/Ongoing_Students/SRP/Runa_Uchikune/Code_n_data/Cum_int_tmp")
	bc_ci_folder <- make_folder("/Users/davidschoeman/Dropbox/Documents/Student_Documents/Ongoing_Students/SRP/Runa_Uchikune/Code_n_data/BC_Cum_Int")


# How many cores? ---------------------------------------------------------

  nworkers <- parallel::detectCores()	- 5
	
		
# Subset the world --------------------------------------------------------
	
		split_the_world <- function(f) {
		  system(paste0("cdo -L -distgrid,4,4 ", input_folder, "/", f, " ", working_folder, "/", gsub(".nc","_", f))) # Splits into 9 x 20 lat, 18 x 20 lon
  		}
	  # netCDFs <- dir(input_folder, pattern = "_ssp")
# 	  plan(multisession, workers = 2)
# 	    future_walk(netCDFs, split_the_world)
#     plan(sequential)

    
# Extract  bias corrected time series, and compute Cum Int ------------------------
	
	nc_dates <- function(nc) {
	  require(PCICt)
	  require(ncdf4)
	  u <- nc$dim$time$units
	  dts <- nc$dim$time$vals
	  cdr <- nc$dim$time$calendar
	  or <- strsplit(u, " ") %>% 
	    unlist() %>% 
	    .[3] %>% 
	    strsplit("-") %>% 
	    unlist()
	  actual_dts <- as.PCICt(dts*60*60*24, cal = cdr, format = "%m%d%Y", origin = paste(or, collapse = "-")) %>%
	    substr(1, 10) %>% 
	    as.Date()
	  return(actual_dts)
	}
	
	get_cum_int <- function(nc_file) {
		nc <- nc_open(paste0(working_folder, "/", nc_file))
		tss <- ncvar_get(nc, "tos") %>% 
		  array_branch(c(1,2)) # Gives you the time series as a list
		lons <- ncvar_get(nc, "lon")
		lats <- ncvar_get(nc, "lat")
		dates <- nc_dates(nc)
		years <- unique(year(as.Date(dates)))
		nc_close(nc)
		rm(nc)
		# Function to extract cum_MHW_impact from each time series
  		get_mhw_imp <- function(ssts, 
  		                        dts = dates) { # To allow compliance with IPCC near-, mid- and long-term periods
  		  df <- data.frame(Date = dts, SST = ssts)
  		  if(sum(!is.na(df$SST)) > 0) {
  		    # First calculate the climatologies
  		    clim <- ts2clm(data = df, x = Date, y = SST, climatologyPeriod = c("1993-01-01", "2012-12-31")) # As per Oliver et al. and Smale et al., but we had only from 1993
  		    # Then the events
  		    yrs <- tibble(year = years)
  		    out <- detect_event(data = clim, x = Date, y = SST) %>% 
  		      .$climatology %>% 
  		      mutate(intensity = SST-seas,
  		             year = year(Date)) %>% 
  		      dplyr::filter(event == TRUE) %>% 
  		      group_by(year, .drop = FALSE) %>%
  		      dplyr::summarise(Cum_Int = sum(intensity, na.rm = TRUE))
  		    suppressMessages(out <- left_join(yrs, out) %>% 
  		                       mutate(Cum_Int = ifelse(is.na(Cum_Int), 0, Cum_Int)))
        		  } else {
        		    out <- tibble(year = years,
        		                  Cum_Int = NaN)
        		  }
  		  return(out$Cum_Int)
  		}	
  	# Do it
  		plan(multisession, workers = nworkers)
  		    cum_int <- future_map(tss, get_mhw_imp, .options = furrr_options(seed = TRUE)) 
  		  plan(sequential)
      # Write to netCDF
  		  out_name <- nc_file %>% 
  		    gsub("tos_Oday", "CumInt_Oyear", .)
  		  ci <- unlist(cum_int) %>% 
          array(., c(length(years), length(lons), length(lats))) %>% 
          aperm(c(2, 3, 1))
        metadata <- list(ci = list(units = 'degCdays'))
        attr(ci, 'variables') <- metadata
        names(dim(ci)) <- c('lon', 'lat', 'time')
        lon <- lons
        dim(lon) <- length(lon)
        metadata <- list(lon = list(units = 'degrees_east'))
        attr(lon, 'variables') <- metadata
        names(dim(lon)) <- 'lon'
        # names(dim(lon)) <- 'longitude'
        lat <- lats
        dim(lat) <- length(lat)
        metadata <- list(lat = list(units = 'degrees_north'))
        attr(lat, 'variables') <- metadata
        names(dim(lat)) <- 'lat'
        # names(dim(lat)) <- 'latitude'
        time <- paste0(years, "-06-30") %>% 
          as.Date() %>% 
          as.numeric()
        dim(time) <- length(time)
        metadata <- list(time = list(units = 'days since 1970-01-01 00:00:00'))
        attr(time, 'variables') <- metadata
        names(dim(time)) <- 'time'
        ArrayToNc(list(ci, lon, lat, time), paste0(output_folder, "/", out_name))
        
    # Drop a breadcrumb to track progress
      f_name <- gsub(".nc", ".txt", nc_file)
      sink(paste0("/Users/davidschoeman/Dropbox/Documents/ghost_in_the_cloud/", f_name))
      print(file.info(paste0(output_folder, "/", nc_file)))
      sink()
  }

# Do the work -------------------------------------------------------------
#   files <- dir(working_folder)
# 	walk(files, get_cum_int)
#     
    
  completed_files <- dir(bc_ci_folder, pattern = "CumInt_Oyear_")
	if(length(completed_files) > 0) {
	  netCDFs <- dir(input_folder, pattern = "_ssp") %>% 
	    setdiff(completed_files %>% 
	              gsub("CumInt_Oyear_","tos_Oday_", .)) 
	} else {
	  netCDFs <- dir(input_folder, pattern = "_ssp")
	}
	by_file <- function(f) {
	  if(length(dir(working_folder, pattern = gsub(".nc", "", f))) == 0) {
	    walk(f, split_the_world)
	  }
	  to_do <- setdiff(
	    dir(working_folder, pattern = "tos_Oday_") %>%
	      str_subset("_OISST", negate = TRUE),
	    dir(output_folder) %>% 
	      gsub("CumInt_Oyear_","tos_Oday_", .))
	  walk(to_do, get_cum_int)
	  mhw_bits <- dir(output_folder, pattern = f %>% 
	                    gsub("tos_Oday_", "CumInt_Oyear_", .) %>% 
	                    str_split("_19930101", simplify = TRUE) %>%
	                    .[,1] %>% 
	                    simplify() %>% 
	                    unique()) %>% 
	    paste0(output_folder, "/", .)
	  terminal_code <- paste0("cdo -s -L -f nc4 -z zip_4 -collgrid ", paste0(mhw_bits, collapse = " "), " ", bc_ci_folder, "/", gsub("tos_Oday_", "CumInt_Oyear_", f))
	    system(terminal_code)
	  terminal_code <- paste0("rm ", output_folder, "/*")
	    system(terminal_code)
	  terminal_code <- paste0("rm ", working_folder, "/", gsub(".nc", "*", f))
	    system(terminal_code)
	}
	walk(netCDFs, by_file)
	


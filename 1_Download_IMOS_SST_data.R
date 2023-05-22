# Function that downloads IMOS ssts, given an array of years, and an output folder into which to write the results
  # Written by Jessie B; modified by Dave S
    # March 2023


# Packages ----------------------------------------------------------------

  library(XML)
  library(tidyverse)


# Function ----------------------------------------------------------------

  getIMOSsst <- function(yr) {
    url <- paste0("http://rs-data1-mel.csiro.au/imos-srs/sst/ghrsst/L3S-1d/dn/", yr) # The URL for the year of data
    pageContent <- readLines(url) # Read the web page
    Links <- getHTMLLinks(pageContent) %>% # Get the lines of stuff
      .[grepl(".nc", .)] %>% # Isolate the names of the linked netCDF files
      paste0(url, "/", .) # Paste the path at the front 
    download_imos_file <- function(l) { # An internal function to download link l
      file_name <- basename(l) # Strip out everything before the file name
      out_name <- paste0(output_folder, "/", file_name) # File name including path of download folder
      if(!file.exists(out_name)) { # Download ONLY files that aren't already downloaded
        download.file(l, out_name) # Download the file and write the file to the download folder
        }
      } # End of internal function
    walk(Links, download_imos_file) # Welcome to purrr! For each link, download the associated file and write it to the output folder (i.e., execute the internal function)
    }

# Do the work -------------------------------------------------------------

  years <- 1992:2020 # Set up some years of data to grab
  output_folder <- "/Volumes/RunaSRPDisk/IMOS_Data" # Write down a path to save to (NOT GitHub!)
    if(!dir.exists(output_folder)) {dir.create(output_folder)} # If the output folder doesn't exist, make it
  walk(years, getIMOSsst) # For each year, run the function

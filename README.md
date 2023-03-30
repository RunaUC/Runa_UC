# Runa_UC

Climate change might detrimentally impact marine vertebrates/invertebrates, and other organisms.

In this research, I will focus on the sea-surface temperature change on the Sunshine Coast, as projected by IPCC Earth System models. I will use these data to compute metrics of marine heatwaves and climate velocity under different emissions scenarios, and explore the impacts on the marine biodiversity. 

“Projecting climate impacts on the marine biodiversity of the Sunshine Coast”

Raw data:
• Australia’s Integrated Marine Observing System (IMOS) data - Daily sea-surface temperature data between 1983 to 2020:
https://thredds.aodn.org.au/thredds/catalog/IMOS/SRS/SST/ghrsst/catalog.html

• Historical and future emission scenarios and its impact on sea-surface temperature from IPCC/CMIP6 Earth System Models. 

Steps – How do we get the SST on Sunshine Coast data?: 
1. Observed daily sea-surface temperature data between 1983 to 2014 is downloaded from IMOS. The raw data will be downscaled to monthly average SST data and to the finer scale at the Sunshine Coast. 

2. Historical data of SST between 1983 and 2014 from IPCC/CMIP6 is the “past scenarios” under CO2 emissions, solar radiation, and other environmental factors. Because the earth system models are desinged to reflect climate (whether the average of weather over the decades), oberverd data will be used to adjust CMIP6 output models. This is known as bias corrections. 

3. Downscalsed bias corrected, CMIP6 model output data (from step2) will be used for future marine heatwaves. Those corrected future marine heatwaves will be used to explore under different emissions scenarios.

4. Those future climate projections will be interpreted the potential impacts on marine biodiversity under future emissions scenarios. 

Analysis: 
R statistical software, version 4.2.1 (2022-06-23): http://www.rstudio.com/

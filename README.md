# Runa_UC

Due to the CO2 emissions, which result in the global warming, the global average of sea-surface temperatures (SSTs) has been experiencing rapid and unprecedented increase (IPCC, 2014). In fact, exceeded threshold of marine heat stress deleteriously impacts species performance, fitness, and adaptation of marine organisms to the environment, which lead to the collapse of marine biodiversity (Smith et al., 2023). The loss of marine biodiversity affects the species assemblages and ecological function, ends up with the decline of the provision of ecological services (Sala & Knowlton, 2006); hence this anomalous trend eventually affects human society. Thus, it is crucial to understand the biological impacts of marine heatwaves affecting SSTs. In this research, I will focus on the sea-surface temperature change on the Sunshine Coast, as projected by IPCC Earth System models. I will use these data to compute metrics of marine heatwaves and climate velocity under different emissions scenarios, and explore the impacts on the marine biodiversity. 

“Projecting climate impacts on the marine biodiversity of the Sunshine Coast”

Raw data:
• Australia’s Integrated Marine Observing System (IMOS) data - Daily sea-surface temperature data between 1983 to 2014:
https://thredds.aodn.org.au/thredds/catalog/IMOS/SRS/SST/ghrsst/catalog.html

• Historical and future emission scenarios and its impact on sea-surface temperature from IPCC/CMIP6 Earth System Models. 

Steps – How do we get the SST on Sunshine Coast data?: 

1.	To see the SST temperature change on the Sunshine Coast, observed daily sea-surface temperature data between 1993 to 2014 was downloaded for the whole area from IMOS. 
2.	These daily data was downscaled to annual SST data, and to the finer scale at the Sunshine Coast. 
3.	Since these annual SST data were different files, which was divided by years; hence these were merged to a single file.
4.	The lead days were then removed to set the calendar to 365 days from gregarious calendar. By using this annual SST data which has cropped to the study area, and fixed to 365 days calendar. 
5.	This date could then be used for computing the mean (in each grid cells), for 1993-2014. This annual SST mean data would be used as a “bias correction”. 
6.	The historical model of SST covering 1993 to 2100, which was downloaded from CMIP6, was calculated. This historical data is the “past scenarios” under CO2 emissions, solar radiation, and other environmental factors. As follow the same step with observation SST data, the historical data was cropped to the Sunshine Coast, and the study period was selected between 1993 and 2100. 
7.	The cropped data under four simulations were ensembled for collecting all the models to explore the same scenario for the same space and time. In other words, all the files which were divided by climate models from different institutions, were then ensembled to a dataset for a specific scenario. This step enables to get a “single” picture of what a scenario looks like, and provide a more comprehensive view of the range of possible climate outcomes under a particular scenario. 
8.	The mean of historical SST model was computed from those four ensembled files. This study utilized four different scenarios under the CO2 emissions; hence four different historical data was computed. 
9.	These four historical SST means are used for anomalies by subtracting the annual temperature values for each year between 2015 and 2100, under the different CO2 emission scenarios. The resulting value indicates how much each year’s temperature deviates from the average. 
10.	 The anomalies under four scenarios were in the large pixel data, while the raster data of the observed mean SST derived from IMOS was smaller pixel data. To remap them, it is necessary to create a mask which defines the land and ocean. This process prevent interpolation from occurring across the land regions, as interpolating between land and ocean points may introduce unrealistic values or artifacts. 
11.	 Bilinear interpolation was utilized, which uses a weighted average of the four nearest neighboring cells to estimate the values at the desired locations. By this interpolation, it is able to remap the coarse CMIP data to the spatial extent and resolution of IMOS. 
12.	 The remapped CMIP anomalies were then remasked again, since we filled coastal cells using nearest-neighbor SST, and it is necessary to turn the land back to NA from 0; otherwise, the land will be disappeared from the map.
13.	 To complete the bias correction, IMOS mean, in other words, observed SST mean between 1993 to 2014, have to be added to CMIP6 anomalies. 
14.	 The final files were plotted after dividing the files under different emissions scenarios into three time periods of equal length, each spanning 20 years: 2001 to 2020, 2041 to 2060, and 2081 to 2100. These time periods were respectively named 'recent', 'mid-century', and 'end-century'. Using a raster stack, a new layer was created to compare the projected future sea surface temperatures (SST) with the SST of the recent period. This was achieved by dividing the time periods of mid-century and end-century by the recent period. This new layer provides insights into how the projected future SSTs differ from the SSTs observed in the recent period. 

Results

The study calculated the sum of projected future sea surface temperatures (SST) for different time scales to assess the overall magnitudes and relative changes in the variables across the specified periods. In the ssp119 scenario, which represents a 1.5°C future situation, the relative increase in marine heatwaves (MHW) ranged from 5.0°C to 7.5°C in the mid-century (A). However, the rise was estimated to be less than 3.0°C and showed little difference offshore in the end-century (B). This indicates that under the 1.5°C future, there may not be significant differences between the two-time scales. Similar findings were observed in the ssp126 scenario, representing a 2.0°C higher future. There was not much variation between the mid-century and end-century time scales. However, the MHW conditions were around 6°C to 7°C worse compared to the 1.5°C scenario (C, D). Although the changes appeared less significant, the end-century time scale presented a worse situation than the mid-century time scale. This trend was consistent with the other two warmer scenarios (E, F, G, H). Notably, a distinct temperature change emerged in the 3.7°C experiments between the 2041-2060 scale (E) and the 2081-2100 scale (F). As depicted in the maps, the temperature range was around 20°C onshore and in parts of the offshore regions during the mid-century time scale. However, in the end-century time scale, the relative MHW increased to 25°C, particularly around the Fraser Coast and parts of the offshore region. These detrimental differences between the two-time scales were even more pronounced in the worst-case scenario, ssp370, representing a 4°C future (G, H). While the relative MHW was relatively similar to the ssp245 scenario in the 2041-2060 period, the highest relative MHW reached nearly 40°C along the coast from Moreton Bay to Fraser Island and 35°C in the offshore region of Moreton Bay.
![figure_SRP](https://github.com/RunaUC/Runa_UC/assets/126734833/2245eaf0-e02b-4a84-96d4-4201646da76f)
Figure 1. Future SST changes relative to four different emissions scenarios; ssp119 (1.5C°) run, ssp126 (2C°) run, ssp245 (3.7C°) run and ssp370 (4C°) run, between 2041 and 2060 (on the left), and 2081 and 2100 (on the right). 

Analysis: 
R statistical software, version 4.2.1 (2022-06-23): http://www.rstudio.com/

References: 
IPCC, 2014: Climate Change 2014: Impacts, Adaptation, and Vulnerability. Part B: Regional Aspects. Contribution of Working Group 2 to the Fifth Assessment Report of the Intergovernmental Panel on Climate Change [Barros, V.R., C.B. Field, D.J. Dokken, M.D. Mastrandrea, K.J. Mach, T.E. Bilir, M. Chatterjee, K.L. Ebi, Y.O. Estrada, R.C. Genova, B. Girma, E.S. Kissel, A.N. Levy, S. MacCracken, P.R. Mastrandrea, and L.L. White (eds.)]. Cambridge University Press, Cambridge, United Kingdom and New York, NY, USC, pp. 1655-1731

Sala, E., & Knowlton, N., (2006). Global Marine Biodiversity Trends. Annual Review of Environment and Resources, 31, 93-122. 
doi: 10.1146/annurev.energy.31.020105.100235

Smith, K.E., Burrows, M.T., Hobday, A.J., King, N.G., Moore, P.J., Gupta, A.S., Thomsen, M.S., Wernberg, T., Smale, D.A., (2023). Biological Impacts of Marine Heatwaves. Annual Review of Marine Science, 15(1), 119-145. 
doi: 10.1146/annurev-marine-032122-121437

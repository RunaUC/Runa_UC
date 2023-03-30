# Runa_UC

Due to the CO2 emissions, which result in the global warming, the global average of sea-surface temperatures (SSTs) has been experiencing rapid and unprecedented increase (IPCC, 2014). In fact, exceeded threshold of marine heat stress deleteriously impacts species performance, fitness, and adaptation of marine organisms to the environment, which lead to the collapse of marine biodiversity (Smith et al., 2023). The loss of marine biodiversity affects the species assemblages and ecological function, ends up with the decline of the provision of ecological services (Sala & Knowlton, 2006); hence this anomalous trend eventually affects human society. Thus, it is crucial to understand the biological impacts of marine heatwaves affecting SSTs. In this research, I will focus on the sea-surface temperature change on the Sunshine Coast, as projected by IPCC Earth System models. I will use these data to compute metrics of marine heatwaves and climate velocity under different emissions scenarios, and explore the impacts on the marine biodiversity. 

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

References: 
IPCC, 2014: Climate Change 2014: Impacts, Adaptation, and Vulnerability. Part B: Regional Aspects. Contribution of Working Group 2 to the Fifth Assessment Report of the Intergovernmental Panel on Climate Change [Barros, V.R., C.B. Field, D.J. Dokken, M.D. Mastrandrea, K.J. Mach, T.E. Bilir, M. Chatterjee, K.L. Ebi, Y.O. Estrada, R.C. Genova, B. Girma, E.S. Kissel, A.N. Levy, S. MacCracken, P.R. Mastrandrea, and L.L. White (eds.)]. Cambridge University Press, Cambridge, United Kingdom and New York, NY, USC, pp. 1655-1731

Sala, E., & Knowlton, N., (2006). Global Marine Biodiversity Trends. Annual Review of Environment and Resources, 31, 93-122. 
doi: 10.1146/annurev.energy.31.020105.100235

Smith, K.E., Burrows, M.T., Hobday, A.J., King, N.G., Moore, P.J., Gupta, A.S., Thomsen, M.S., Wernberg, T., Smale, D.A., (2023). Biological Impacts of Marine Heatwaves. Annual Review of Marine Science, 15(1), 119-145. 
doi: 10.1146/annurev-marine-032122-121437

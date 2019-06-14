# Fake paper based on the first part of Chapter 16 of Spatial Data Science book
# https://keen-swartz-3146c4.netlify.com/interpolation.html 

# Link to hourly (time series) data on Air Quality, Cyprus, 2017. Source: EEA
# https://fme.discomap.eea.europa.eu/fmedatastreaming/AirQualityDownload/AQData_Extract.fmw?CountryCode=CY&CityName=&Pollutant=8&Year_from=2017&Year_to=2017&Station=&Samplingpoint=&Source=E1a&Output=TEXT&UpdateDate=

library(here)
library(tidyverse)

#  "analysis.R" has the cone to preparing the air quality dataset used as input data here

no2.sf <- st_read(here("data", "no2_cy.geojson"))
crs <- 3857 # Mercator

# spatial transformation
library(sf)
# load Cyprus boundaries
library(cshapes)
cshp <- cshp(as.Date("2000-01-1"))
cy <- cshp[cshp$ISONAME == "Cyprus",]
cy.sf <- st_transform(st_as_sf(cy), crs)

# Map making
ggplot() + 
  geom_sf(data=cy.sf) + 
  geom_sf(data=no2.sf, mapping = aes(col = NO2)) + 
  geom_sf_text(data=no2.sf, aes(label = no2.sf$station_local_code), colour = "black", size=2, nudge_y = -1) + 
  theme_bw()

# Lists of stations and NO2 mesure
no2.sf %>% select(station_local_code, NO2)


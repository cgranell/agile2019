# Fake paper based on the first part of Chapter 16 of Spatial Data Science book
# https://keen-swartz-3146c4.netlify.com/interpolation.html 

# Link to hourly (time series) data on Air Quality, Cyprus, 2017. Source: EEA
# https://fme.discomap.eea.europa.eu/fmedatastreaming/AirQualityDownload/AQData_Extract.fmw?CountryCode=CY&CityName=&Pollutant=8&Year_from=2017&Year_to=2017&Station=&Samplingpoint=&Source=E1a&Output=TEXT&UpdateDate=

if(!require(sf)) {
  install.packages("sf", repos="https://cran.rstudio.com") }
# library(sf)
library(here)
library(xts)
library(tidyverse)
library(cshapes)

data_aq <- here::here("Authors_Complete", "data", "aq")

# Read all files into a list
files <- list.files(data_aq, pattern = "*.csv", full.names = TRUE)
r <- lapply(files, function(f) read.csv(f, encoding = "UTF-8"))

Sys.setenv(TZ = "UTC") # make sure times are not interpreted as DST
r <- lapply(r, function(f) {
  f$t <- as.POSIXct(f$DatetimeBegin) 
  f[order(f$t), ] 
}) 

# get rid of smaller datasets that do not contain hourly data
r <- r[sapply(r, nrow) > 1000]
names(r) <-  sapply(r, function(f) unique(f$AirQualityStationEoICode))
length(r) == length(unique(names(r)))

# Combine files based on time
r <- lapply(r, function(f) xts(f$Concentration, f$t))
aq <- do.call(cbind, r)

# remove stations with more than 75% missing values:
sel <- apply(aq, 2, function(x) sum(is.na(x)) < 0.75 * 365 * 24)
aqsel <- aq[, sel] # stations are in columns

# Read name stations and filter for ones in Cyprus
a2 <- read.csv(here::here("Authors_Complete","data", "AirBase_v8_stations.csv"), 
               sep = "\t", stringsAsFactors = FALSE) %>% 
  as_tibble  %>% 
  filter(country_iso_code == "CY")

# Spatial transformation  
a2.sf <- sf::st_as_sf(a2, 
                  coords = c("station_longitude_deg", "station_latitude_deg"), 
                  crs = 4326)

sel <- colnames(aqsel) %in% a2$station_european_code
aqsel <- aqsel[, sel]

tb <- tibble(NO2 = apply(aqsel, 2, mean, na.rm = TRUE), 
             station_european_code = colnames(aqsel))
no2.sf <- right_join(a2.sf, tb) %>% st_transform(crs=4326)  

# load Cyprus boundaries
cshp <- cshp(as.Date("2000-01-1"))
cy <- cshp[cshp$ISONAME == "Cyprus",]
cy.sf <- st_transform(st_as_sf(cy), crs=4326)

# Map making
ggplot() + 
  geom_sf(data=cy.sf) + 
  geom_sf(data=no2.sf, mapping = aes(col = NO2)) + 
  geom_sf_text(data = no2.sf, aes(label = station_local_code), colour = "black", size=2, nudge_y = -0.05) + 
  theme_bw()



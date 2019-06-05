
# Fake paper based on the Chapter 16 of Spatial Data Science
# https://keen-swartz-3146c4.netlify.com/interpolation.html 

# Link to hourly (time series) data on Air Quality, Cyprus, 2017. Source: EEA

url <- "https://fme.discomap.eea.europa.eu/fmedatastreaming/AirQualityDownload/AQData_Extract.fmw?CountryCode=CY&CityName=&Pollutant=8&Year_from=2017&Year_to=2017&Station=&Samplingpoint=&Source=E1a&Output=TEXT&UpdateDate="

library(here)

data_aq <- here("R", "data")

files = list.files(data_aq, pattern = "*.csv", full.names = TRUE)
r = lapply(files, function(f) read.csv(f, encoding = "UTF-8"))

Sys.setenv(TZ = "UTC") # make sure times are not interpreted as DST
r = lapply(r, function(f) {
  f$t = as.POSIXct(f$DatetimeBegin) 
  f[order(f$t), ] 
}) 

r = r[sapply(r, nrow) > 1000]
names(r) =  sapply(r, function(f) unique(f$AirQualityStationEoICode))
length(r) == length(unique(names(r)))


library(xts)
r = lapply(r, function(f) xts(f$Concentration, f$t))
aq = do.call(cbind, r)


# remove stations with more than 75% missing values:
sel = apply(aq, 2, function(x) sum(is.na(x)) < 0.75 * 365 * 24)
aqsel = aq[, sel] # stations are in columns

library(tidyverse)
read.csv(here("R", "AirBase_v8_stations.csv"), sep = "\t", stringsAsFactors = FALSE) %>% 
  as_tibble  %>% 
  # filter(country_iso_code == "CY", type_of_station == "Background") -> a2
  filter(country_iso_code == "CY") -> a2

library(sf)
library(stars)
a2.sf = st_as_sf(a2, coords = c("station_longitude_deg", "station_latitude_deg"), crs = 4326)

sel =  colnames(aqsel) %in% a2$station_european_code
aqsel = aqsel[, sel]

tb = tibble(NO2 = apply(aqsel, 2, mean, na.rm = TRUE), station_european_code = colnames(aqsel))
crs = 3857
right_join(a2.sf, tb) %>% st_transform(crs) -> no2.sf 

# load Cyprus boundaries
library(cshapes)
cshp = cshp(as.Date("2000-01-1"))
cy = cshp[cshp$ISO1AL2 == "CY",]
cy <- st_transform(st_as_sf(cy), crs)

ggplot() + geom_sf(data=cy) + geom_sf(data = no2.sf, mapping = aes(col = NO2))



## some text plus R expression


library(gstat)
# build a grid over Germany:
bb = st_bbox(cy)
dx = seq(bb[1], bb[3], 10000)
dy = seq(bb[4], bb[2], -10000) # decreases!
st_as_stars(matrix(0, length(dx), length(dy))) %>%
  st_set_dimensions(1, dx) %>%
  st_set_dimensions(2, dy) %>%
  st_set_dimensions(names = c("x", "y")) %>%
  st_set_crs(crs) -> grd
i = st_intersects(grd, cy)
grd[[1]][lengths(i)==0] = NA
grd

v <- gstat::variogram(NO2~1, no2.sf)
plot(v, plot.numbers = TRUE)
v.m = gstat::fit.variogram(v, vgm(1, "Exp", 50000, 1))
k = gstat::krige(NO2~1, no2.sf, grd, v.m)
#> [using ordinary kriging]
ggplot() + geom_stars(data = k, aes(fill = var1.pred, x = x, y = y)) + 
  geom_sf(data = st_cast(cy, "MULTILINESTRING")) + 
  geom_sf(data = no2.sf)

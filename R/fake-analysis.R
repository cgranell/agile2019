
# Fake paper based on the Chapter 16 of Spatial Data Science 

# Link to hourly (time series) data on Air Quality, Cyprus, 2017. Source: EEA

url <- "https://fme.discomap.eea.europa.eu/fmedatastreaming/AirQualityDownload/AQData_Extract.fmw?CountryCode=CY&CityName=&Pollutant=8&Year_from=2017&Year_to=2017&Station=&Samplingpoint=&Source=E1a&Output=TEXT&UpdateDate="


library(here)

data_aq <- here("R", "data")

files = list.files(data_aq, pattern = "*.csv", full.names = TRUE)
r = lapply(files[-1], function(f) read.csv(f))

Sys.setenv(TZ = "UTC") # make sure times are not interpreted as DST
r = lapply(r, function(f) {
  f$t = as.POSIXct(f$DatetimeBegin) 
  f[order(f$t), ] 
  }
) 


r = r[sapply(r, nrow) > 1000]
names(r) =  sapply(r, function(f) unique(f$AirQualityStationEoICode))
length(r) == length(unique(names(r)))


library(xts)
r = lapply(r, function(f) xts(f$Concentration, f$t))
aq = do.call(cbind, r)



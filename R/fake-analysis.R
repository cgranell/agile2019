
# Fake paper based on the Chapter 16 of Spatial Data Science 

# Link to hourly (time series) data on Air Quality, Cyprus, 2017. Source: EEA

url <- "https://fme.discomap.eea.europa.eu/fmedatastreaming/AirQualityDownload/AQData_Extract.fmw?CountryCode=CY&CityName=&Pollutant=8&Year_from=2017&Year_to=2017&Station=&Samplingpoint=&Source=E1a&Output=TEXT&UpdateDate="


library(here)

data_aq <- here("R", "data")

files = list.files(data_aq, pattern = "*.csv", full.names = TRUE)
r = lapply(files[-1], function(f) read.csv(f))
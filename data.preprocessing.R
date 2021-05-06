######################################### IMMIGRATION TO CANADA #########################################
# Clear working directory
rm(list = ls())

# Import and load packages
library(data.table)
library(tidyverse)

# Set working directory 
#setwd("") Input your working directory here.

# Import the dataset
canada.immigration.data.raw <- data.table::fread("Canada.csv", skip = 1)

# Data Preprocessing 
# Drop the unrequired columns and rows. Make sure to check your data during this step, mine imported with NA columns
canada.immigration.data.clean <- canada.immigration.data.raw %>%
  dplyr::select(c(-44:-51), -Coverage, -Type, -AREA, -REG, -DEV) %>% 
  .[1:197, ]

# Reshape the data 
canada.immigration.data.clean <- melt(canada.immigration.data.clean,
                                      id.vars = 1:4, measure.vars  = 5:38,
                                      variable.name = "Immigration Year",
                                      value.name = "Immigrant Count") %>% 
  setnames(old = c("OdName", "AreaName", "RegName", "DevName"),
           new = c("Country", "Continent", "Sub-continent", "Development status")) 

# Drop the country named "Total"
canada.immigration.data.clean <- canada.immigration.data.clean[Country != "Total"]

# Check the presence of missing data
sum(is.na(canada.immigration.data.clean))

# Convert the year from factor to numeric 
canada.immigration.data.clean[, `Immigration Year` := as.numeric(as.character(`Immigration Year`))]

# Export data (to be used for data visualization in tableau)
fwrite(canada.immigration.data.clean, "canada.immigration.data.clean.csv")

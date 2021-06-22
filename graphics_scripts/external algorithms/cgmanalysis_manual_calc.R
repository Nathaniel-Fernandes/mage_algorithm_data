# 0. include R package cgmanalysis
if(!require(cgmanalysis)) install.packages('cgmanalysis')
library(cgmanalysis)

# 1. Complete Data Analysis from Scratch

# This function from cgmanalysis calculates mage for the cgmdata in files in the input directory
cgmvariables("./graphics_scripts/external algorithms/data/files/", "./graphics_scripts/external algorithms/data/", outputname = "cgmanalysis results")


# 2. Load Results from CSV

cgmanalysis_data <- read.csv('./graphics_scripts/external algorithms/data/cgmanalysis results.csv')
cgmanalysis_mage <- cgmanalysis_data$r_mage


# calculate the manual calculations for other algorithms
if(!require(cgmanalysis)) install.packages('cgmanalysis')
library(cgmanalysis)

#cgmvariables("./graphics_scripts/external algorithms/data/files/", "./graphics_scripts/external algorithms/data/", outputname = "cgmanalysis data") # test43.csv throws an error sometimes, so delete it and rerun if that is the case

cgmanalysis_data <- read.csv('./graphics_scripts/external algorithms/data/cgmanalysis data.csv')

cgmanalysis_mage <- cgmanalysis_data$r_mage
cgmanalysis_mage_all <- c(cgmanalysis_mage[1:42], NaN, cgmanalysis_mage[43:length(cgmanalysis_mage)]) # insert NaN in index 43 because it throws an error

# Old cgmanalysis data
cgmanalysis_data_old <- read.csv('./graphics_scripts/external algorithms/data/cgmanalysis data (v2.7).csv')

cgmanalysis_mage_old <- cgmanalysis_data_old$r_mage
cgmanalysis_mage_old_all <- c(cgmanalysis_mage_old[1:42], NaN, cgmanalysis_mage_old[43:length(cgmanalysis_mage_old)]) # insert NaN in index 43 because it throws an error


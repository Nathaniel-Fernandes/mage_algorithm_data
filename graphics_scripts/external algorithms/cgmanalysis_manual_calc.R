# calculate the manual calculations for other algorithms
if(!require(cgmanalysis)) install.packages('cgmanalysis')
library(cgmanalysis)

#cgmvariables("./graphics_scripts/external algorithms/data/files/", "./graphics_scripts/external algorithms/data/", outputname = "cgmanalysis data")

cgmanalysis_data <- read.csv('./graphics_scripts/external algorithms/data/cgmanalysis data.csv')

cgmanalysis_mage <- cgmanalysis_data$r_mage
cgmanalysis_mage_all <- c(cgmanalysis_mage[1:39], NaN, cgmanalysis_mage[40:length(cgmanalysis_mage)]) # insert NaN in index 40 because removed it in line 15 of file "save_df_as_csv.R"


# calculate the manual calculations for other algorithms
if(!require(cgmanalysis)) install.packages('cgmanalysis')
if(!require(dplyr)) install.packages('dplyr')
library(cgmanalysis)
library(dplyr)

# Create a csv file in a separate directory for each df
# cgm_dataset_df_baghurst <- cgm_dataset_df
# for (i in 1:length(cgm_dataset_df_baghurst)) {
#   names(cgm_dataset_df_baghurst[[i]]) <- c('subjectid', 'sensorglucose', 'timestamp')
#   cgm_dataset_df_baghurst[[i]] <- cgm_dataset_df_baghurst[[i]] %>% select('subjectid', 'timestamp', 'sensorglucose')
# }
# 
# for (i in 1:length(cgm_dataset_df_baghurst)) {
#   if(i == 40) {
#     next
#     # Dataset 40 throws an error when used with cgmvariables so just skip it
#   }
#   write.csv(cgm_dataset_df_baghurst[[i]], paste0("./graphics_scripts/External MAGE Algorithms/Baghurst/Files/test", i, ".csv"))
# }

# cgmvariables("./graphics_scripts/External MAGE Algorithms/Baghurst/Files/", "./graphics_scripts/External MAGE Algorithms/Baghurst/Output/", outputname = "CGMAnalysis Data")

cgmanalysis_data <- read.csv('./graphics_scripts/External MAGE Algorithms/Baghurst/Output/CGMAnalysis Data.csv')

cgmanalysis_mage <- cgmanalysis_data$r_mage
cgmanalysis_mage_all <- c(cgmanalysis_mage[1:39], NaN, cgmanalysis_mage[40:length(cgmanalysis_mage)]) # insert NaN in index 40 because removed it in line 15


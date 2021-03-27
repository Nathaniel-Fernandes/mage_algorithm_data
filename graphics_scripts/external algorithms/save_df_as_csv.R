if(!require(dplyr)) install.packages('dplyr')
library(dplyr)

# Create a csv file in a separate directory for each df
# The columns are 'subjectid', 'sensorglucose', 'timestamp' - as needed by cgmanalysis
cgm_dataset_df_cp <- cgm_dataset_df
for (i in 1:length(cgm_dataset_df_cp)) {
  names(cgm_dataset_df_cp[[i]]) <- c('subjectid', 'sensorglucose', 'timestamp')
  cgm_dataset_df_cp[[i]] <- cgm_dataset_df_cp[[i]] %>% select('subjectid', 'timestamp', 'sensorglucose')
}

for (i in 1:length(cgm_dataset_df_cp)) {
  # if(i == 40) {
  #   next  # Data set 40 throws an error when used with cgmvariables so uncomment and skip it if you encounter an error
  # }
  
  write.csv(cgm_dataset_df_cp[[i]], paste0("./graphics_scripts/external algorithms/data/files/test", i, ".csv"))
}


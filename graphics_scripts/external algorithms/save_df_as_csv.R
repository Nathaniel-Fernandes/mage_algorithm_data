if(!require(dplyr)) install.packages('dplyr')
library(dplyr)

# Create a csv file in a separate directory for each df
# The columns are 'subjectid', 'sensorglucose', 'timestamp' - as needed by cgmanalysis
cgm_dataset_df_cp <- cgm_dataset_df
for (i in 1:length(cgm_dataset_df_cp)) {
  names(cgm_dataset_df_cp[[i]]) <- c('subjectid', 'timestamp','sensorglucose')
  cgm_dataset_df_cp[[i]] <- cgm_dataset_df_cp[[i]] %>% select('subjectid', 'timestamp', 'sensorglucose')
}

alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

for (i in 1:length(cgm_dataset_df_cp)) {
  # Generate unique id so files sort properly
  start = ceiling(i/2)
  end = ceiling((i+1) %% 2)
  
  UID = substring(alphabet, start, start+end)
    
  write.csv(cgm_dataset_df_cp[[i]], paste0("./graphics_scripts/external algorithms/data/files/",UID,"_test", i, ".csv"),row.names=FALSE)
}


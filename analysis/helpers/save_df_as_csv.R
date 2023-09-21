if(!require(dplyr)) install.packages('dplyr')
library(dplyr)

save_df_as_csv <- function(dfs, folderpath, colnames = c('subjectid', 'timestamp','sensorglucose')) {
  for (i in 1:length(dfs)) {
    names(dfs[[i]]) <- colnames # R uses copy-on-modify so changes to dfs won't propagate upwards/won't mutate in place
    dfs[[i]] <- dfs[[i]] %>% select(colnames) # ??? why is this line necessary?  
  }
  
  for (i in 1:length(dfs)) {
    # Prepend letters so files sort properly
    start = ceiling(i/2)
    end = ceiling((i+1) %% 2)
    UID = substring('ABCDEFGHIJKLMNOPQRSTUVWXYZ', start, start+end)
    
    write.csv(cgm_dataset_df_cp[[i]], paste0(folderpath, UID, "_test", i, ".csv"), row.names=FALSE)
  }
}

save_df_as_csv(cgm_dataset_df, './analysis/external algorithms/data/files/')
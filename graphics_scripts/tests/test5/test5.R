# This is to see the time

# source("./graphics_scripts/graphics.R") # Source this file to load data & helper functions!

cgm_dataset_df

time_duration <- sapply(1:length(cgm_dataset_df), function(x) {
  start_time <- as.POSIXct(cgm_dataset_df[[x]]$time[1])
  end_time <- as.POSIXct(cgm_dataset_df[[x]]$time[length(cgm_dataset_df[[x]]$time)])
  dt<- difftime(end_time, start_time, units="mins")
  as.numeric(dt)
})

# edge
min(time_duration)
max(time_duration)

# quantile
quantile(time_duration)
mean(time_duration)

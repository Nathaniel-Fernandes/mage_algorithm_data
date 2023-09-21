# This is to see the time

source("./graphics_scripts/graphics.R") # Source this file to load data & helper functions!

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

# correlation between manual calculations and each algorithm
cor(cgm_manual_calc, sapply(cgm_dataset_df, function(x) { iglu::mage(x)$MAGE }))
cor(cgm_manual_calc, sapply(cgm_dataset_df, function(x) { iglu::mage(x, "naive")$MAGE }))
cor(cgm_manual_calc, cgmanalysis_mage, use="pairwise.complete.obs")
cor(cgm_manual_calc, cgmquantify_mage)
cor(cgm_manual_calc, easygv_mage)


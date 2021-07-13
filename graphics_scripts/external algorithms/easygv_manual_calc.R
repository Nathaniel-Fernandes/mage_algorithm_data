#if(!require("xlsx")) install.packages("xlsx")
#library("xlsx")
library("readxl")

# 1. Create a master df with all subjects that can then write to an excel csv
max_col_length <- max(sapply(1:length(cgm_dataset_df), function(x) {length(cgm_dataset_df[[x]]$gl)}))

master_df <- data.frame(v1 = rep(NA, max_col_length))

for(i in 1:length(cgm_dataset_df)) {
  # Add column
  master_df[1:length(cgm_dataset_df[[i]]$gl),i] <-
    cgm_dataset_df[[i]]$gl
  
  # Change names
  names(master_df)[i] <- cgm_dataset_df[[i]]$id[1]
}

# Write the master df to an excel file
write.csv(master_df, file = './graphics_scripts/external algorithms/data/easygv_all_data.csv', row.names = FALSE, na = '')

# 1.5 Copy and paste the data from the newly created "easygv_all_data.csv" into the "Raw Data" sheet of the EasyGV workbook. Then click "Start Analysis" on the "main" sheet

# 2. Read in algorithm results
#easygv_results <- read.xlsx("./graphics_scripts/external algorithms/data/EasyGV results.xlsx", 1)
easygv_results <- read_excel("./graphics_scripts/external algorithms/data/EasyGV results.xlsx")

# remove rows w/ all na's
indices <- apply(easygv_results, 1, function(x) all(is.na(x)))
easygv_results <- easygv_results[ !indices, ]

for (i in 1:length(easygv_results$MAGE)) {
  if (easygv_results$MAGE[i] == "No Deviations outside 1 SD") {
    easygv_results[i, "MAGE"] <- "0"
  }
}

easygv_mage <- as.numeric(easygv_results$MAGE)

if(!require(xlsx)) install.packages("xlsx")
library("xlsx")

# cgm_easygv_format <- sapply(cgm_dataset_df, function(x) x$gl)
# 
# maxlength <- 0
# for(i in 1:length(cgm_dataset_df)) {
#   df_length <- length(cgm_dataset_df[[i]]$gl)
#   if(df_length > maxlength) {
#     maxlength <- df_length
#   }
# }
# 
# easygv_dataset_list <- cgm_dataset_df
# for(i in 1:length(easygv_dataset_list)) {
#   easygv_dataset_list[[i]] <- c(easygv_dataset_list[[i]]$gl, rep(NA, times = (maxlength - length(easygv_dataset_list[[i]]$gl)) ))
# }
# 
# names(easygv_dataset_list) <- sapply(1:46, function(i) paste0("test", i))
# 
# l <- cbind.data.frame(easygv_dataset_list)
# 
# write.csv(l, file = "./graphics_scripts/External MAGE Algorithms/easygv/cgmoutput.csv")

#c1 <- loadWorkbook("./graphics_scripts/External MAGE Algorithms/easygv/EasyGV.xlsx")
#sheets <- getSheets(c1)
#t = getCells(getRows(sheets$`Raw Data`))
c1 <- read.xlsx("./graphics_scripts/External MAGE Algorithms/easygv/EasyGV.xlsx", 4, "Results")

easygv_mage <- as.numeric(c1$MAGE)
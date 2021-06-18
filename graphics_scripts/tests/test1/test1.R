# This file contains a baseline test. All 45 samples are used to cross validate and select the best long and short moving average

# 1. Do 5-fold cross-validation to estimate algorithm accuracy on unseen data
# load('./graphics_scripts/tests/test1/cv_errors.Rda')
ps <- pod_split(1:length(cgm_dataset_df), 5, seed = 200)
cv_errors <- cross_val(ps, vector = TRUE) # expensive
save(cv_errors, file="./graphics_scripts/tests/test1/cv_errors.Rda")

mean(cv_errors) # 10.03% 

# 2. Find best short/long moving average pair
load('./graphics_scripts/tests/test1/pem_all.Rda')
# pem_all <- create_pem2(1:length(cgm_dataset_df)) # expensive
#save(pem_all, file="./graphics_scripts/tests/test1/pem_all.Rda")

plot_heatmap(pem_all) # Can visualize results
best_ma <- find_min_poderror(pem_all)[1,]

errors_df <- make_boxplot_df(1:length(cgm_dataset_df), short_ma=best_ma$short, long_ma=best_ma$long)
plot_boxplot(errors_df, "Algorithm Comparison vs Manual (5, 32)")

# data analysis
sd_err <- sapply(errors_df, sd, na.rm=TRUE)
summary_err <- sapply(errors_df, summary)


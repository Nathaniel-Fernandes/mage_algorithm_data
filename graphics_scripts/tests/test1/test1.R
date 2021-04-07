# This file contains a baseline test. All 49 samples are used to cross validate and select the best long and short moving average

# 1. Do 6-fold cross-validation to estimate algorithm accuracy on unseen data
ps <- pod_split(1:length(cgm_dataset_df), 6, seed = 200)
load('./graphics_scripts/tests/test1/cv_errors.Rda')
#cv_errors <- cross_val(ps, vector = TRUE) # expensive
mean(cv_errors) # 10.03% 

#save(cv_errors, file="./graphics_scripts/tests/test1/cv_errors.Rda")

# 2. Find best short/long moving average pair

load('./graphics_scripts/tests/test1/pem_all.Rda')
# pem_all <- create_pem2(1:length(cgm_dataset_df)) # expensive
#save(pem_all, file="./graphics_scripts/tests/test1/pem_all.Rda")

plot_heatmap(pem_all) # Can visualize results
best_ma <- find_min_poderror(pem_all)[1,]

# Note: need to fix calculation of other algorithms now that added 3 more samples
errors_df <- make_boxplot_df(1:length(cgm_dataset_df), short_ma=best_ma$short, long_ma=best_ma$long)
plot_boxplot(errors_df, "Algorithm Comparison vs Manual (5, 32)")

# data analysis
#sd_err <- sapply(errors_df, sd, na.rm=TRUE)
#summary_err <- sapply(errors_df, summary)
#View(summary_err)


# save(cross_validation_error, file="./graphics_scripts/tests/test1/cross_validation_error.Rda")
# save(o_1, file="./graphics_scripts/tests/test1/optimize.Rda")
# save(errors_df, file="./graphics_scripts/tests/test1/errors.Rda")
# save(sd_err, file="./graphics_scripts/tests/test1/sd_error.Rda")
# save(summary_err, file="./graphics_scripts/tests/test1/summary_err.Rda")
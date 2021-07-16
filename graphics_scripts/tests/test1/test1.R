# In this file, we:
#   1. perform 5-fold cross validation to estimate the accuracy of the IGLU V2 algorithm
#   2. Find the best short & long moving average pair over ALL the data
#   3. Calculate 5 # summary on algorithms error for all parameters
#   4. Compare the accuracy of all the algorithms on all samples

source("./graphics_scripts/graphics.R") # loads data & helper functions

# 1. Do 5-fold cross-validation to estimate algorithm accuracy on unseen data

# ps <- pod_split(1:length(cgm_dataset_df), 5, seed = 200)
# cv_errors <- cross_val(ps, vector = TRUE) # expensive (~20 minutes)
# save(cv_errors, file="./graphics_scripts/tests/test1/cv_errors.Rda")

load('./graphics_scripts/tests/test1/cv_errors.Rda')

mean(cv_errors) 
# 9.00% 


# 2. Find best short/long moving average pair over all 45 samples

# pem_all <- create_pem2(1:length(cgm_dataset_df)) # expensive
# save(pem_all, file="./graphics_scripts/tests/test1/pem_all.Rda")

load('./graphics_scripts/tests/test1/pem_all.Rda')

plot_heatmap(pem_all) # Can visualize results
best_ma <- find_min_poderror(pem_all)[1,]

best_ma
#     values  ind short long
#1183 4.85149 V32     5   32


# 3. Calculate mean and five-number summary on error for all samples

all_errors <- as.numeric(pem_all)
all_errors <- all_errors[!is.na(all_errors)] 

mean(all_errors)
# 7.585036

quantile(all_errors)
summary(all_errors)
# 0%        25%       50%       75%      100% 
# 4.851490  6.869470  7.688021  8.230413 11.649731 

# 4. Plot a boxplot comparing all the algorithms accuracy on all 45 samples
errors_df <- make_boxplot_df(1:length(cgm_dataset_df), short_ma=best_ma$short, long_ma=best_ma$long)
plot_boxplot(errors_df, "Algorithm Comparison vs Manual (5, 32)")

sd_err <- sapply(errors_df, sd, na.rm=TRUE)
summary_err <- sapply(errors_df, summary)

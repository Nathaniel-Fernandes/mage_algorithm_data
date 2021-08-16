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

mean(cv_errors) # across all
# 5.82% 


# 2. Find best short/long moving average pair over all 45 samples

#pem_all <- create_pem2(1:length(cgm_dataset_df)) # expensive
#save(pem_all, file="./graphics_scripts/tests/test1/pem_all_test726.Rda")

#pem_all_median <- create_pem2(1:length(cgm_dataset_df), calculate_mean = FALSE)

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

#################################################################
# Reload the errors on all 45 traces for various alpha/beta parameters and plot
load("./graphics_scripts/tests/test1/ErrorsMage_Irina.Rda")

# 4. Plot a boxplot comparing all the algorithms accuracy on all 45 samples
errors_df <- make_boxplot_df(1:length(cgm_dataset_df), short_ma=best_ma$short, long_ma=best_ma$long)

# Adjust to add cross-validation errors
errors_df$Iglu_ma_cv = errors_cv * 100

# Change how the boxplot is computed by reshaping errors_df

errors_tidy = tidyr::pivot_longer(errors_df, names_to = "Algorithm", values_to = "Error", cols = 1:6)

# Reorder factor levels

errors_tidy$Algorithm = factor(errors_tidy$Algorithm, levels = c("Iglu_ma", "Iglu_ma_cv", "Iglu_naive", "Easy_GV", "CGM_Analysis", "CGM_Quantify"))

# Rename factor levels for plotting

library(plyr)
errors_tidy$Algorithm = mapvalues(errors_tidy$Algorithm, from = c("Iglu_ma", "Iglu_ma_cv", "Iglu_naive", "Easy_GV", "CGM_Analysis", "CGM_Quantify"), to = c("iglu (ma, best)", "iglu (ma, cv)", "iglu (naive)", "EasyGV", "cgmanalysis", "cgmquantify"))

# Create plot

p = ggplot(errors_tidy, aes(x = Algorithm, y = Error)) +
  geom_boxplot(outlier.shape = NA) + geom_jitter(color = "blue", alpha=0.4, width = 0.15) +
  labs(x = "Algorithm", y = "% Error") +
  theme(text = element_text(size = 18))
p

# Save plot

figure.path = paste0(getwd(), "/graphics_scripts/tests/Figures/")

# pdf figure
pdf(file = paste(figure.path, "Boxplots.pdf"), width=10, height=6)
# png figure
png(file = paste0(figure.path, "Boxlots.png"), pointsize = 2, width = 4500, height = 3000, res = 500)
print(p)
dev.off()

# Extract summary statistics for all methods
library(tidyverse)
errors_tidy %>%
  dplyr::group_by(Algorithm)%>%
  dplyr::summarize(mean = mean(Error, na.rm = TRUE), med = median(Error, na.rm = TRUE), Q1 = quantile(Error, probs = 0.25, na.rm = TRUE), Q3 = quantile(Error, probs = 0.75, na.rm = TRUE))
#Algorithm        mean   med     Q1     Q3
#1 iglu (ma, best)  4.86  1.09  0.317   3.63
#2 iglu (ma, cv)    5.83  1.33  0.333   6.63
#3 iglu (naive)    39.0  42.0  32.6    48.3 
#4 EasyGV          23.4  11.3   6      22.3 
#5 cgmanalysis     23.9  20.3   8.61   32.1 
#6 cgmquantify     91.9  78.4  30.8   132.
# Script to reproduce the graphics in the paper
# Author: Nathaniel Fernandes
# Date: February 15, 2021

# NOTE: Run entire file from top to bottom first. Then go back and run specific plots if necessary.

# clear global environment, load datasets, source helper functions 
rm(list=ls())
source("./graphics_scripts/load_data.R")
source("./graphics_scripts/helpers.R")
source("./graphics_scripts/ggplot_graphics.R")
source("./graphics_scripts/External MAGE Algorithms/cgmanalysis_manual_calc.R")
source("./graphics_scripts/External MAGE Algorithms/cgmquantify_manual_calc.R")
source("./graphics_scripts/External MAGE Algorithms/easygv_manual_calc.R")

# 0. Preprocessing: split the data into helpful categories by sample index
gap_sample_id <- sapply(1:length(cgm_all_data), function(x) ifelse(cgm_all_data[[x]]$gap == 1,x,NA)) 
gap_sample_id <- gap_sample_id[!is.na(gap_sample_id)] # Remove the NA values from vectors

short_sample_id <- sapply(1:length(cgm_all_data), function(x) ifelse(cgm_all_data[[x]]$short == 1, x, NA)) 
short_sample_id <- short_sample_id[!is.na(short_sample_id)]

ideal_sample_id <- base::setdiff(1:length(cgm_all_data), c(gap_sample_id, short_sample_id)) # The ideal samples are those that are not short and don't have gaps


# 1. Plot the heat map for the optimization of moving average lengths
# o <- optimize_ma(ideal_sample_id) # Very computationally expensive - saved result in .Rda file
load("./graphics_scripts/data/optimize_cgm_data.RDa")
o <- optimize_cgm_data
plot_heatmap(o)


# 2. perform the cross-validation to find the approximate true error of the algorithm


# 2. Plot box plots of % error for algorithms
# a. Box plot 1 - comparing the performance of new mage algorithm on different types of samples
iglu_v2_err_ideal <- pod_error_iglu(ideal_sample_id, vector = TRUE)
iglu_v2_err_gap <- pod_error_iglu(gap_sample_id, vector = TRUE)
iglu_v2_err_short <- pod_error_iglu(short_sample_id, vector = TRUE)
  
# create a DF but fix the differing lengths first
iglu_v2_err_gap <- append(iglu_v2_err_gap, rep(NA, length(iglu_v2_err_ideal) - length(iglu_v2_err_gap)))
iglu_v2_err_short <- append(iglu_v2_err_short, rep(NA, length(iglu_v2_err_ideal) - length(iglu_v2_err_short)))

iglu_v2_df <- data.frame(iglu_v2_err_ideal,iglu_v2_err_gap,iglu_v2_err_short) %>%
  rename(Normal = 1, Gap = 2, Short = 3)

plot_boxplot(iglu_v2_df, title="IGLU MAGE Cross % Error") 

# b. Boxplot 2 - % Error for each algorithm vs the manual calculations 

# proposed iglu algorithm
iglu_v2_err_ideal <- pod_error_iglu(ideal_sample_id, vector = TRUE)

# iglu algorithm v1
iglu_v1_err_ideal <- pod_error_iglu(ideal_sample_id, algo="iglu_v1", vector = TRUE)

# cgmanalysis
cgmanalysis_err_ideal <- mage_error(ideal_sample_id, cgmanalysis_mage_all, cgm_manual_calc, TRUE)

# cgmquantify
cgmquantify_err_ideal <- mage_error(ideal_sample_id, cgmquantify_mage, cgm_manual_calc, TRUE)

easygv_err_ideal <- mage_error(ideal_sample_id, easygv_mage, cgm_manual_calc, TRUE)

l <- list("Iglu_v2" = iglu_v2_err_ideal,
          "Iglu_v1" = iglu_v1_err_ideal,
          "CGM_Analysis" = cgmanalysis_err_ideal,
          "CGM_Quantify" = cgmquantify_err_ideal,
          "Easy_GV" = easygv_err_ideal)
l <- cbind.data.frame(lapply(l, function(x) c(x, rep(NA, times = length(ideal_sample_id) - length(x)))))
  
plot_boxplot(l, "% Error Across Mage Algorithms")


# This script clears the global environment, loads the data sets, 
#     & sources helper functions in the proper order
# Author: Nathaniel Fernandes
# Date: February 15, 2021

rm(list=ls())
source("./graphics_scripts/load_data.R")
source("./graphics_scripts/helpers.R")
source("./graphics_scripts/ggplot_graphics.R")
source("./graphics_scripts/external algorithms/cgmanalysis_manual_calc.R")
source("./graphics_scripts/external algorithms/cgmquantify_manual_calc.R")
source("./graphics_scripts/external algorithms/easygv_manual_calc.R")
# This script clears the global environment, loads the data sets, 
# and sources helper functions in the proper order

rm(list=ls())
source("./analysis/load_data.R")
source("./analysis/helpers.R")
source("./analysis/ggplot_graphics.R")
source("./analysis/external algorithms/cgmanalysis_manual_calc.R")
source("./analysis/external algorithms/cgmquantify_manual_calc.R")
source("./analysis/external algorithms/easygv_manual_calc.R")
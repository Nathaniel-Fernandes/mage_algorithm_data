# This script clears the global environment, loads the data sets, 
# and sources helper functions in the proper order

rm(list=ls())

# load helpers
source("./analysis/helpers/load_data.R")
source("./analysis/helpers/error.R")
source("./analysis/helpers/graphics.R")
source("./analysis/helpers/cross_validation.R")
source("./analysis/helpers/save_df_as_csv.R")

# load
source("./analysis/external algorithms/cgmanalysis_manual_calc.R")
source("./analysis/external algorithms/cgmquantify_manual_calc.R")
source("./analysis/external algorithms/easygv_manual_calc.R")
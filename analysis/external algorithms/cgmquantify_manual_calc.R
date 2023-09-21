# 1. Complete Data Analysis from Scratch

# DOES NOT WORK YET. Use the command line instead
# library("reticulate")
# conda_create("r-reticulate")
# py_install("pandas")
# conda_install("exp")
# conda_install("r-reticulate", "cgmquantify")

# 2. Load Results from CSV

cgmquantify_data <- read.csv("./graphics_scripts/external algorithms/data/cgmquantify results.csv")
cgmquantify_mage <- cgmquantify_data$mage

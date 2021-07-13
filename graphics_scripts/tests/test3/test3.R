# Separate into normal, short, gaps

# 7/12/2021 - This file has not been run yet so the # are not updated

source("./graphics_scripts/graphics.R") # Source this file to load data & helper functions!

# preprocess data
cgm_gap_days <- cgm_gap_days[!is.na(cgm_gap_days)]
cgm_short_days <- cgm_short_days[!is.na(cgm_short_days)]
cgm_normal_days <- base::setdiff(1:length(cgm_all_data), c(cgm_gap_days,cgm_short_days))

load("graphics_scripts/tests/test3/pem_gap.Rda")
load("graphics_scripts/tests/test3/pem_short.Rda")
load("graphics_scripts/tests/test3/pem_normal.Rda")

# pem_gap <- create_pem2(cgm_gap_days)
# pem_normal <- create_pem2(cgm_normal_days)
# pem_short <- create_pem2(cgm_short_days)

# save(pem_gap, file="graphics_scripts/tests/test3/pem_gap.Rda")
# save(pem_normal, file="graphics_scripts/tests/test3/pem_normal.Rda")
# save(pem_short, file="graphics_scripts/tests/test3/pem_short.Rda")


plot_heatmap(pem_gap)
plot_heatmap(pem_short)
plot_heatmap(pem_normal)

find_min_poderror(pem_gap)[1,]
find_min_poderror(pem_short)[1,]
find_min_poderror(pem_normal)[1,]

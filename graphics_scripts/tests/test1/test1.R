# This file contains a baseline test. All 49 samples are used to cross validate and select the best long and short moving average

# 1. Find best short/long moving average pair

pem_all <- create_pem2(1:46)
save(pem_all, file="./graphics_scripts/tests/test3/pem_all.Rda")
load('./graphics_scripts/tests/test1/pem_all.Rda')
plot_heatmap(pem_all)
View(find_min_poderror(pem_all))

errors_df <- make_boxplot_df(1:46, short_ma = 5, long_ma=32)
plot_boxplot(errors_df, "Algorithm Comparison vs Manual (5, 32)")

# data analysis
sd_err <- sapply(errors_df, sd, na.rm=TRUE)
summary_err <- sapply(errors_df, summary)
View(summary_err)
# save(cross_validation_error, file="./graphics_scripts/tests/test1/cross_validation_error.Rda")
# save(o_1, file="./graphics_scripts/tests/test1/optimize.Rda")
# save(errors_df, file="./graphics_scripts/tests/test1/errors.Rda")
# save(sd_err, file="./graphics_scripts/tests/test1/sd_error.Rda")
# save(summary_err, file="./graphics_scripts/tests/test1/summary_err.Rda")

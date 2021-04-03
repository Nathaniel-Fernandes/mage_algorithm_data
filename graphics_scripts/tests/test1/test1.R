# This is the baseline test. All 46 samples are used to cross validate and select the best long and short moving average

# o_1 <- optimize_ma(1:46)
load('./graphics_scripts/tests/test1/optimize.Rda')
plot_heatmap(o_1)

errors_df <- make_boxplot_df(1:46)
plot_boxplot(errors_df)

# data analysis
sd_err <- sapply(errors_df, sd, na.rm=TRUE)
summary_err <- sapply(errors_df, summary)

# save(cross_validation_error, file="./graphics_scripts/tests/test1/cross_validation_error.Rda")
# save(o_1, file="./graphics_scripts/tests/test1/optimize.Rda")
# save(errors_df, file="./graphics_scripts/tests/test1/errors.Rda")
# save(sd_err, file="./graphics_scripts/tests/test1/sd_error.Rda")
# save(summary_err, file="./graphics_scripts/tests/test1/summary_err.Rda")

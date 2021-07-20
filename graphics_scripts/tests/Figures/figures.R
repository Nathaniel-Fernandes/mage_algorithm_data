library(iglu)
figure.path = paste0(getwd(), "/graphics_scripts/tests/Figures/")

# 1. Moving Averages on glucose plot
p1 = mage(cgm_dataset_df[[6]], short_ma = 5, long_ma = 32, plot=TRUE, show_ma=TRUE)
pdf(file = paste0(figure.path, "moving_averages.pdf"), width = 10, height = 5)
print(p1)
dev.off()

p2 = mage(cgm_dataset_df[[33]], short_ma = 5, long_ma = 32, plot=TRUE)
pdf(file = paste0(figure.path, "gap.pdf"), width = 10, height = 5)
print(p2)
dev.off()

# after run test1.R (load results from test1)
source("./graphics_scripts/ggplot_graphics.R")
load('./graphics_scripts/tests/test1/pem_all.Rda')
p3 = plot_heatmap(pem_all, low = 4, high = 12)
pdf(file = paste0(figure.path, "heatmap_percent_error.pdf"), width = 10, height = 5)
print(p3)
dev.off()

p4 = plot_boxplot(errors_df, "Algorithm Comparison vs Manual (5, 32)")
pdf(file = paste0(figure.path, "boxplot comparison of algorithms.pdf"), width=10, height=5)
print(p4)
dev.off()

# After running test4.R
p5 = ggplot(df2, aes(x=mage_plus_clean, y=mage_minus_clean)) + geom_point(size=2) + stat_function(fun = function(x) {x}, color="blue") + xlim(0, 300) + ggtitle("MAGE Plus vs MAGE Minus (2 Removed)")
pdf(file = paste(figure.path, "correlation mage plus minus.pdf"), width=8, height=6)
print(p5)
dev.off()

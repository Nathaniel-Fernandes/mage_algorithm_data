# Script to reproduce plots for JHU_subject5 manual MAGE
# Author: Elizabeth Chun
# Date: February 1st, 2021

# This data comes from one of the publically available datasets that comes with the
# R package iglu. Therefore we can simply load the iglu package
# We also load the ggplot2 package to create the pdf plot
if (!require(iglu)) install.packages('iglu')
if (!require(ggplot2)) install.packages('ggplot2')
library(iglu)
library(ggplot2)

# Subset the data exactly as was manually done
plot_data <- list()
plot_data[[1]] <- example_data_5_subject[11018:11301, ]
plot_data[[2]] <- example_data_5_subject[11302:11588, ]
plot_data[[3]] <- example_data_5_subject[11589:11830, ]
plot_data[[4]] <- example_data_5_subject[11831:12118, ]
plot_data[[5]] <- example_data_5_subject[12119:12406, ]

# Name dataset, dates, and manual mage values 
dataset <- "JHU_subject5"
dates <- c("3-1-2015", "3-2-2015", "3-3-2015", "3-4-2015", "3-5-2015")
manual_mage <- c(119.6, 211, 147, 125.25, 226.5)

# Save plots to pdf
figure.path <- "plot_scripts/plots/"
pdf(file = paste0(figure.path, dataset, ".pdf", sep = ""),
    width = 10, height = 5, onefile = TRUE)
for (i in 1:length(plot_data)) {
  p = plot_glu(plot_data[[i]]) + ggtitle(paste0("Manual MAGE: ", manual_mage[i], " (",
                                                dates[i], ")", sep = ""))
  print(p)
}
dev.off()

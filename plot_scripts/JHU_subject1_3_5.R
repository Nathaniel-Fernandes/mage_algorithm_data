# Script to reproduce plots for JHU_subjects 1, 3, and 5 manual MAGE
# Author: Elizabeth Chun
# Date: February 14th, 2021

# This data comes from one of the publically available datasets that comes with the
# R package iglu. Therefore we can simply load the iglu package
# We also load the ggplot2 package to create the pdf plot
if (!require(iglu)) install.packages('iglu')
if (!require(ggplot2)) install.packages('ggplot2')
library(iglu)
library(ggplot2)

# Subset the data exactly as was manually done
plot_data <- list()
plot_data[[1]] <- example_data_5_subject[405:644, ]
plot_data[[2]] <- example_data_5_subject[5746:5842, ]
plot_data[[3]] <- example_data_5_subject[12653:12940, ]

# Name dataset, dates, and manual mage values 
dataset <- "JHU_subject1_3_5"
dates <- c("6-9-2015", "3-10-2015", "3-7-2015")
manual_mage <- c(46.75, 89, 153)

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

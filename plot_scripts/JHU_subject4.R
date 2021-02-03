# Script to reproduce plots for JHU_subject4 manual MAGE
# Author: Lizzie Chun
# Date: February 2nd, 2021

# This data comes from one of the publically available datasets that comes with the
# R package iglu. Therefore we can simply load the iglu package
# We also load the ggplot2 package to create the pdf plot
if (!require(iglu)) install.packages('iglu')
if (!require(ggplot2)) install.packages('ggplot2')
library(iglu)
library(ggplot2)

# Subset the data exactly as was manually done
plot_data <- list()
plot_data[[1]] <- example_data_5_subject[7414:7699, ]
plot_data[[2]] <- example_data_5_subject[7700:7986, ]
plot_data[[3]] <- example_data_5_subject[7987:8274, ]
plot_data[[4]] <- example_data_5_subject[8275:8562, ]
plot_data[[5]] <- example_data_5_subject[8563:8850, ]

# Name dataset, dates, and manual mage values 
dataset <- "JHU_subject4"
dates <- c("3-14-2015", "3-15-2015", "3-16-2015", "3-17-2015", "3-18-2015")
manual_mage <- c(67, 57.5, 50, 41, 31.83)

# Save plots to pdf
figure.path <- "plot_scripts/plots/"
pdf(file = paste0(figure.path, dataset, ".pdf", sep = ""),
    width = 10, height = 5, onefile = TRUE)
for (i in 1:length(plot_data)) {
  p = plot_glu(plot_data[[i]]) + ggtitle(paste0("MAGE: ", manual_mage[i], " (",
                                                dates[i], ")", sep = ""))
  print(p)
}
dev.off()

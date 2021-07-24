# Script to reproduce plots for Dubosson (2018) subjects 1 and 2 manual MAGE
# Author: Elizabeth Chun
# Date: February 2nd, 2021; edited July 24th, 2021

# All data can be found in the data/ folder of this repository. This
# script is for the dataset titled Dubosson2018

# This dataset comes from a publically available CGM dataset. Both the link to the original
# download site and a preprocessor script can be found through our Awesome-CGM GitHub
# repository: https://github.com/irinagain/Awesome-CGM. This specific dataset is labeled
# Dubosson (2018). After downloading the raw data and running the preprocessor, the 
# processed data can now be used.

# Load in processed data
file <- "data/Dubosson2018_processed.csv"
datafile <- read.csv(file, header = TRUE)

# load/install required packages
if (!require(iglu)) install.packages('iglu')
if (!require(ggplot2)) install.packages('ggplot2')
library(iglu)
library(ggplot2)

# Subset the data exactly as was manually done
plot_data <- list()
plot_data[[1]] <- datafile[1:59, ]
plot_data[[2]] <- datafile[60:352, ]
plot_data[[3]] <- datafile[353:645, ]
plot_data[[4]] <- datafile[646:939, ]
plot_data[[5]] <- datafile[940:1233, ]
plot_data[[6]] <- datafile[1497:1787, ]
plot_data[[7]] <- datafile[1788:2078, ]

# Name dataset, dates, and manual mage values 
dataset <- "Dubosson2018"
subjects = c()
dates <- rep(as.Date(plot_data[[1]]$time[1]), length(plot_data))
for (i in 1:length(plot_data)) {
  subjects[i] <- unique(plot_data[[i]]$id)
  dates[i] <- as.Date(plot_data[[i]]$time[1])
}

manual_mage <- c(52, 118, 264, 183, 150, 266, 166)

# Save plots to pdf
figure.path <- "plot_scripts/plots/"
pdf(file = paste0(figure.path, dataset, ".pdf", sep = ""),
    width = 10, height = 5, onefile = TRUE)
for (i in 1:length(plot_data)) {
  p = plot_glu(plot_data[[i]]) + ggtitle(paste0("Manual MAGE: ", manual_mage[i], 
                                                " (", subjects[i], ", ",
                                                dates[i], ")", sep = ""))
  print(p)
}
dev.off()

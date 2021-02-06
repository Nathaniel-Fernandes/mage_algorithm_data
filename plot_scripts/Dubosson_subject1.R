# Script to reproduce plots for Dubosson (2018) subject 1 manual MAGE
# Author: Lizzie Chun
# Date: February 2nd, 2021

# This dataset comes from a publically available CGM dataset. Both the link to the original
# download site and a preprocessor script can be found through our Awesome-CGM GitHub
# repository: https://github.com/irinagain/Awesome-CGM. This specific dataset is labeled
# Dubosson (2018). After downloading the raw data and running the preprocessor, the 
# processed data can now be used.

# Load in processed data
file <- "Dubosson2018_processed.csv"
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

# Name dataset, dates, and manual mage values 
dataset <- "Dubosson2018_subject1"
dates <- c("10-1-2014", "10-2-2014", "10-3-2014", "10-4-2014", "10-5-2014")
manual_mage <- c(52, 108, 264, 183, 150.33)

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

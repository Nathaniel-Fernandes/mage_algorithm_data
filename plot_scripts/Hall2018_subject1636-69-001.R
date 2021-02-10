# Script to reproduce plots for Hall(2018) subject 1636-69-001 manual MAGE
# Author: Elizabeth Chun
# Date: February 1st, 2021

# This dataset comes from a publically available CGM dataset. Both the link to the original
# download site and a preprocessor script can be found through our Awesome-CGM GitHub
# repository: https://github.com/irinagain/Awesome-CGM. This specific dataset is labeled
# Hall (2018). After downloading the raw data and running the preprocessor, the 
# processed data can now be used.

# Load in processed data
file <- "Hall2018_processed.csv"
datafile <- read.csv(file, header = TRUE)

# load/install required packages
if (!require(iglu)) install.packages('iglu')
if (!require(ggplot2)) install.packages('ggplot2')
library(iglu)
library(ggplot2)

# Subset the data exactly as was manually done
plot_data <- list()
plot_data[[1]] <- datafile[1:244, ]
plot_data[[2]] <- datafile[245:531, ]
plot_data[[3]] <- datafile[532:754, ]
plot_data[[4]] <- datafile[755:849, ]
plot_data[[5]] <- datafile[849:1101, ]

# Name dataset, dates, and manual mage values 
dataset <- "Hall2018_subject1636-69-001"
dates <- c("2-3-2014", "2-4-2014", "2-5-2014", "3-29-2015", "3-30-2015")
manual_mage <- c(30.6, 106.6, 83, 91, 57.67)

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

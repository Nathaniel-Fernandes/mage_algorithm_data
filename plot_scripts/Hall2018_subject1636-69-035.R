# Script to reproduce plots for Hall(2018) subject 1636-69-035 manual MAGE
# Author: Lizzie Chun
# Date: February 2nd, 2021

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
plot_data[[1]] <- datafile[7698:7954, ]
plot_data[[2]] <- datafile[7955:8129, ]
plot_data[[5]] <- datafile[8130:8344, ]
plot_data[[3]] <- datafile[8345:8514, ]
plot_data[[4]] <- datafile[8515:8746, ]

# Name dataset, dates, and manual mage values 
dataset <- "Hall2018_subject1636-69-035"
dates <- c("1-29-2016", "1-30-2016", "1-31-2016", "2-1-2016", "2-2-2016")
manual_mage <- c(51.67, 74.5, 46, 40, 61)

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

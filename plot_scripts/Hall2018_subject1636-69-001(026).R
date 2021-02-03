# Script to reproduce plots for Hall(2018) subject 1636-69-001 and subject 1636-69-026 manual MAGE
# Author: Lizzie Chun
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
plot_data[[1]] <- datafile[1103:1380, ]
plot_data[[2]] <- datafile[1381:1667, ]
plot_data[[3]] <- datafile[1668:1847, ]
plot_data[[4]] <- datafile[1848:2125, ]
plot_data[[5]] <- datafile[2126:2304, ]
plot_data[[6]] <- datafile[2305:2586, ]

# Name dataset, dates, and manual mage values 
dataset <- "Hall2018_subject1636-69-001(026)"
dates <- c("3-31-2015", "4-1-2015", "4-2-2015", "11-24-2015", 
           "11-25-2015", "11-26-2015")
manual_mage <- c(50.6, 56.6, 34.33, 53, 65, 47.33)

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

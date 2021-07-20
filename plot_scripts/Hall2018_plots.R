# Script to reproduce plots for Hall(2018)  manual MAGE
# Author: Elizabeth Chun
# Date: February 1st, 2021; edited July 20th, 2021

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
plot_data[[6]] <- datafile[1102:1379, ]
plot_data[[7]] <- datafile[1380:1666, ]
plot_data[[8]] <- datafile[1667:1846, ]
plot_data[[9]] <- datafile[1847:2124, ]
plot_data[[10]] <- datafile[2125:2303, ]
plot_data[[11]] <- datafile[2304:2585, ]

# Name dataset, dates, and manual mage values 
dataset <- "Hall2018"
subjects = c()
dates <- rep(as.Date(plot_data[[1]]$time[1]), length(plot_data))
for (i in 1:length(plot_data)) {
  subjects[i] <- unique(plot_data[[i]]$id)
  dates[i] <- as.Date(plot_data[[i]]$time[1])
}

manual_mage <- c(31, 107, 83, 91, 58, 51, 57, 34, 53, 65, 47)

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

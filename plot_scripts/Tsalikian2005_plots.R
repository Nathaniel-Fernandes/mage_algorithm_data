# Script to reproduce plots for Tsalikian (2005) manual MAGE
# Author: Elizabeth Chun
# Date: February 2nd, 2021; edited July 20th, 2021

# This dataset comes from a publically available CGM dataset. Both the link to the original
# download site and a preprocessor script can be found through our Awesome-CGM GitHub
# repository: https://github.com/irinagain/Awesome-CGM. This specific dataset is labeled
# Tsalikian (2005). After downloading the raw data and running the preprocessor, the 
# processed data can now be used.

# Load in processed data
file <- "Tsalikian2005_processed.csv"
datafile <- read.csv(file, header = TRUE)

# load/install required packages
if (!require(iglu)) install.packages('iglu')
if (!require(ggplot2)) install.packages('ggplot2')
library(iglu)
library(ggplot2)

# Subset the data exactly as was manually done
plot_data <- list()
plot_data[[1]] <- datafile[1:135, ]
plot_data[[2]] <- datafile[136:242, ]
plot_data[[3]] <- datafile[243:384, ]
plot_data[[4]] <- datafile[456:561, ]
plot_data[[5]] <- datafile[1601:1755, ]
plot_data[[6]] <- datafile[3076:3230, ]
plot_data[[7]] <- datafile[3319:3475, ]
plot_data[[8]] <- datafile[3549:3701, ]
plot_data[[9]] <- datafile[4272:4423, ]

# Name dataset, dates, and manual mage values 
dataset <- "Tsalikian2005"

subjects = c()
dates <- rep(as.Date(plot_data[[1]]$time[1]), length(plot_data))
for (i in 1:length(plot_data)) {
  subjects[i] <- unique(plot_data[[i]]$id)
  dates[i] <- as.Date(plot_data[[i]]$time[1])
}

manual_mage <- c(138, 164, 135, 45, 55, 87, 360, 105, 283)

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

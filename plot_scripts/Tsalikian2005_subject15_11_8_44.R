# Script to reproduce plots for Tsalikian (2005) subjects 15, 11, 8, and 44 manual MAGE
# Author: Lizzie Chun
# Date: February 2nd, 2021

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
plot_data[[1]] <- datafile[1602:1756, ]
plot_data[[2]] <- datafile[3077:3231, ]
plot_data[[3]] <- datafile[3320:3476, ]
plot_data[[4]] <- datafile[3550:3702, ]
plot_data[[5]] <- datafile[4273:4424, ]

# Name dataset, dates, and manual mage values 
dataset <- "Tsalikian2005_subject15_11_8_44"
dates <- c("1-30-2000", "3-3-2000", "3-19-2000", "3-18-2000", "3-6-2000")
manual_mage <- c(68.5, 87.33, 360, 105.33, 283)

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

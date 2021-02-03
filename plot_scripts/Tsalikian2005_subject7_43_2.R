# Script to reproduce plots for Tsalikian (2005) subjects 7, 43, and 2 manual MAGE
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
plot_data[[1]] <- datafile[2:136, ]
plot_data[[2]] <- datafile[137:243, ]
plot_data[[3]] <- datafile[244:385, ]
plot_data[[4]] <- datafile[386:456, ]
plot_data[[5]] <- datafile[457:562, ]

# Name dataset, dates, and manual mage values 
dataset <- "Tsalikian2005_subject7_43_2"
dates <- c("2-7-2000", "2-8-2000", "2-8-2000", "2-9-2000", "2-6-2000")
manual_mage <- c(144, 95.5, 135, 14.5, 45)

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

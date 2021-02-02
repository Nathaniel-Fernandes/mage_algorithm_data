# Script to reproduce plots for Hall(2018) subject 1636-69-001 and subject 1636-69-026
# manual MAGE
# Author: Lizzie Chun
# Date: February 1st, 2021

########### Minor Problem with plot3

# This dataset comes from a publically available CGM dataset, the link to which
# can be found at our GitHub repository: https://github.com/irinagain/Awesome-CGM
# The dataset is labeled Hall (2018). A link to the original data, can be found on 
# the Awesome-CGM page for this study. Additionally, a preprocessor.r script is
# available from Awesome-CGM that will process the raw data into a common format:
# three columns id, time, and gl.

# Here we load in the data. The raw data file must be in the working directory.
file <- "Hall2018_processed.csv"
datafile <- read.csv(file, header = TRUE)

# load/install required packages
if (!require(iglu)) install.packages('iglu')
if (!require(ggplot2)) install.packages('ggplot2')
library(iglu)

# There are 5 manual calculations for this subject. Here we subset the data as was
# manually done
plot_data <- list()
plot_data[[1]] <- datafile[1103:1380, ]
plot_data[[2]] <- datafile[1381:1667, ]
plot_data[[3]] <- datafile[1668:1847, ]
plot_data[[4]] <- datafile[1848:2125, ]
plot_data[[5]] <- datafile[2126:2304, ]
plot_data[[6]] <- datafile[2305:2586, ]

# Now we create filenames for each of the datasets 
dataset <- "Hall2018_subject1636-69-001(026)"
dates <- c("3-31-2015", "4-1-2015", "4-2-2015", "11-24-2015", 
           "11-25-2015", "11-26-2015")
manual_mage <- c(50.6, 56.6, 34.33, 53, 65, 47.33)

# Save plots to pdf
figure.path <- "plot_scripts/"
pdf(file = paste0(figure.path, dataset, ".pdf", sep = ""),
    width = 10, height = 5, onefile = TRUE)
for (i in 1:length(plot_data)) {
  p = plot_glu(plot_data[[i]]) + ggtitle(paste0("MAGE: ", manual_mage[i], " (",
                                                dates[i], ")", sep = ""))
  print(p)
}
dev.off()

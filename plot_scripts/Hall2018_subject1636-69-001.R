# Script to reproduce plots for Hall(2018) subject 1636-69-001 manual MAGE
# Author: Lizzie Chun
# Date: February 1st, 2021

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

# There are 6 manual calculations is this manual set. Here we subset the data as was
# manually done
plot_data <- list()
plot_data[[1]] <- datafile[2:245, ]
plot_data[[2]] <- datafile[246:532, ]
plot_data[[3]] <- datafile[533:755, ]
plot_data[[4]] <- datafile[756:850, ]
plot_data[[5]] <- datafile[850:1102, ]

# Now we create filenames for each of the datasets 
dataset <- "Hall2018_subject1636-69-001"
dates <- c("2-3-2014", "2-4-2014", "2-5-2014", "3-29-2015", "3-30-2015")
manual_mage <- c(30.6, 106.6, 83, 91, 57.67)

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

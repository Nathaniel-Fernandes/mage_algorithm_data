# Script to reproduce plots for JHU_subject2 manual MAGE
# Author: Lizzie Chun
# Date: February 1st, 2021

# This data comes from one of the publically available datasets that comes with the
# R package iglu. Therefore we can simply load the iglu package
# We also load the ggplot2 package to create the pdf plot
if (!require(iglu)) install.packages('iglu')
if (!require(ggplot2)) install.packages('ggplot2')
library(iglu)

# There are 5 manual calculations for this subject. Here we subset the data as was
# manually done
plot_data <- list()
plot_data[[1]] <- example_data_5_subject[2995:3282, ]
plot_data[[2]] <- example_data_5_subject[3283:3570, ]
plot_data[[3]] <- example_data_5_subject[3571:3858, ]
plot_data[[4]] <- example_data_5_subject[3859:4145, ]
plot_data[[5]] <- example_data_5_subject[4146:4433, ]

# Now we create filenames for each of the datasets 
dataset <- "JHU_subject2"
dates <- c("2-25-2015", "2-26-2015", "2-27-2015", "2-28-2015", "3-1-2015")
manual_mage <- c(70, 81.33, 154, 71, 95)

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

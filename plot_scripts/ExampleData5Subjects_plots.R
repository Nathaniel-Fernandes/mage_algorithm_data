# Script to reproduce plots for Broll 2021 manual MAGE
# Author: Elizabeth Chun
# Date: February 14th, 2021, edited July 24th, 2021

# This data comes from one of the publically available datasets that comes with the
# R package iglu. Therefore we could simply load the iglu package
if (!require(iglu)) install.packages('iglu')
library(iglu)

# Alternatively, the data is also available in this repository labeled 
# ExampleData5Subjects.csv and can be loaded from that file by uncommenting the
# following code:
# example_data_5_subject <- read.csv("data/ExampleData5Subjects.csv")

if (!require(ggplot2)) install.packages('ggplot2')
library(ggplot2)

# Subset the data exactly as was manually done
plot_data <- list()
plot_data[[1]] <- example_data_5_subject[405:644, ]
plot_data[[2]] <- example_data_5_subject[2994:3281, ]
plot_data[[3]] <- example_data_5_subject[3282:3569, ]
plot_data[[4]] <- example_data_5_subject[3570:3857, ]
plot_data[[5]] <- example_data_5_subject[3858:4144, ]
plot_data[[6]] <- example_data_5_subject[4145:4432, ]
plot_data[[7]] <- example_data_5_subject[5746:5842, ]
plot_data[[8]] <- example_data_5_subject[7413:7698, ]
plot_data[[9]] <- example_data_5_subject[7699:7985, ]
plot_data[[10]] <- example_data_5_subject[7986:8273, ]
plot_data[[11]] <- example_data_5_subject[8274:8561, ]
plot_data[[12]] <- example_data_5_subject[8562:8849, ]
plot_data[[13]] <- example_data_5_subject[11018:11301, ]
plot_data[[14]] <- example_data_5_subject[11302:11588, ]
plot_data[[15]] <- example_data_5_subject[11589:11830, ]
plot_data[[16]] <- example_data_5_subject[11831:12118, ]
plot_data[[17]] <- example_data_5_subject[12119:12406, ]
plot_data[[18]] <- example_data_5_subject[12653:12940, ]

# Name dataset, dates, and manual mage values 
dataset <- "ExampleData5Subjects"

subjects = c()
dates <- rep(as.Date(plot_data[[1]]$time[1]), length(plot_data))
for (i in 1:length(plot_data)) {
  subjects[i] <- unique(plot_data[[i]]$id)
  dates[i] <- as.Date(plot_data[[i]]$time[1])
}

manual_mage <- c(47, 70, 81, 154, 104, 95, 89, 75, 58, 45, 69, 32,
                 120, 211, 147, 125, 227, 153)

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

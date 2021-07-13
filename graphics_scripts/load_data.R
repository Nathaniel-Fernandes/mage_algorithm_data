# Script to load the data and manual calculations to reproduce graphics
# Author: Nathaniel Fernandes
# Date: February 15, 2021

# 1. Require necessary packages
if (!require("iglu")) install.packages('iglu')
#if(!require("xlsx")) install.packages("xlsx")

library("iglu")
#library("xlsx")

library("readxl")

# 2. Read in the manual calculations data into a df
# manual_calc <- read.xlsx("./graphics_scripts/data/manual_calculations.xlsx", 1)

manual_calc <- read_excel("./graphics_scripts/data/manual_calculations.xlsx")

# Create file names for data
filepath = "./graphics_scripts/data/"
Dubosson2018_csv <- paste0(filepath, "Dubosson2018_processed.csv")
Hall2018_csv <- paste0(filepath, "Hall2018_processed.csv")
Tsalikian2005_csv <- paste0(filepath, "Tsalikian2005_processed.csv")

# Read in datasets
Dubosson2018 <- read.csv(Dubosson2018_csv, header = TRUE)
Hall2018 <- read.csv(Hall2018_csv, header = TRUE)
Tsalikian2005 <- read.csv(Tsalikian2005_csv, header = TRUE)
JHU <- example_data_5_subject

# 3. Combine all the data into "master" store

# 3.1 exclude the samples where the comment is "exclude"
cgm_all_data <- lapply(1:length(manual_calc$dataset), function(x) {
    as.list(manual_calc[x, ])
})
cgm_all_data <- Filter(function(x) is.na(x$comment) || x$comment != "exclude", cgm_all_data)

# 3.2 Subset the complete data sets by the row numbers found in the manual calculations
cgm_dataset_df <- lapply(cgm_all_data, function(x) {
  dataset <- x$dataset
  eval(parse(text=dataset))[x$start:x$end, ] # evaluate the text
})

cgm_manual_calc <- sapply(cgm_all_data, function(x) x$manual) # get manual calculations

# 4. Split the samples into meaningful groups by recording the index of the sample
cgm_gap_days <- sapply(1:length(cgm_all_data), function(i) ifelse(cgm_all_data[[i]]$gap==1,i,NA))
cgm_short_days <- sapply(1:length(cgm_all_data), function(i) ifelse(cgm_all_data[[i]]$short==1,i, NA))
cgm_adults <- sapply(1:length(cgm_all_data), function(i) ifelse(cgm_all_data[[i]]$adult==1,i,NA))
cgm_children <- sapply(1:length(cgm_all_data), function(i) ifelse(cgm_all_data[[i]]$adult==0, i, NA))
cgm_type_1 <- sapply(1:length(cgm_all_data), function(i) ifelse(cgm_all_data[[i]]$dtype==1,i,NA))
cgm_type_2 <- sapply(1:length(cgm_all_data), function(i) ifelse(cgm_all_data[[i]]$dtype==2,i,NA))
cgm_type_healthy <- sapply(1:length(cgm_all_data), function(i) ifelse(cgm_all_data[[i]]$dtype==0,i,NA))

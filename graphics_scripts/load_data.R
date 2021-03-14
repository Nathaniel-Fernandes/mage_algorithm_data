# Script to load the data and manual calculations to reproduce graphics
# Author: Nathaniel Fernandes
# Date: February 15, 2021

# 1. Require necessary packages
if (!require(iglu)) install.packages('iglu')
library(iglu)

# 2. Load Processed Data and subset exactly (order matters)
# NOTE: See the "Plot Scripts" for information on how to access the data sets
filepath = "./graphics_scripts/data/"
  
# DUBOSSON DATASET
Dubosson2018_csv <- paste0(filepath, "Dubosson2018_processed.csv")
Dubosson2018_df <- read.csv(Dubosson2018_csv, header = TRUE)

#Dubosson2018_manual_1 <- c(52, 118, 264, 183, 150.33)

# Subject 1 in dataset
Dubosson2018_data <- list()
Dubosson2018_data[[1]] <- c(Dubosson2018_df[1:59, ], manual=52, gap=0, short=1)
Dubosson2018_data[[2]] <- c(Dubosson2018_df[60:352, ], manual=118, gap=0, short=0)
Dubosson2018_data[[3]] <- c(Dubosson2018_df[353:645, ], manual=264, gap=0, short=0)
Dubosson2018_data[[4]] <- c(Dubosson2018_df[646:939, ], manual=183, gap=0, short=0)
Dubosson2018_data[[5]] <- c(Dubosson2018_df[940:1233,],manual=150.33, gap=0, short=0)

# HALL DATASET
Hall2018_csv <- paste0(filepath, "Hall2018_processed.csv")
Hall2018_df <- read.csv(Hall2018_csv, header = TRUE)
Hall2018_data <- list()

#Hall2018_manual_001 <- c(30.6, 106.6, 83, 91, 57.67) # Subject 1636-69-001 in dataset
Hall2018_data[[1]] <- c(Hall2018_df[1:244,    ], manual=30.6 , gap=0, short=0)
Hall2018_data[[2]] <- c(Hall2018_df[245:531,  ], manual=106.6, gap=0, short=0)
Hall2018_data[[3]] <- c(Hall2018_df[532:754,  ], manual=83   , gap=0, short=0)
Hall2018_data[[4]] <- c(Hall2018_df[755:849,  ], manual=91   , gap=1, short=0)
Hall2018_data[[5]] <- c(Hall2018_df[849:1101, ], manual=57.67, gap=0, short=0) # microscopic gap

#Hall2018_manual_026 <- c(50.6, 56.6, 34.33, 53, 65, 47.33) # Subject 1636-69-001(026) in dataset
Hall2018_data[[6]] <-  c(Hall2018_df[1102:1379, ], manual=50.6 , gap=0, short=0)
Hall2018_data[[7]] <-  c(Hall2018_df[1380:1666, ], manual=56.6 , gap=0, short=0)
Hall2018_data[[8]] <-  c(Hall2018_df[1667:1846, ], manual=34.33, gap=0, short=0) # Has a small gap
Hall2018_data[[9]] <-  c(Hall2018_df[1847:2124, ], manual=53   , gap=0, short=0)
Hall2018_data[[10]] <- c(Hall2018_df[2125:2303, ], manual=65   , gap=1, short=0)
Hall2018_data[[11]] <- c(Hall2018_df[2304:2585, ], manual=47.33, gap=0, short=0) # Has microscopic gap

#Hall2018_manual_035 <- c(51.67, 74.5, 46, 40, 61) # subject 035 in dataset
Hall2018_data[[12]] <- c(Hall2018_df[7697:7953, ], manual=51.67, gap=1, short=0) # has number of small gaps
Hall2018_data[[13]] <- c(Hall2018_df[7954:8128, ], manual=74.5 , gap=1, short=0)
Hall2018_data[[14]] <- c(Hall2018_df[8129:8343, ], manual=46   , gap=1, short=0)
Hall2018_data[[15]] <- c(Hall2018_df[8344:8513, ], manual=40   , gap=1, short=0)
Hall2018_data[[16]] <- c(Hall2018_df[8514:8745, ], manual=61   , gap=1, short=0)

# JHU DATASET (comes with the iglu package)
JHU_data <- list()

#JHU_manual_2 <- c(70, 81.33, 154, 71, 95) # subject 2 in dataset
JHU_data[[1]] <- c(example_data_5_subject[2994:3281, ], manual=70, gap=0, short=0)
JHU_data[[2]] <- c(example_data_5_subject[3282:3569, ], manual=81.33, gap=0, short=0)
JHU_data[[3]] <- c(example_data_5_subject[3570:3857, ], manual=154, gap=0, short=0)
JHU_data[[4]] <- c(example_data_5_subject[3858:4144, ], manual=71, gap=0, short=0)
JHU_data[[5]] <- c(example_data_5_subject[4145:4432, ], manual=95, gap=0, short=0)

#JHU_manual_4 <- c(67, 57.5, 50, 41, 31.83) # subject 4 in dataset
JHU_data[[6]] <-  c(example_data_5_subject[7413:7698, ], manual=67, gap=0, short=0)
JHU_data[[7]] <-  c(example_data_5_subject[7699:7985, ], manual=57.5, gap=0, short=0)
JHU_data[[8]] <-  c(example_data_5_subject[7986:8273, ], manual=50, gap=0, short=0)
JHU_data[[9]] <-  c(example_data_5_subject[8274:8561, ], manual=41, gap=0, short=0)
JHU_data[[10]] <- c(example_data_5_subject[8562:8849, ], manual=31.83, gap=0, short=0)

#JHU_manual_5 <- c(119.6, 211, 147, 125.25, 226.5) # Subject 5 in dataset
JHU_data[[11]] <- c(example_data_5_subject[11018:11301, ], manual=119.6, gap=0, short=0) # has microscopic gap
JHU_data[[12]] <- c(example_data_5_subject[11302:11588, ], manual=211, gap=0, short=0) # has microscopic gap
JHU_data[[13]] <- c(example_data_5_subject[11589:11830, ], manual=147, gap=1, short=0) 
JHU_data[[14]] <- c(example_data_5_subject[11831:12118, ], manual=125.25, gap=0, short=0)
JHU_data[[15]] <- c(example_data_5_subject[12119:12406, ], manual=226.5, gap=0, short=0)

# TSALIKIAN DATASET
Tsalikian2005_csv <- paste0(filepath, "Tsalikian2005_processed.csv")
Tsalikian2005_df <- read.csv(Tsalikian2005_csv, header = TRUE)
Tsalikian2005_data <- list()
#37
#Tsalikian2005_manual_7 <- c(144, 95.5, 135, 14.5, 45) # Subject 7 in dataset
Tsalikian2005_data[[1]] <- c(Tsalikian2005_df[1:135,   ], manual=144, gap=0, short=1)
Tsalikian2005_data[[2]] <- c(Tsalikian2005_df[136:242, ], manual=95.5, gap=0, short=1)
Tsalikian2005_data[[3]] <- c(Tsalikian2005_df[243:384, ], manual=135, gap=0, short=1)
Tsalikian2005_data[[4]] <- c(Tsalikian2005_df[385:455, ], manual=14.5, gap=0, short=1)
Tsalikian2005_data[[5]] <- c(Tsalikian2005_df[456:561, ], manual=45, gap=0, short=1)

#Tsalikian2005_manual_15 <- c(68.5, 87.33, 360, 105.33, 283)
Tsalikian2005_data[[6]] <-  c(Tsalikian2005_df[1601:1755, ], manual=68.5, gap=0, short=1)
Tsalikian2005_data[[7]] <-  c(Tsalikian2005_df[3076:3230, ], manual=87.33, gap=0, short=1)
Tsalikian2005_data[[8]] <-  c(Tsalikian2005_df[3319:3475, ], manual=360, gap=0, short=1)
Tsalikian2005_data[[9]] <-  c(Tsalikian2005_df[3549:3701, ], manual=105.33, gap=0, short=1)
Tsalikian2005_data[[10]] <- c(Tsalikian2005_df[4272:4423, ], manual=283, gap=0, short=1)

## RESULT ##
# Combine all data into "master" store (order partially matters)
cgm_all_data <- c(Dubosson2018_data, Hall2018_data, JHU_data, Tsalikian2005_data)

# Extract the needed functions in different variables
cgm_dataset_list <- lapply(cgm_all_data, function(x) as.data.frame(x[c('id', 'gl', 'time')]))
cgm_dataset_df <- lapply(cgm_all_data, function(x) as.data.frame(x[c('id', 'gl', 'time')]))

#iglu_mage_calc <- lapply(cgm_dataset_df, function (x) iglu::mage(x, plot = T))

cgm_manual_calc <- sapply(cgm_all_data, function(x) x$manual) # get manual calculations
cgm_gap_days <- sapply(1:length(cgm_all_data), function(i) ifelse(cgm_all_data[[i]]$gap==1,i,NA))
cgm_short_days <- sapply(1:length(cgm_all_data), function(i) ifelse(cgm_all_data[[i]]$short==1,i, NA))



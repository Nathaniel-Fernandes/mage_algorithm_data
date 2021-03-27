if(!require(xlsx)) install.packages("xlsx")
library("xlsx")

c1 <- read.xlsx("./graphics_scripts/external algorithms/data/EasyGV.xlsx", 4, "Results")

easygv_mage <- as.numeric(c1$MAGE)
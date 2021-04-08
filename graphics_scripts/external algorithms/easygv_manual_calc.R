if(!require(xlsx)) install.packages("xlsx")
library("xlsx")

c1 <- read.xlsx("./graphics_scripts/external algorithms/data/EasyGV.xlsx", 4, "Results")

for (i in 1:length(c1$MAGE)) {
  if (c1$MAGE[i] == "No Deviations outside 1 SD") {
    c1[i, "MAGE"] <- 0
  }
}

easygv_mage <- as.numeric(c1$MAGE)

# In this file, we compare the difference between MAGE+ and MAGE-. We expect the correlation
# to be moderate as Baghurst asserts that MAGE+ and MAGE- often do not correlate well

# 1. A low correlation of 0.44 when include ALL samples, however this is probably due to a couple outliers
# (see below)
mage_plus <- sapply(cgm_dataset_df, function(x) mage(x$gl, type="plus")$MAGE)
mage_minus <- sapply(cgm_dataset_df, function(x) mage(x$gl, type="minus")$MAGE)

cor(mage_plus, mage_minus)
# 0.44

df <- as.data.frame(cbind(mage_plus, mage_minus))
ggplot(df, aes(x=mage_plus, y=mage_minus)) + geom_point(size=2) + stat_function(fun = function(x) {x}, color="blue") + xlim(0, 300) + ggtitle("MAGE Plus vs MAGE Minus")



# 2. Remove outliers that have a ratio greater than 10 and rerun
# now the correlation is moderately strong (0.80). This indicates that on balance,
# there is a moderately strong correlation between MAGE+ & MAGE-, especially when they are both small
ratios <- sapply(1:length(mage_plus), function(x) {
  if_else(mage_plus[x] > mage_minus[x], mage_plus[x]/mage_minus[x], mage_minus[x]/mage_plus[x])
})

mage_plus_clean <- mage_plus[-which(ratios > 10)]
mage_minus_clean <- mage_minus[-which(ratios > 10)]
cor(mage_plus_clean, mage_minus_clean)
# 0.7952275

df2 <- as.data.frame(cbind(mage_plus_clean, mage_minus_clean))
ggplot(df2, aes(x=mage_plus_clean, y=mage_minus_clean)) + geom_point(size=2) + stat_function(fun = function(x) {x}, color="blue") + xlim(0, 300) + ggtitle("MAGE Plus vs MAGE Minus (2 Removed)")

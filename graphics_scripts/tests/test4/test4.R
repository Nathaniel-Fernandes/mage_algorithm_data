# To compare the difference between MAGE+ and MAGE-

# NOTE: the current mage function in the iglu package on GitHub does not have the ability to calculate mage+/-

mage_plus <- sapply(cgm_dataset_df, function(x) mage(x$gl, type="plus")$MAGE)

mage_minus <- sapply(cgm_dataset_df, function(x) mage(x$gl, type="minus")$MAGE)

cor(mage_plus, mage_minus)

df <- as.data.frame(cbind(mage_plus, mage_minus))

ggplot(df, aes(x=mage_plus, y=mage_minus)) + geom_point(size=2) + stat_function(fun = function(x) {x}, color="blue") + xlim(0, 300) + ggtitle("MAGE Plus vs MAGE Minus")

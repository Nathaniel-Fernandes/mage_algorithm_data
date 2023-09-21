
# Find all errors for a particular sample on short and long
all_errors_short_long <- function(data, manual){
  m <- matrix(NA, 15, 38)
  
  for(long in 16:38) {
    for(short in 1:15) {
      # Calculate average error across the data for that particular long and short
      m[short, long] = abs(iglu::mage(data, long_ma = long, short_ma = short)$MAGE / manual - 1)
    }
  }
  
  m
}

source("./graphics_scripts/graphics.R") # loads data & helper functions


# Calculate errors for all 45 samples with all moving averages at once
errors = array(NA, dim = c(n, 15, 38))
for (i in 1:n){
  print(i)
  errors[i, , ] = all_errors_short_long(data[[i]], manual[i])
}

dim(errors)

# Then check what is the smallest combination across all, that is
# Need to take mean across everything
mean_all = apply(errors, c(2, 3), mean, na.rm = TRUE)
best_pair = which(mean_all == min(mean_all, na.rm = TRUE), arr.ind = TRUE) #5, 32
errors_best = errors[, best_pair[1], best_pair[2]] # mean is 4.8%, median is 1.1%

# Now do cross-validation error check
# First, split into folds, same way as Nathaniel for consistency
ps <- pod_split(1:length(cgm_dataset_df), 5, seed = 200)

# Redo the folds into vector form
fold_id = rep(NA, length(cgm_dataset_df))
for (i in 1:5){
  fold_id[ps[[i]]] = i
}

# Next, find best pair only based on data into folds and get the errors outside
errors_cv = rep(NA, n)

# Note that the best moving averate is quite consistently is around 5, 32
for (i in 1:5){
  print(i)
  # Find the optimal parameter value for long and short on 4/5 of the data
  mean_all_but_i = apply(errors[fold_id != i, , ], c(2, 3), mean, na.rm = TRUE)
  best_pair_but_i = which(mean_all_but_i == min(mean_all_but_i, na.rm = TRUE), arr.ind = TRUE) 
  print(best_pair_but_i)
  # Just in case the minimum is not unique
  if (length(best_pair_but_i) > 2){
    best_pair_but_i = best_pair_but_i[1, ]
  }
  
  # Evaluate the errors on the remaining 1/5 of the data
  errors_cv[fold_id == i] = errors[fold_id == i, best_pair_but_i[1], best_pair_but_i[2]]
}

summary(errors_cv) #mean is 5.8%, median is 1.3%

#Save errors and cv errors
save(errors_best, errors_cv, file = "graphics_scripts/tests/test1/ErrorsMage_Irina.Rda")

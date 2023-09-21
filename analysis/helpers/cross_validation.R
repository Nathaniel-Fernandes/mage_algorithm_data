# 5. Cross Validate IGLU V2
# Perform an n-fold cross validation, where n is the length(pod_list)
cross_val <- function(pod_list, vector = FALSE, return_pem=FALSE) {
  ln <- length(pod_list) # number of pods to determine n in n-fold cross val
  
  total_ln <- length(unlist(pod_list)) # the total # of samples
  indices <- 1:total_ln
  pem_sums <- list()
  
  # OPTIMIZATION TRICK
  # calculate the percent error matrix for each sample individually so you can just
  # sum the required ones at the end. This eliminates the need to recalculate the PEM of
  # sample 3 (for example) in every fold.
  pem_list <- list()
  for(i in 1:total_ln) {
    pem_list[[i]] <- create_pem2(i)
  }
  
  for(i in 1:ln) {
    # The purpose of this loop is to find the short/long that yields the MINIMUM error 
    # on all the training samples not in sample i, so can test error of that combo
    # on sample i
    
    # 1. Pt. 1
    # pod_list[[i]] contains indices of the randomly split samples 
    # `indices` contains ALL sample indices (1 to total_ln)
    # THUS: indices[-pod_list[[i]]] selects all sample indices NOT in the testing sample i
    
    # 2. Pt. 2
    # pem_list[i] contains the "percent error matrices" for each sample i (i in 1:total_ln) 
    # pem_list[vector of indices] will subset the list to return a list w/ the PEM of the desired indices
    # THUS: Reduce(`+`, list of nXn matrices) will sum all the selected indices
    
    # 3. Result
    # min_error is a list with length ln (i.e. 5 for 5-fold cross val), and will contain the
    # sums of the PEMs (percent error matrices) for all training samples NOT in testing group i
    pem_sums[[i]] <- Reduce(`+`, pem_list[indices[-pod_list[[i]]]])
  }
  
  # for each sample, find the short & long moving average lengths that yields the lowest error on the training PEM
  optimal_params <- lapply(pem_sums, function(x) { 
    find_min_poderror(x)[1,]
  })
  
  # calculate the mean error on each pod `i` where the short & long moving averages are given by the "optimal" parameters
  errors <- sapply(1:ln, function(x) {
    pod_error_iglu(pod_list[[x]],short_ma=optimal_params[[x]]$short, long_ma = optimal_params[[x]]$long, vector=TRUE)
  })
  
  if(return_pem == TRUE) {
    return(min_error)
  }
  
  if(vector == TRUE) {
    return(errors)
  }
  
  mean(errors)
}



###### IRINA's VERSION

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

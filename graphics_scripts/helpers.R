# Script contains helper functions to reproduce graphics in paper
# Author: Nathaniel Fernandes
# Date: March 1, 2021

# 1. Percent Error on a single sample (IGLU V1/2)
# @parameter sample_index The index in the list of cgm data for the dataset
# @param algo Whether to use the version 1 or 2 of the iglu mage algorithm
# @param ... Any additional parameters to pass to iglu::mage (see documentation)

single_error_iglu <- function(sample_index, algo = c('iglu_ma', 'iglu_naive'), ...) {
  algo = match.arg(algo)
  percent_err <- NULL
  
  if(algo == 'iglu_ma') {
    err <- iglu::mage(cgm_dataset_df[[sample_index]], ...)$MAGE / cgm_manual_calc[sample_index] - 1
  }
  else if(algo == 'iglu_naive') {
    err <- iglu::mage(cgm_dataset_df[[sample_index]], 'naive', ...)$MAGE / cgm_manual_calc[sample_index] - 1
  }
  
  percent_err <- abs(err * 100)
  return(percent_err)
}


# 2. Percent Error on a vector of sample indices (IGLU)
# @param pod A numeric vector of sample indices
# @param vector Whether to return a vector of errors for each sample index or the mean
# @param ... Any other parameters to pass to "single_error_iglu"

pod_error_iglu <- function(pod, vector = FALSE, algo = c('iglu_ma', 'iglu_naive'), ...) {
  
  algo = match.arg(algo)
  percent_err <- NULL
  err <- NULL
  
  if(algo == 'iglu_ma') {
    err <- sapply(cgm_dataset_df[pod], function(x) iglu::mage(x, ...)$MAGE) / cgm_manual_calc[pod] - 1
  }
  else if(algo == 'iglu_naive') {
    err <- sapply(cgm_dataset_df[pod], function(x) iglu::mage(x, 'naive', ...)$MAGE) / cgm_manual_calc[pod] - 1
  }

  percent_err <- abs(err) * 100
  
  if(vector) {
    return(percent_err)
  }
  
  mean(percent_err, na.rm = T)
}


# 3. Percent Error on arbitrary algorithm (ANY)
# @param pod A vector of sample indices
# @param algo_calc The algorithm's MAGE calculation on a sample of CGM data
# @param manual_calc The manual MAGE calculation on a sample of CGM data
# @param vector Boolean. True = return vector of % error. False = return mean of % errors

mage_error <- function(pod, algo_calc, manual_calc, vector = FALSE) {
  err <- (algo_calc[pod] - manual_calc[pod]) / manual_calc[pod]
  
  percent_err <- abs(err) * 100
  
  if(vector == TRUE) {
    return(percent_err)
  }
  
  mean(percent_err, na.rm = TRUE)
}

# 4. Optimize MA lengths (IGLU V2)
# Given a pod of "sample indices" create_pem will calculate the % error for each combination
# of short and long moving average lengths (1 to n) on the samples and return a n X n matrix
# where each cell is the % error. 
#
# Notes: 
# 1. "n" can be specified by the max_n parameter 
# 2. create_pem = "Create Percent Error Matrix"
# 3. short is restricted to 1-15, long is 16-max_n
# 4. create_pem2 is slightly faster (7.5 vs 10 sec on 1 sample)
# microbenchmark(create_pem(1), times=5)
# microbenchmark(create_pem2(1), times=5)

# @param pod A vector of sample indices
# @param max_n The maximum length of the moving average
create_pem <- function(pod, max_n = 38) {
  structure <- rep(NaN, max_n*max_n*length(pod));
  expanded_array <- array(structure, c(max_n, max_n, length(pod)))

  for(long in 16:max_n) {
    for(short in 1:15) {
      for(i in 1:length(pod)) {
        if(pod[i] != 0) {
          expanded_array[short, long, i] <- single_error_iglu(pod[i], short_ma = short, long_ma = long)
        }
      }
    }
  }

  if(length(pod) == 1) {
    return(expanded_array)
  }
    
  rowMeans(expanded_array[,,], dims = 2, na.rm = TRUE) # collapse the array
}
create_pem2 <- function(pod, max_n = 38) {
  m <- matrix(NA, max_n, max_n)
  
  for(long in 16:max_n) {
    for(short in 1:15) {
      m[short, long] <- pod_error_iglu(pod, short_ma = short, long_ma = long)
    }
  }
  return(m)
}

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
    pod_error_iglu(pod_list[[x]],short_ma=optimal_params[[x]]$short, long_ma = optimal_params[[x]]$long)
  })
  
  if(return_pem == TRUE) {
    return(min_error)
  }
  
  if(vector == TRUE) {
    return(errors)
  }
  
  mean(errors)
}

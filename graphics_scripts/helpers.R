# Script contains helper functions to reproduce graphics in paper
# Author: Nathaniel Fernandes
# Date: March 1, 2021

## 1. Percent Error on a single sample (IGLU V1/2)
# @parameter sample_index The index in the list of cgm data for the dataset
# @param algo Whether to use the version 1 or 2 of the iglu mage algorithm
# @param ... Any additional parameters to pass to iglu::mage (see documentation)

single_error_iglu <- function(sample_index, algo = c('iglu_v2', 'iglu_v1'), ...) {
  algo = match.arg(algo)
  percent_err <- NULL
  
  if(algo == 'iglu_v2') {
    err <- iglu::mage(cgm_dataset_df[[sample_index]], ...)$MAGE / cgm_manual_calc[sample_index] - 1
  }
  else if(algo == 'iglu_v1') {
    err <- iglu::mage(cgm_dataset_df[[sample_index]], 'v1', ...)$MAGE / cgm_manual_calc[sample_index] - 1
  }
  
  percent_err <- abs(err * 100)
  return(percent_err)
}


# 2. Percent Error on a vector of sample indices (IGLU)
# @param pod A numeric vector of sample indices
# @param vector Whether to return a vector of errors for each sample index or the mean
# @param ... Any other parameters to pass to "single_error_iglu"

pod_error_iglu <- function(pod, vector = FALSE, algo = c('iglu_v2', 'iglu_v1'), ...) {
  
  algo = match.arg(algo)
  percent_err <- NULL
  err <- NULL
  
  if(algo == 'iglu_v2') {
    err <- sapply(cgm_dataset_df[pod], function(x) iglu::mage(x, ...)$MAGE) / cgm_manual_calc[pod] - 1
  }
  else if(algo == 'iglu_v1') {
    err <- sapply(cgm_dataset_df[pod], function(x) iglu::mage(x, 'v1', ...)$MAGE) / cgm_manual_calc[pod] - 1
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

cross_val2 <- function(pod_list, vector = FALSE) {
  ln <- length(pod_list)
  total_ln <- length(unlist(pod_list))
  
  pods_opt <- list()
  
  for(i in 1:total_ln) {
    pods_opt[[i]] <- create_pem2(i)
  }
  
  indices <- 1:total_ln
  min_error <- list()
  for(i in 1:ln) {
    # The purpose of this loop is to find the short/long that yields the MINIMUM error 
    # on all the training samples not in sample i, so can test error of that combo
    # on sample i
    
    # 1. Pt. 1
    # pod_list[[i]] contains indices of the randomly split samples 
    # indices contains ALL sample indices (1 to total_ln)
    # THUS: indices[-pod_list[[i]] selects all sample indices NOT in the testing sample i
    
    # 2. Pt. 2
    # pods_opt[i] contains the "percent error matrices" for each sample i (i in 1:total_ln) 
    # pods_opt[vector of indices] will subset the list to return the desired indices
    # THUS: Reduce(`+`, list of nXn matrices) will sum all the selected indices
    
    # 3. Result
    # min_error is a list with length ln (i.e. 5 for 5-fold cross val), and will contain the
    # sums of the PEMs (percent error matrices) for all training samples NOT in training group i
    min_error[[i]] <- Reduce(`+`, pods_opt[indices[-pod_list[[i]]]])
  }
  
  optimal_params <- lapply(min_error, function(x) { 
        find_min_poderror(x)[1,]
    })
  
  errors<- sapply(1:ln, function(x) {
    pod_error_iglu(pod_list[[i]],short_ma=optimal_params[[x]]$short, long_ma = optimal_params[[x]]$long)
  })
  
  if(vector) {
    return(errors)
  }
  
  mean(errors)
}

#5. TO DO TEST 2 and FIND MIN ERROR IN POD
cross_val <- function(pod_list, vector = FALSE) {
  ln <- length(pod_list)
  
  # 0. preallocate array
  errors <- numeric(ln)
  temp_indices <- 1:ln
  
  # 1. save the optimization for each pod
  pods_opt <- rep(list(), ln)
  for(i in 1:ln) {
    print(paste(i, "start"))
    sample_indices <- unlist(pod_list[temp_indices[-c(i)]])
    pods_opt[[i]] <- find_min_poderror(create_pem(sample_indices))[1,]
    print(paste(i, "end"))
  }
  
  # 2. For each pod do the leave one out and append error
  count <- 1
  for(i in 1:ln) {
    for(j in 1:ln) {
      if(j != i) {
        errors[count] <- pod_error_iglu(pod_list[[i]],short_ma = pods_opt[[j]]$short, long_ma = pods_opt[[j]]$long)
        count <- count + 1
      }
    }
  }
  
  if(vector == TRUE) {
    return(errors)
  }

  mean(errors)
}


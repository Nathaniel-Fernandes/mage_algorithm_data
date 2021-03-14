# Script contains helper functions to reproduce graphics in paper
# Author: Nathaniel Fernandes
# Date: March 1, 2021

## 1. Calculate the Error For an Algorithm on a Data set(s)
# error calculation for new and old iglu
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

# Error on a vector of sample indexes
# @param pod A numeric vector of sample indexes
# @param vector Wheter to return a vector of errors for each sample index or the mean
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

# Error for an arbitrary algorithm - input the indexes in pod, the calculations for algorithm, and the manual calc
mage_error <- function(pod, algo_calc, manual_calc, vector = FALSE) {
  err <- (algo_calc[pod] - manual_calc[pod]) / manual_calc[pod]
  
  percent_err <- abs(err) * 100
  
  if(vector == TRUE) {
    return(percent_err)
  }
  
  mean(percent_err, na.rm = TRUE)
}

### 2. Optimize the new Iglu function
#####
## Optimize MA lengths
optimize_ma <- function(pod) {
  structure <- rep(NaN, 38*38*length(pod));
  expanded_array <- array(structure, c(38, 38, length(pod)))
  
  for(long in 2:38) {
    for(short in 1:(long - 1)) {
      for(i in 1:length(pod)) {
        if(pod[i] != 0) {
          expanded_array[short, long, i] <- single_error_iglu(i, short_ma = short, long_ma = long)
        }
      }
    }
  }
  
  rowMeans(expanded_array[,,], dims = 2, na.rm = TRUE) # collapse the array
}

## TO DO TEST 2 and FIND MIN ERROR IN POD
# View(find_min_poderror(optimize_MA(pod6)))
cross_val <- function(pod_list) {
  ln <- length(pod_list)
  #print(ln)
  # 0. preallocate array
  errors <- numeric(ln * (ln - 1))
  #print(errors)
  
  # 1. save the optimization for each pod
  pods_opt <- rep(list(), ln)
  for(i in 1:ln) {
    pods_opt[[i]] <- find_min_poderror(optimize_ma(pod_list[[i]]))[1,]
    #print(pods_opt)
  }
  
  # 2. For each pod do the leave one out and append error
  count <- 1
  for(i in 1:ln) {
    for(j in 1:ln) {
      if(j != i) {
        errors[count] <- pod_error_MA(pod_list[[i]],pods_opt[[j]]$x, pods_opt[[j]]$ind)
        count <- count + 1
      }
    }
  }
  
  #print(errors)
  mean(errors)
}

# Returns a df of "errors" that is ordered by the lowest error for the different combos of short & long period lengths
find_min_poderror <- function(collapsed_arr) {
  sa <- stack(as.data.frame(collapsed_arr))
  sa$short <- rep(seq_len(nrow(collapsed_arr)), ncol(collapsed_arr))
  sa$long <- rep(1:38, each = 38)
  
  return(sa[with(sa,order(values)),])
}

# Split the different samples pseudo-randomly into different sets
pod_split <- function(allpods, splits = 2, seed = 122) {
  set.seed(seed)
  # 1. get sample order
  .order <- sample(allpods)
  
  if(splits > length(allpods)) {
    stop('Cannot randomize that small :(')
  }
  
  num <- length(allpods) %/% splits
  remainder <- length(allpods) %% splits
  
  pods <- rep(list(numeric(num + ceiling(remainder / num))), splits)
  
  count <- 1
  for (i in 1:splits) {
    above <- ifelse(i <= remainder, 1, 0)
    
    for (j in 1:(num+above)) {
      pods[[i]][j] <- .order[count]
      count <- count + 1
    }
  }
  
  return(pods)
}

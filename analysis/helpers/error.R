# 1. Generic error calculation
MAPE <- function(y, y_pred, indexes = c(), returns = c('mean', 'vector', 'median')) {
  #' MAPE = Mean Absolute Percent Error
  #' Formula: 1/N * ∑abs((pred - actual)/actual)
  #' 
  #' @param y_hat VECTOR of prediction
  #' @param y VECTOR of ground truth
  
  returns = match.arg(returns)
  
  if (length(indexes)) {
    y = y[indexes]
    y_pred = y_pred[indexes]
  }
  
  percent_error = abs((y_pred - y) / y) * 100
  
  if (returns == 'vector') {
    return(percent_error)
  }
  
  if (returns == 'median') {
    return(median(percent_error, na.rm = TRUE))
  }
  
  return(mean(percent_error, na.rm = TRUE))
}

# 2. Calculate iglu mage, then error on "pod"
pod_error_iglu <- function(pod, returns = c('mean', 'vector', 'median'), algo = c('iglu_ma', 'iglu_naive'), ...) {
  # @param pod A numeric vector of sample indices
  # @param ... Any other parameters to pass to "iglu::mage"
  
  returns = match.arg(returns)
  algo = match.arg(algo)
  
  mage_fx = choose_mage_version(algo)
  
  y = cgm_manual_calc[pod] # TODO: make a pure function
  y_pred = sapply(cgm_dataset_df[pod], function(x) mage_fx(x, ...)$MAGE) # TODO: make a pure function
  
  return(MAPE(y, y_pred, c(), returns))
}

# 3. Optimize MA lengths (IGLU V2)
# Will calculate the % error for each combo of (short, long) moving averages, for iglu::mage(moving_average)
# Returns a NxN matrix where each cell is the % error. 

# short = [1, 15]; long = [16, max_n]

create_pem <- function(pod, max_n = 38) {
  # @param pod A vector of sample indices
  # @param max_n The maximum length of the moving average
  
  m <- matrix(NA, max_n, max_n)
  
  for(long in 16:max_n) {
    for(short in 1:15) {
      m[short, long] <- pod_error_iglu(pod, short_ma = short, long_ma = long)
    }
  }
  
  return(m)
}
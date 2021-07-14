library(ggplot2)
library(dplyr)

######################
## Graphics - HEATMAP
plot_heatmap <- function(collapsed_err, title = "MAGE vs. Manual Calculations", low = 0, high = 31) {
  sa <- stack(as.data.frame(collapsed_err))
  sa$x <- rep(seq_len(nrow(collapsed_err)), ncol(collapsed_err))
  sa$ind <- rep(1:38, each = 38)

  names(sa) <- c("Error", "Long", "Short")
  
  plot <- ggplot(sa, aes(x = `Long`, y = `Short`, fill = `Error`)) +
    geom_tile() +
    scale_fill_gradient(limits = c(low, high), low="blue", high="white",
                        oob = scales::squish, na.value = "grey") +
    ggtitle(title) +
    labs(x = expression("Long Moving Average Window Size"~beta), y = expression("Short Moving Average Window Size"~alpha), fill = "% Error") +
    ylim(c(0, 16)) +
    xlim(c(16, 38))

  return(plot)
}

plot_boxplot <- function(df, title = "Boxplot") {
  ## provide a dataframe where each column will be different box
  df <- stack(df)
  
  means <- aggregate(values ~ ind, df, mean)
  
  plot <- ggplot(df, aes(x = ind, y = values)) +
    geom_boxplot(outlier.colour="red", outlier.shape=8,
                 outlier.size=4) + geom_jitter(color = "blue", alpha=0.4) +
    ggtitle(title) +
    labs(x = "Groups", y = "% Error")
  
  return(plot)
}

algorithm_errors <- function(pod, algos = c('iglu_v2','iglu_v1')) {
  
  iglu_v2_errors <- pod_error_iglu(pod, algo='iglu_v2', vector = TRUE) * 100
  iglu_v1_errors <- pod_error_iglu(pod, algo='iglu_v1', vector = TRUE) * 100
  
  df <- data.frame(new_normal_errors,new_gap_errors,new_short_errors) %>%
    rename(Normal = 1, Gap = 2, Short = 3)
}

# 5. Create a data frame to compare the % error of all algorithms
# creates a df where each column is the error of a different algorithm
make_boxplot_df <- function(sample_ids, short_ma, long_ma) {
  iglu_v2_err <- pod_error_iglu(sample_ids, short_ma = short_ma, long_ma=long_ma, vector = TRUE)
  
  # iglu algorithm v1
  iglu_v1_err <- pod_error_iglu(sample_ids, algo="iglu_v1", vector = TRUE)
  
  # cgmanalysis
  cgmanalysis_err <- mage_error(sample_ids, cgmanalysis_mage, cgm_manual_calc, TRUE)

  # cgmquantify
  cgmquantify_err <- mage_error(sample_ids, cgmquantify_mage, cgm_manual_calc, TRUE)
  
  easygv_err <- mage_error(sample_ids, easygv_mage, cgm_manual_calc, TRUE)
  
  l <- list("Iglu_v2" = iglu_v2_err,
            "Iglu_v1" = iglu_v1_err,
            "CGM_Analysis" = cgmanalysis_err,
            "CGM_Quantify" = cgmquantify_err,
            "Easy_GV" = easygv_err)
  
  df <- cbind.data.frame(lapply(l, function(x) c(x, rep(NA, times = length(sample_ids) - length(x)))))
  return(df)
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


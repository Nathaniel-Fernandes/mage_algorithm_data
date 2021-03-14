library(ggplot2)
library(dplyr)

######################
## Graphics - HEATMAP
plot_heatmap <- function(collapsed_err, title = "MAGE vs. Manual Calculations") {
  sa <- stack(as.data.frame(collapsed_err))
  sa$x <- rep(seq_len(nrow(collapsed_err)), ncol(collapsed_err))
  sa$ind <- rep(1:38, each = 38)

  names(sa) <- c("Error", "Long", "Short")
  # sa <- sa %>%
  #   mutate(Error = Error)

  plot <- ggplot(sa, aes(x = `Long`, y = `Short`, fill = `Error`)) +
    geom_tile() +
    scale_fill_gradient(limits = c(0,31), low="blue", high="white",
                        oob = scales::squish, na.value = "grey") +
    ggtitle(title) +
    labs(x="Long Moving Average (MA)", y="Short MA", fill="% Error")

  return(plot)
}

## BOXPLOTS - create df to pass to boxplot
## proposed v. iglu
# new_errors <- pod_error_MA(.ideal, vector = T) * 100
# iglu_errors <- pod_error_iglu(.ideal, vector = T) * 100
# vigers_old_error <- pod_error_general(.ideal, mage_vigers_old, vector = T) * 100
# vigers_new_error <- pod_error_vig_new(.ideal, T) * 100
# easygv_error <- pod_error_general(.ideal, mage_easygv, vector = T) * 100
# cgmquant_error <- pod_error_general(.ideal, mage_cgmquantify, vector = T) * 100
# df <- data.frame(new_errors, iglu_errors, easygv_error, cgmquant_error, vigers_new_error, vigers_old_error) %>%
#   rename(Proposed = 1, Iglu = 2, EasyGV = 3, cgmquantify = 4, "cgmanalysis (new)"=5, cgmanalysis=6)
# 
# ## Proposed Algo - ideal, gap, short
# gap_sample_id <- sapply(1:length(cgm_all_data), function(x) ifelse(cgm_all_data[[x]]$gap == 1, x, NA) ) 
# new_ideal_errors <- pod_error_MA(.ideal, 13, 33, vector = T) * 100
# new_normal_errors <- pod_error_MA(normal, 13,33, vector = T) * 100
# 
# new_gap_errors <- pod_error_MA(gaps, 13, 33, vector = T) * 100
# new_gap_errors <- append(new_gap_errors, rep(NA, length(new_normal_errors) - length(new_gap_errors))) #Fix different lengths
# 
# new_short_errors <- pod_error_MA(short, 13,33,T) * 100
# new_short_errors <- append(new_short_errors, rep(NA, length(new_normal_errors) - length(new_short_errors))) #Fix different lengths
# 
# df <- data.frame(new_normal_errors,new_gap_errors,new_short_errors) %>%
#   rename(Normal = 1, Gap = 2, Short = 3)
# takes in ids of the samples and returns a df and a vector of which algorithms 
algorithm_errors <- function(pod, algos = c('iglu_v2','iglu_v1')) {
  
  iglu_v2_errors <- pod_error_iglu(pod, algo='iglu_v2', vector = TRUE) * 100
  iglu_v1_errors <- pod_error_iglu(pod, algo='iglu_v1', vector = TRUE) * 100
  
  df <- data.frame(new_normal_errors,new_gap_errors,new_short_errors) %>%
    rename(Normal = 1, Gap = 2, Short = 3)
}
  
plot_boxplot <- function(df, title = "Boxplot") {
  ## provide a dataframe where each column will be different box
  df <- stack(df)

  plot <- ggplot(df, aes(x = ind, y = values)) +
    geom_boxplot(outlier.colour="red", outlier.shape=8,
                 outlier.size=4) + geom_jitter(color = "blue", alpha=0.4) +
    ggtitle(title) +
    labs(x = "Groups", y = "% Error")

  return(plot)
}

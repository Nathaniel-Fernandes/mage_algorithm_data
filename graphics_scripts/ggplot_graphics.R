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
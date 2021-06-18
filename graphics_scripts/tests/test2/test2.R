if(!require(dplyr)) install.packages("dplyr")
library(dplyr)

# In this file, we randomly split the samples into 2 groups. Then, we find the best short/long MA length on one data set and test the error on the other data set (and vice versa)


# 0. Preprocess the data
# a. remove na values from vector
cgm_adults <- cgm_adults[!is.na(cgm_adults)]
cgm_children <- cgm_children[!is.na(cgm_children)]
cgm_type_1 <- cgm_type_1[!is.na(cgm_type_1)]
cgm_type_2 <- cgm_type_2[!is.na(cgm_type_2)]
cgm_type_healthy <- cgm_type_healthy[!is.na(cgm_type_healthy)]

# b. Randomly split into 2 groups
set.seed(200)

exclude <- vector()
group1 <- vector()

g1_children <- sample(cgm_children, size=length(cgm_children)/2)
group1 <- append(group1, g1_children)
exclude <- append(exclude, cgm_children)

g1_type1 <- sample(setdiff(cgm_type_1, exclude), size=(ceiling(length(cgm_type_1)/2)-length(intersect(group1, cgm_type_1))))
group1 <- append(group1, g1_type1)
exclude <- append(exclude, cgm_type_1)

g1_type2 <- sample(setdiff(cgm_type_2, exclude), size=(floor(length(cgm_type_2)/2)-length(intersect(group1, cgm_type_2))))
group1 <- append(group1, g1_type2)
exclude <- append(exclude, cgm_type_2)

g1_typehealty <- sample(setdiff(cgm_type_healthy, exclude), size=(floor(length(cgm_type_healthy)/2)-length(intersect(group1, cgm_type_healthy))))
group1 <- append(group1, g1_typehealty)
exclude <- append(exclude, cgm_type_healthy)

g1_adult <- sample(setdiff(cgm_adults, exclude), size=(floor(length(cgm_adults)/2)-length(intersect(group1, cgm_adults))))
group1 <- append(group1, g1_adult)

group2 <- base::setdiff(1:length(cgm_dataset_df), group1)

# c. create data frames from the two groups
errors_df_g1 <- make_boxplot_df(group1, short_ma=5, long_ma=32) # 5 & 32 are used b/c they are experimentally the best values from test1.R
errors_df_g2 <- make_boxplot_df(group2, short_ma=5, long_ma=32)
errors_df_g2 <- errors_df_g2 %>% 
  rename(
    Iglu_v2_g2 = Iglu_v2,
    Iglu_v1_g2 = Iglu_v1,
    CGM_Analysis_g2 = CGM_Analysis,
    CGM_Quantifyg2 = CGM_Quantify,
    Easy_GV_g2 = Easy_GV
  )

df <- merge(errors_df_g1, errors_df_g2, by=0) %>% 
  select(-Row.names)

# Data Analysis
# 1. Compare the Errors between Groups Visually
plot_boxplot(df, "Algorithms vs Manual on 2 Random Groups (5, 32))")

sd_err_g1 <- sapply(errors_df_g1, sd, na.rm=TRUE)
summary_err_g1 <- sapply(errors_df_g1, summary)

sd_err_g2 <- sapply(errors_df_g2, sd, na.rm=TRUE)
summary_err_g2 <- sapply(errors_df_g2, summary)

#d. algorithm error on all plots
errors_df <- make_boxplot_df(1:50, short_ma=5, long_ma=32)
plot_boxplot(errors_df)
# 2. Estimate accuracy of algorithm on unseen data
# ie. find best short/long MA pair on one group and test error on other group

## create "percent error matrices"
# pem_g1 <- create_pem2(group1) 
# pem_g2 <- create_pem2(group2)

# save(pem_g1, file="./graphics_scripts/tests/test2/pem_g1.Rda")
# save(pem_g2, file="./graphics_scripts/tests/test2/pem_g2.Rda")

load('./graphics_scripts/tests/test2/pem_g1.Rda')
load('./graphics_scripts/tests/test2/pem_g2.Rda')

plot_heatmap(pem_g1)
plot_heatmap(pem_g2)

best_ma_g1 <- find_min_poderror(pem_g1)[1,]
best_ma_g2 <- find_min_poderror(pem_g2)[1,]

pod_error_iglu(group1, short_ma=best_ma_g2$short, long_ma=best_ma_g2$long) # Error 13.61

pod_error_iglu(group2, short_ma=best_ma_g1$short, long_ma=best_ma_g1$long) # Error 13.61

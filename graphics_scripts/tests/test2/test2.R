library(dplyr)

# remove na values from vector
cgm_adults <- cgm_adults[!is.na(cgm_adults)]
cgm_children <- cgm_children[!is.na(cgm_children)]
cgm_type_1 <- cgm_type_1[!is.na(cgm_type_1)]
cgm_type_2 <- cgm_type_2[!is.na(cgm_type_2)]
cgm_type_healthy <- cgm_type_healthy[!is.na(cgm_type_healthy)]

# Randomly split into 2 groups
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

group2 <- base::setdiff(1:46, group1)

# Half and half
errors_df_g1 <- make_boxplot_df(group1, short_ma=5, long_ma=32)
colnames(errors_df_g1)
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

# plot_boxplot(errors_df_g1, "Group 1 Errors")
plot_boxplot(df, "Algorithms vs Manual on 2 Random Groups (5, 32))")

# Data analysis
sd_err_g1 <- sapply(errors_df_g1, sd, na.rm=TRUE)
summary_err_g1 <- sapply(errors_df_g1, summary)

sd_err_g2 <- sapply(errors_df_g2, sd, na.rm=TRUE)
summary_err_g2 <- sapply(errors_df_g2, summary)

# o_1 <- create_pem2(1:46)
load('./graphics_scripts/tests/test2/optimize_group1.Rda')
o_g1 <- create_pem2(group1)
plot_heatmap(o_g1)
pod_error_iglu(group1, short_ma=4, long_ma=30) # Error 13.61

# o_g2 <- create_pem2(group2)
plot_heatmap(o_g2)
pod_error_iglu(group2, short_ma=17, long_ma = 20) # Error: 11.56


# save(o_g1, file='./graphics_scripts/tests/test2/optimize_group1.Rda')
# save(o_g2, file='./graphics_scripts/tests/test2/optimize_group2.Rda')
# 
# save(cross_validation_error, file="./graphics_scripts/tests/test1/cross_validation_error.Rda")
# 
# save(errors_df_g1, file="./graphics_scripts/tests/test2/errors.Rda")
# save(sd_err_g1, file="./graphics_scripts/tests/test2/sd_error.Rda")
# save(summary_err_g1, file="./graphics_scripts/tests/test2/summary_err.Rda")
# 
# save(errors_df_g2, file="./graphics_scripts/tests/test2/errors.Rda")
# save(sd_err_g2, file="./graphics_scripts/tests/test2/sd_error.Rda")
# save(summary_err_g2, file="./graphics_scripts/tests/test2/summary_err.Rda")


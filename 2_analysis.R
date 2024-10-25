###############################################################################
# EqualStrength Name Survey - Analysis
###############################################################################

# Loading required packages
library(tidyverse) # for data manipulation
library(haven) # to import/export from/to SPSS/STATA formats
library(gt) # formatted tables
library(cowplot) # arrange multiple plots

# Importing working dataset
# Please see 1_process.R for the data processing that generated this file
df <- read_sav("./data/ES2_NameSurvey_2024-10-17.sav")


###############################################################################
# Generate table 1.1: total number of distinct names  ########################

tb_sample <-
  df |>
    group_by(country_survey) |>
    summarise(Names = n_distinct(Name), Tests = n()) |>
    gt() |>
    cols_label(country_survey = "Country survey")

gtsave(tb_sample, "./img/tb_sample.png")

###############################################################################
# Generate Figure 2.1: OLS of congruence rates by ethnic fr  ########################

get_plot <- function(resp_var, title = "", rm_countries = NULL){
  estimates <- 
    df |>
      filter(!country_survey %in% rm_countries) |>
      mutate(cntry = if_else(region_es == "Majority", "_Majority", country_name)) |>
      group_by(country_survey) |>
      group_modify(~ broom::tidy(lm(get(resp_var) ~ cntry, weights = Weging, data = .x), conf.int = TRUE)) |>
      mutate(term = str_remove(term, "cntry")) |>
      mutate(region_cntry = case_match(term,
        c("Morocco", "Pakistan", "Turkey") ~ "MENAP",
        c("Congo", "Nigeria", "Senegal") ~ "SSA",
        .default = "Other"))

  estimates$region_cntry <- factor(estimates$region_cntry, levels=c("MENAP", "SSA", "Other"))
  
  estimates |>
    filter(term != "(Intercept)")  |>
    ggplot(aes(y = term, x = estimate, xmin = conf.low, xmax = conf.high)) +
    geom_vline(xintercept = 0, linetype='dashed') +
    geom_pointrange(aes(color = country_survey, shape = country_survey)) +
    scale_color_brewer(palette = "Set3") +
    scale_shape_manual(values=1:9)+
    theme_classic() +
    theme(legend.position = "bottom",
          legend.title=element_blank(),
          axis.text = element_text(size = 11),
          title = element_text(size = 13)) +
    labs(title = title, y = NULL, x = NULL) +
    facet_wrap(~region_cntry, ncol = 1, strip.position = 'left', scales = "free_y")
}

plot_sex <- get_plot("cong_sex", title = "Sex")
plot_ses <- get_plot("ladder_adj", title = "SES")
plot_skin <- get_plot("skin_adj", title = "Skin colour" , rm_countries = c("Czech Republic", "Hungary"))
plot_relig <- get_plot("cong_religion", title = "Religion", rm_countries = c("Czech Republic", "Hungary"))

fig_ols <- plot_grid(plot_sex, plot_ses, plot_skin, plot_relig,  ncol = 2)

ggsave(fig_ols, filename =  "./img/fig_ols.png")



###############################################################################
# Generate Table 2.3: Average region congruence rate for Nigerian names ######

# Recoding variables
df <- 
  df |>
  mutate(resp_sex = case_match(VS1, 1 ~ "Male", 2 ~ "Female", .default = NA),
          resp_edu = case_match(VS3, 1 ~ "No higher", 2 ~ "Higher", .default = NA),
          resp_age = case_when(VS2 < 25 ~ "18-24", VS2 > 24 & VS2 < 46 ~ "25-45", VS2 > 45 ~ "46+")) 

# Function to compare congruence rates

compare_cong <- function(country, group_comp){
  
  get_mean <- function(var_es, wgt_es){
    weighted.mean({{var_es}}, w = {{wgt_es}}, na.rm = TRUE)
  }

  df |> 
    filter(country_name == country) |>
    group_by(country_survey, Name, group = get(group_comp)) |>
    summarise(region = get_mean(cong_region, Weging), .groups = 'drop') |>
    filter(!is.na(group)) |>
    group_by(country_survey, group) |>
    summarise(mean = mean(region), .groups = 'drop') |>
    pivot_wider(names_from = group, values_from = mean)
}

# Generating table

tb_nigeria <- 
  compare_cong("Nigeria", "resp_sex") |>
    left_join(compare_cong("Nigeria", "resp_edu")) |>
    left_join(compare_cong("Nigeria", "resp_age")) |>
    gt() |> 
    cols_label(country_survey = "Country survey") |>
    fmt_percent(decimals = 0) |>
    sub_missing() |>
    tab_spanner(label = "Sex", columns = c("Female", "Male")) |>
    tab_spanner(label = "Education", columns = c("Higher", "No higher")) |>
    tab_spanner(label = "Age group", columns = c("18-24", "25-45", "46+"))

gtsave(tb_nigeria, "./img/tb_nigeria.png")

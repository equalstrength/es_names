###############################################################################
# EqualStrength Name Survey - Analysis
###############################################################################

# Loading required packages
library(tidyverse) # for data manipulation
library(haven) # to import/export from/to SPSS/STATA formats
library(gt) # formatted tables
library(sjPlot) # plot regression coefficients

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

get_plot <- function(target_variable, plot_title){

  model <- lm(df[[target_variable]] ~ region_es, weights = Weging, data = df)
  plot <- sjPlot:::plot_model(
    model,
    #terms = "region_es [SSA, MENAP, Other]",
    #axis.labels = c("SSA", "MENAP", "Other"),
    title = plot_title
    ) +
    theme_classic() +
    geom_hline(yintercept=0, linetype='dashed') +
    ylim(-0.6, 0.6)

  return(plot)
}

fig_vars <- c("cong_religion", "cong_sex", "cong_region", "skin_adj")
fig_titles <- c(paste0("Congruence rate for ", c("religion", "sex", "region")), "Monk skin color")

fig_ols <- plot_grid(map2(fig_vars, fig_titles, ~get_plot(.x, .y)), tags = rep("", 4))

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

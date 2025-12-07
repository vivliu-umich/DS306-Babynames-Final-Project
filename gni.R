# Run locally once
library(dplyr)
library(tidyr)
library(readr)

babynames_regional <- readRDS("babynames_regional.rds")

# compute proportions and GNI
gni_summary <- babynames_regional %>%
  group_by(state, year, sex) %>%
  mutate(prop = count / sum(count)) %>%
  ungroup() %>%
  select(state, year, name, sex, prop) %>%
  pivot_wider(names_from = sex, values_from = prop, names_prefix = "prop_") %>%
  mutate(
    is_unisex = !is.na(prop_M) & !is.na(prop_F),
    prop_M = replace_na(prop_M, 0),
    prop_F = replace_na(prop_F, 0),
    GNI = ifelse(is_unisex, 1 - abs(prop_M - prop_F), 0)
  ) %>%
  mutate(neutral = GNI >= 0.80) %>%
  group_by(state, year) %>%
  summarize(
    prop_gender_neutral = mean(neutral, na.rm = TRUE),
    .groups = "drop"
  )

# Save only the final summary
saveRDS(gni_summary, "gni_summary.rds")

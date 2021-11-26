# combine fluxnet and p-model data in a consistent
# dataset

library(tidyverse)

# read in forcing data
flux_forcing <- readRDS("data-raw/df_fluxnet.rds") %>%
  unnest(cols = c(data))

# read in gpp data
flux_gpp <- readRDS("data-raw/ddf_fluxnet_gpp.rds") %>%
  unnest(cols = c(data)) %>%
  select(
    sitename,
    date,
    gpp
  )

model_gpp <- readRDS("data-raw/df_output_rsofun.rds") %>%
  unnest(cols = c(data)) %>%
  select(
    sitename,
    date,
    gpp
  ) %>%
  rename(
    'gpp_mod' = 'gpp'
  )

# combine gpp data
gpp <- left_join(flux_gpp, model_gpp)

# combine with forcing data in final tidy data frame
df <- left_join(flux_forcing, gpp)

# save the data
saveRDS(
  df,
  file = "data/model_data.rds",
  compress = "xz"
  )




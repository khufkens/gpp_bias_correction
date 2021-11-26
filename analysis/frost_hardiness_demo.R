# run a small example of the frost hardiness
# function

library(tidyverse)
library(GenSA)
source("R/frost_hardiness.R")
source("R/temperature_response.R")

# read in data
df <- readRDS("data/model_data.rds") %>%
  mutate(
    year = format(date, "%Y")
  ) %>%
  filter(
    sitename == "US-NR1",
    date > "2012-01-01"
  )

# second order model for forst hardiness
# after Leinone et al. 1995 and simplified by
# Hanninen and Kramer 2007
# literature values of the
# frost hardiness function

par <- c(
  a = 1.5,
  b = -21.5,
  T8 = 11.3,
  t = 5,
  base_t = -25
  #Topt = 21,
  #Tmin = 0
)

scaling_factors <- df %>%
  group_by(sitename, year) %>%
  do({
    scaling_factor <- frost_hardiness(
      .$temp,
      par
    )

    data.frame(
      sitename = .$sitename,
      date = .$date,
      scaling_factor = scaling_factor
    )
  })

df <- left_join(df, scaling_factors)

# exploratory plot
p <- ggplot(df) +
  geom_line(
    aes(
      date,
      gpp_mod
    ),
    colour = "red"
  ) +
  geom_line(
    aes(
      date,
      gpp_mod * scaling_factor
    ),
    colour = "blue"
  ) +
  geom_line(
    aes(
      date,
      gpp
    )
  ) +
  labs(
    x = "",
    y = "GPP",
    title = "US-NR1"
  ) +
  theme_minimal()

ggsave("niwot.png", width = 7, height = 4)

# run a small example of the frost hardiness
# function

library(tidyverse)
library(GenSA)
source("R/frost_hardiness.R")

# read in data
df <- readRDS("data/model_data.rds") %>%
  mutate(
    year = format(date, "%Y")
  ) %>%
  filter(
    sitename == "US-NR1",
    date > "2012-01-01"
  ) %>%
  na.omit()

# literature values of the
# frost hardiness function
par <- c(
  a = 1.5,
  b = -21.5,
  T8 = 11.3,
  t = 5,
  base_t = -25
)

# optimize model parameters using the
# Generalized Simulated Annealing algorithm
lower=c(0,-100,-100,1, -100)
upper=c(100,0,100,60, 0)

# run model and compare to true values
# returns the RMSE
cost <- function(
  data,
  par
  ) {

  scaling_factor <- data %>%
    group_by(sitename) %>%
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

  df <- left_join(df, scaling_factor)

  rmse <- sqrt(
    sum(
      (df$gpp - df$gpp_mod * df$scaling_factor)^2)
    )/nrow(df)

  # This visualizes the process,
  # comment out when running for real
  plot(df$gpp, type = 'l')
  lines(df$gpp_mod, col = "red")
  lines(df$gpp_mod * df$scaling_factor, col = "blue")
  Sys.sleep(0.1)

  return(rmse)
}

# optimize stuff
optim_par <- GenSA::GenSA(
  par = par,
  fn = cost,
  data = df,
  lower = lower,
  upper = upper,
  control = list(max.call=100))$par


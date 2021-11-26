# run a small example of the frost hardiness
# function

library(tidyverse)
library(GenSA)
source("R/frost_hardiness.R")
source("R/temperature_response.R")

# literature values of the
# frost hardiness function
par <- c(
  a = 1.5,
  b = -21.5,
  T8 = 11.3,
  t = 5,
  Topt = 21,
  Tmin = 0,
  a1 = 1,
  b1 = 2,
  T9 = -50
)

demo <- frost_hardiness(
  temp,
  par,
  plot = TRUE
)

# optimize model parameters using the
# Generalized Simulated Annealing algorithm
par= c(a,b,T8,t,a1,b1,T9)
lower=c(-100,-100,-100,1,-100,-100,-100)
upper=c(100,100,100,60,100,100,-10)

# run model and compare to true values
# returns the RMSE
cost <- function(data,par){
  model = lagged.temperature(data$T,par)
  RMSE = sqrt(sum((data$Amax - model)^2,na.rm = TRUE)/length(model))
  return(RMSE)
}

# optimize stuff
optim_par <- GenSA::GenSA(
  par = par,
  fn = cost,
  data = data,
  lower = lower,
  upper = upper,
  control = list(max.call=10000))$par


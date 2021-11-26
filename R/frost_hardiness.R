#' Frost hardiness function
#'
#' second order model for forst hardiness
#' after Leinone et al. 1995 and simplified by
#' Hanninen and Kramer 2007
#'
#' @param temp
#' @param par
#' @param plot
#'
#' @return
#' @export

frost_hardiness <- function(
  temp,
  par,
  plot = FALSE
  ) {

  # length temp
  l <- length(temp)

  # split out parameters into
  # readable format
  a <- par[1]
  b <- par[2]
  T8 <- par[3]
  t <- par[4]
  base_t <- par[5]

  # create empty state vectors
  Ssh <- rep(0,l)
  Rh <- rep(0,l)

  # Temperature response (instantaneous)
  # can be another function as well
  Ssh <- ifelse(
    temp <= T8,
    a * temp + b,
    a * T8 + b
    )

  # calculate the rate of change of frost hardiness
  # and asymptotic frost hardiness (C2/3 and D2/3,
  # where D3 equals the sum of Rah/Rh up until t/i).
  for (i in 1:l){
    Sh <- sum(Rh[1:i])
    Rh[i] <- 1/t * (Ssh[i] - Sh)
  }

  # this is the cold hardiness
  cold <- cumsum(Rh)

  # normalize cold hardiness
  cold[cold > base_t] <- cold[cold > base_t] - base_t
  cold[cold <= base_t] <- 0
  cold <- scales::rescale(cold, c(0,1))

  if(plot){
    plot(cold)
  }

  return(cold)
}

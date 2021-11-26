#' Temperature response curve
#'
#' temperature response curve with 2 parameters
#'
#' @param temp temperature value
#' @param par parameters
#'
#' @return
#' @export

g <- function(
  temp,
  par
  ){
  Tmax 	= 45
  Topt	= par[1]
  Tmin  = par[2]
  g = ((Tmax - T)/(Tmax - Topt)) * (((temp - Tmin) / (Topt - Tmin)) ** (Topt/(Tmax - Topt)))
  g[is.nan(g)] = 0
  return(g)
}

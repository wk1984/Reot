#' Create lagged RasterStacks
#' 
#' @description
#' The function is used to produce lagged RasterStacks. The second is cut
#' from the beginning, the first from the tail to ensure equal output lengths
#' (provided that input lengths were equal).
#' 
#' @param data.pred a RasterStack (to be cut from tail)
#' @param data.resp a RasterStack (to be cut from beginning)
#' @param lag the desired lag (in the native frequency of the stacks)
#' @param freq the frequency of the RasterStacks
#' @param ... currently not used
#' 
#' @return
#' a list with the two RasterStacks lagged by \code{lag}
#' 
#' @examples
#' data(pacificSST)
#' data(australiaGPCP)
#' 
#' # lag GPCP by 4 months
#' lagged <- lagalize(pacificSST, australiaGPCP, lag = 4, freq = 12)
#' lagged[[1]][[1]] #check names to see date of layer
#' lagged[[2]][[1]] #check names to see date of layer
#' 
#' @export lagalize
lagalize <- function(data.pred, 
                     data.resp, 
                     lag = NULL,
                     freq = 12,
                     ...) {
  
  # Return list of unmodified RasterStacks if lag == NULL
  if (is.null(lag)) {
    return(list(data.pred, data.resp))
  } else {
    rest <- freq - lag
    # Lagalize predictor stack
    data.pred.lag <- cutStack(data = data.pred, tail = TRUE, 
                              lag = lag)
    data.pred.lag.adj <- data.pred.lag[[1:(nlayers(data.pred.lag) - rest)]]
    # Lagalize response stack
    data.resp.lag <- cutStack(data = data.resp, tail = FALSE, 
                              lag = lag)
    data.resp.lag.adj <- data.resp.lag[[1:(nlayers(data.resp.lag) - rest)]]
    # Return list of lagalized stacks
    return(list(data.pred.lag, data.resp.lag))
  }
}
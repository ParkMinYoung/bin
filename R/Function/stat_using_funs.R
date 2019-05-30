stat_using_funs <-
function(df, funs, round_num=2){
  
  require(purrr)
  require(dplyr)
  # funs <- c("min", "max", "mean")
  funs %>% 
    map( match.fun ) %>% 
    map_dfc( ~ df %>% 
               map_dbl(.x) %>% 
               round(round_num) %>% 
               as.data.frame  
    ) -> sumdf
    
  rownames(sumdf) <- colnames(df)
  colnames(sumdf) <- functionlist
  return(sumdf)
}

conc_fill <-
function(conc){
  
  samples =unique(c(conc$A,conc$B))
  identity <- 
    data.frame(A = samples,
               B = samples,
               Overlapping_calls = 0, 
               Nonmissing_calls=0, 
               Conc_Num=0,
               ConcordantRate=100, 
               stringsAsFactors = FALSE) 

  conc <-
    conc %>% 
    mutate(C=A, A=B, B=C) %>% 
    select(-C) %>% 
    bind_rows(., conc) %>% 
    bind_rows(., identity)
  
}

funs_groups_cols <-
function (df, funs, grps, cols){

  dots<-
    paste0(funs, "(", cols, ")") %>% as.list 
  
  nms<-
    paste0(cols,"_", funs) %>% as.list 
  
  
  df %>% 
  group_by_( .dots = grps ) %>% 
    summarise_( .dots = setNames(dots, nms) )

}

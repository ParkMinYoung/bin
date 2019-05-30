row_col_group_by_q <-
function(df, Group, expr) { 

# row_col_group_by_mean(df, Group, function(x) mean(x,na.rm=TRUE))  
  
  #Group = split(colnames(df)[-1], rep(LETTERS[1:10], each=10))
  expr <- enquo(expr)
   
  colnames(Group) <- c("sample", "group")
  colnames(df)[1] <- "ID"
  df %>% 
    gather("sample", "value", -ID) %>% 
    left_join(., Group, by=c("sample"="sample")) %>% 
    group_by(ID, group) %>% 
    dplyr::summarise( value = !! expr ) %>% 
    spread(group, value)
  
  
}

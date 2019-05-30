row_col_group_by <-
function(df, Group, f) { 

# row_col_group_by_mean(df, Group, function(x) mean(x,na.rm=TRUE))  
  
  #Group = split(colnames(df)[-1], rep(LETTERS[1:10], each=10))
  colnames(Group) <- c("sample", "group")
  colnames(df)[1] <- "ID"
  df %>% 
    gather("sample", "value", -ID) %>% 
    left_join(., Group, by=c("sample"="sample")) %>% 
    group_by(ID, group) %>% 
    dplyr::summarise( value = f(value)) %>% 
    spread(group, value)
  
  
}

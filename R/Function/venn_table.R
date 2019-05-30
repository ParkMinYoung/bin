venn_table <-
function(df, key, ID  ){

  require(dplyr)  
  cmd <-paste0("paste(",ID, ", collapse= ':')")

  df %>% 
     group_by_(.dots = key) %>% 
     summarise_( .dots = setNames(cmd, "type")) %>% 
   ungroup() %>% 
   count(type) -> model_count

  show_datatable(model_count, "model_count")
  
}

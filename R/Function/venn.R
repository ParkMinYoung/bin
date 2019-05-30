venn <-
function(df, key, id){
  
  require(UpSetR)
  
  model <-
    df %>% 
    select_(.dots = c(key, id)) %>% 
    table() %>% 
    as.data.frame.matrix()
  
  #png("Pembro.upset.png", width = 900, height = 900)
  upset(model, sets = names(model)[colSums(model)>0], mb.ratio = c(0.55, 0.45), order.by = "freq", text.scale = 2)
  #dev.off()
}

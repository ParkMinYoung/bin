log2ratio_plot <-
function(df, sample){
  
df %>% 
  filter( Group == sample ) -> df1


df1$log2[df1$log2 < -3]=-3
ggplot(df1, aes(xmin = start , xmax = end, ymin = 0, ymax = log2)) +
  geom_rect(aes(fill = log2), colour = "grey50") + 
  facet_grid(chromosome~., scales="free") + 
  #scale_fill_gradient2( breaks=c(3,0,-3), low = "blue", high="red", mid="green", midpoint = 0)
  scale_fill_gradient2( breaks=c(3,0,-3), labels=c(3, 0,-3), low = "blue", high="red", mid = "green", midpoint = 0) + 
  ylim(c(-3,3))

}

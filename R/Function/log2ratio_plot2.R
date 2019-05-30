log2ratio_plot2 <-
function(df, sample, is_save){
  
df %>% 
  filter( Group == sample ) -> df1


df1$log2[df1$log2 < -3]=-3
df1$log2[df1$log2 > 3] = 3
range <- c(-3, 0, 3)

p<-
ggplot(df1, aes(xmin = start , xmax = end, ymin = 0, ymax = log2)) +
  theme_bw() + 
  geom_rect(aes(fill = log2), colour = "grey50") +
  geom_hline(yintercept = 1, col="purple") + 
  geom_hline(yintercept = -1, col="purple") + 
  facet_grid(.~chromosome, scales="free", space = "free" ,switch = "x") + 
  ylim(c(range[1], range[3])) + 
  scale_fill_gradientn(
    name = "log2ratio", 
    limits = c(range[1],range[3]),
    #colours=c("navyblue", "darkmagenta", "darkorange1"),
    colours=c("blue", "green", "red"),
    breaks=range, 
    labels=format(range)) + 
  labs(subtitle=sample ,
       x="Chromosome", 
       y="Log2Ratio") + 
  theme(
    axis.text.x = element_blank(), 
    axis.title = element_text(face = "bold"),
    axis.title.x = element_blank(), 
    plot.title = element_text(face = "bold", size = 10, colour = "black"),
    plot.subtitle = element_text(face = "bold", size = 10, colour = "black"), 
    strip.placement = "outside",  
    strip.background = element_blank(), 
    strip.text = element_text( size = 10 , colour = "blue"),
    legend.position = "bottom"
    ) 

  if( is_save > 0 ){
    print(p)
    dir.create(file.path("./", sample), showWarnings = FALSE)
    sample_f <- paste( sample, sample, sep = "/")
    gg_format = "png"
    filename <- paste( sample_f, gg_format, sep =".")
  
    ggsave(filename, device=gg_format,  width = 26, height = 11, units = "cm")
  }else{
    print(p)
  }

# https://stackoverflow.com/questions/13888222/ggplot-scale-color-gradient-to-range-outside-of-data-range
}

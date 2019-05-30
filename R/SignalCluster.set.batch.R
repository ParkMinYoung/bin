library(ggplot2)
library(dplyr)
#setwd("/home/adminrig/workspace.min/AxiomBovine.Cluster/All.Cluster/bymin")

df<-read.table("try", header=T)

#df <- mutate(df, set= as.factor(sample(10, NROW(df), replace=T)), batch=as.factor(sample(3, NROW(df), replace=T)))

#summary(df)



for (i in unique(df$marker) ){
  
  df_i<-
    df %>%
    dplyr::filter( marker == i )
  
  g1 <-
    ggplot(df_i, aes(x,y,col=as.factor(geno))) + 
    geom_point() +
    xlim(c(-1,1)) + 
    facet_grid(batch + set ~ .)
  
  ggsave(g1, filename=paste(i, "png", sep="."))
}



#filter(df, marker=="AX-106719468" ) %>%



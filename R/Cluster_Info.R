args <- commandArgs(TRUE)
#setwd("/home/adminrig/workspace.min/APT_BatchCall_UsingSGE/Axiom_KORV1.0.SSH.HongKyungSu/Simulation/Three/try.1")

library(pacman)
p_load(ggplot2, gridExtra, dplyr)

#library(gridExtra)
#grid.table(mydf)

#CS<-read.table("x39.ClusterSignal.txt", header=T, sep="\t")
#PS<-read.table("x39.Ps.performance.txt", header=T, sep="\t")

CS<-read.table(args[1], header=T, sep="\t")
PS<-read.table(args[2], header=T, sep="\t")

CS$LABEL<-as.factor(CS$LABEL)
CS$geno<-as.factor(CS$geno)
#str(CS)
#str(PS)
#head(CS)
# 

PS$probeset_id %>% head()

for(i in PS$probeset_id) {
  #for(i in PS$probeset_id %>% head()) {
  
  df<-
    filter(CS, marker==i)
  
  g1<-
  ggplot(df, aes(x,y,col=geno)) +
    geom_point() + 
    facet_grid( LABEL ~ .) +
    xlim(c(-1, 1) ) +
    ylim(c(0, 15))
  
  df_t<-
    filter(PS, probeset_id==i)
  
  #g2<-grid.table(t(df_t))
  g2<-tableGrob(t(df_t))
  
  plot_list=list()
  plot_list = c(plot_list, list(g1,g2))
  
  #do.call(grid.arrange, c(plot_list, list(ncol=2, widths=c(1,1))))
  png(paste0(i,".png"), width=1600, height = 900)
  do.call(grid.arrange, c(plot_list, list(ncol=2,widths=c(1,1))))
  dev.off()

}

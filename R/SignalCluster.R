
library(ggplot2)
library(dplyr)
library(gridExtra)


setwd("/home/adminrig/workspace.min/ChosunUniv.Tagman")
df<-read.table("ApoE_signal", header=T, sep="\t")
summary(df)



df$X<-as.numeric(as.vector(df$X))
df$Y<-as.numeric(as.vector(df$Y))
df$geno<-as.character(df$geno)

# str(df)

g1<-ggplot(df, aes(X,Y, col=geno)) + 
  geom_point() + 
  facet_wrap(~batch, ncol=1) + 
  scale_x_continuous(breaks=seq(-1, 1, 0.1)) + 
  scale_y_continuous(breaks=seq(0, 10, 0.2))

rect <- data.frame(xmin = c(0.17, 0.12), xmax = c(0.25, 0.22), ymin = -Inf, ymax = Inf, batch = c("3","4"))



df1<-read.table("ApoE_signal.TaqmanResult", header=T, sep="\t")
#str(df1)

df1$geno<-as.character(df1$geno)
df1$batch<-as.character(df1$batch)

mis<-
  df1 %>%
  filter( taqman == "mismatch" )

 ggplot(df1, aes(X,Y,col=geno,shape=taqman)) +
   geom_point(size=3) + 
   geom_point(data=mis, aes(x = X, y = Y, col = "red" ), size=5) + 
   facet_grid(batch ~.)


g1<-ggplot(df, aes(X,Y, col=geno)) + 
  geom_point() + 
  geom_rect(data=rect, aes(xmin = xmin, ymin = ymin, xmax = xmax, ymax = ymax), fill = "green", alpha = 15/100, inherit.aes = FALSE) + 
  facet_wrap(~batch, ncol=1) + 
  scale_x_continuous(breaks=seq(-1, 1, 0.05)) + 
  scale_y_continuous(breaks=seq(0, 10, 0.2)) + 
  xlim(c(0.1, 0.3))


g2<-ggplot(df, aes(X,Y, col=geno)) + 
  geom_point() + 
  geom_point(data=df1, aes(x=X, y=Y, col=geno, shape=taqman),size=3) + 
  geom_point(data=mis, aes(x=X, y=Y, shape=taqman), col="red", size=5 ) + 
  geom_rect(data=rect, aes(xmin = xmin, ymin = ymin, xmax = xmax, ymax = ymax), fill = "green", alpha = 15/100, inherit.aes = FALSE) + 
  facet_wrap(~batch, ncol=1) + 
  scale_x_continuous(breaks=seq(-1, 1, 0.05)) + 
  scale_y_continuous(breaks=seq(0, 10, 0.2)) + 
  xlim(c(0.1, 0.3))
  





plot_list=list()
plot_list = c(plot_list, list(g1,g2))


png("ApoE.rs729358.png", width=2400, height=900)
# http://stackoverflow.com/questions/20531579/plotting-multiple-graphs-in-r-ggplot2-and-saving-the-result
do.call(grid.arrange, c(plot_list, list(ncol=2, widths=c(1,1))))
dev.off()

png("ApoE.rs729358.row2.png", width=1200, height=1800)
# http://stackoverflow.com/questions/20531579/plotting-multiple-graphs-in-r-ggplot2-and-saving-the-result
do.call(grid.arrange, c(plot_list, list(ncol=1)))
dev.off()





df %>%
  filter( batch == 3, geno==-1 ) %>%
  summarise( min = min(X), max = max(X))

df %>%
  filter( batch == 3, geno==-1 ) %>%
  arrange(X)
library(gridExtra)
library(ggplot2)
library(xlsx)

#df<-read.table("IBS.genome.test", header=T)
df<-read.table("IBS.genome", header=T)
str(df)

#attach(df)

df$sum<-df$IBS0 + df$IBS1 + df$IBS2
df$P0<-df$IBS0/df$sum
df$P1<-df$IBS1/df$sum
df$P2<-df$IBS2/df$sum

df$Mean<-df$P1+2*df$P2
df$Std<-(df$P1+4*df$P2 )-(df$Mean^2)

cutoff<-1.6
df$color<-"Unrelated Pair"
df$color[df$Mean>=cutoff & df$Std<0.5]<-"Related Pair"
#table(df$color)
table(df$Mean=cutoff)

g1<-ggplot(df, aes(Mean, Std, colour=color) ) + geom_point() + xlim(c(0,2)) + ylim(c(0,1))

png("IBS.GRR.png")
g1
dev.off()

df$color

Pair_table<-subset(df, color=="Related Pair")[,c(1,3,7,8,9,10,24,25,26)]
Pair_table_sort <- Pair_table[rev( order(Pair_table$Mean) ) , ]
row.names(Pair_table_sort)<-1:dim(Pair_table_sort)[[1]]


write.xlsx(Pair_table_sort, "IBS.result.xlsx")






#detach(df)


library(ggplot2)
library(scales)
library(reshape2)


df<-read.table("Scanning.txt", header=T)
df$scan<-1

nrows<-length(unique(df$set))
g1<-ggplot(df, aes(factor(wellNum), wellA, fill=scan)) + geom_tile(colour="white")+ ylab("Well Letters") + xlab("Well Nums") + facet_wrap( ~ set, ncol=10)
png("Scanning.png", width=1600, height=25*nrows)
g1
dev.off()


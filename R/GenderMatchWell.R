library(ggplot2)
library(scales)
library(reshape2)

df<-read.table("Summary.Gender.txt", header=T)

df$well<-as.character(df$well)
idx<-nchar( df$well ) == 2
df$well[idx]<-sub( "(\\d$)", "0\\1", df$well[idx], perl=T )
df$well<-factor(df$well, level= sort( unique(df$well) ) )



df$wellnum<-as.numeric( sub("^\\w", "", df$well, perl=T) )
df$wellA<-sub("\\d+$", "", df$well, perl=T) 

#DL000063<-subset(df, set=="DL000063")

ncols<-10
nrows<-ceiling( length( unique(df$set) ) / ncols )

#g1<-ggplot(df, aes(as.factor(wellnum), wellA, fill=gender_match)) + geom_raster() + scale_fill_gradient2(low = muted("blue"), high = muted("red"), mid="green", midpoint=2.5, limits=c(1,4)) + ylab("Well Letters") + xlab("Well Nums") + facet_wrap( ~ set, ncol=10)
g1<-ggplot(df, aes(as.factor(wellnum), wellA, fill=gender_match)) + geom_raster() + scale_fill_gradient2(low = muted("yellow"), high = muted("red"), mid="green", midpoint=2.5, limits=c(1,4)) + ylab("Well Letters") + xlab("Well Nums") + facet_wrap( ~ set, ncol=6,  scale="free")

#ggplot(df, aes(wellA, as.factor(wellnum), fill=call_rate)) + geom_raster() + scale_fill_gradient2(low = muted("red"), high = muted("blue"), mid="green", midpoint=95, limits=c(90,100)) + xlab("Well Letters") + ylab("Well Nums") + facet_wrap( ~ set, ncol=10)
#ggplot(df, aes(wellA, as.factor(wellnum), fill=call_rate)) + geom_raster() + scale_fill_gradient2(low = "red", high = "blue", mid="green", midpoint=95, limits=c(90,100)) + xlab("Well Letters") + ylab("Well Nums") + facet_wrap( ~ set, ncol=10)


png("GenderMatch.Well.png", width=1600, height=200*nrows)
g1
dev.off()


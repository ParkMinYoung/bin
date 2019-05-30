library(ggplot2)
library(scales)
library(reshape2)

#sort_df<-df[with(df, order[set,well]), ]
#matrix(sort_df$well, nrow=96, byrow=F)

df<-read.table("Summary.txt", header=T)

df$well<-as.character(df$well)
idx<-nchar( df$well ) == 2
df$well[idx]<-sub( "(\\d$)", "0\\1", df$well[idx], perl=T )
df$well<-factor(df$well, level= sort( unique(df$well) ) )



df$wellnum<-as.numeric( sub("^\\w", "", df$well, perl=T) )
df$wellA<-sub("\\d+$", "", df$well, perl=T) 

#DL000063<-subset(df, set=="DL000063")

ncols<-10
nrows<-ceiling( length( unique(df$set) ) / ncols )

g1<-ggplot(df, aes(as.factor(wellnum), wellA, fill=call_rate)) + geom_raster() + scale_fill_gradient2(low = muted("red"), high = muted("blue"), mid="green", midpoint=95, limits=c(90,100)) + ylab("Well Letters") + xlab("Well Nums") + facet_wrap( ~ set, ncol=10)

#ggplot(df, aes(wellA, as.factor(wellnum), fill=call_rate)) + geom_raster() + scale_fill_gradient2(low = muted("red"), high = muted("blue"), mid="green", midpoint=95, limits=c(90,100)) + xlab("Well Letters") + ylab("Well Nums") + facet_wrap( ~ set, ncol=10)
#ggplot(df, aes(wellA, as.factor(wellnum), fill=call_rate)) + geom_raster() + scale_fill_gradient2(low = "red", high = "blue", mid="green", midpoint=95, limits=c(90,100)) + xlab("Well Letters") + ylab("Well Nums") + facet_wrap( ~ set, ncol=10)


png("Well.png", width=1600, height=120*nrows)
g1
dev.off()



attach(df)

meanCR_per_well<-as.data.frame( tapply(call_rate, list(wellA, wellnum), mean, na.rm=T ) )
meanCR_per_well$WELL<-rownames(meanCR_per_well)

melt_CR <- melt( meanCR_per_well, id=length(meanCR_per_well) )

colnames(melt_CR) <- c("well", "num", "call_rate")

s<-range(melt_CR$call_rate)[1]
e<-range(melt_CR$call_rate)[2]
midpoint_value<-e-(e-s)/2


g2<-ggplot(melt_CR, aes(num, well, fill=call_rate)) + geom_raster()+ ylab("Well Letters") + xlab("Well Nums") + scale_fill_gradient2(low = muted("red"), high = muted("blue"), mid="green", midpoint=midpoint_value, limits=c(s,e)) 

png("Well.meanCR.png", width=620, height=330)
g2
dev.off()




library(dplyr)
library(tidyr)
library(ggplot2)
library(gridExtra)

setwd("/home/adminrig/workspace.min/AMC.JangSooWhan.CCP.PDX/MouseAlignment/BAM")

df<-read.table("flagstats.txt.data", header=T)

colnames(df)<- sub("\\.", "-", sub("^X", "", colnames(df)))

mdf <- gather(df, "ID", "MappingRate",  2:21)

mdf$type<-ifelse(grepl("-1", mdf$ID), "FFPE", "PDX")

mdf$sample<-sub("-\\d+","", mdf$ID, perl=T)


g1<-ggplot(mdf,aes(ID, MappingRate, fill=type)) + geom_bar(stat="identity") + facet_wrap(~sample, ncol=5, scale="free_x") +
  geom_text(aes(y=MappingRate, label=MappingRate), vjust=1.5, colour="blue", size=4)


g2<-ggplot(mdf,aes(ID, MappingRate, fill=type)) + geom_bar(stat="identity") + facet_grid(~type,  scale="free") + 
  geom_text(aes(y=MappingRate, label=MappingRate), vjust=1.5, colour="blue", size=4)


g3<-ggplot(mdf, aes(type, MappingRate, col=sample, group=sample)) + geom_point() + geom_line() + 
  geom_text(aes(y=MappingRate, label=sample), vjust=1.5, colour="blue", size=4)


png("MappingRate.png", width=1560, height=600)
grid.arrange(arrangeGrob(g1,g2,ncol=1), arrangeGrob(g3, ncol=1), ncol=2)
dev.off()



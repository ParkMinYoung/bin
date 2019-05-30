library(ggplot2)
library(gplots)
library(dplyr)
library(tidyr)

setwd("/home/adminrig/src/xenome/xenome-1.0.1-r/Test")
df<-read.table("statistics.txt", header=T)

dfset<-gather(df, "class", "percent", 2:6)

dfset$sample_type<-ifelse( grepl("-1$", dfset$probeset_id) , "FFPE", "PDX")
# http://stackoverflow.com/questions/10128617/test-if-characters-in-string-in-r

dfset$ID<-sub("-\\d+$", "", dfset$probeset_id, perl=T)


e1<-ggplot(dfset, aes(class, percent, fill=ID)) + geom_bar(stat="identity", position="dodge") + facet_grid(~sample_type)
  
e2<-ggplot(dfset, aes(class, percent, fill=class)) + geom_bar(stat="identity", position="dodge") + facet_grid(~probeset_id)

e3<-ggplot(dfset, aes(probeset_id, percent, fill=class)) + geom_bar(stat="identity") + facet_grid(~probeset_id, scales="free", space="free_x")
## best
e4<-ggplot(dfset, aes(probeset_id, percent, fill=sample_type)) + geom_bar(stat="identity") + facet_wrap(ID~class, scales="free", ncol=5)

e5<-ggplot(dfset, aes(ID, percent, fill=class)) + geom_bar(stat="identity") + facet_grid(sample_type~ID, scales="free", space="free_x")

e6<-ggplot(dfset, aes(class, percent, fill=class)) + geom_bar(stat="identity") + facet_grid(sample_type~ID, scales="free", space="free_x")

png("Xenome.ETC.png", width=1100, height=2500)
grid.arrange(e1,e2,e3,e4,e5,e6, ncol=2)
dev.off()

dfset$percent<-round(dfset$percent,2)

human<-filter(dfset, class == "ucsc.hg19")
human$class<-"Human"

mouse<-human
mouse$percent<-100-mouse$percent
mouse$class<-"Mouse"

ddf<-rbind(human, mouse)
ddf$class<-as.factor(ddf$class)
str(ddf)

Human_read<-filter(ddf, class=="Human")

g1<-ggplot(ddf, aes(probeset_id, percent, fill=class)) + 
  geom_bar(stat="identity") + 
  geom_text(aes(y=percent, label=percent), data=Human_read, vjust=1.5, colour="blue", size=4) + 
  facet_grid(~ID, scales="free", space="free_x") + 
  xlab("sample id")  




g2<-ggplot(ddf, aes(sample_type, percent, col=ID, group=ID)) + 
  geom_point() + 
  geom_line() + 
  facet_wrap(~class, ncol=5, scale="free") + 
  geom_text(aes(y=percent, label=ID), vjust=1.5, colour="blue", size=4)
  


g3<-ggplot(dfset, aes(class, percent, fill=sample_type)) + 
  geom_bar(stat="identity", position="dodge") + 
  facet_grid(class~ID, scales="free", space="free_x") + 
  xlab("sample id")  +  
  theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5)) + theme(legend.position="none")

png("Xenome.png", width=1600, height=600)
grid.arrange(g1,g2, ncol=2)
dev.off()






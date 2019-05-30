library(dplyr)
library(tidyr)
library(ggplot2)
library(gridExtra)

setwd("/home/adminrig/workspace.min/AMC.JangSooWhan.CCP.PDX/CombinedAlignment/BAM/ReadCount")
df<-read.table("ReadCount.txt", header=T)
df$Mouse<-df$Total-df$Human


mutate(df, HumanP=round(Human/Total*100,2 ), MouseP=round(Mouse/Total*100, 2))

ddf<-   mutate(df, HumanP=round(Human/Total*100,2 ), MouseP=round(Mouse/Total*100, 2)) %>%
        select(-Total, -Human, -Mouse ) %>%
        gather("Species", "Read", 2:3 ) %>%
        filter( Species != "Total")

label<-gsub("P$", "", levels(ddf$Species))
ddf$Species<-factor(ddf$Species, label= label) 

ddf$sample<-gsub("-\\d", "", ddf$probeset_id, perl=T)
ddf$type<-ifelse(grepl("-1", ddf$probeset_id), "FFPE", "PDX")


Human_read<-filter(ddf, Species=="Human") %>% select(probeset_id, Read, Species, sample)


ggplot(ddf, aes(probeset_id, Read, fill=Species)) + geom_bar(stat="identity") +
  geom_text(aes(y=Read, label=Read), data=Human_read, vjust=1.5, colour="blue", size=4)

# best
g1<-ggplot(ddf, aes(probeset_id, Read, fill=Species)) + geom_bar(stat="identity") + facet_grid(.~sample, scale="free") + 
  geom_text(aes(y=Read, label=Read), data=Human_read, vjust=1.5, colour="blue", size=4) + 
  xlab("Sample Id") +
  ylab("Mapping Rate (%)")

 

g2<-ggplot(ddf, aes(type, Read, col=sample, group=sample)) + geom_point() + geom_line() + facet_wrap(~Species,  scale="free", ncol=2) +
  geom_text(aes(y=Read, label=sample), vjust=1.5, colour="blue", size=4) + 
  xlab("Sample Type") + 
  ylab("Mapping Rate (%)")


png("MappingRate.png", width=1600, height=700)
grid.arrange(g1,g2, ncol=2)
#grid.arrange(arrangeGrob(g1,g2,ncol=1), arrangeGrob(g3, ncol=1), ncol=2)
dev.off()







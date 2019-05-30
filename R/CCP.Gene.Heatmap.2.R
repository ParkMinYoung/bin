library(ggplot2)
library(tidyr)
library(dplyr)


df<-read.table("DepthofCov.txt.GeneLabel", header=T, na.strings = "NaN")
df[is.na(df)]<-0

dp<-gather(df, "sample", "depth", 2:dim(df)[2]-1, -probeset_id)
dp$Sample<-dp$sample
dpp<-dp %>% separate(sample, c("Type", "ID"))

png("genebox.png", width=1600, height=30000)
#ggplot(dppp, aes(Sample, depth, fill=Type)) + geom_boxplot() + facet_grid(Gene~.)
ggplot(dpp, aes(Sample, depth, fill=Type)) + geom_boxplot() + facet_wrap(~Gene, ncol=1, scale="free")
dev.off()


## mean depth per gene
mean_df_gene <-df %>%
  select(-probeset_id) %>%
  group_by(Gene) %>% 
  summarise_each(funs(mean))

write.csv(mean_df_gene, file="mean_depth_perGene.csv")

dp<-gather(mean_df_gene, "sample", "depth", 2:dim(mean_df_gene)[2] , -Gene)


#dp %>% separate(sample, c("Type", "ID")) 
dp$Sample<-dp$sample
df<-dp %>% separate(sample, c("Type", "ID"))

png("DepthHistogram.png", width=1000, height=1000)
ggplot(df, aes(depth, fill=Type)) + geom_bar(width=10) + facet_grid(ID~Type) + xlim(c(0,150))
dev.off()



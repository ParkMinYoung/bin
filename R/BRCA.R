

setwd("/home/adminrig/workspace.min/IonTorrent/IonProton/bin/Ion.Input/Auto_user_DL0-60-20160616_Amp_Customized_69genes_550k_set33_117_152/Analysis/BAM/IGV")
library(pacman)

p_load(ggplot2,dplyr,tidyr)

df<-read.table("DepthCov", header=T, sep="\t")

head(df)
dff<-gather(df, "sample", "depth", 4:12 )
head(dff)

BRCA1 <- dff %>%
  filter( Gene == "BRCA1") 

BRCA2 <- dff %>%
  filter( Gene == "BRCA2") 

#  summary(BRCA2)

png("BRCA1.png", width=1800, height=900)

ggplot(BRCA1, aes(Amplicon, depth, fill=sample)) + 
  geom_bar(stat="identity") + 
  facet_grid(sample~Num,space="free", scales="free_x" ) + 
  theme(axis.text.x=element_blank()) + 
  labs(title="BRCA1")

dev.off()


png("BRCA2.png", width=1800, height=900)

ggplot(BRCA2, aes(Amplicon, depth, fill=sample)) + 
  geom_bar(stat="identity") + 
  facet_grid(sample~Num,space="free", scales="free_x" ) + 
  theme(axis.text.x=element_blank()) + 
  labs(title="BRCA2")

dev.off()



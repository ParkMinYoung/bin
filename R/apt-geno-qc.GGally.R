setwd("/home/adminrig/workspace.min/CEL.Status/20160414/step1.md5sum/Structure/CEL_Structure/GenomeWideSNP_6/Analysis/Analysis.23957.20160526/batch")

library(GGally)

df<-read.table("apt-geno-qc.txt", header=T, sep="\t")


png("apt-geno.png", width=2400, height=4800)
ggpairs(data=df, columns=2:length(colnames(df))-1, title="apt-geno", colour = "em.cluster.chrX.het,contrast_gender") # aesthetics, ggplot2 style
dev.off()



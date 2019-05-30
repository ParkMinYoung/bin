library(GGally)
library(ggplot2)

setwd("/home/adminrig/workspace.min/ChosunUniv.Tagman/DQC")

df<-read.table("apt-geno-qc.tab", header=T, sep="\t")

str(df)

#png("QC.png", width=2400, height=4800)
#ggpairs(data=df, columns=c(1,7:28,33,34),, title="apt-probeset-genotype", colour = "cn.probe.chrXY.ratio_gender") # aesthetics, ggplot2 style
#dev.off()


df<-read.table("apt-geno-qc.all.tab", header=T, sep="\t")

png("QC.all.png", width=9600, height=9600)
ggpairs(data=df, columns=c(1,7:28,33,34), title="apt-geno-qc") # aesthetics, ggplot2 style
dev.off()

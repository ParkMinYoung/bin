setwd("/home/adminrig/workspace.min/AFFX/Axiom_KORV1.0/Axiom_KORV1.0.LeeKeunHo.v7.3719/Analysis/Analysis.3719.20160523/batch/Output")
df=read.table("Ps.performance.txt", header=T, sep="\t")

library(ggplot2)

summary(df)

ggplot(df, aes(FLD, fill=ConversionType)) + geom_histogram() + facet_grid(.~ConversionType)
ggplot(df, aes(HetSO, fill=ConversionType)) + geom_histogram() + facet_grid(.~ConversionType)

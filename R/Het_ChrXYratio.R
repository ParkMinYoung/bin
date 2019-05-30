#setwd("/home/adminrig/workspace.min/AFFX/Axiom_KORV1.1/Analysis/Analysis.20161008/Mosaicm/plinkMerge")

df<-read.table("HetRatePerID", header=T, sep="\t")

library(ggplot2)
library(plotly)

# str(df)
# ggplotly(
#   ggplot(df, aes(Het, XYratio)) + geom_point()
# )
# 

png("Het_XYratio.png")
ggplot(df, aes(Het, XYratio)) + geom_point()
dev.off()


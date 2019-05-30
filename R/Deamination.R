library(reshape2)
library(ggplot2)
library(gridExtra)
library(plyr)

df<-read.table("deamination.txt", header=T, sep="\t")
#df1<-df[-NROW(df), -1 ]
df1<-df[-NROW(df), ]


melt_df1<-melt(df1, id=1)
colnames(melt_df1)<-c("Genotype", "ID", "Count")

g1<-ggplot(melt_df1, aes(Genotype, Count, fill=ID)) + geom_bar(stat="identity") + theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5))
g2<-ggplot(melt_df1, aes(ID, Count, fill=Genotype)) + geom_bar(stat="identity") + theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5))

png("GenotypeCount.png", height=450, width=1000)
grid.arrange(g1,g2, ncol=2)
def.off()


#  R CMD BATCH --no-save --no-restore HiseqSummaryPlot.R

library(xlsx)
library(reshape2)
library(ggplot2)
library(gridExtra)
library(plyr)
library(GGally)
library(scales) # to use comma scale


df<-read.delim("SplitedFastqMeanQscore.Metrics.Table.txt")
#df<-read.delim("MergedFastqMeanQscore.Metrics.Table.txt")
df$lane<-as.factor(df$lane)

g1<-ggplot(df, aes(id, QNumOfTotalBases , fill=lane)) + geom_bar(stat="identity") + theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5)) + scale_y_continuous(labels=comma)
g2<-ggplot(df, aes(lane, , fill=project)) + geom_bar() +  stat_bin( geom="text", aes(label=..count..), size=5)
g3<-ggplot(df, aes(lane, QNumOfTotalBases , fill=lane)) + geom_boxplot() + scale_y_continuous(labels=comma)
g4<-ggplot(df, aes(project, QNumOfTotalBases , fill=lane)) + geom_boxplot() + scale_y_continuous(labels=comma)
g5<-ggplot(df, aes(lane, Q30 , fill=lane)) + geom_boxplot() +facet_grid(read~.)
g6<-ggplot(df, aes(project, Q30, fill=lane)) + geom_boxplot() +facet_grid(read~.)
g7<-ggplot(df, aes(lane, MeanQualityScore , fill=lane)) + geom_boxplot() +facet_grid(read~.)
g8<-ggplot(df, aes(project, MeanQualityScore  , fill=lane)) + geom_boxplot()+facet_grid(read~.)


dff <- ddply(df, "lane", transform, Yield=cumsum(as.numeric(QNumOfTotalBases)))
g9<-ggplot(dff, aes(lane, QNumOfTotalBases, fill=id) ) + geom_bar(stat="identity", width=.5, colour="black") + geom_text(aes(y=Yield, label=comma(QNumOfTotalBases)), vjust=1.5, colour="green", position=position_dodge(0), size=3) + scale_y_continuous(labels=comma)


dfp <- ddply(df, "lane", transform, Yield_per= QNumOfTotalBases / sum(as.numeric(QNumOfTotalBases)) * 100)
dfpp <- ddply(dfp, "lane", transform, Yield_PER=cumsum(Yield_per))
g10<-ggplot(dfpp, aes(lane, Yield_per, fill=Yield_per) ) + geom_bar(stat="identity", width=.5, colour="black") + geom_text(aes(y=Yield_PER, label=comma(sprintf("%1.2f%%", Yield_per))), vjust=1.5, colour="green", position=position_dodge(0), size=3) + scale_y_continuous(labels=comma)




# http://stackoverflow.com/questions/18332520/how-to-put-percentage-label-in-ggplot-when-geom-text-is-not-suitable


png("NextSeqBatchReview.png", width=1600, height=2400)
grid.arrange(g1, g2, g3,g4, g5, g6, g7, g8, g9, g10, nrow=5)
dev.off()


png("NextSeqBatchReviewByGGally.png", width=1920, height=1200)
ggpairs(data=df, columns=c(2,4,13,7,10), title="NextSeq Batch Review",  colour = "lane")
dev.off()


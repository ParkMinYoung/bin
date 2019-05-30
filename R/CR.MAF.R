
library(ggplot2)
library(gridExtra)



df<-read.table("AxiomGT1.calls.txt.extract.plink_fwd.gender.count.frq.count.CR")
colnames(df)<-c("AFFX","CR")
CR_df<-as.data.frame( table( cut(df$CR, breaks=c(0,50,80,90,95,96,97,98,99,100)) ) )
colnames(CR_df)<-c("bin", "count")
g1<-ggplot(CR_df, aes(bin, count, fill=bin)) + geom_bar(stat="identity") +  geom_text(aes(y=count, label=comma(sprintf("%1.2f%%", count / sum(count) * 100 ))), vjust=-.5, colour="blue", position=position_dodge(0), size=5) + scale_y_continuous(labels=comma) + ylab("count") + xlab("Call Rate Interval")



df<-read.table("AxiomGT1.calls.txt.extract.plink_fwd.gender.count.frq.tab", header=T)

MAF_df<-as.data.frame( table( cut(df$MAF, breaks=c(-1,0,0.001, 0.005, 0.01, 0.05, 0.1, 0.2, 0.3, 0.4, 0.5 )) ) )
colnames(MAF_df)<-c("bin", "count")
g2<-ggplot(MAF_df, aes(bin, count, fill=bin)) + geom_bar(stat="identity") +  geom_text(aes(y=count, label=comma(sprintf("%1.2f%%", count / sum(count) * 100 ))), vjust=-.5, colour="blue", position=position_dodge(0), size=5) + scale_y_continuous(labels=comma) + ylab("count") + xlab("MAF Interval")


png("CR.MAF.png", width=1400, height=650)
grid.arrange(g1,g2, ncol=2)
dev.off()


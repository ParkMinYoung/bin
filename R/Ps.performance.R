# R CMD BATCH --no-save --restore Ps.performance.R

library(ggplot2)
library(gridExtra)
library(scales)


# R 
df<-read.table("Ps.performance.txt", header=T)

type<- as.data.frame( table(df$ConversionType )  )
type$Per<-(type$Freq/sum(type$Freq)*100)
colnames(type)<-c("ConversionType", "Count","Percent")

g1<-ggplot(type, aes(reorder(ConversionType,Count), Count, fill=ConversionType)) + geom_bar(stat="identity") + geom_text(aes(y=Count, label=comma(sprintf("%1.2f %%", Percent))), vjust=-1, colour="blue", size=4) + theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5))+ scale_y_continuous(labels=comma) + xlab("ConversionType")  + geom_text(aes(y=0, label=comma(Count)), vjust=1.5, colour="darkorange", size=3) #+  ggtitle("SNPolisher : Marker Classicfication")
#g1<-ggplot(type, aes(reorder(ConversionType,Count), Count, fill=ConversionType)) + geom_bar(stat="identity") + geom_text(aes(y=Count, label=comma(sprintf("%1.2f %%", Percent))), vjust=-1, colour="blue", size=4) + theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5))+ scale_y_continuous(labels=comma) + xlab("ConversionType") + annotate("text", x=-Inf, y=Inf, label=paste("Total Marker", comma(sum(type$Count)), sep=" : "), size=5 , hjust=-.2, vjust=2, colour="blue") + geom_text(aes(y=0, label=comma(Count)), vjust=1.5, colour="darkorange", size=3) #+  ggtitle("SNPolisher : Marker Classicfication")


type<- as.data.frame( table(df$ConversionType )  )
type$Per<-(type$Freq/sum(type$Freq)*100)
colnames(type)<-c("ConversionType", "Count","Percent")
#ggplot(df, aes(reorder(factor(df$ConversionType),factor(df$ConvertionType), length) , FLD, fill=ConversionType)) + geom_boxplot()



g2<-ggplot(df, aes(reorder(factor(ConversionType),factor(ConversionType), length) , FLD, fill=ConversionType)) + geom_boxplot() + theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5)) + geom_hline(yintercept = 5, colour="blue", linetype="dashed") + geom_hline(yintercept = 7, colour="green", linetype="dashed") + geom_hline(yintercept = 3, colour="red", linetype="dashed") + xlab("ConversionType") #+ scale_x_discrete(limits=c(8,4,6))


#http://stackoverflow.com/questions/3253641/how-to-change-the-order-of-a-discrete-x-scale-in-ggplot
#http://stackoverflow.com/questions/19622063/adding-vertical-line-in-plot-ggplot
# geom_vline(xintercept=2)
#http://stackoverflow.com/questions/13254441/add-a-horizontal-line-to-plot-and-legend-in-ggplot2
# geom_hline(hintercept=2)

g3<-ggplot(df, aes(reorder(factor(ConversionType),factor(ConversionType), length) , HomRO, fill=ConversionType)) + geom_boxplot() + theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5)) + geom_hline(yintercept = 0, colour="blue", linetype="dashed") + geom_hline(yintercept = 2, colour="green", linetype="dashed") + geom_hline(yintercept = -2, colour="red", linetype="dashed") + xlab("ConversionType") #+ scale_x_discrete(limits=c(8,4,6))

g4<-ggplot(df, aes(reorder(factor(ConversionType),factor(ConversionType), length) , CR, fill=ConversionType)) + geom_boxplot() + theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5))+ xlab("ConversionType") + geom_hline(yintercept = 95, colour="blue", linetype="dashed")  + geom_hline(yintercept = 97, colour="green", linetype="dashed") + annotate("text", x=-Inf, y=Inf, label="CR : 97", size=4, hjust=-.2, vjust=2, colour="green")


g5<-ggplot(df, aes(reorder(factor(ConversionType),factor(ConversionType), length) , CR, fill=ConversionType)) + geom_boxplot() + theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5))+ xlab("ConversionType") + geom_hline(yintercept = 95, colour="blue", linetype="dashed")  + geom_hline(yintercept = 97, colour="green", linetype="dashed") + annotate("text", x=-Inf, y=Inf, label="CR : 97", size=4, hjust=-.2, vjust=2, colour="green") + scale_x_discrete(limits=c("MonoHighResolution","NoMinorHom","PolyHighResolution"))

g6<-ggplot(df, aes(reorder(factor(ConversionType),factor(ConversionType), length) , CR, fill=ConversionType)) + geom_boxplot() + theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5))+ xlab("ConversionType") + geom_hline(yintercept = 95, colour="blue", linetype="dashed")  + geom_hline(yintercept = 97, colour="green", linetype="dashed") + annotate("text", x=-Inf, y=Inf, label="CR : 97", size=4, hjust=-.2, vjust=2, colour="green") + scale_x_discrete(limits=c("MonoHighResolution","NoMinorHom","PolyHighResolution")) + ylim(c(95,100))



df$ConversionType<- factor(df$ConversionType, levels=names( rev( sort ( table(df$ConversionType) ) ) ) )
g7<-ggplot(df, aes(CR, fill=ConversionType)) + geom_histogram(binwidth=1, size=.2)  + facet_grid(ConversionType~., scales="free", space="free_x", margins=T) + xlim(c(50,100)) + scale_y_continuous(labels=comma)

CR<-as.data.frame( table( cut(df$CR, breaks=seq(0,100,10)) ) )
g8<-ggplot(CR, aes(Var1, Freq, fill=Var1)) + geom_bar(stat="identity") + geom_text(aes(y=0, label=comma(Freq)), size=4, vjust=1.5, col="darkorange") + geom_text(aes(label=sprintf("%1.2f%%", Freq/sum(Freq)*100)), vjust=-1.5, size=4, col="blue") + scale_y_continuous(labels=comma) + xlab("Call Rate Interval (%)") + ylab("Marker Count")


df$MAF<-df$nMinorAllele/(df$n_AA+df$n_AB+df$n_BB)
# NA handle
df$MAF[is.na(df$MAF)]<-0

df$MAF[ df$MAF > 0.5 ] <- 1 - df$MAF[df$MAF > 0.5]



MAF_df<-as.data.frame( table( cut(df$MAF, breaks=c(-1,0,0.001, 0.005, 0.01, 0.05, 0.1, 0.2, 0.3, 0.4, 0.5 )) ) )
colnames(MAF_df)<-c("bin", "count")
g9<-ggplot(MAF_df, aes(bin, count, fill=bin)) + geom_bar(stat="identity") +  geom_text(aes(y=count, label=comma(sprintf("%1.2f%%", count / sum(count) * 100 ))), vjust=-.5, colour="blue", position=position_dodge(0), size=4) + scale_y_continuous(labels=comma) + ylab("count") + xlab("MAF Interval") + geom_text(aes(y=0, label=comma(count)), vjust=1.5, colour="darkorange", size=3)  + theme(axis.text.x = element_text(angle=45, hjust=1, vjust=.5))


png("Ps.performance.png", width=1200, height=2400)
grid.arrange(g1,g2,g3,g4,g6,g7,g8,g9, ncol=2)
dev.off()


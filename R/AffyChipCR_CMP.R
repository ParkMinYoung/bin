library(ggplot2)
library(gridExtra)


df<-read.table("tmp", header=T)

table( cut(df$call_rate, breaks=c(0,50,80,90,95,96,97,98,99,100) ) )
CR1<- as.data.frame( table( cut(df$call_rate, breaks=c(0,50,80,90,95,96,97,98,99,100) ) ) )
CR2<- as.data.frame( table( cut(df$call_rate.1, breaks=c(0,50,80,90,95,96,97,98,99,100) ) ) )

# CR<-merge(CR1, CR2, all=T)


g1<-ggplot(CR1, aes(Var1, Freq)) + geom_bar(stat="identity", position="dodge") + geom_text(aes(y=0, label=comma(Freq)) ,size=4, hjust=.5, vjust=1.5, position=position_dodge(.9), col="darkorange") + geom_text(aes(label=comma(sprintf("%1.2f%%", Freq/sum(Freq)*100))), vjust=-.5, colour="blue", position=position_dodge(0), size=5) + scale_y_continuous(labels=comma) + xlab("Interval") + ylab("Count") + ylim(c(0, max(CR1$Freq)*1.05))
g2<-ggplot(CR2, aes(Var1, Freq)) + geom_bar(stat="identity", position="dodge") + geom_text(aes(y=0, label=comma(Freq)), size=4, hjust=.5, vjust=1.5, position=position_dodge(.9), col="darkorange") + geom_text(aes(label=comma(sprintf("%1.2f%%", Freq/sum(Freq)*100))), vjust=-.5, colour="blue", position=position_dodge(0), size=5) + scale_y_continuous(labels=comma) + xlab("Interval") + ylab("Count") + ylim(c(0, max(CR2$Freq)*1.05))



CR=CR1
CR$diff<-CR1$Freq-CR2$Freq
g3<-ggplot(CR, aes(Var1, diff, fill=Var1)) + geom_bar(stat="identity") + geom_text(aes(label=diff)) + xlab("Interval") + ylab("Standart - New")

png("CMP.png", height=1100, width=1200)
grid.arrange(g1,g2,g3)
dev.off()


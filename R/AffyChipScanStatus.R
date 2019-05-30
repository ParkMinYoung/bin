args <- commandArgs(TRUE)

library(reshape2)
library(ggplot2)

#setwd("/home/adminrig/workspace.min/AFFX/Axiom_BioBankPlus_SNUHDMEX")
#df<-read.table(text=system("/home/adminrig/workspace.min/AFFX/Axiom_BioBankPlus_SNUHDMEX/check.sh", intern=T), sep="\t", header=T,stringsAsFactors=T)

setwd(args[1])
check<-paste(args[1], args[2], sep="/")
df<-read.table(text=system(check, intern=T), sep="\t", header=T,stringsAsFactors=T)

df$scan_sum <- df[,2] + df[,3]
done<-subset(df, Type == "done")[,1]

subset_df<-df[, c(1,4,5,6,9)]
colnames(subset_df) <-c("SET", "BACKUP", "SERVER", "ANALYSIS", "SCAN")
melt_df<- melt(subset_df, id=1)
melt_df$SET<-as.factor(melt_df$SET)
melt_df$variable<-factor(melt_df$variable, levels =c( "SCAN","SERVER","ANALYSIS", "BACKUP" ))

g1<-ggplot(melt_df, aes(as.factor(SET), value, fill=variable)) + geom_bar(stat="identity", position="dodge") + scale_fill_discrete(limits=c("SCAN","SERVER","ANALYSIS", "BACKUP"))  + facet_wrap(~SET, ncol=6, scale="free_x") + geom_text(aes(y=max(value)/2, label=value), col="black", position=position_dodge(width=.9)) + geom_rect(data = subset(melt_df, SET %in% done) , aes(fill="blue"), xmin= -Inf, xmax= Inf, ymin = -Inf, ymax = Inf, alpha =0.2) + xlab("SET") + ylab("SCAN, SERVER, ANALYSIS AND BACKUP CEL COUNT")



nrow<-ceiling( NROW(df)/6 )
ggsave(g1, file="Scan_vs_Analysis_stataus.png", width=30, height= nrow*4, units ="cm")



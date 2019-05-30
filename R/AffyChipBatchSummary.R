# R CMD BATCH --no-save --no-restore ~/src/short_read_assembly/bin/R/AffyChipBatchSummary.R

library(xlsx)
library(reshape2)
library(ggplot2)
library(gridExtra)
library(plyr)
library(scales)
library(GGally)



## read DQC file 
df<-read.delim("batch/apt-geno-qc.txt", comment.char="#")
df$num<-1:length(df$cel_files)


df2<-read.table("batch/AxiomGT1.report.txt", header=T, comment.char="#")

 
# boxplot DQC per male
g1<-ggplot(df, aes(cn.probe.chrXY.ratio_gender, axiom_dishqc_DQC, fill=cn.probe.chrXY.ratio_gender)) + geom_boxplot()


# scatter plot per male(long)
g2<-ggplot(df, aes(reorder(cel_files,axiom_dishqc_DQC) , axiom_dishqc_DQC, col=cn.probe.chrXY.ratio_gender)) + geom_point() + labs(x="samples", y="DQC") + theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5)) #+ ylim(y=c(90,100)) 


#png("apt-geno.png", width=2400, height=4800)
#ggpairs(data=df, columns=2:29, title="apt-geno", colour = "cn.probe.chrXY.ratio_gender") # aesthetics, ggplot2 style
#ggpairs(data=df, columns=2:length(colnames(df))-1, title="apt-geno") # aesthetics, ggplot2 style
#dev.off()


# bar plot per gender
gender_cnt <- as.data.frame( table(df2$computed_gender) )
  colnames(gender_cnt) <- c("Gender", "Count")
  g3<- ggplot(gender_cnt, aes( Gender, Count, fill=Gender) ) + 
  geom_bar(stat="identity") +
  geom_text( aes(y=Count, label=comma(Count)), vjust=1.5, colour="white", size=6) + 
  xlab("Gender") + 
  ylab("Number of Sample") + 
  scale_fill_discrete(name="Gender")


# call rate scatter plot(long)
g4<-ggplot(df2, aes(reorder(cel_files, call_rate), call_rate, col=computed_gender)) + geom_point() + theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5)) #+ ylim(y=c(90,100)) 


# call boxplot per gender
g5<-ggplot(df2, aes(x=computed_gender, y=call_rate, fill=computed_gender)) + geom_boxplot(outlier.colour=NA, width=.4) + geom_dotplot(binaxis="y", binwidth=.001, stackdir="center", fill=NA)
 
# call histogram 
g6<-ggplot(df2, aes(x=call_rate, y=..density..)) + geom_histogram(binwidth=1, fill="cornsilk", colour="grey60", size=.2) + stat_bin(binwidth=1, geom="text", aes(label=..count..)) + geom_density() 

# axiom_dishqc_DQC histogram
g10<-ggplot(df, aes(x=axiom_dishqc_DQC, y=..density..)) + geom_histogram(binwidth=.01, fill="cornsilk", colour="grey60", size=.2) + stat_bin(binwidth=.01, geom="text", aes(label=..count..)) + geom_density() 

# het rate scatter plot(long)
g7<-ggplot(df2, aes(reorder(cel_files, het_rate), het_rate, col=computed_gender)) + geom_point() + theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5)) #+ ylim(y=c(90,100)) 

# cn.probe scatter plot
g8<-ggplot(df2, aes(cn.probe.chrXY.ratio_gender_meanX, cn.probe.chrXY.ratio_gender_meanY, col=computed_gender)) + geom_point()

# cn.probe scatter plot(long)
g9<-ggplot(df2, aes(reorder(cel_files, cn.probe.chrXY.ratio_gender_ratio), cn.probe.chrXY.ratio_gender_ratio, col=computed_gender )) + geom_point() + theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5)) #+ ylim(y=c(90,100)) 


ppi<-300
png("Summary.png", width=1600, height=2400)
#grid.arrange(arrangeGrob(g3,g1,g6,g5,g8, ncol=2), arrangeGrob(g2, g4, ncol=1),arrangeGrob(g7,g9, ncol=1))
grid.arrange(arrangeGrob(g3,g8,g1,g10,g5,g6, ncol=2), arrangeGrob(g2, g4, ncol=1),arrangeGrob(g7,g9, ncol=1))
dev.off()


#png("apt-probeset-genotype.png", width=2400, height=4800)
#ggpairs(data=df2, columns=2:20, title="apt-probeset-genotype", colour = "cn.probe.chrXY.ratio_gender") # aesthetics, ggplot2 style
#dev.off()


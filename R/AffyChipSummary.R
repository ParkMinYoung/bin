# R CMD BATCH --no-save --no-restore AffyChipSummary.R

library(xlsx)
library(reshape2)
library(ggplot2)
library(gridExtra)
library(plyr)
library(scales)
library(GGally)

df <- read.table("Summary.txt", header=T)

# bar plot per gender 
gender_t<-as.data.frame(table(df$apt_probeset_genotype_gender))
colnames(gender_t)<-c("Gender", "Count")
g1<-ggplot(gender_t , aes(Gender, Count, fill=Gender)) +
	geom_bar(stat="identity") +
	geom_text(aes(y=0, label=comma(Count)), size=4, vjust=-.5, col="black") +
	xlab("Gender") +
	ylab("Number of Sample") +
	scale_fill_discrete(name="Gender")


# bar plot per set
g2<-ggplot(df , aes(set, fill=apt_probeset_genotype_gender)) +
geom_bar(size=1) +
annotate("text", x=-Inf, y=Inf, label=paste("Total Exp Sample Count", length(df$id), length( unique(df$set) ), sep=":"), size=5 , hjust=-.2, vjust=2, colour="black") +
ylim(c(0,120)) +
ylab("Number of Sample") +
theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5)) +
theme(legend.position="bottom") +
scale_fill_discrete(name="Gender")


# DQC boxplot per set
g3<-ggplot(df, aes(set, axiom_dishqc_DQC, fill=set)) + geom_boxplot() + theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5)) + theme(legend.position="none")
#g3<-ggplot(df, aes(set, axiom_dishqc_DQC, fill=set)) + geom_boxplot() + theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5)) + facet_wrap(~ set, ncol=20)


# DQC boxplot per set
#g4<-ggplot(df, aes(interaction(set,apt_probeset_genotype_gender), axiom_dishqc_DQC, fill=set)) + geom_boxplot() + theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5)) + theme(legend.position="none")
g4<-ggplot(df, aes(set, axiom_dishqc_DQC, fill=set)) + geom_boxplot() + theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5)) + facet_grid(apt_probeset_genotype_gender~.)+ theme(legend.position="none")

# call rate per set
g5<-ggplot(df, aes(set, call_rate, fill=set)) + geom_boxplot() + theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5))  + theme(legend.position="none")
#g5<-ggplot(df, aes(set, call_rate, fill=set)) + geom_boxplot() + theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5)) +  facet_wrap(~ set, ncol=20) 
g6<-ggplot(df, aes(set, call_rate, fill=set)) + geom_boxplot() + theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5)) + facet_grid(apt_probeset_genotype_gender~.) + theme(legend.position="none")



g7<-ggplot(df, aes(set, het_rate, fill=set)) + geom_boxplot() + theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5))  + theme(legend.position="none")
#g7<-ggplot(df, aes(set, het_rate, fill=set)) + geom_boxplot() + theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5)) +  facet_wrap(~ set, ncol=20) 
g8<-ggplot(df, aes(set, het_rate, fill=set)) + geom_boxplot() + theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5))  + facet_grid(apt_probeset_genotype_gender~.) + theme(legend.position="none")



# DQC
g11<-ggplot(df, aes(axiom_dishqc_DQC)) + geom_histogram(binwidth=.01, fill="cornsilk", colour="grey60", size=.2) + stat_bin(binwidth=.01, geom="text", aes(label=scales::percent( (..count..)/sum(..count..) )), colour="blue") + geom_density(colour="blue") 
g12<-ggplot(df, aes(axiom_dishqc_DQC)) + geom_histogram(binwidth=.01, fill="cornsilk", colour="grey60", size=.2) + stat_bin(binwidth=.01, geom="text", aes(label=..count..), colour="blue") + geom_density(colour="blue") 

# Call rate
g9<-ggplot(df, aes(call_rate)) + geom_histogram(binwidth=1, fill="cornsilk", colour="grey60", size=.2) + stat_bin(binwidth=1, geom="text", aes(label=scales::percent( (..count..)/sum(..count..) )), colour="blue") + geom_density(colour="blue") 
g10<-ggplot(df, aes(call_rate)) + geom_histogram(binwidth=1, fill="cornsilk", colour="grey60", size=.2) + stat_bin(binwidth=1, geom="text", aes(label=..count..), colour="blue") + geom_density(colour="blue") 
#g9<-ggplot(df, aes(x=call_rate, y=..density..)) + geom_histogram(binwidth=.01, fill="cornsilk", colour="grey60", size=.2) + stat_bin(binwidth=.01, geom="text", aes(label=..count..)) + geom_density() 
#ggplot(df, aes(x=call_rate)) + geom_histogram()

g11<-ggplot(df, aes(axiom_dishqc_DQC)) + geom_histogram(binwidth=.01, fill="cornsilk", colour="grey60", size=.2) + stat_bin(binwidth=.01, geom="text", aes(label=scales::percent( (..count..)/sum(..count..) )), colour="blue") + geom_density(colour="blue") 

# x call rate, y het_rate scatter plot
g13<-ggplot(df, aes(call_rate, het_rate, col=set)) + geom_point(alpha=1) + theme(legend.position="none")



## Added Plot

g20<-ggplot(df, aes(set, axiom_dishqc_DQC, fill=set)) + geom_boxplot() + theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5)) + ylim(c(0.6,1)) + geom_hline(yintercept = 0.82, colour="blue", linetype="dashed")  + annotate("text", x=-Inf, y=Inf, label="DQC Pass Cutoff Value : 0.82", size=4, hjust=-0.1, vjust=25, colour="red") + theme(legend.position="none")

g21<-ggplot(df, aes(set, call_rate, fill=set)) + geom_boxplot() + theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5), legend.position="none") + ylim(c(90,100)) + geom_hline(yintercept = 95, colour="red", linetype="dashed")  + annotate("text", x=-Inf, y=Inf, label="CR : 99%", size=3, hjust=-0.2, vjust=2, colour="red") 
	
#DQC histogram
g22<-ggplot(df, aes(axiom_dishqc_DQC)) + geom_histogram(binwidth=.02, fill="cornsilk", colour="grey60", size=.2) + stat_bin(binwidth=.02, geom="text", aes(label=scales::percent( (..count..)/sum(..count..) )), colour="blue", vjust=-.5) + geom_density(colour="blue") + xlim(c(0.75,1))
# CR histogram
g23<-ggplot(df, aes(call_rate)) + geom_histogram(binwidth=.5, fill="cornsilk", colour="grey60", size=.2) + stat_bin(binwidth=.5, geom="text", aes(label=scales::percent( (..count..)/sum(..count..) )), colour="blue", vjust=-.5) + geom_density(colour="blue") +xlim(c(90,100))

g24<-ggplot(df, aes(axiom_dishqc_DQC)) + geom_histogram(binwidth=.02, fill="cornsilk", colour="grey60", size=.2) + stat_bin(binwidth=.02, geom="text", aes(label=..count..), colour="blue") + geom_density(colour="blue") + xlim(c(0.75,1))

g25<-ggplot(df, aes(call_rate)) + geom_histogram(binwidth=.5, fill="cornsilk", colour="grey60", size=.2) + stat_bin(binwidth=.5, geom="text", aes(label=..count..), colour="blue") + geom_density(colour="blue")  + xlim(c(90,100))


CR_df<-as.data.frame( table( cut(df$call_rate, breaks=c(0,50,80,90,95,96,97,98,99,100)) ) )
colnames(CR_df)<-c("bin", "count")
#g26<-ggplot(CR_df, aes(bin, count, fill=bin)) + geom_bar(stat="identity") + geom_text(aes(y=count, label=comma(sprintf("%1.2f%%", count / sum(count) * 100 ))), vjust=-.5, colour="blue", position=position_dodge(0), size=5)+ geom_text(aes(y=count, label=comma(sprintf("%1.2f%%", count / sum(count) * 100 ))), vjust=-.5, colour="blue", position=position_dodge(0), size=5) + scale_y_continuous(labels=comma) + ylab("count") + xlab("Call Rate Interval") + geom_text(aes(y=0, label=comma(count)), vjust=1.5, colour="darkorange", size=4)
Below99<-sum( CR_df[-NROW(CR_df),2])
g26<-ggplot(CR_df, aes(bin, count, fill=bin)) + geom_bar(stat="identity") + geom_text(aes(y=count, label=comma(sprintf("%1.2f%%", count / sum(count) * 100 ))), vjust=-.5, colour="blue", position=position_dodge(0), size=5) + scale_y_continuous(labels=comma) + ylab("count") + xlab("Call Rate Interval") + geom_text(aes(y=0, label=comma(count)), vjust=1.5, colour="darkorange", size=4) + geom_text(x=-Inf, y=Inf, hjust=-.2, vjust=2, label=paste( "# < 99% :",Below99, " "), col="darkorange")


DQC_df<-as.data.frame( table( cut(df$axiom_dishqc_DQC, breaks=c(0, 0.82, 0.88, 0.92, 0.96,  1 )) ) )
colnames(DQC_df)<-c("bin", "count")
g27<-ggplot(DQC_df, aes(bin, count, fill=bin)) + geom_bar(stat="identity") +  geom_text(aes(y=count, label=comma(sprintf("%1.2f%%", count / sum(count) * 100 ))), vjust=-.5, colour="blue", position=position_dodge(0), size=5) + scale_y_continuous(labels=comma) + ylab("count") + xlab("DQC Interval") + geom_text(aes(y=0, label=comma(count)), vjust=1.5, colour="darkorange", size=4)


Het_df<-as.data.frame( table( cut(df$het_rate, breaks=c(0, 10, 13, 14, 15, 16, 17, 18, 20, 50, 100 )) ) )
colnames(Het_df)<-c("bin", "count")
g28<-ggplot(Het_df, aes(bin, count, fill=bin)) + geom_bar(stat="identity") +  geom_text(aes(y=count, label=comma(sprintf("%1.2f%%", count / sum(count) * 100 ))), vjust=-.5, colour="blue", position=position_dodge(0), size=5) + scale_y_continuous(labels=comma) + ylab("count") + xlab("Het Rate Interval") + geom_text(aes(y=0, label=comma(count)), vjust=1.5, colour="darkorange", size=4)




Mean_df<-ddply(df, "set", summarise, DQC_mean=mean(axiom_dishqc_DQC))
g31<-ggplot(Mean_df, aes(set, DQC_mean)) + geom_point(size=4,colour="blue", shape=18) + coord_flip() + ylab("Mean DQC per Plate") + xlab("Plate Number")
g32<-ggplot(Mean_df, aes(reorder(set,DQC_mean), DQC_mean)) + geom_point(size=4,colour="darkorange", shape=18) + coord_flip() + ylab("Mean DQC per Plate") + xlab("Plate Number")

Mean_df<-ddply(df, "set", summarise, CR_mean=mean(call_rate))
g33<-ggplot(Mean_df, aes(set, CR_mean)) + geom_point(size=4,colour="blue", shape=18) + coord_flip() + ylab("Mean CR per Plate") + xlab("Plate Number")
g34<-ggplot(Mean_df, aes(reorder(set,CR_mean), CR_mean)) + geom_point(size=4,colour="darkorange", shape=18) + coord_flip() + ylab("Mean CR per Plate") + xlab("Plate Number")

Mean_df<-ddply(df, "set", summarise, Het_mean=mean(het_rate))
g35<-ggplot(Mean_df, aes(set, Het_mean)) + geom_point(size=4,colour="blue", shape=18) + coord_flip() + ylab("Mean Het Rate per Plate") + xlab("Plate Number")
g36<-ggplot(Mean_df, aes(reorder(set,Het_mean), Het_mean)) + geom_point(size=4,colour="darkorange", shape=18) + coord_flip() + ylab("Mean Het Rate per Plate") + xlab("Plate Number")



#png("Summary.GGally.png", width=2400, height=4800)
#ggpairs(data=df, columns=3:9, title="summary", colour = "set") # aesthetics, ggplot2 style
#dev.off()

png("Summary.png", width=1600, height=5000)
grid.arrange(g1, g2, g3, g4, g5, g6, g7, g8, g20, g21, g22, g23, g24, g25,    g26, g27,  g31,g32,g33,g34,g35,g36,  g13,g28, ncol=2)
#grid.arrange(g1, g2, g3, g4, g5, g6, g7, g8, g9, g10, g11, g12, g20, g21, g22, g23, g24, g25, g26, g27, g13, ncol=2)
#grid.arrange(g1, g2, g3, g5, g7,  g9, g10, g11, g12, g13, ncol=2)
dev.off()







doPlot_CR = function(sel_name) {
   dum = subset(df, set == sel_name)
   ggobj = ggplot(dum, aes( reorder(id, call_rate), call_rate, col=apt_probeset_genotype_gender)) + geom_point() + theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5)) + labs(x=sel_name) 
   print(ggobj)
   #ggsave(sprintf("%s.pdf", sel_name))
}

doPlot_DQC = function(sel_name) {
   dum = subset(df, set == sel_name)
   ggobj = ggplot(dum, aes( reorder(id, axiom_dishqc_DQC), axiom_dishqc_DQC, col=apt_probeset_genotype_gender)) + geom_point() + theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5)) + labs(x=sel_name) 
   print(ggobj)
   #ggsave(sprintf("%s.pdf", sel_name))
}

#lapply(unique(df$set), doPlot_CR)




multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  require(grid)

  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)

  numPlots = length(plots)

  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                    ncol = cols, nrow = ceiling(numPlots/cols))
  }

 if (numPlots==1) {
    print(plots[[1]])

  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))

    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))

      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}




plots <- list() 
sets<-as.character( unique(df$set) )
set_num<-length(sets)
for (i in 1:set_num ) { 
   dum = subset(df, set == sets[i])
   plots[[i]] = ggplot(dum, aes( reorder(id, call_rate), call_rate, col=apt_probeset_genotype_gender)) + geom_point() + theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5)) + labs(x=sets[i]) 

}

png("CR.png", width=1200, height=200*set_num)
multiplot(plotlist = plots, cols = 1)
dev.off()


plots <- list() 
sets<-as.character( unique(df$set) )
set_num<-length(sets)
for (i in 1:set_num ) { 
   dum = subset(df, set == sets[i])
   plots[[i]] = ggplot(dum, aes( reorder(id, axiom_dishqc_DQC), axiom_dishqc_DQC, col=apt_probeset_genotype_gender)) + geom_point() + theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5)) + labs(x=sets[i]) 

}

png("DQC.png", width=1200, height=200*set_num)
multiplot(plotlist = plots, cols = 1)
dev.off()


ncol<-5
Mean_df<-ddply(df, "set", summarise, CR_mean=mean(call_rate))
nRow<- ceiling( NROW(Mean_df)/ncol )
png("CR.histogram.png", width=1500, height=120*nRow)
#ggplot(df, aes(call_rate, fill=set)) + geom_histogram(binwidth=1, size=.2) + stat_bin(binwidth=1, geom="text", aes(label=..count..), colour="red")+ xlim(c(70,100)) + facet_wrap(~ set, ncol=5) 

Below99<-ddply( subset(df, call_rate<99), "set", summarise, count=length(call_rate))

CR_per_set_df<-as.data.frame( table( list( df$set, cut(df$call_rate, breaks=c(0,90,95,96,97,98,99,100)) )  ) )
colnames(CR_per_set_df)<-c("set", "bin", "count")

CR<- merge(Mean_df, Below99, all=T)
CR$count[ is.na( CR$count ) ] <- 0
CR_per_set_df$set<-factor( CR_per_set_df$set, levels=CR[rev(order(CR$count)), "set"])

CR_per_set_df[CR_per_set_df$count==0, "count"]<-NA
ggplot(CR_per_set_df, aes(factor(set), count, fill=bin)) + geom_bar(stat="identity", position="dodge") + geom_text(aes(x=set, y=0, label=count),position=position_dodge(width=0.9), vjust=-1, colour="darkorange", size=4) + facet_wrap(~set, ncol=5, scale="free") + scale_y_continuous(labels=comma) + ylab("count") + xlab("Call Rate Interval")

dev.off()





## Add 20141209
ncol<-6
nRow<- ceiling( NROW(Mean_df)/ncol ) 

mean_CR_sorted_df <- df[, c("set", "call_rate")]
mean_CR_sorted_df$set<- factor(mean_CR_sorted_df$set, levels=Mean_df[order(Mean_df$CR_mean),1])

png("CR.Boxplot.png", height=nRow*140, width=900)
ggplot(mean_CR_sorted_df, aes(set, call_rate)) + geom_rect(data = subset(mean_CR_sorted_df, set %in% Mean_df[ Mean_df$CR_mean < 99, 1] ) , aes(fill=set), xmin= -Inf, xmax= Inf, ymin = -Inf, ymax = Inf, alpha =0.01) + geom_boxplot(width=.5) + facet_wrap(~set, ncol=6, scale="free") + geom_text(data=Mean_df, aes(label=comma(sprintf("%1.2f%%",CR_mean))), x=Inf, y=-Inf, vjust=-1, hjust=1, col="red" )
dev.off()


df$set<-factor(mean_CR_sorted_df$set, levels=Mean_df[order(Mean_df$CR_mean),1])
png("CR_vs_HetRate.ScatterPlot.png", height=nRow*110, width=1500)
#ggplot(df, aes(call_rate, axiom_dishqc_DQC)) + geom_rect(data = subset(df, set %in% Mean_df[ Mean_df$CR_mean < 99, 1] ) , aes(fill=set), xmin= -Inf, xmax= Inf, ymin = -Inf, ymax = Inf, alpha =0.1) + geom_point(shape=1) + stat_density2d(colour="yellow") + facet_wrap(~set, ncol=6) + xlim(c(95,100)) + ylim(c(0.8, 1)) + geom_vline(xintercept=99, colour="red") +  geom_hline(yintercept=0.9, colour="red")
ggplot(df, aes(call_rate, axiom_dishqc_DQC)) + geom_rect(data = subset(df, set %in% Mean_df[ Mean_df$CR_mean < 99, 1] ) , aes(fill=set), xmin= -Inf, xmax= Inf, ymin = -Inf, ymax = Inf, alpha =0.01) + geom_point(shape=1) + stat_density2d(colour="yellow") + facet_wrap(~set, ncol=6, scale="free") + geom_vline(xintercept=99, colour="red") +  geom_hline(yintercept=0.9, colour="red") + geom_text(data=Mean_df, aes(label=comma(sprintf("%1.2f%%",CR_mean))), x=Inf, y=-Inf, vjust=-1, hjust=1, col="red" )
dev.off()






#########		attach(df)
#########
#########		CR-as.matrix( tapply(call_rate, list(well, set), sum) )
#########		CR<-t(CR)
#########png("CR.Grid.png", height=1400, width=1400)
##########image(m, axes=F, col=pal[1:9],col=rainbow(25) )
#########		image(t(CR), axes=F, col=brewer.pal(11,"Spectral"))
#########		axis(1, at=c(seq(0,1,by=(1/(ncol(CR)-1)))), labels=colnames(CR), las=1, cex.lab=.3, col.axis="blue", cex.axis=.7, las=2)
#########		axis(2, at=seq(0,1,by=(1/(nrow(CR)-1))), labels=rownames(CR), las=2, cex.lab=.3, col.axis="blue", cex.axis=.8)
#########
#########		grid(nrow(m),ncol(m),col="gray",lty=1,lwd=1)
#########		box("plot", col="black", lwd=2)
#########		 
#########dev.off()





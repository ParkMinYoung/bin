#  R CMD BATCH --no-save --no-restore HiseqSummaryPlot.R

library(xlsx)
library(reshape2)
library(ggplot2)
library(gridExtra)
library(plyr)
library(GGally)
library(scales) # to use comma scale


df = read.xlsx2("Fastq.sequence.summary_drop.xlsx", sheetName = "Sheet1")
# df = read.xlsx2("Fastq.sequence.summary_drop.xlsx", sheetName = "Sheet1", colClasses = c(rep("character", x),rep("num.with.commas", 2), rep("numeric", ncol(df)-x-2+1)))
# df = read.xlsx2("Fastq.sequence.summary_drop.xlsx", sheetName = "Sheet1", colClasses = c(rep("character", x),rep("numeric", ncol(df)-x+1)))

num_col<-ncol(df)

col2cvt <- 5:6
df[,col2cvt] <- lapply(df[,col2cvt],function(x){as.numeric(gsub(",", "", x))})

col2cvt <- 7:num_col
df[,col2cvt] <- lapply(df[,col2cvt],function(x){as.numeric(as.vector(x))})


# convert 2,123 string to number
# http://stackoverflow.com/questions/3605807/how-to-convert-numbers-with-comma-inside-from-character-to-numeric-in-r

#> str(df)
#'data.frame':  60 obs. of  13 variables:
# $ 1 Lane                         : Factor w/ 7 levels "2","3","4","5",..: 1 1 1 1 1 1 1 1 1 1 ...
# $ 2 Sample.ID                    : Factor w/ 60 levels "B27","B28","B29",..: 1 2 3 4 5 6 7 8 9 10 ...
# $ 3 Index                        : Factor w/ 13 levels "ACAGTG","ACTTGA",..: 3 5 12 11 1 8 4 2 7 10 ...
# $ 4 Project                      : Factor w/ 2 levels "20141021_SNU_ParkHanSoo_ExomeSeq_1",..: 1 1 1 1 1 1 1 1 1 1 ...
# $ 5 Yield..Mbases.               : num  5067 5597 4893 4997 6006 ...
# $ 6 X..Reads                     : num  50167804 55415636 48442368 49475406 59468380 ...
# $ 7 X..of.raw.clusters.per.lane  : num  8.62 9.53 8.33 8.51 10.22 ...
# $ 8 X..Perfect.Index.Reads       : num  97.7 97.8 97.7 97.2 98.1 ...
# $ 9 X..One.Mismatch.Reads..Index.: num  2.33 2.17 2.32 2.81 1.92 2.65 2.6 2.67 2.17 2.38 ...
# $10 X..of....Q30.Bases..PF.      : num  91.3 92 92 91.9 92.1 ...
# $11 Mean.Quality.Score..PF.      : num  35.7 35.9 35.9 35.9 35.9 ...
# $12 R1.Duprate                   : num  26.9 33.9 26.2 25.6 31.9 ...
# $13 R2.Duprate                   : num  27 33.8 26.5 25.8 31.7 ...

# barplot yield Mbp per sample
#ggplot(df, aes(Sample.ID, Yield..Mbases. , fill=Lane)) + geom_bar(stat="identity") + facet_grid(.~Lane)
g1<-ggplot(df, aes(Sample.ID, Yield..Mbases. , fill=Lane)) + geom_bar(stat="identity") + theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5))

# barplot sample count per lane
g12<-ggplot(df, aes(Lane, , fill=Project)) + geom_bar() +  stat_bin( geom="text", aes(label=..count..), size=5)


# boxplot yield Mbp per lane
g2<-ggplot(df, aes(Lane, Yield..Mbases. , fill=Lane)) + geom_boxplot()

# boxplot yield Mbp per Project
g3<-ggplot(df, aes(Project, Yield..Mbases. , fill=Lane)) + geom_boxplot()



# boxplot yield Mbp per lane
g4<-ggplot(df, aes(Lane, X..of....Q30.Bases..PF. , fill=Lane)) + geom_boxplot()
# boxplot yield Mbp per Project
g5<-ggplot(df, aes(Project, X..of....Q30.Bases..PF. , fill=Lane)) + geom_boxplot()



# boxplot yield Mbp per lane
g6<-ggplot(df, aes(Lane, Mean.Quality.Score..PF. , fill=Lane)) + geom_boxplot()
# boxplot yield Mbp per Project
g7<-ggplot(df, aes(Project, Mean.Quality.Score..PF. , fill=Lane)) + geom_boxplot()


# boxplot yield Mbp per lane
g8<-ggplot(df, aes(Lane, R1.Duprate , fill=Lane)) + geom_boxplot()
g9<-ggplot(df, aes(Project, R1.Duprate , fill=Lane)) + geom_boxplot()



dff <- ddply(df, "Lane", transform, Yield=cumsum(Yield..Mbases.))
g13<-ggplot(dff, aes(Lane, Yield..Mbases., fill=Yield..Mbases.) ) + geom_bar(stat="identity", width=.5, colour="black") + geom_text(aes(y=Yield, label=comma(Yield..Mbases.)), vjust=1.5, colour="green", position=position_dodge(0), size=3) + scale_y_continuous(labels=comma)


dfp <- ddply(df, "Lane", transform, Yield_per= Yield..Mbases. / sum(Yield..Mbases.) * 100)
dfpp <- ddply(dfp, "Lane", transform, Yield_PER=cumsum(Yield_per))
g14<-ggplot(dfpp, aes(Lane, Yield_per, fill=Yield_per) ) + geom_bar(stat="identity", width=.5, colour="black") + geom_text(aes(y=Yield_PER, label=comma(sprintf("%1.2f%%", Yield_per))), vjust=1.5, colour="green", position=position_dodge(0), size=3) + scale_y_continuous(labels=comma)




# http://stackoverflow.com/questions/18332520/how-to-put-percentage-label-in-ggplot-when-geom-text-is-not-suitable



if( num_col == 13 ){

	# boxplot yield Mbp per lane
	g10<-ggplot(df, aes(Lane, R2.Duprate , fill=Lane)) + geom_boxplot()
	g11<-ggplot(df, aes(Project, R2.Duprate , fill=Lane)) + geom_boxplot()
	png("HiseqBatchReview.png", width=1600, height=2400)
	grid.arrange(g1, g12, g13,g14, g2, g3, g4, g5, g6, g7,g8,g9,g10,g11,ncol=2)
	dev.off()
}else{
	png("HiseqBatchReview.png", width=1600, height=2400)
	grid.arrange(g1, g12, g13,g14, g2, g3, g4, g5, g6, g7,g8,g9, ncol=2)
	dev.off()
}


png("HiseqBatchReviewByGGally.png", width=1920, height=1200)
ggpairs(data=df, columns=c(1,4,5,10:num_col), title="Hiseq Batch Review",  colour = "Lane")
dev.off()

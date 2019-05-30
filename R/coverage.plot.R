#  R CMD BATCH --no-save --no-restore '--args 32/20130426/Bone.1.bam.coverage Bone.1' coverage.plot.R


library(gridExtra)
library(gplots)

args <- commandArgs(TRUE)


T1<-read.delim(args[1], header=F, col.names=c("chr", "start", "end", "reads", "exp.bp", "target.bp", "coverage") , sep="\t")

out<-paste(args[1], "plot.pdf", sep=".")

pdf(out)

par(mfrow=c(3,2))

## 1
hist(T1$coverage, main="histogram of coverage rate")

## 2 
H<-hist(T1$coverage, plot=FALSE )
count<-matrix(H$counts, dimnames=list(H$breaks[-1], "COUNT"))
textplot( count, valign="top")
title("coverage rate table")

## 3
hist(T1$reads)
reads<-T1[T1$reads<200,]$reads

R<-hist(reads, plot=FALSE)
count1<-matrix(R$counts, dimnames=list(R$breaks[-1], "COUNT"))

## 4
hist(reads, breaks=100, main="read count histogram (read<200)")

## 5
TT1<- T1[T1$reads>30,]
plot(TT1$coverage, TT1$reads, xlab="coverage rate of bin 1k", ylab="reads count", col="blue", cex=.5, main=args[2])

## 6
textplot( count1, valign="top")
title("read count table")

dev.off()

#par(mfrow=c(1,1))


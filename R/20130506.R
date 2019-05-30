cd /home/adminrig/workspace.min/IonTorrent/IonProton/bin/32/20130426
R script

library(ggplot2)

T<-read.delim("Bone.1.bam.refFlat.txt.Gene.bed.coverage", header=F, col.names=c("chr", "start", "end", "gene", "reads", "exp.bp", "target.bp", "coverage") , sep="\t")

pdf("Bone.Coverage.pdf", width = 16, height = 12)

TT<-T[grep(pattern="_", invert=TRUE, T$chr),]
TT$chr<- factor(TT$chr, labels=paste("chr", c(1:22,"X","Y"), sep=""))
qplot(coverage, target.bp, data=TT, facets= ~ chr)
qplot(coverage, target.bp, data=TT, colour=chr)
qplot(coverage, data=TT, facets= ~chr)
qplot(coverage, data=TT)

H<-hist(TT$coverage, plot=FALSE)
cbind(H$breaks[-1], H$counts,H$density)


TTT<-TT[TT$target.bp>=500,] 
TT$chr<- factor(TTT$chr, labels=paste("chr", c(1:22,"X","Y"), sep=""))
qplot(coverage, target.bp, data=TTT, facets= ~ chr)
qplot(coverage, target.bp, data=TTT, colour=chr)
qplot(coverage, data=TTT, facets= ~chr)
qplot(coverage, data=TTT)

dev.off()



args <- commandArgs(TRUE)

library(gplots)

#df<-read.table("/home/adminrig/workspace.min/IonTorrent/IonProton/bin/Ion.Input/DNALink.Giant.CCP/Analysis/VAR/Merge/VCFMerge/merge.vcf.num.score", header=T, na.strings = "NaN")
df<-read.table(args[1], header=T, na.strings = "NaN")
con<-df[,-1]
rownames(con)<-df[,1]
#mat<-head(as.matrix(con), 500)
mat<-as.matrix(con)
cc<-rep(rainbow(ncol(mat)/3, start=0, end=1),each=3)


png("NoQC.All.png", width=1200, height=1300)
heatmap.2(mat,
          breaks=c(-2, -1.1, -0.01, 0.9, 2), 
          col=c("white", "grey", "green", "blue"), 
          Rowv=FALSE, 
          Colv=TRUE,
          margins = c(12, 22),
          trace = "none", 
          xlab = "Sample",
          lhei = c(2, 8),
          na.color="blue",
          cexRow = 0.5, 
          cexCol = 1.5,
		  labRow=NA,
          main = "Clustering Based Genotype", 
          dendrogram = "col",
          ColSideColors=cc,
)
dev.off()


png("NoQC.50.png", width=1200, height=1300)
mat<-head(as.matrix(con), 50)
heatmap.2(mat,
          breaks=c(-2, -1.1, -0.01, 0.9, 2), 
          col=c("white", "grey", "green", "blue"), 
          Rowv=FALSE, 
          Colv=TRUE,
          margins = c(12, 22),
          trace = "none", 
          xlab = "Sample",
          lhei = c(2, 8),
          na.color="blue",
          cexRow = 0.5, 
          cexCol = 1.5,
		  labRow=NA,
          main = "Clustering Based Genotype", 
          dendrogram = "col",
          ColSideColors=cc,
)
dev.off()


df<-read.table(args[2], header=T, na.strings = "NaN")
con<-df[,-1]
rownames(con)<-df[,1]
mat<-as.matrix(con)
cc<-rep(rainbow(ncol(mat)/2, start=0, end=.5),each=2)

png("QC.All.png", width=1200, height=1300)
##heatmap.2(mat,
##		  col=bluered,
##          Rowv=FALSE, 
##          Colv=TRUE,
##          margins = c(12, 22),
##          trace = "none", 
##		  labRow=NA,
##          xlab = "Sample",
##          lhei = c(2, 8),
##          cexRow = 0.5, 
##          cexCol = 1.5,
##          main = "CCP Genotype", 
##          dendrogram = "col",
##          ColSideColors=cc,
##          )

heatmap.2(mat,
          breaks=c(-2, -1.1, -0.01, 0.9, 2), 
          col=c("white", "grey", "green", "blue"), 
          Rowv=FALSE, 
          Colv=TRUE,
          margins = c(12, 22),
          trace = "none", 
          xlab = "Sample",
          lhei = c(2, 8),
          na.color="blue",
          cexRow = 0.5, 
          cexCol = 1.5,
		  labRow=NA,
          main = "Clustering Based Genotype", 
          dendrogram = "col",
          ColSideColors=cc,
          )
dev.off()

png("QC.50.png", width=1200, height=1300)
mat<-head(as.matrix(con), 50)

heatmap.2(mat,
          breaks=c(-2, -1.1, -0.01, 0.9, 2), 
          col=c("white", "grey", "green", "blue"), 
          Rowv=FALSE, 
          Colv=TRUE,
          margins = c(12, 22),
          trace = "none", 
          xlab = "Sample",
          lhei = c(2, 8),
          na.color="blue",
          cexRow = 0.5, 
          cexCol = 1.5,
		  labRow=NA,
          main = "Clustering Based Genotype", 
          dendrogram = "col",
          ColSideColors=cc,
)
dev.off()






heatmap.2(mat,col=bluered, na.rm=TRUE, na.color="blue", )
heatmap.2(as.matrix(con),col=cm.colors(255),scale="column")
heatmap.2(as.matrix(con),col=bluered)


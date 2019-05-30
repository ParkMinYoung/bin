
#setwd("/home/adminrig/workspace.min/MethylSeq/EWhaUnivHost.Ovarian.Summary")

df<-read.table("Methylation.txt.TargetCpG.Summary.percent", header=T, sep="\t")
summary(df)

library(gplots)



con<-df[,-1]
rownames(con)<-df[,1]
#mat<-head(as.matrix(con), 500)
mat<-as.matrix(con)
#heatmap.2(mat)



png("heatmap.png", width=1200, height=900)
#heatmap.2(mat, dendrogram=c("column"), srtCol=90, cexCol=0.9,  main = "Methylation Percent", col=redgreen, offsetRow=-1, offsetCol=-1)
heatmap.2(mat, dendrogram=c("column"), srtCol=90, cexCol=0.9,  main = "Methylation Percent", col=redgreen, offsetRow=0, offsetCol=-1, lmat=rbind( c(0, 3, 4), c(2,1,0 ) ), lwid=c(1.5, 4, 2 ) )
#example(heatmap.2)

#grid.newpage()
dev.off()

pdf("heatmap.pdf")
heatmap.2(mat, dendrogram=c("column"), srtCol=90, cexCol=0.9,  main = "Methylation Percent", col=redgreen, offsetRow=0, offsetCol=-1, lmat=rbind( c(0, 3, 4), c(2,1,0 ) ), lwid=c(1.5, 4, 2 ), trace=("none") )
dev.off()

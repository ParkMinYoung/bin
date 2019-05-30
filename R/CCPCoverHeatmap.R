# R CMD BATCH --no-save --no-restore CCPCoverHeatmap.R 

library(gplots)
df<-read.table("CCP.depthcov", header=T,stringsAsFactors = F)

con<-df[,-1]
rownames(con)<-df[,1]
#mat<-head(as.matrix(con), 500)
mat<-as.matrix(con)
#heatmap.2(mat)


mat[mat>2000]=2000
#heatmap.2(mat, dendrogram=c("column"),srtRow=45, adjRow=c(0, 1),col=cm.colors(255), cexCol=0.5 )
#heatmap.2(mat, dendrogram=c("column"), cexCol=0.9, main = "CCP Cover")
#heatmap.2(mat, col=bluered, dendrogram=c("column"), cexCol=0.9,  main = "CCP Cover")


png("CCPCoverHeatmap.Zscore.png", width=1200, height=1200)
#heatmap.2(mat, dendrogram=c("column"), cexCol=0.9, labRow=NA, main = "CCP Strand Cover")
heatmap.2(mat, dendrogram=c("column"), srtCol=45, cexCol=0.9, labRow=NA, main = "Comprehensive Cancer Panel\nDepth of Covarge", scale="column",col=redgreen)
dev.off()

png("CCPCoverHeatmap.png", width=1200, height=1200)
#heatmap.2(mat, dendrogram=c("column"), cexCol=0.9, labRow=NA, main = "CCP Strand Cover")
heatmap.2(mat, dendrogram=c("column"), srtCol=45, cexCol=0.9, labRow=NA, main = "Comprehensive Cancer Panel\nDepth of Covarge",col=redgreen)
dev.off()


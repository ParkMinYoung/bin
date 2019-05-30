# R CMD BATCH --no-save --no-restore CCPStrandCoverHeatmap.R 

library(gplots)
df<-read.table("AmpliconStrandCover.txt.DiffRegion", header=T,stringsAsFactors = F)

con<-df[,-1]
rownames(con)<-df[,1]
#mat<-head(as.matrix(con), 500)
mat<-as.matrix(con)
#heatmap.2(mat)


#mat[mat>2000]=2000
heatmap.2(mat, dendrogram=c("column"),srtRow=45, adjRow=c(0, 1),col=cm.colors(255), cexCol=0.5 )
heatmap.2(mat, dendrogram=c("column"), cexCol=0.9, main = "CCP Strand Cover")
heatmap.2(mat, col=bluered, dendrogram=c("column"), cexCol=0.9,  main = "CCP Strand Cover")


png("CCPStrandCoverHeatmap.png")
#heatmap.2(mat, dendrogram=c("column"), cexCol=0.9, labRow=NA, main = "CCP Strand Cover")
heatmap.2(mat, dendrogram=c("column"), cexCol=0.9,  main = "CCP Strand Cover")
dev.off()



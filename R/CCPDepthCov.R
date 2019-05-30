# R CMD BATCH --no-save --no-restore CCPDepthCov.R



library(gplots)
df<-read.table("pool1.depthcov.txt", header=T,stringsAsFactors = F)

con<-df[,-1]
rownames(con)<-df[,1]
#mat<-head(as.matrix(con), 500)
mat<-as.matrix(con)
#heatmap.2(mat)


mat[mat>2000]=2000
heatmap.2(mat, dendrogram=c("column"),srtRow=45, adjRow=c(0, 1),col=cm.colors(255), cexCol=0.5, labRow=NA )
heatmap.2(mat, dendrogram=c("column"), cexCol=0.9, labRow=NA, main = "CCP Pool1")
heatmap.2(mat, col=bluered, dendrogram=c("column"), cexCol=0.9, labRow=NA, main = "CCP Pool1")


png("CCP-pool1.png", height=1000, width=800)
heatmap.2(mat, dendrogram=c("column"), cexCol=0.9, labRow=NA, main = "CCP Pool1")
dev.off()



df<-read.table("pool2.depthcov.txt", header=T,stringsAsFactors = F)

con<-df[,-1]
rownames(con)<-df[,1]
#mat<-head(as.matrix(con), 500)
mat<-as.matrix(con)
#heatmap.2(mat)


mat[mat>2000]=2000
#heatmap.2(mat, dendrogram=c("column"),srtRow=45, adjRow=c(0, 1),col=cm.colors(255), cexCol=0.5, labRow=NA )
#heatmap.2(mat, dendrogram=c("column"), cexCol=0.9, labRow=NA, main = "CCP Pool1")
#heatmap.2(mat, col=bluered, dendrogram=c("column"), cexCol=0.9, labRow=NA, main = "CCP Pool1")

png("CCP-pool2.png", height=1000, width=800)
heatmap.2(mat, dendrogram=c("column"), cexCol=0.9, labRow=NA, main = "CCP Pool2")
dev.off()

df<-read.table("pool3.depthcov.txt", header=T,stringsAsFactors = F)

con<-df[,-1]
rownames(con)<-df[,1]
#mat<-head(as.matrix(con), 500)
mat<-as.matrix(con)
#heatmap.2(mat)


mat[mat>2000]=2000
#heatmap.2(mat, dendrogram=c("column"),srtRow=45, adjRow=c(0, 1),col=cm.colors(255), cexCol=0.5, labRow=NA )
#heatmap.2(mat, dendrogram=c("column"), cexCol=0.9, labRow=NA, main = "CCP Pool1")
#heatmap.2(mat, col=bluered, dendrogram=c("column"), cexCol=0.9, labRow=NA, main = "CCP Pool1")

png("CCP-pool3.png", height=1000, width=800)
heatmap.2(mat, dendrogram=c("column"), cexCol=0.9, labRow=NA, main = "CCP Pool3")
dev.off()

df<-read.table("pool4.depthcov.txt", header=T,stringsAsFactors = F)

con<-df[,-1]
rownames(con)<-df[,1]
#mat<-head(as.matrix(con), 500)
mat<-as.matrix(con)
#heatmap.2(mat)


mat[mat>2000]=2000
#heatmap.2(mat, dendrogram=c("column"),srtRow=45, adjRow=c(0, 1),col=cm.colors(255), cexCol=0.5, labRow=NA )
#heatmap.2(mat, dendrogram=c("column"), cexCol=0.9, labRow=NA, main = "CCP Pool1")
#heatmap.2(mat, col=bluered, dendrogram=c("column"), cexCol=0.9, labRow=NA, main = "CCP Pool1")

png("CCP-pool4.png", height=1000, width=800)
heatmap.2(mat, dendrogram=c("column"), cexCol=0.9, labRow=NA, main = "CCP Pool4")
dev.off()



library(cummeRbund)

cuff<-readCufflinks()

#annot<-read.table("gene_annotation.tab",sep="\t",header=T,na.string="-")
#addFeatures(cuff,annot,level="genes")

disp<-dispersionPlot(genes(cuff))
png("../DispersionPlot.png")
disp
dev.off()

#genes.scv<-fpkmSCVPlot(genes(cuff))
#png("gene.SCVPlot.png")
#genes.scv
#dev.off()

#isoforms.scv<-fpkmSCVPlot(isoforms(cuff))#sthash.AUH7kCyM.dpuf
#png("isoforms.SCVPlot.png")
#isoforms.scv
#dev.off()

dens<-csDensity(genes(cuff))
png("../DensityPlot.png")
dens
dev.off()

densRep<-csDensity(genes(cuff),replicates=T)
png("../DensityPlot.replicate.png")
densRep
dev.off()

b<-csBoxplot(genes(cuff))
png("../BoxPlot.png")
b
dev.off()

brep<-csBoxplot(genes(cuff),replicates=T)
png("../BoxPlot.replicate.png")
brep
dev.off()

s<-csScatterMatrix(genes(cuff))
png("../ScatterMatrix.png")
s
dev.off()

#s<-csScatter(genes(cuff),"hESC","Fibroblasts",smooth=T)

#dend<-csDendro(genes(cuff))
#dend.rep<-csDendro(genes(cuff),replicates=T)#sthash.AUH7kCyM.dpuf

#m<-MAplot(genes(cuff),"hESC","Fibroblasts")

#mCount<-MAplot(genes(cuff),"hESC","Fibroblasts",useCount=T)

v<-csVolcanoMatrix(genes(cuff))
png("../VolcanoMatrix.png")
v
dev.off()

#v<-csVolcano(genes(cuff),"hESC","Fibroblasts")

#h<-csHeatmap(myGenes,cluster='both')

#h.rep<-csHeatmap(myGenes,cluster='both',replicates=T)

#b<-expressionBarplot(myGenes)

#s<-csScatter(myGenes,"Fibroblasts","hESC",smooth=T)

#v<-csVolcano(myGenes,"Fibroblasts","hESC")

#ih<-csHeatmap(isoforms(myGenes),cluster='both',labRow=F)

#th<-csHeatmap(TSS(myGenes),cluster='both',labRow=F)

#den<-csDendro(myGenes)

#gl<-expressionPlot(myGene)

#gl.rep<-expressionPlot(myGene,replicates=TRUE)

#v<-csVolcano(myGenes,"Fibroblasts","hESC")

#ih<-csHeatmap(isoforms(myGenes),cluster='both',labRow=F)

#th<-csHeatmap(TSS(myGenes),cluster='both',labRow=F)

#den<-csDendro(myGenes)

#gl<-expressionPlot(myGene)

#gl.rep<-expressionPlot(myGene,replicates=TRUE)

#so.rep<-expressionPlot(isoforms(myGene),replicates=T)

#gl.cds.rep<-expressionPlot(CDS(myGene),replicates=T)

#gb<-expressionBarplot(myGene)

#gb.rep<-expressionBarplot(myGene,replicates=T)

#igb<-expressionBarplot(isoforms(myGene),replicates=T)

#myDistHeat<-csDistHeat(genes(cuff))

#myRepDistHeat<-csDistHeat(genes(cuff),replicates=T)

#genes.PCA<-PCAplot(genes(cuff),"PC1","PC2")

#genes.MDS<-MDSplot(genes(cuff))
#png("MDSPlot.png")
#genes.MDS
#dev.off()

#genes.PCA.rep<-PCAplot(genes(cuff),"PC1","PC2",replicates=T)

genes.MDS.rep<-MDSplot(genes(cuff),replicates=T)
png("../MDSPlot.replicate.png")
genes.MDS.rep
dev.off()


# http://www.sthda.com/english/wiki/gviz-visualize-genomic-data

source("http://bioconductor.org/biocLite.R")
biocLite("Gviz")
biocLite("Homo.sapiens")

library(Homo.sapiens)
library(Gviz)

data(cpgIslands)
atrack <- AnnotationTrack(cpgIslands, name = "CpG")
gen<-genome(cpgIslands)
gtrack<-GenomeAxisTrack()
itrack<- IdeogramTrack( genome= gen, chromosome = chr)

#plotTracks(list(itrack, grtrack, gtrack, atrack), from=26700000, to=26750000)
#plotTracks(list(itrack, grtrack, gtrack, atrack), extend.left=0.5, extend.right=1000000)

txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene

setwd("/home/adminrig/workspace.min/IonTorrent/IonProton/bin/Ion.Input/Auto_user_DL1-56-20150130-Amp.Customized.69genes.550k.set25_117_169/Analysis/BAM")
bamN<-AlignmentsTrack("snuh0315_N.bam.AddRG.bam", isPaired = F, name="snuh0315_N")
bamT<-AlignmentsTrack("snuh0315_T.bam.AddRG.bam", isPaired = F, name="snuh0315_T")

grtrack <- GeneRegionTrack(txdb, genome = gen, name = "UCSC known genes",chromosome = "chr3", transcriptAnnotation = "symbol", background.panel = "#FFFEDB", background.title = "darkblue")
bmt<-BiomartGeneRegionTrack(genome=gen, chromosome = "chr3", start=178952064, end=178952104, filter=list(with_ox_refseq_mrna = TRUE), stacking="dense", name="BioMart")
ht<-HighlightTrack(trackList = list(bmt, bamT, grtrack, bamN, sTrack), start =178952085, width = 0, chromosome = "chr3") 
  

# plotTracks(list(itrack, gtrack, bmt, bamT, grtrack, bamN, sTrack), from=178952064, to=178952104, extend.right = 20, extend.left = 20, chromosome = "chr3" )
plotTracks(list(itrack, gtrack, ht), from=178952064, to=178952104, extend.right = 20, extend.left = 20, chromosome = "chr3" )

# plotTracks(list(itrack, gtrack, grtrack), from=178952064, to=178952104, extend.right = 1000000, extend.left = 1000000, chromosome = "chr3" )

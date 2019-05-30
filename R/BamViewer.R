# http://www.sthda.com/english/wiki/gviz-visualize-genomic-data

args <- commandArgs(TRUE)


if( length(args) == 7 ){

str(args)

library(Gviz)
library(Homo.sapiens)
library(BSgenome.Hsapiens.UCSC.hg19)

gen<-"hg19"

#Normal<-"snuh9998_N.bam.AddRG.bam"
#Cancer<-"snuh9998_T.bam.AddRG.bam"

Normal<-args[4]
Cancer<-args[5]

#N_name<-"snuh0315_N"
#T_name<-"snuh0315_T"

N_name<-args[6]
T_name<-args[7]

#chr<-"chr1"
#start_pos<-43812410+1
#end_pos<-43812411
chr<-args[1]
start_pos<-as.numeric(args[2])+1
end_pos<-as.numeric(args[3])

bp_width<-end_pos - start_pos

txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene

gtrack<-GenomeAxisTrack()
itrack<- IdeogramTrack( genome= gen, chromosome = chr)

#plotTracks(list(itrack, grtrack, gtrack, atrack), from=26700000, to=26750000)
#plotTracks(list(itrack, grtrack, gtrack, atrack), extend.left=0.5, extend.right=1000000)


position=paste(chr,start_pos,end_pos, sep=":")
title<-paste(position,"SNP View between", N_name, "and", T_name, sep=" ")
bamN<-AlignmentsTrack(Normal, isPaired = F, name=N_name)
bamT<-AlignmentsTrack(Cancer, isPaired = F, name=T_name)

grtrack <- GeneRegionTrack(txdb, genome = gen, name = "UCSC",chromosome = chr, transcriptAnnotation = "symbol", background.panel = "#FFFEDB", background.title = "darkblue")
bmt<-BiomartGeneRegionTrack(genome=gen, chromosome = chr, start=start_pos-1000, end=end_pos+1000, filter=list(with_ox_refseq_mrna = TRUE), stacking="dense", name="BioMart")
sTrack<-SequenceTrack(Hsapiens)
ht<-HighlightTrack(trackList = list(bmt, bamN, grtrack, bamT, sTrack), start =start_pos, width =bp_width , chromosome = chr) 

filename<-paste(chr,start_pos, end_pos,"png", sep=".")
png(filename, width=1200, height=900)
# plotTracks(list(itrack, gtrack, bmt, bamT, grtrack, bamN, sTrack), from=178952064, to=178952104, extend.right = 20, extend.left = 20, chromosome = "chr3" )
plotTracks(list(itrack, gtrack, ht), from=start_pos-1, to=end_pos, extend.right = 40, extend.left = 40, chromosome = chr, main=title, cex.main=2, title.width=4)

dev.off()
# plotTracks(list(itrack, gtrack, grtrack), from=178952064, to=178952104, extend.right = 1000000, extend.left = 1000000, chromosome = "chr3" )

}

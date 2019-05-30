#!/bin/sh 

source ~/.bash_function

PDF=$1    # VennDiagram.pdf
INPUT=$2  # merge-vcf.output.vcf.VennInput
TITLE=$3  # NCC - 1 sample 4 stage

if [ $# -eq 3 ] && [ -f "$2" ];then

R --slave <<RSCRIPT
  
pdf("$PDF")
source("http://faculty.ucr.edu/~tgirke/Documents/R_BioCond/My_R_Scripts/overLapper.R")
set<-read.delim("$INPUT")

len<-length(set)
max<-ifelse(len>6,5,len)

setlist4 <- set[1:max]
OLlist4 <- overLapper(setlist=setlist4, sep="_", type="vennsets"); 
counts <- list(sapply(OLlist4\$Venn_List, length));

len1<-length(counts[[1]])
#counts[[1]][len1][[1]]<-counts[[1]][len1][[1]]
counts[[1]][len1][[1]]<-counts[[1]][len1][[1]]-1
vennPlot(counts=counts, mymain="$TITLE", yoffset=c(0, -0.2),  mylwd=5, diacol=, type="circle", ccex=0.6, lcex=1.0)
#vennPlot(counts=counts, mymain="$TITLE", yoffset=c(0, -0.2),  mylwd=5, diacol=, type="ellipse", ccex=0.6, lcex=1.0)
#vennPlot(counts=counts, mymain="$TITLE", yoffset=c(0, -0.2),  mylwd=5, diacol=, type="ellipse", ccex=1, lcex=1.0)


dev.off() 
## mylwd : circle line thick
## lcex : sample title 2-3
## ccex : count number 1

RSCRIPT


else
	usage "output.pdf VennInput \"venn title\" " 
fi
 
# S1      S2      S3      S4
# G26:1/1:1/1     G26:1/1:1/1     G26:1/1:1/1     G26:1/1:1/1
# G48:0/0:0/0     G48:0/0:0/0     G48:0/0:0/0     G48:1/1:1/1
# G248:1/1:1/1    G248:1/1:1/1    G248:1/1:1/1    G248:1/1:1/1
# G253:0/1:0/1    G253:0/1:0/1    G253:0/1:0/1    G253:0/1:0/1
# G259:1/1:1/1    G259:1/1:1/1    G259:1/1:1/1    G259:1/1:1/1
# G260:1/1:1/1    G260:1/1:1/1    G260:1/1:1/1    G260:1/1:1/1
# G262:1/1:1/1    G262:1/1:1/1    G262:1/1:1/1    G262:1/1:1/1
# G263:1/1:1/1    G263:1/1:1/1    G263:1/1:1/1    G263:1/1:1/1
# G276:1/1:1/1    G276:1/1:1/1    G276:1/1:1/1    G276:1/1:1/1
# G280:0/0:0/0    G280:0/0:0/0    G280:0/0:0/0    G280:0/1:0/1
# G294:1/1:1/1    G294:1/1:1/1    G294:1/1:1/1    G294:0/1:0/1
# G295:0/1:0/1    G295:0/0:0/0    G295:0/0:0/0    G295:0/0:0/0
# G296:1/1:1/1    G296:1/1:1/1    G296:1/1:1/1    G296:1/1:1/1
# G299:1/1:1/1    G299:1/1:1/1    G299:1/1:1/1    G299:1/1:1/1
# G318:1/1:1/1    G318:1/1:1/1    G318:1/1:1/1    G318:1/1:1/1
# G321:1/1:1/1    G321:1/1:1/1    G321:1/1:1/1    G321:1/1:1/1
# G323:1/1:1/1    G323:1/1:1/1    G323:1/1:1/1    G323:1/1:1/1
# G326:0/1:0/1    G326:0/0:0/0    G326:0/0:0/0    G326:0/0:0/0


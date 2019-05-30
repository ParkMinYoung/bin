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
#counts[[1]][15][[1]]<-counts[[1]][15][[1]]-1
vennPlot(counts=counts, mymain="$TITLE", yoffset=c(0, -0.2),  mylwd=5, diacol=1, type="ellipse", ccex=1.0, lcex=1.0)


dev.off() 
## lcex : sample title 2-3
## ccex : count number 1

RSCRIPT


else
	usage "output.pdf VennInput \"venn title\" " 
fi





# excute time : 2016-09-09 22:01:04 : make Overlap v2
#perl -F'\t' -MMin -ane'chomp@F; $k=join ":", @F[0,2,3]; $h{$k}{$ARGV}= "$F[0]:$F[2]:$F[3]"; }{ mmfss_blank("Overlap", %h)' *bed 



# excute time : 2016-09-09 22:04:05 : make format
#		(head -1 Overlap.txt | sed 's/.csv.tab.bed//g' ; sed -n '2,$p' Overlap.txt) | cut -f2- > Overlap.txt.tab 


# excute time : 2016-09-09 22:06:20 : make venn diagram
#				VennDiagram.sh Bovine.pdf Overlap.txt.tab "Venn Diagram" 



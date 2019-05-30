# Venn
#setwd("/home/adminrig/workspace.jhye/20160516_PDX_ctDNA_prep_1/Somatic/result")

#d1<-read.delim("012_NT_XO.simple.txt.input")
#d2<-read.delim("012_NT_X.simple.txt.input")
#require(gplots) 
#venn(list(A=d1,B=d2))


# R CMD BATCH --no-save --no-restore '--args data1 data2 title' PCA.R
#  R CMD BATCH --no-save --no-restore '--args 012_NT_XO.simple.txt.input 012_NT_X.simple.txt.input 012 PDX ctDNA' VennDiagram.2.R
args <- commandArgs(TRUE)

require(VennDiagram)
#install.packages("VennDiagram")

d1 = scan(args[1], what = "character")
d2 = scan(args[2], what = "character")
title=args[3]


venn.diagram(list(B = d2, A = d1 ),fill = c("red", "green"),
             alpha = c(0.5, 0.5), cex = 2,cat.fontface = 4,lty =2, fontfamily =3, 
             filename = paste0(title, ".tiff"), main=title);



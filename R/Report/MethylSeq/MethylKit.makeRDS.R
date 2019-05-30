
library(methylKit)

files<-as.list( list.files(path = "DMR/BAM", pattern = "sort.bam$", recursive = FALSE, full.names = TRUE) )
samples<-as.list( gsub( ".+\\/(.+)_\\w{6,8}_L.+", "\\1", files ) )

objs<-processBismarkAln(location=files, sample.id=samples, assembly="hg19", save.folder=NULL, save.context=NULL, read.context="CpG", nolap=FALSE, mincov=10, minqual=20, phred64=FALSE, treatment=rep(0, length(samples)))



saveRDS(objs, "methylKit.RDS")
#load("/home/adminrig/workspace.min/MethylSeq/KNIH.IncurableDisease/DMR/BAM/meth.RDS")


#myobj<-objs
#meth=unite(myobj, destrand=FALSE)
#getTreatment(meth) <- 1:length(samples)

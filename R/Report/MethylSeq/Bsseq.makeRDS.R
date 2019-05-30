
library(bsseq)

#analysis_dir<-"/home/adminrig/workspace.min/MethylSeq/20180914_KCDCP_ParkMihyunMethyl_1"
analysis_dir<-getwd()
cov.gz <- list.files(path=analysis_dir, pattern="bismark.cov.gz", recursive = T, full.names = T)
infile <- cov.gz[ grep("submit", cov.gz , invert=TRUE) ]

files<-gsub(paste0(analysis_dir, "/"), "", infile)
ID<-gsub("(.+)(/.+)", "\\1", perl =TRUE, files)




bsseq <- read.bismark(files = infile,
                        colData = DataFrame(row.names = ID),
                        rmZeroCov = FALSE,
                        strandCollapse = FALSE,
                        verbose = TRUE)#,
#nThread=4)

#saveRDS(objs, "bsseq.RDS")
save.image(file = "Bsseq.RData")


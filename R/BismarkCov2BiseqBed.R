#!/usr/bin/env Rscript
##
## DESCRIPTION:   Run BiSeq tools for bismark CpG bedgraph coverage count files, for small sample set
## AUTHOR:        Jin Kim jjinking(at)gmail(dot)com
## CREATED:       2014.02.10
## LAST MODIFIED: 
## MODIFIED BY:   
## 
## USAGE:         modules/methyl/biseq.bismark.bedgraph.cov.small.R
##                                                            outprefix            # Prefix to be used for all output files
##                                                            samples_group        # Tab-delimited file containing 3 columns: (sample, CPG.bedgraph.bismark.cov, 0/1(case:1 vs control:0))
##                                                            cluster.min.sites    # Minimum number of methylated sites per cluster
##                                                            cluster.max.dist     # Maximum distance between DMRs in same cluster
##                                                            theads               # Max number of threads
## 
## OUTPUT:        
##

## 211.174.205.72 server setting
## openstack name

args <- commandArgs(TRUE)

args[1]

cmd.help <- function(){
cat("prefix_file_name group_file\n")
cat("prefix_file_name : Analysis2.biseq\n")
cat("group file : 2.early.vs.HM.HS.HR.US.cov\n")
cat("early   /isilon_home/adminrig/workspace.jin/KNIH.Methylation.12Samples/run3/Sample_CHA_hES15_early_p27/CHA_hES15_early_p27_GATCAG_L002_R1_001.fastq.gz.bedgraph.bismark.cov     0\n")
cat("early1  /isilon_home/adminrig/workspace.jin/KNIH.Methylation.12Samples/run3/Sample_CHA_hES15_early_p27/CHA_hES15_early_p27_GATCAG_L002_R1_001.fastq.gz.bedgraph.bismark.cov     0\n")
cat("HM4     /isilon_home/adminrig/workspace.jin/KNIH.Methylation.12Samples/Sample_Hm4/Hm4_ACTTGA_L005_R1_001.fastq.gz.bedgraph.bismark.cov  1\n")
cat("HM5     /isilon_home/adminrig/workspace.jin/KNIH.Methylation.12Samples/Sample_Hm5/Hm5_GATCAG_L005_R1_001.fastq.gz.bedgraph.bismark.cov  1\n")
cat("HR3     /isilon_home/adminrig/workspace.jin/KNIH.Methylation.12Samples/run2/bismark/Sample_HR3/HR3_CGATGT_L001_R1_010.fastq.gz.bedgraph.bismark.cov     1\n")
cat("HR4     /isilon_home/adminrig/workspace.jin/KNIH.Methylation.12Samples/Sample_HR4/HR4_AAAGCA_L005_R1_001.fastq.gz.bedgraph.bismark.cov  1\n")
cat("HS3   /isilon_home/adminrig/workspace.jin/KNIH.Methylation.12Samples/Sample_HS3/HS3_GCCAAT_L006_R1_001.fastq.gz.bedgraph.bismark.cov  1\n")
cat("HS5   /isilon_home/adminrig/workspace.jin/KNIH.Methylation.12Samples/Sample_HS5/HS5_CTTGTA_L006_R1_001.fastq.gz.bedgraph.bismark.cov  1\n")
cat("US3   /isilon_home/adminrig/workspace.jin/KNIH.Methylation.12Samples/Sample_US3/US3_ATCACG_L005_R1_001.fastq.gz.bedgraph.bismark.cov  1\n")
cat("US4   /isilon_home/adminrig/workspace.jin/KNIH.Methylation.12Samples/Sample_US4/US4_TTAGGC_L005_R1_001.fastq.gz.bedgraph.bismark.cov  1\n")
cat("R CMD BATCH --no-save --no-restore '--args Analysis2.biseq 2.early.vs.HM.HS.HR.US.cov' BiseqAnalysis.R\n")
}

if( !  length(args) == 2 ){ 
    cmd.help()
    stop('Error in args in commandline arguments. Stop.\n') 
}

library(BiSeq)

# Process command line arguments
#outpre <- "Analysis3.biseq"
#samples.grouping <- "30C.vs.42C.cov"

outpre <- args[1]
samples.grouping <- args[2]


cluster.min.sites <- 10
cluster.max.dist <- 200
threads <- 10

# Set up parameters
batch_args <- read.table(samples.grouping, sep="\t")
sn.list = as.character(batch_args[,1])
file.list = as.character(batch_args[,2])
grouping.list = as.character(batch_args[,3])

# Read in raw data containing raw read counts and raw methylated counts
print("Reading in bismark output files")
coldata <- DataFrame(group=grouping.list, row.names=sn.list)
bsdata <- readBismark(file.list, colData=coldata)

# Convert to BSrel object containing relative methylation levels between 0 and 1
print("Generating relative methylation levels between 0 and 1")
bsdata.rel <- rawToRel(bsdata)


# Create bed files for viewing in IGV
print("Creating bed files for viewing in IGV")
track.names <- paste('g', colData(bsdata)$group, "_", colnames(bsdata), sep="")
writeBED(object = bsdata, name = track.names, file = paste(colnames(bsdata), "raw", "bed", sep="."))
#writeBED(object = bsdata.rel, name = track.names, file = paste(outpre, colnames(bsdata.rel), "rel", "bed", sep="."))





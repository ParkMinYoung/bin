#################################################
## Run seeFastq/seeFastqPlot from Command-Line ##
#################################################
## Author: Thomas Girke
## Last update: 29-Jun-12
## Utility:
##      Plots quality report for set of FASTQ files from command-line
##      For details see: http://manuals.bioinformatics.ucr.edu/home/ht-seq#TOC-Quality-Reports-of-FASTQ-Files-
## Usage:
## Rscript seeFastq.R -i fastqFiles.txt -o fastqReport.pdf -a all -c all -s 100000 -k 8
##    -i: file listing fastq files as here: http://faculty.ucr.edu/~tgirke/Documents/R_BioCond/Samples/fastqQualityFiles
##    -o: name of graphics output, also defines base name of summary stats file *.list
##    -c: samples/columns to include in plot, e.g.: -c 1_2_3_4
##    -a: rows/stats type to include in plot, e.g. -a 1_2_3_4_5_8_6_7
##    -s: number of reads to random sample from each fastq file
##    -k: k-mer length

## Process arguments
myarg <- commandArgs(TRUE)
if(length(myarg)==0) stop("Run script like this: \n\t Rscript seeFastq.R -i fastqFiles.txt -o fastqReport.pdf -a all -c all -s 100000 -k 8") 
myarg <- unlist(strsplit(myarg, " {1,}"))
myargv <- myarg[seq(2, length(myarg), by=2)]; names(myargv) <- gsub("-", "", myarg[seq(1, length(myarg), by=2)])
if(any(names(myargv) %in% "i") & any(names(myargv) %in% "l")) stop("Arguments -i and -l cannot be used together.")
if(!any(names(myargv) %in% "a")) myargv <- c(myargv, a="all") # Sets default rows/stats number in plot to all 
if(!any(names(myargv) %in% "c")) myargv <- c(myargv, c="all") # Sets default column number in plot to all 
if(!any(names(myargv) %in% "s")) myargv <- c(myargv, s=100000) # Sets default for random sample size to 100,000 
if(!any(names(myargv) %in% "k")) myargv <- c(myargv, k=8) # Sets default for k-mer size to 8

## Import seeFastq/seeFastqPlot functions
#source("http://faculty.ucr.edu/~tgirke/Documents/R_BioCond/My_R_Scripts/fastqQuality.R")
source("/home/adminrig/src/short_read_assembly/bin/R/fastqQuality.R")

## If '-i' is provided, run analysis starting from fastq files
if(any(names(myargv) %in% "i")) {
	## Import paths and names of fastq samples
	fastqDF <- read.delim(myargv[["i"]])
	fastq <- as.character(fastqDF$Files); names(fastq) <- fastqDF$Samples

	## Generate fastq statistics and store results in list
	fqlist <- seeFastq(fastq=fastq, batchsize=as.numeric(myargv[["s"]]), klength=as.numeric(myargv[["k"]]))
	save(fqlist, file=paste(myargv[["o"]], ".list", sep=""))
}

## If '-l' is provided, import precomputed list object and generate plot in next step
if(any(names(myargv) %in% "l")) {
	## Import paths and names of fastq samples
	load(file=myargv[["l"]])
}

## Generate plots and output graphics to file
if(myargv[["a"]] == "all") { # Specify row arrangement in plot
	myrow <- c(1, 2, 3, 4, 5, 8, 6, 7)
} else {
	myrow <- as.numeric(unlist(strsplit(myargv[["a"]], "_")))	
}
if(myargv[["c"]] == "all") { # Specify column arrangement in plot
	mycol <- seq(along=fqlist)
} else {
	mycol <- as.numeric(unlist(strsplit(myargv[["c"]], "_")))	
}
pdf(myargv[["o"]], height=18, width=4*length(fqlist))  
seeFastqPlot(fqlist[mycol], arrange=myrow)
dev.off()




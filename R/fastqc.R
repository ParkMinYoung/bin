library(ShortRead); library(ggplot2)
source("~/src/short_read_assembly/bin/R/fastqQuality.R")
fastq <- list.files("data", "*.fastq$");
fastq_name<-sub("_[0-9][0-9][0-9].fastq.gz(.N.fastq(.gz)?)?", "", fastq)
fastq <- paste("data/", fastq, sep="")
names(fastq)<-fastq_name

#names(fastq) <- paste("flowcell6_lane", 1:length(fastq), sep="_") # Values in
## Compute quality stats
fqlist <- seeFastq(fastq=fastq, batchsize=1000000, klength=8) # Returns summary stats in a relatively small list object that can be saved to disk with 'save()' and reloaded with 'load()' for later plotting. The argument 'klength' specifies the k-mer length and 'batchsize' the number of reads to random sample from each fastq file.  
## Plot quality stats 
seeFastqPlot(fqlist)
#seeFastqPlot(fqlist[16:1], arrange=c(1,2,3,4,5,6,7,8)) # Example for plotting specific rows and columns.
## Output plot to PDF
dtag<-format(Sys.time(), "%Y%b%d")
pdf_name<-paste("fastqReport", dtag, "pdf", sep=".") 
pdf(pdf_name, height=24, width=4*length(fastq))
seeFastqPlot(fqlist)
dev.off()



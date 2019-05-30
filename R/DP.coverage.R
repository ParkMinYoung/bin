
library("Rsamtools")
library("GenomicRanges")
library("ggbio")


bf1 <- c("rawlib.bam.AddRG.bam.Dedupping.bam")
bf2 <- c("rawlib.bam.AddRG.bam.Dedupping.Mark.bam.dup.bam")
bf3 <- c("rawlib.bam.AddRG.bam.Dedupping.Mark.bam")

bf1<-BamFile(bf1)
bf2<-BamFile(bf2)
bf3<-BamFile(bf3)


chr<-paste("chr", c(1:22,"X","Y"), sep="")




# for i in {1..24};do perl -sple's/chr1/chr$n/g;' -- -n=$i r.temp  ;done > r.temp.out

pdf("coverage.pdf", width=6, height=6)


p1<-ggplot(bf1) + stat_coverage(geom="line", which=c("chr1"), ylab="coverage", maxBinSize=2^14, col="blue")
p2<-ggplot(bf2) + stat_coverage(geom="line", which=c("chr1"), ylab="coverage", maxBinSize=2^14, col="red")
p3<-ggplot(bf3) + stat_coverage(geom="line", which=c("chr1"), ylab="coverage", maxBinSize=2^14, col="green")

tracks(raw=p3, duplicates=p2, cleanup=p1, xlab = "base pair", title = "chr1")  + ylim(0, 20000000) 

p1<-ggplot(bf1) + stat_coverage(geom="line", which=c("chr2"), ylab="coverage", maxBinSize=2^14, col="blue")
p2<-ggplot(bf2) + stat_coverage(geom="line", which=c("chr2"), ylab="coverage", maxBinSize=2^14, col="red")
p3<-ggplot(bf3) + stat_coverage(geom="line", which=c("chr2"), ylab="coverage", maxBinSize=2^14, col="green")

tracks(raw=p3, duplicates=p2, cleanup=p1, xlab = "base pair", title = "chr2")  + ylim(0, 20000000) 

p1<-ggplot(bf1) + stat_coverage(geom="line", which=c("chr3"), ylab="coverage", maxBinSize=2^14, col="blue")
p2<-ggplot(bf2) + stat_coverage(geom="line", which=c("chr3"), ylab="coverage", maxBinSize=2^14, col="red")
p3<-ggplot(bf3) + stat_coverage(geom="line", which=c("chr3"), ylab="coverage", maxBinSize=2^14, col="green")

tracks(raw=p3, duplicates=p2, cleanup=p1, xlab = "base pair", title = "chr3")  + ylim(0, 20000000) 

p1<-ggplot(bf1) + stat_coverage(geom="line", which=c("chr4"), ylab="coverage", maxBinSize=2^14, col="blue")
p2<-ggplot(bf2) + stat_coverage(geom="line", which=c("chr4"), ylab="coverage", maxBinSize=2^14, col="red")
p3<-ggplot(bf3) + stat_coverage(geom="line", which=c("chr4"), ylab="coverage", maxBinSize=2^14, col="green")

tracks(raw=p3, duplicates=p2, cleanup=p1, xlab = "base pair", title = "chr4")  + ylim(0, 20000000) 

p1<-ggplot(bf1) + stat_coverage(geom="line", which=c("chr5"), ylab="coverage", maxBinSize=2^14, col="blue")
p2<-ggplot(bf2) + stat_coverage(geom="line", which=c("chr5"), ylab="coverage", maxBinSize=2^14, col="red")
p3<-ggplot(bf3) + stat_coverage(geom="line", which=c("chr5"), ylab="coverage", maxBinSize=2^14, col="green")

tracks(raw=p3, duplicates=p2, cleanup=p1, xlab = "base pair", title = "chr5")  + ylim(0, 20000000) 

p1<-ggplot(bf1) + stat_coverage(geom="line", which=c("chr6"), ylab="coverage", maxBinSize=2^14, col="blue")
p2<-ggplot(bf2) + stat_coverage(geom="line", which=c("chr6"), ylab="coverage", maxBinSize=2^14, col="red")
p3<-ggplot(bf3) + stat_coverage(geom="line", which=c("chr6"), ylab="coverage", maxBinSize=2^14, col="green")

tracks(raw=p3, duplicates=p2, cleanup=p1, xlab = "base pair", title = "chr6")  + ylim(0, 20000000) 

p1<-ggplot(bf1) + stat_coverage(geom="line", which=c("chr7"), ylab="coverage", maxBinSize=2^14, col="blue")
p2<-ggplot(bf2) + stat_coverage(geom="line", which=c("chr7"), ylab="coverage", maxBinSize=2^14, col="red")
p3<-ggplot(bf3) + stat_coverage(geom="line", which=c("chr7"), ylab="coverage", maxBinSize=2^14, col="green")

tracks(raw=p3, duplicates=p2, cleanup=p1, xlab = "base pair", title = "chr7")  + ylim(0, 20000000) 

p1<-ggplot(bf1) + stat_coverage(geom="line", which=c("chr8"), ylab="coverage", maxBinSize=2^14, col="blue")
p2<-ggplot(bf2) + stat_coverage(geom="line", which=c("chr8"), ylab="coverage", maxBinSize=2^14, col="red")
p3<-ggplot(bf3) + stat_coverage(geom="line", which=c("chr8"), ylab="coverage", maxBinSize=2^14, col="green")

tracks(raw=p3, duplicates=p2, cleanup=p1, xlab = "base pair", title = "chr8")  + ylim(0, 20000000) 

p1<-ggplot(bf1) + stat_coverage(geom="line", which=c("chr9"), ylab="coverage", maxBinSize=2^14, col="blue")
p2<-ggplot(bf2) + stat_coverage(geom="line", which=c("chr9"), ylab="coverage", maxBinSize=2^14, col="red")
p3<-ggplot(bf3) + stat_coverage(geom="line", which=c("chr9"), ylab="coverage", maxBinSize=2^14, col="green")

tracks(raw=p3, duplicates=p2, cleanup=p1, xlab = "base pair", title = "chr9")  + ylim(0, 20000000) 

p1<-ggplot(bf1) + stat_coverage(geom="line", which=c("chr10"), ylab="coverage", maxBinSize=2^14, col="blue")
p2<-ggplot(bf2) + stat_coverage(geom="line", which=c("chr10"), ylab="coverage", maxBinSize=2^14, col="red")
p3<-ggplot(bf3) + stat_coverage(geom="line", which=c("chr10"), ylab="coverage", maxBinSize=2^14, col="green")

tracks(raw=p3, duplicates=p2, cleanup=p1, xlab = "base pair", title = "chr10")  + ylim(0, 20000000) 

p1<-ggplot(bf1) + stat_coverage(geom="line", which=c("chr11"), ylab="coverage", maxBinSize=2^14, col="blue")
p2<-ggplot(bf2) + stat_coverage(geom="line", which=c("chr11"), ylab="coverage", maxBinSize=2^14, col="red")
p3<-ggplot(bf3) + stat_coverage(geom="line", which=c("chr11"), ylab="coverage", maxBinSize=2^14, col="green")

tracks(raw=p3, duplicates=p2, cleanup=p1, xlab = "base pair", title = "chr11")  + ylim(0, 20000000) 

p1<-ggplot(bf1) + stat_coverage(geom="line", which=c("chr12"), ylab="coverage", maxBinSize=2^14, col="blue")
p2<-ggplot(bf2) + stat_coverage(geom="line", which=c("chr12"), ylab="coverage", maxBinSize=2^14, col="red")
p3<-ggplot(bf3) + stat_coverage(geom="line", which=c("chr12"), ylab="coverage", maxBinSize=2^14, col="green")

tracks(raw=p3, duplicates=p2, cleanup=p1, xlab = "base pair", title = "chr12")  + ylim(0, 20000000) 

p1<-ggplot(bf1) + stat_coverage(geom="line", which=c("chr13"), ylab="coverage", maxBinSize=2^14, col="blue")
p2<-ggplot(bf2) + stat_coverage(geom="line", which=c("chr13"), ylab="coverage", maxBinSize=2^14, col="red")
p3<-ggplot(bf3) + stat_coverage(geom="line", which=c("chr13"), ylab="coverage", maxBinSize=2^14, col="green")

tracks(raw=p3, duplicates=p2, cleanup=p1, xlab = "base pair", title = "chr13")  + ylim(0, 20000000) 

p1<-ggplot(bf1) + stat_coverage(geom="line", which=c("chr14"), ylab="coverage", maxBinSize=2^14, col="blue")
p2<-ggplot(bf2) + stat_coverage(geom="line", which=c("chr14"), ylab="coverage", maxBinSize=2^14, col="red")
p3<-ggplot(bf3) + stat_coverage(geom="line", which=c("chr14"), ylab="coverage", maxBinSize=2^14, col="green")

tracks(raw=p3, duplicates=p2, cleanup=p1, xlab = "base pair", title = "chr14")  + ylim(0, 20000000) 

p1<-ggplot(bf1) + stat_coverage(geom="line", which=c("chr15"), ylab="coverage", maxBinSize=2^14, col="blue")
p2<-ggplot(bf2) + stat_coverage(geom="line", which=c("chr15"), ylab="coverage", maxBinSize=2^14, col="red")
p3<-ggplot(bf3) + stat_coverage(geom="line", which=c("chr15"), ylab="coverage", maxBinSize=2^14, col="green")

tracks(raw=p3, duplicates=p2, cleanup=p1, xlab = "base pair", title = "chr15")  + ylim(0, 20000000) 

p1<-ggplot(bf1) + stat_coverage(geom="line", which=c("chr16"), ylab="coverage", maxBinSize=2^14, col="blue")
p2<-ggplot(bf2) + stat_coverage(geom="line", which=c("chr16"), ylab="coverage", maxBinSize=2^14, col="red")
p3<-ggplot(bf3) + stat_coverage(geom="line", which=c("chr16"), ylab="coverage", maxBinSize=2^14, col="green")

tracks(raw=p3, duplicates=p2, cleanup=p1, xlab = "base pair", title = "chr16")  + ylim(0, 20000000) 

p1<-ggplot(bf1) + stat_coverage(geom="line", which=c("chr17"), ylab="coverage", maxBinSize=2^14, col="blue")
p2<-ggplot(bf2) + stat_coverage(geom="line", which=c("chr17"), ylab="coverage", maxBinSize=2^14, col="red")
p3<-ggplot(bf3) + stat_coverage(geom="line", which=c("chr17"), ylab="coverage", maxBinSize=2^14, col="green")

tracks(raw=p3, duplicates=p2, cleanup=p1, xlab = "base pair", title = "chr17")  + ylim(0, 20000000) 

p1<-ggplot(bf1) + stat_coverage(geom="line", which=c("chr18"), ylab="coverage", maxBinSize=2^14, col="blue")
p2<-ggplot(bf2) + stat_coverage(geom="line", which=c("chr18"), ylab="coverage", maxBinSize=2^14, col="red")
p3<-ggplot(bf3) + stat_coverage(geom="line", which=c("chr18"), ylab="coverage", maxBinSize=2^14, col="green")

tracks(raw=p3, duplicates=p2, cleanup=p1, xlab = "base pair", title = "chr18")  + ylim(0, 20000000) 

p1<-ggplot(bf1) + stat_coverage(geom="line", which=c("chr19"), ylab="coverage", maxBinSize=2^14, col="blue")
p2<-ggplot(bf2) + stat_coverage(geom="line", which=c("chr19"), ylab="coverage", maxBinSize=2^14, col="red")
p3<-ggplot(bf3) + stat_coverage(geom="line", which=c("chr19"), ylab="coverage", maxBinSize=2^14, col="green")

tracks(raw=p3, duplicates=p2, cleanup=p1, xlab = "base pair", title = "chr19")  + ylim(0, 20000000) 

p1<-ggplot(bf1) + stat_coverage(geom="line", which=c("chr20"), ylab="coverage", maxBinSize=2^14, col="blue")
p2<-ggplot(bf2) + stat_coverage(geom="line", which=c("chr20"), ylab="coverage", maxBinSize=2^14, col="red")
p3<-ggplot(bf3) + stat_coverage(geom="line", which=c("chr20"), ylab="coverage", maxBinSize=2^14, col="green")

tracks(raw=p3, duplicates=p2, cleanup=p1, xlab = "base pair", title = "chr20")  + ylim(0, 20000000) 

p1<-ggplot(bf1) + stat_coverage(geom="line", which=c("chr21"), ylab="coverage", maxBinSize=2^14, col="blue")
p2<-ggplot(bf2) + stat_coverage(geom="line", which=c("chr21"), ylab="coverage", maxBinSize=2^14, col="red")
p3<-ggplot(bf3) + stat_coverage(geom="line", which=c("chr21"), ylab="coverage", maxBinSize=2^14, col="green")

tracks(raw=p3, duplicates=p2, cleanup=p1, xlab = "base pair", title = "chr21")  + ylim(0, 20000000) 

p1<-ggplot(bf1) + stat_coverage(geom="line", which=c("chr22"), ylab="coverage", maxBinSize=2^14, col="blue")
p2<-ggplot(bf2) + stat_coverage(geom="line", which=c("chr22"), ylab="coverage", maxBinSize=2^14, col="red")
p3<-ggplot(bf3) + stat_coverage(geom="line", which=c("chr22"), ylab="coverage", maxBinSize=2^14, col="green")

tracks(raw=p3, duplicates=p2, cleanup=p1, xlab = "base pair", title = "chr22")  + ylim(0, 20000000) 

p1<-ggplot(bf1) + stat_coverage(geom="line", which=c("chrX"), ylab="coverage", maxBinSize=2^14, col="blue")
p2<-ggplot(bf2) + stat_coverage(geom="line", which=c("chrX"), ylab="coverage", maxBinSize=2^14, col="red")
p3<-ggplot(bf3) + stat_coverage(geom="line", which=c("chrX"), ylab="coverage", maxBinSize=2^14, col="green")

tracks(raw=p3, duplicates=p2, cleanup=p1, xlab = "base pair", title = "chrX")  + ylim(0, 20000000) 

p1<-ggplot(bf1) + stat_coverage(geom="line", which=c("chrY"), ylab="coverage", maxBinSize=2^14, col="blue")
p2<-ggplot(bf2) + stat_coverage(geom="line", which=c("chrY"), ylab="coverage", maxBinSize=2^14, col="red")
p3<-ggplot(bf3) + stat_coverage(geom="line", which=c("chrY"), ylab="coverage", maxBinSize=2^14, col="green")

tracks(raw=p3, duplicates=p2, cleanup=p1, xlab = "base pair", title = "chrY")  + ylim(0, 20000000) 



dev.off()


pdf("1K_bin.plot.pdf")

T1<-read.delim("27/20130510/Bone1-3-0977.bam.coverage", header=F, col.names=c("chr", "start", "end", "reads", "exp.bp", "target.bp", "coverage") , sep="\t")
T2<-read.delim("28/20130510/Bone1-5-1018.bam.coverage", header=F, col.names=c("chr", "start", "end", "reads", "exp.bp", "target.bp", "coverage") , sep="\t")
T3<-read.delim("29/20130510/Bone1-11-R027.bam.coverage", header=F, col.names=c("chr", "start", "end", "reads", "exp.bp", "target.bp", "coverage") , sep="\t")
T4<-read.delim("32/20130426/Bone.1.bam.coverage", header=F, col.names=c("chr", "start", "end", "reads", "exp.bp", "target.bp", "coverage") , sep="\t")


par(mfrow = c(2, 2))

plot(T1$coverage, T1$reads, xlab="coverage rate of bin 1k", ylab="reads count", col="blue", cex=.5, main="Bone1-3-0977")
plot(T2$coverage, T2$reads, xlab="coverage rate of bin 1k", ylab="reads count", col="blue", cex=.5, main="Bone1-5-1018")
plot(T3$coverage, T3$reads, xlab="coverage rate of bin 1k", ylab="reads count", col="blue", cex=.5, main="Bone1-11-R027")
plot(T4$coverage, T4$reads, xlab="coverage rate of bin 1k", ylab="reads count", col="blue", cex=.5, main="Bone1")


dev.off()
# R CMD BATCH --no-save --no-restore  1k.bin.plot.R

H<-read.delim("KP.summaryReport.txt", header=TRUE, sep="\t")
QC<-H[grep(H$ID, pattern="QC"),]
NO<-H[grep(H$ID, pattern="NO"),]

pdf("QC.pdf", width=16, height=16)
plot(QC, col=1:20, pch=97:117, cex=1.4)
dev.off()

pdf("NO.pdf", width=16, height=16)
plot(NO, col=1:20, pch=97:117, cex=1.4)
dev.off()


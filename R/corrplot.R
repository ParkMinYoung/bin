args <- commandArgs(TRUE)

library("corrplot")
df<-read.delim(args[1], header=TRUE, sep="\t")

M<-cor(na.omit(df))

basic<-paste(args[1], "basic.pdf", sep=".")
hclust<-paste(args[1], "hclust.pdf", sep=".")

basicpng<-paste(args[1], "basic.png", sep=".")
hclustpng<-paste(args[1], "hclust.png", sep=".")

pdf(basic)
corrplot(M)
dev.off()

pdf(hclust)
corrplot.mixed(M, order="hclust")
dev.off()


png(basicpng)
corrplot(M)
dev.off()

png(hclustpng)
corrplot.mixed(M, order="hclust")
dev.off()

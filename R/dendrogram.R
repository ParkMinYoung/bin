args<-commandArgs(TRUE)
df<-read.delim(args[1], header=TRUE, sep="\t")


tr.df<-as.data.frame(t(df))
#plot(hclust(dist(tr.df)))
#ec<-hclust(dist(tr.df))
#rect.hclust(ec, 3)


hc<-hclust(dist(tr.df))
hcd = as.dendrogram(hc)

# vector of colors
labelColors = c("#CDB380", "#036564", "#EB6841", "#EDC951")

# cut dendrogram in 4 clusters
clusMember = cutree(hc, 4)

# function to get color labels
colLab <- function(n) {
  if (is.leaf(n)) {
    a <- attributes(n)
    labCol <- labelColors[clusMember[which(names(clusMember) == a$label)]]
    attr(n, "nodePar") <- c(a$nodePar, lab.col = labCol)
  }
  n
}

# using dendrapply
clusDendro = dendrapply(hcd, colLab)



#out<-paste(args[1], "dendrogram.png", sep=".")
out<-paste(args[1], "dendrogram.pdf", sep=".")
pdf(out)

# make plot
plot(clusDendro, main = "Methylation Dendrogram", type = "triangle")
plot(clusDendro, main = "Methylation Dendrogram", hang = -1)
plot(clusDendro, main = "Methylation Dendrogram")
#plot(clusDendro, main = "Cool Dendrogram")

dev.off()


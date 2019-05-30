
# R CMD BATCH --no-save --no-restore '--args data' PCA.R
args <- commandArgs(TRUE)


library(GGally)
df<-read.table(args[1], header=T, comment.char="#")
out<-paste(args[1], "PCA.png", sep=".")

png(out, width=4800, height=4800)
ggpairs(data=df, columns=2:11, title="PCA", mapping = ggplot2::aes(color = Group) ) # aesthetics, ggplot2 style
dev.off()


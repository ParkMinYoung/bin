args <- commandArgs(TRUE)
library(hexbin)
df<-read.delim(args[1], header=TRUE, sep="\t")

out<-paste(args[1], "plot.hexbin.png", sep=".")

png(out)
plot(hexbin(df))
dev.off()


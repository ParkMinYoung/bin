

library(ggplot2)

sample<-read.delim("DepthCoverage.sample_summary.table", header=T, sep="\t")

pdf("DepthCoverage.sample_summary.table.pdf")

ggplot(sample, aes(depth, value, group=depth, colour=depth))+ geom_jitter(alpha=I(1/4)) + geom_boxplot(colour="red", width=3, alpha=I(1/20)) + 
coord_cartesian(ylim=c(0,100)) + scale_y_continuous(breaks=seq(0, 100, 5)) +
coord_cartesian(xlim=c(0,100)) + scale_x_continuous(breaks=seq(0, 100, 5)) +
xlab("Depth (X)") + ylab("Target Coverage (%)") +
ggtitle("Target Coverage per Depth") +
theme(plot.title=element_text(lineheight=.8, face="bold")) +
geom_hline(aes(yintercept=80), colour="#990000", linetype="dashed") +
geom_vline(aes(xintercept=20), colour="#990000", linetype="dashed")


dev.off()


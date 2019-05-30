args <- commandArgs(TRUE)


df<-read.delim(args[1], header=TRUE, sep="\t")

out<-paste(args[1], "plot.png", sep=".")

png(out)

		A<-colnames(df)[1]
		B<-colnames(df)[2]
		with(df, plot(df[,1], df[,2], xlab=A, ylab=B, pch=1, col=rgb(0,0,0, alpha=0.2)))
		abline(fit <- lm(df[,2] ~ df[,1], data=df), col='red', lwd=4)
		legend("topright", bty="n", legend=paste("R2 is", format(summary(fit)$adj.r.squared, digits=4)))
		mtext(paste("R2 between",A,"and",B, "is", format(summary(fit)$adj.r.squared, sep=" ")), col="red")

dev.off()

H<-read.delim("Hiseq.KP_005.sample_interval_summary.table", header=T, sep="\t")
I<-read.delim("KP_005.SSV3.bam.AddRG.bam.DepthCoverage.Report.sample_interval_summary.table", header=T, sep="\t")


pdf("cmp.mean_dp.pdf", width=24, height=18)

par(mfrow = c(10, 1))

plot(H$mean_dp, type="h", ylim=c(0,5000), xlab="SureSelect V3 50M", ylab="Hiseq Mean DP", col="blue", lwd=0.1, )
plot(I$mean_dp, type="h", ylim=c(0,5000), xlab="SureSelect V3 50M", ylab="Proton Mean DP", col="red", lwd=0.1, )

plot(H$mean_dp, type="h", ylim=c(0,1000), xlab="SureSelect V3 50M", ylab="Hiseq Mean DP", col="blue", lwd=0.1, )
plot(I$mean_dp, type="h", ylim=c(0,1000), xlab="SureSelect V3 50M", ylab="Proton Mean DP", col="red", lwd=0.1, )

plot(H$mean_dp, type="h", ylim=c(0,20),xlab="SureSelect V3 50M", ylab="Hiseq Mean DP", col="blue", lwd=0.1, )
plot(I$mean_dp, type="h", ylim=c(0,20), xlab="SureSelect V3 50M", ylab="Proton Mean DP", col="red", lwd=0.1, )

plot(H$mean_dp, type="h", ylim=c(20,100),xlab="SureSelect V3 50M", ylab="Hiseq Mean DP",  col="blue", lwd=0.1, )
plot(I$mean_dp, type="h", ylim=c(20,100), xlab="SureSelect V3 50M", ylab="Proton Mean DP", col="red", lwd=0.1, )

plot(H$mean_dp, type="h", ylim=c(100,200),xlab="SureSelect V3 50M", ylab="Hiseq Mean DP",  col="blue", lwd=0.1, )
plot(I$mean_dp, type="h", ylim=c(100,200),xlab="SureSelect V3 50M", ylab="Proton Mean DP",  col="red", lwd=0.1, )



chr_list <- paste("chr", c(1:22,"X","Y"), sep="")
chr<-NULL
for( i in chr_list){
	
	
	h_dp <- H[H$chr==i,]$mean_dp
	i_dp <- I[I$chr==i,]$mean_dp
	
	par(mfrow = c(10, 1))

	plot(h_dp, type="h", ylim=c(0,5000), xlab=i, ylab="Hiseq Mean DP", col="blue", lwd=0.1, )
	plot(i_dp, type="h", ylim=c(0,5000), xlab=i, ylab="Proton Mean DP", col="red", lwd=0.1, )

	plot(h_dp, type="h", ylim=c(0,1000), xlab=i, ylab="Hiseq Mean DP", col="blue", lwd=0.1, )
	plot(i_dp, type="h", ylim=c(0,1000), xlab=i, ylab="Proton Mean DP", col="red", lwd=0.1, )

	plot(h_dp, type="h", ylim=c(0,20),xlab=i, ylab="Hiseq Mean DP", col="blue", lwd=0.1, )
	plot(i_dp, type="h", ylim=c(0,20), xlab=i, ylab="Proton Mean DP", col="red", lwd=0.1, )

	plot(h_dp, type="h", ylim=c(20,100),xlab=i, ylab="Hiseq Mean DP",  col="blue", lwd=0.1, )
	plot(i_dp, type="h", ylim=c(20,100), xlab=i, ylab="Proton Mean DP", col="red", lwd=0.1, )

	plot(h_dp, type="h", ylim=c(100,200),xlab=i, ylab="Hiseq Mean DP",  col="blue", lwd=0.1, )
	plot(i_dp, type="h", ylim=c(100,200),xlab=i, ylab="Proton Mean DP",  col="red", lwd=0.1, )

	
	#chr <- c(chr, length(h_dp))


}

dev.off()


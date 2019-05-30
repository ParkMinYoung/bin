
args <- commandArgs(TRUE)


H<-read.delim(args[1], header=T, sep="\t")
I<-read.delim(args[2], header=T, sep="\t")


name<-paste(args[3], args[4], sep=".")

file<-paste(name, "pdf", sep=".")

pdf(file, width=24, height=18)

par(mfrow = c(10, 1))

ylab1<-paste(args[3], "Mean DP", sep=" ")
ylab2<-paste(args[4], "Mean DP", sep=" ")

plot(H$mean_dp, type="h", ylim=c(0,5000), xlab="SureSelect V3 50M", ylab=ylab1, col="blue", lwd=0.1, )
plot(I$mean_dp, type="h", ylim=c(0,5000), xlab="SureSelect V3 50M", ylab=ylab2, col="red", lwd=0.1, )

plot(H$mean_dp, type="h", ylim=c(0,1000), xlab="SureSelect V3 50M", ylab=ylab1, col="blue", lwd=0.1, )
plot(I$mean_dp, type="h", ylim=c(0,1000), xlab="SureSelect V3 50M", ylab=ylab2, col="red", lwd=0.1, )

plot(H$mean_dp, type="h", ylim=c(0,20),xlab="SureSelect V3 50M", ylab=ylab1, col="blue", lwd=0.1, )
plot(I$mean_dp, type="h", ylim=c(0,20), xlab="SureSelect V3 50M", ylab=ylab2, col="red", lwd=0.1, )

plot(H$mean_dp, type="h", ylim=c(20,100),xlab="SureSelect V3 50M", ylab=ylab1,  col="blue", lwd=0.1, )
plot(I$mean_dp, type="h", ylim=c(20,100), xlab="SureSelect V3 50M", ylab=ylab2, col="red", lwd=0.1, )

plot(H$mean_dp, type="h", ylim=c(100,200),xlab="SureSelect V3 50M", ylab=ylab1,  col="blue", lwd=0.1, )
plot(I$mean_dp, type="h", ylim=c(100,200),xlab="SureSelect V3 50M", ylab=ylab2,  col="red", lwd=0.1, )

dev.off()


chr_list <- paste("chr", c(1:22,"X","Y"), sep="")
chr<-NULL
for( i in chr_list){


        h_dp <- H[H$chr==i,]$mean_dp
        i_dp <- I[I$chr==i,]$mean_dp

	 	file<-paste(name, i, "pdf", sep=".")
		pdf(file, width=24, height=18)
        par(mfrow = c(10, 1))

        plot(h_dp, type="h", ylim=c(0,5000), xlab=i, ylab=ylab1, col="blue", lwd=0.1, )
        plot(i_dp, type="h", ylim=c(0,5000), xlab=i, ylab=ylab2, col="red", lwd=0.1, )

        plot(h_dp, type="h", ylim=c(0,1000), xlab=i, ylab=ylab1, col="blue", lwd=0.1, )
        plot(i_dp, type="h", ylim=c(0,1000), xlab=i, ylab=ylab2, col="red", lwd=0.1, )

        plot(h_dp, type="h", ylim=c(0,20),xlab=i, ylab=ylab1, col="blue", lwd=0.1, )
        plot(i_dp, type="h", ylim=c(0,20), xlab=i, ylab=ylab2, col="red", lwd=0.1, )

        plot(h_dp, type="h", ylim=c(20,100),xlab=i, ylab=ylab1,  col="blue", lwd=0.1, )
        plot(i_dp, type="h", ylim=c(20,100), xlab=i, ylab=ylab2, col="red", lwd=0.1, )

        plot(h_dp, type="h", ylim=c(100,200),xlab=i, ylab=ylab1,  col="blue", lwd=0.1, )
        plot(i_dp, type="h", ylim=c(100,200),xlab=i, ylab=ylab2,  col="red", lwd=0.1, )


        #chr <- c(chr, length(h_dp))

		dev.off()

}


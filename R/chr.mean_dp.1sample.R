args <- commandArgs(TRUE)


H<-read.delim(args[1], header=T, sep="\t")
pdfname<-paste(args[2], "PlotPerChr", "pdf", sep=".")
#30x


xlabel<-"WGS 1K Bin"
ylabel<-"Mean DP"
color<-"blue"
main_title<-"WGS"

pdf(pdfname, width=24, height=18)

par(mfrow = c(4, 6))



chr_list <- paste("chr", c(1:22,"X","Y"), sep="")
chr<-NULL
for( i in chr_list){

        H_dp<-H[H$chr==i,]$mean_dp

        title<-paste(i, main_title, sep=" ")

        plot(H_dp, type="h", ylim=c(-1000,1000), xlab=xlabel, ylab=ylabel, col=color, lwd=0.1, main=title)
}

dev.off()

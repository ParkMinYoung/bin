args <- commandArgs(TRUE)


pdfname<-paste(args[1], "pdf", sep=".")

CPNAME<-args[1]
#CPNAME<-"corus_calamus_NC_007407"

xlabel<-"CP Binning 100bp"
ylabel<-"Mean Depth Coverage"
color<-"blue"
main_title<-"Chroloplast Genome binning 100bp"

pdf(pdfname, width=24, height=(length(args)-1)*4)

par(mfrow = c(length(args)-1, 1))



list <- c(2:length(args))
for( i in list){

		H<-read.delim(args[i], header=T, sep="\t")
        title<-paste(CPNAME, main_title, sep=" ")
		xlabel<-paste("IonXpress",i-1, sep="_")

		#plot(H$mean_dp, type="h",  xlab=xlabel, ylab=ylabel, col=color, lwd=0.1, main=title)
		if( i == 2 ){
				plot(H$mean_dp, type="h", ylim=c(0,2500), xlab=xlabel, ylab=ylabel, col=color, lwd=0.1, main=title)
		}else{
				plot(H$mean_dp, type="h", ylim=c(0,2500), xlab=xlabel, ylab=ylabel, col=color, lwd=0.1)
		}
}

dev.off()

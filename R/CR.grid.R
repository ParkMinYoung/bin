library(RColorBrewer)

df<-read.table("Summary.txt", header=T)

## convert string like "B7" to "B07"

df$well<-as.character(df$well)
idx<-nchar( df$well ) == 2
df$well[idx]<-sub( "(\\d$)", "0\\1", df$well[idx], perl=T )
df$well<-factor(df$well, level= sort( unique(df$well) ) )


attach(df)

CR<-as.matrix( tapply(call_rate, list(well, set), sum) )
CR<-t(CR)

nrows<-length( unique( set ) )



png("CR.Grid.png", height=nrows*50, width=1600)

#layout(matrix(data=c(1,2), nrow=1, ncol=2), widths=c(8,1), heights=c(1,1))

split.screen(rbind(c(0.05,0.90,0, 1),c(0.9,1,0.6,0.8)))
screen(1)


#image(m, axes=F, col=pal[1:9],col=rainbow(25) )
# 5.1 4.1 4.1 2.1

breaks<-seq(90,100,1)
breaks2<-breaks[-length(breaks)]

#par(mar=c(5.1,10.1,4.2), oma=c(0.2,0.2,0.2,0.2), mex=.5)
par(mar=c(5.1,2.1,1,2))


image(t(CR), axes=F, col=brewer.pal(10,"Spectral"), breaks=breaks)
axis(1, at=c(seq(0,1,by=(1/(ncol(CR)-1)))), labels=colnames(CR), las=1, cex.lab=.3, col.axis="blue", cex.axis=.9, las=2)
axis(2, at=seq(0,1,by=(1/(nrow(CR)-1))), labels=rownames(CR), las=2, cex.lab=.3, col.axis="blue", cex.axis=.8)

grid(ncol(CR),nrow(CR), col="gray",lty=1,lwd=1)
box("plot", col="black", lwd=2)


screen(2)
par(mar = c(1,1,2,2))
image(x=1, y=0:length(breaks2),z=t(matrix(breaks2))*1.001, col=brewer.pal(10,"Spectral"),axes=FALSE,breaks=breaks,xlab="", ylab="",xaxt="n")
axis(4,at=0:(length(breaks2)-1), labels=breaks2, col="white",las=1)
grid(1,length(breaks2), col="white", lty=1, lwd=3)

detach(df)


dev.off()





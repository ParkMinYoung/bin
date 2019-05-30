


png("StringentGeneSummary.v2.png", width=1600, height=960)


m<-read.table("Giant.Pass.v2.txt", header=T)

rownames(m)<-m[,1]
m<-data.matrix(m[,-1])

#m<- m[, rev( order( colSums(m) ) ) ]
m<- m[ rev( order( rowSums(m) ) ), ]

#m<-m[,1:36]

samples<-unique( sub(".\\w+$","",colnames(m), perl=T) )
genes<-rownames(m)


split.screen(rbind(c(0.1,0.80,0.15, 0.80),c(0.073,0.828,0.805,0.95),c(0.805,0.95,0.125,0.825)))
screen(1)
par(mar = c(0, 0, 0, 0))


m<-t(m)
image(m, axes=F, col=c("white","red","darkorange", "forestgreen"))

axis(1, at=seq(0,1,by=(1/(nrow(m)-1)))[seq(2, nrow(m), 3)], labels=samples, las=2, cex.lab=.3, col.axis="blue", cex.axis=.8)
axis(2, at=c(seq(0,1,by=(1/(ncol(m)-1)))), labels=genes, las=1, cex.lab=.3, col.axis="green", cex.axis=.7)

grid(nrow(m)/3,ncol(m),col="gray",lty=1,lwd=1)
box("plot", col="black", lwd=2)

screen(2)
par(mar = c(0, 0, 0, 0))
#barplot(rowSums(m)/1:3, col=c("red","darkorange", "forestgreen"), space=0)
barplot(matrix(rowSums(m)/1:3, nrow=3, byrow=F), col=c("red","darkorange", "forestgreen"), space=0)

#mt<-apply(m, 2, table)

screen(3)
par(mar = c(0, 0, 0, 0))
#matrix(rowSums(m)/1:3, nrow=3, byrow=F)

cave <- function(x) c( sum( x[seq(1,length(x),3)] / 1 ), sum( x[seq(2,length(x),3)] / 2 ), sum( x[seq(3,length(x),3)] / 3 ) )
barplot(apply(m, 2, cave ), col=c("red","darkorange", "forestgreen"), space=0, horiz=T, yaxt="n")

dev.off()


png("LenientGeneSummary.v2.png", width=1600, height=960)

m<-read.table("Giant.Hold.v2.txt", header=T)

rownames(m)<-m[,1]
m<-data.matrix(m[,-1])

#m<- m[, rev( order( colSums(m) ) ) ]
m<- m[ rev( order( rowSums(m) ) ), ]

#m<-m[,1:36]

samples<-unique( sub(".\\w+$","",colnames(m), perl=T) )
genes<-rownames(m)


split.screen(rbind(c(0.1,0.80,0.15, 0.80),c(0.073,0.828,0.805,0.95),c(0.805,0.95,0.125,0.825)))
screen(1)
par(mar = c(0, 0, 0, 0))


m<-t(m)
image(m, axes=F, col=c("white","red","darkorange", "forestgreen"))

axis(1, at=seq(0,1,by=(1/(nrow(m)-1)))[seq(2, nrow(m), 3)], labels=samples, las=2, cex.lab=.3, col.axis="blue", cex.axis=.8)
axis(2, at=c(seq(0,1,by=(1/(ncol(m)-1)))), labels=genes, las=1, cex.lab=.3, col.axis="green", cex.axis=.7)

grid(nrow(m)/3,ncol(m),col="gray",lty=1,lwd=1)
box("plot", col="black", lwd=2)

screen(2)
par(mar = c(0, 0, 0, 0))
#barplot(rowSums(m)/1:3, col=c("red","darkorange", "forestgreen"), space=0)
barplot(matrix(rowSums(m)/1:3, nrow=3, byrow=F), col=c("red","darkorange", "forestgreen"), space=0)

#mt<-apply(m, 2, table)

screen(3)
par(mar = c(0, 0, 0, 0))
#matrix(rowSums(m)/1:3, nrow=3, byrow=F)

cave <- function(x) c( sum( x[seq(1,length(x),3)] / 1 ), sum( x[seq(2,length(x),3)] / 2 ), sum( x[seq(3,length(x),3)] / 3 ) )
barplot(apply(m, 2, cave ), col=c("red","darkorange", "forestgreen"), space=0, horiz=T, yaxt="n")

dev.off()


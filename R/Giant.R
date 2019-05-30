

### using split.screen

m<-read.table("Giant.Hold.txt", header=T)

rownames(m)<-m[,1]
m<-data.matrix(m[,-1])


#colSums( m[, rev( order( colSums(m) ) )] )
# sample count sort 
m<- m[, rev( order( colSums(m) ) ) ]
m<- m[ rev( order( rowSums(m) ) ), ]

samples<-colnames(m)
genes<-rownames(m)


min<-min(m)
max<-max(m)


png("LenientGeneSummary.png", width=1600, height=960)
split.screen(rbind(c(0.1,0.80,0.15, 0.80),c(0.073,0.828,0.805,0.95),c(0.805,0.95,0.125,0.825)))
screen(1)
par(mar = c(0, 0, 0, 0))
image( t(m), axes=F,col=c("white","red"))
box("plot", lwd=2, col="black")


axis(1, at=c(seq(0,1,by=(1/(ncol(m)-1)))), labels=samples, las=2, cex.lab=.3, col.axis="blue", cex.axis=.8)
axis(2, at=c(seq(0,1,by=(1/(nrow(m)-1)))), labels=genes, las=1, cex.lab=.3, col.axis="green", cex.axis=.7)

grid(ncol(m),nrow(m),col="gray",lty=1,lwd=1)


screen(2)
par(mar = c(0, 0, 0, 0))
sample_count <- apply(m, 2, sum)
sample_max<-max(sample_count)
barplot(apply(m, 2, sum), col="blue", space=0,xaxt='n', ylim=c(0,sample_max))
#box("plot", col="red")

screen(3)
par(mar = c(0, 0, 0, 0))
gene_count <- apply(m, 1, sum)
gene_max<-max(gene_count)
barplot(apply(m, 1, sum), col="green", space=0, yaxt='n',horiz=T, xlim=c(0,gene_max))
#box("plot", col="red")

dev.off()



### using split.screen

m<-read.table("Giant.Pass.txt", header=T)

rownames(m)<-m[,1]
m<-data.matrix(m[,-1])


#colSums( m[, rev( order( colSums(m) ) )] )
# sample count sort 
m<- m[, rev( order( colSums(m) ) ) ]
m<- m[ rev( order( rowSums(m) ) ), ]

samples<-colnames(m)
genes<-rownames(m)


min<-min(m)
max<-max(m)


png("StringentGeneSummary.png", width=1600, height=960)
split.screen(rbind(c(0.1,0.80,0.15, 0.80),c(0.073,0.828,0.805,0.95),c(0.805,0.95,0.125,0.825)))
screen(1)
par(mar = c(0, 0, 0, 0))
image( t(m), axes=F,col=c("white","red"))
box("plot", lwd=2, col="black")


axis(1, at=c(seq(0,1,by=(1/(ncol(m)-1)))), labels=samples, las=2, cex.lab=.3, col.axis="blue", cex.axis=.8)
axis(2, at=c(seq(0,1,by=(1/(nrow(m)-1)))), labels=genes, las=1, cex.lab=.3, col.axis="green", cex.axis=.7)

grid(ncol(m),nrow(m),col="gray",lty=1,lwd=1)


screen(2)
par(mar = c(0, 0, 0, 0))
sample_count <- apply(m, 2, sum)
sample_max<-max(sample_count)
barplot(apply(m, 2, sum), col="blue", space=0,xaxt='n', ylim=c(0,sample_max))
#box("plot", col="red")

screen(3)
par(mar = c(0, 0, 0, 0))
gene_count <- apply(m, 1, sum)
gene_max<-max(gene_count)
barplot(apply(m, 1, sum), col="green", space=0, yaxt='n',horiz=T, xlim=c(0,gene_max))
#box("plot", col="red")

dev.off()


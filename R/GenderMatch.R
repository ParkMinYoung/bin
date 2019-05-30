df<-read.table("Summary.Gender.txt", header=T)

df$well<-as.character(df$well)
idx<-nchar( df$well ) == 2
df$well[idx]<-sub( "(\\d$)", "0\\1", df$well[idx], perl=T )
df$well<-factor(df$well, level= sort( unique(df$well) ) )


#sort_df<-df[with(df, order(set, well)), ]
#m<-matrix(sort_df$gender_match, nrow=96)

attach(df)
m<-as.matrix( tapply(gender_match, list(well, set), sum) )

#colnames(m)<-sort( unique(df$set) )
#rownames(m)<-sort( unique(df$well) )



png("GenderMatch.png", width=1020, height=800)
par(mar=c(5.1,6, 1, 1))

image((m), axes=F, col=c("gray", "darkorange", "black", "forestgreen"), xlab="WELL", ylab="Plate")
grid(nrow(m), ncol(m), col="white", lty=1, lwd=2)



axis(1, at=seq(0,1,by=(1/(nrow(m)-1))), labels=rownames(m), las=2, cex.lab=.3, col.axis="green", cex.axis=.6)
axis(2, at=c(seq(0,1,by=(1/(ncol(m)-1)))), labels=colnames(m), las=1, cex.lab=.3, col.axis="blue", cex.axis=.6, las=2)


box("plot", col="black", lwd=2)

dev.off()


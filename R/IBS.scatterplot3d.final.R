# R CMD BATCH --no-slave --no-restore IBS.scatterplot3d.final.R
# R CMD BATCH --no-save --no-restore '--args 32/20130426/Bone.1.bam.coverage Bone.1' coverage.plot.R
# R CMD BATCH --no-save --no-restore '--args plink.genome' IBS.scatterplot3d.final.R 


args <- commandArgs(TRUE)

#T1<-read.delim(args[1], header=F, col.names=c("chr", "start", "end", "reads", "exp.bp", "target.bp", "coverage") , sep="\t")

out1<-paste(args[1], "scatterplot3d", "default", "plot.png", sep=".")
out2<-paste(args[1], "scatterplot3d", "magnify", "plot.png", sep=".")
out3<-paste(args[1], "ggplot", "1x3", "plot.png", sep=".")
out4<-paste(args[1], "ggplot", "2x2", "plot.png", sep=".")


library(gridExtra)
library(scatterplot3d)
library(ggplot2)
library(xlsx)

df<-read.table(args[1], header=T)

cutoff<-0.1

df$pcolor<-"black"
df$pcolor[df$Z2>=cutoff & df$Z1>=0.05]<-"green"
df$pcolor[df$Z2>=0.9]<-"red"

df$Related<-"Unrelated Pair"
df$Related[df$pcolor!="black"]<-"Related Pair"



if ( max( df$Z2 ) > 0.99 ) {

	png(out2)

	with(df, {
	    s3d <- scatterplot3d(Z0, Z1, Z2,              # x y x axi
                 color=pcolor, pch=19,    # color, point 
				 type="h", lty.hplot=2,   
				 xlim=c(0,.01),
				 ylim=c(0,.01),
				 zlim=c(.99,1),
				 scale.y=.75,
				 main="IBS Test",
				 xlab="Z0",
				 ylab="Z1",
				 zlab="Z2")
    	s3d.coords <- s3d$xyz.convert(Z0,Z1,Z2)


	    text(s3d.coords$x,s3d.coords$y,
         labels=paste(FID1, FID2, sep="---"), 
		 pos=4, cex=.5)
	})

	# legend("topleft", inset=.05, bty="n", cex=.5, title="TTTTTTT", c("P", "F"), fill=c("red", "black")
	dev.off()

}


png(out1)

with(df, {
    s3d <- scatterplot3d(Z0, Z1, Z2,              # x y x axi

                         color=pcolor, 
						 pch=19,    # color, point
                         main="IBS Test",
                         type="h", 
						 #lty.hplot=2,
						 col.axis="blue",
						 col.grid="lightblue", 
						 #highlight.3d=TRUE,
                         xlim=c(0,1),
                         ylim=c(0,1),
                         zlim=c(0,1),
                         scale.y=.75,
                         xlab="Z0",
                         ylab="Z1",
                         zlab="Z2")
    s3d.coords <- s3d$xyz.convert(Z0,Z1,Z2)
})

##with(df, {
##    s3d <- scatterplot3d(Z0, Z1, Z2,              # x y x axi
##                         color=pcolor, pch=19,    # color, point 
##			 main="IBS Test",
##			 xlab="Z0",
##			 ylab="Z1",
##			 zlab="Z2")
##    s3d.coords <- s3d$xyz.convert(Z0,Z1,Z2)
##})
dev.off()





g1<-ggplot(df, aes(Z1,Z2, col=Related)) + geom_point()

if( max(df$Z2) > 0.99 ){
	g2<-ggplot(df, aes(Z1,Z2, col=Related)) + geom_point() + ylim(c(.99,1)) + xlim(c(0,.05)) + geom_text(aes(label=paste(FID1, FID2, sep=":")), size=4, hjust=-.05, color="red")
}else{
	g2<-ggplot(df, aes(Z1,Z2, col=Related)) + geom_point() + geom_text(aes(label=paste(FID1, FID2, sep=":")), size=4, hjust=-.05, color="red") + xlim(c(0.2, 1)) + ylim(c(cutoff, 1)) 


}
	
g4<-ggplot(df, aes(Z1,Z2, col=Related)) + geom_point() + ylim(c(.15,.95))+ xlim(c(.2, 1)) + geom_text(aes(label=paste(FID1, FID2, sep=":")), size=4, hjust=-.05, color="red")

Pair_table<-subset(df, Related=="Related Pair")[,c(1,3,7,8,9,10)]
Pair_table_sort <- Pair_table[rev( order(Pair_table$PI_HAT) ) , ]
row.names(Pair_table_sort)<-1:dim(Pair_table_sort)[[1]]
g3<-tableGrob(Pair_table_sort)



Add_height = ceiling( NROW(Pair_table_sort) /10 ) * 200

png(out4, width=1200, height=800+Add_height)
#grid.arrange(arrangeGrob(g1,g2,ncol=2), arrangeGrob(g3, ncol=1), nrow=2)
grid.arrange(arrangeGrob(g1,g2,ncol=2), arrangeGrob(g3,g4, ncol=2), nrow=2)
dev.off()


write.xlsx(Pair_table_sort, "IBS.result.xlsx")




png(out3, width=800, height=1300+Add_height)

gA <- ggplot_gtable(ggplot_build(g1))
gB <- ggplot_gtable(ggplot_build(g2))

maxWidth = grid::unit.pmax(gA$widths[2:3], gB$widths[2:3])
gA$widths[2:3] <- as.list(maxWidth)
gB$widths[2:3] <- as.list(maxWidth)


grid.arrange(gA, gB, g3, ncol=1)
dev.off()



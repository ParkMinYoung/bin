library(ggplot2)
df=read.delim("TargetCov.Depth.Table", header=T, sep="\t")
df$UNIQ<-factor(df$UNIQ, labels=c(1,2))
pdf("Diff.HDPvsIDP.pdf", width=12, height=8)
qplot(H_DP,I_DP, data=df, facets=UNIQ~TYPE, colour=factor(UNIQ), geom=c("point"), main="Depth Diff bwt Hiseq and Proton",  ylim=c(0, 8000), xlim=c(0,8000))+ stat_smooth(method="lm", se=F, fullrange=T)
qplot(H_DP,I_DP, data=df, facets=UNIQ~TYPE, colour=factor(UNIQ), geom=c("point"), main="Depth Diff bwt Hiseq and Proton",  ylim=c(0, 2000), xlim=c(0,2000))+ stat_smooth(method="lm", se=F, fullrange=T)
qplot(H_DP,I_DP, data=df, facets=UNIQ~TYPE, colour=factor(UNIQ), geom=c("point"), main="Depth Diff bwt Hiseq and Proton",  ylim=c(0, 200), xlim=c(0,200))+ stat_smooth(method="lm", se=F, fullrange=T)
qplot(H_DP,I_DP, data=df, facets=UNIQ~TYPE, colour=factor(UNIQ), geom=c("point"), main="Depth Diff bwt Hiseq and Proton",  ylim=c(0, 200), xlim=c(0,200))+ stat_smooth()
qplot(H_DP,I_DP, data=df, facets=UNIQ~TYPE, colour=factor(UNIQ), geom=c("point"), main="Depth Diff bwt Hiseq and Proton",  ylim=c(0, 2000), xlim=c(0,2000), alpha=I(1/20))+ stat_smooth(method="lm", se=F, fullrange=T)
qplot(H_DP,I_DP, data=df, facets=UNIQ~TYPE, colour=factor(UNIQ), geom=c("point"), main="Depth Diff bwt Hiseq and Proton",  ylim=c(0, 200), xlim=c(0,200), alpha=I(1/20))+ stat_smooth(method="lm", se=F, fullrange=T)


dev.off()




pdf("TargetCov.BWT.HDPvsIDP.pdf", width=12, height=8)
qplot(H_DP, I_DP, data=df, colour=UNIQ, xlab="Hiseq DP", ylab="Proton DP", xlim=c(0,8000), ylime=c(0,8000) ) + stat_smooth()
qplot(H_DP, I_DP, data=df, colour=UNIQ, xlab="Hiseq DP", ylab="Proton DP", xlim=c(0,8000), ylim=c(0,8000) ) + stat_smooth(method="lm", se=F, fullrange=T)
qplot(H_DP, I_DP, data=df, colour=UNIQ, xlab="Hiseq DP", ylab="Proton DP", xlim=c(0,200), ylim=c(0,200) ) + stat_smooth(method="lm", se=F, fullrange=T)
qplot(H_DP, I_DP, data=df, colour=UNIQ, xlab="Hiseq DP", ylab="Proton DP", xlim=c(0,2000), ylim=c(0,2000) ) + stat_smooth(method="lm", se=F, fullrange=T)

qplot(H_DP, I_DP, data=df, colour=UNIQ, xlab="Hiseq DP", ylab="Proton DP", xlim=c(0,200), ylim=c(0,200) ) + stat_smooth()
qplot(H_DP, I_DP, data=df, colour=UNIQ, xlab="Hiseq DP", ylab="Proton DP", xlim=c(0,2000), ylim=c(0,2000) ) + stat_smooth()


dev.off()



## create IonProton.DP.GQ.pdf

pdf("DP.scatter.hist.plot.8000.pdf")

cutDP<-2000

I_IDX<- df$I_DP < cutDP & df$H_DP < cutDP
H_DP<-df$H_DP[I_IDX]
I_DP<-df$I_DP[I_IDX]


par(fig=c(0,0.8,0,0.8), new=TRUE)
plot(H_DP, I_DP, xlab="Hiseq Depth", ylab="Proton Depth")
par(fig=c(0,0.8,0.55,1), new=TRUE)
boxplot(H_DP, horizontal=TRUE, axes=FALSE)
par(fig=c(0.65,1,0,0.8),new=TRUE)
boxplot(I_DP, axes=FALSE)
mtext("DP distribution between Hiseq and Proton", side=3, outer=TRUE, line=-3)

dev.off()

pdf("DP.scatter.hist.plot.200.pdf")

cutDP<-200

I_IDX<- df$I_DP < cutDP & df$H_DP < cutDP
H_DP<-df$H_DP[I_IDX]
I_DP<-df$I_DP[I_IDX]


par(fig=c(0,0.8,0,0.8), new=TRUE)
plot(H_DP, I_DP, xlab="Hiseq Depth", ylab="Proton Depth")
par(fig=c(0,0.8,0.55,1), new=TRUE)
boxplot(H_DP, horizontal=TRUE, axes=FALSE)
par(fig=c(0.65,1,0,0.8),new=TRUE)
boxplot(I_DP, axes=FALSE)
mtext("DP distribution between Hiseq and Proton", side=3, outer=TRUE, line=-3)




dev.off()


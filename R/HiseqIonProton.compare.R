#### R script ####


library(ggplot2)
library(grid)

#####################################################################################################

## create Discordant.pdf 

Simul<-read.delim("DP.GQ.simulation.Discordant", header=T, sep="\t")

p1<-qplot(DP, P_MIS, data=Simul, colour=factor(GQ))
p2<-qplot(GQ, P_MIS, data=Simul, colour=factor(DP))
p3<-qplot(DP, P_MIS, data=Simul, colour=Type, facets=.~GQ, geom="point", main="Discordant Rate per DP")
p4<-qplot(GQ, P_MIS, data=Simul, colour=Type, facets=.~DP, geom="point", main="Discordant Rate per GQ")

## Stolen from ggplot documenation 

#pdf("Discordant.pdf", width = 8, height = 6) 
pdf("Discordant.pdf", width = 16, height = 12) 
grid.newpage() 
pushViewport(viewport(layout = grid.layout(3, 2))) 
vplayout <- function(x, y) 
viewport(layout.pos.row = x, layout.pos.col = y) 
#print(a, vp = vplayout(1, 1:2)) 
print(p1, vp = vplayout(1, 1)) 
print(p2, vp = vplayout(1, 2)) 
print(p3, vp = vplayout(2, 1:2)) 
print(p4, vp = vplayout(3, 1:2)) 
dev.off() 

## create Discordant.pdf 

#####################################################################################################



#####################################################################################################

## create DiscordantSimul.DP.HGQ.IGQ.pdf 

Simul<-read.delim("DP.HGQ.IGQ.simulation.Discordant", header=T, sep="\t")


#qplot(DP, P_MIS, data=Simul, colour=Type, facets=.~HGQ, geom="point")
#qplot(DP, P_MIS, data=Simul, colour=Type, facets=HGQ~IGQ, geom="point")

p1<-qplot(HGQ, P_MIS, data=Simul, facets=Type~DP, colour=factor(IGQ), geom=c("point","line"), main="Discordant Simulation")
p2<-qplot(HGQ, N_CMP, data=Simul, facets=Type~DP, colour=factor(IGQ), geom=c("point","line"), main="N_Comparison Simulation")


## Stolen from ggplot documenation 

pdf("DiscordantSimul.DP.HGQ.IGQ.pdf", width=12, height=16) 
grid.newpage() 
pushViewport(viewport(layout = grid.layout(2, 1))) 
vplayout <- function(x, y) 
viewport(layout.pos.row = x, layout.pos.col = y) 

print(p1, vp = vplayout(1, 1)) 
print(p2, vp = vplayout(2, 1)) 

dev.off() 

#####################################################################################################


#####################################################################################################

## create DiscordantSimul.DP.HGQ.IGQ.2.pdf

Simul<-read.delim("DP.HGQ.IGQ.simulation.Discordant.2", header=T, sep="\t")


#qplot(DP, P_MIS, data=Simul, colour=Type, facets=.~HGQ, geom="point")
#qplot(DP, P_MIS, data=Simul, colour=Type, facets=HGQ~IGQ, geom="point")

p1<-qplot(HGQ, P_MIS, data=Simul, facets=Type~DP, colour=factor(IGQ), geom=c("point","line"), main="Discordant Simulation")
p2<-qplot(HGQ, N_CMP, data=Simul, facets=Type~DP, colour=factor(IGQ), geom=c("point","line"), main="N_Comparison Simulation")


## Stolen from ggplot documenation

pdf("DiscordantSimul.DP.HGQ.IGQ.2.pdf", width=12, height=16)
grid.newpage()
pushViewport(viewport(layout = grid.layout(2, 1)))
vplayout <- function(x, y)
viewport(layout.pos.row = x, layout.pos.col = y)

print(p1, vp = vplayout(1, 1))
print(p2, vp = vplayout(2, 1))

dev.off()

#####################################################################################################



#####################################################################################################

## create DiscordantSimul.DP.HGQ.IGQ.2.pdf

Simul<-read.delim("DP.HGQ.IGQ.simulation.Discordant.2.SNV", header=T, sep="\t")


#qplot(DP, P_MIS, data=Simul, colour=Type, facets=.~HGQ, geom="point")
#qplot(DP, P_MIS, data=Simul, colour=Type, facets=HGQ~IGQ, geom="point")

p1<-qplot(HGQ, P_MIS, data=Simul, facets=Type~DP, colour=factor(IGQ), geom=c("point","line"), main="Discordant Simulation")
p2<-qplot(HGQ, N_CMP, data=Simul, facets=Type~DP, colour=factor(IGQ), geom=c("point","line"), main="N_Comparison Simulation")


## Stolen from ggplot documenation

pdf("DiscordantSimul.DP.HGQ.IGQ.2.SNV.pdf", width=12, height=8)
grid.newpage()
pushViewport(viewport(layout = grid.layout(2, 1)))
vplayout <- function(x, y)
viewport(layout.pos.row = x, layout.pos.col = y)

print(p1, vp = vplayout(1, 1))
print(p2, vp = vplayout(2, 1))

dev.off()

#####################################################################################################



#####################################################################################################

## create DP.GQ.pdf

H<-read.delim("Hiseq.vcf.DP.GQ", header=T, sep="\t")
I<-read.delim("IonProton.vcf.DP.GQ", header=T, sep="\t")

pdf("multiple.plot.pdf")

par(mfrow=c(3,2))
plot(H, xlab="Depth", ylab="GQ", main="Hiseq")
plot(I, xlab="Depth", ylab="GQ", main="IonProton")
hist(H$DP, breaks=100, col="blue", xlab="Depth", freq=T, main="")
hist(I$DP, breaks=100, col="blue", xlab="Depth", freq=T, main="")
hist(H$GQ, breaks=100, col="blue", xlab="GQ", freq=T, main="")
hist(I$GQ, breaks=100, col="blue", xlab="GQ", freq=T, main="")

dev.off()

#####################################################################################################



#####################################################################################################

## create Hiseq.DP.GQ.pdf

cutDP<-2000

pdf("Hiseq.DP.GQ.pdf")

H_IDX<- H$DP < cutDP
H_DP<-H$DP[H_IDX]
H_GQ<-H$GQ[H_IDX]

par(fig=c(0,0.8,0,0.8), new=TRUE)

plot(H_DP, H_GQ, xlab="Depth", ylab="Genotype Quality")
par(fig=c(0,0.8,0.55,1), new=TRUE)
boxplot(H_DP, horizontal=TRUE, axes=FALSE)
par(fig=c(0.65,1,0,0.8),new=TRUE)
boxplot(H_GQ, axes=FALSE)
mtext("Genotype Quality per Depth in Hiseq", side=3, outer=TRUE, line=-3) 

dev.off()

## create IonProton.DP.GQ.pdf

pdf("IonProton.DP.GQ.pdf")

I_IDX<- I$DP < cutDP
I_DP<-I$DP[I_IDX]
I_GQ<-I$GQ[I_IDX]


par(fig=c(0,0.8,0,0.8), new=TRUE)
plot(I_DP, I_GQ, xlab="Depth", ylab="Genotype Quality")
par(fig=c(0,0.8,0.55,1), new=TRUE)
boxplot(I_DP, horizontal=TRUE, axes=FALSE)
par(fig=c(0.65,1,0,0.8),new=TRUE)
boxplot(I_GQ, axes=FALSE)
mtext("Genotype Quality per Depth in IonProton", side=3, outer=TRUE, line=-3) 

dev.off()


#####################################################################################################



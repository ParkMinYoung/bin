library(reshape2)
library(ggplot2)
library(scales)
library(gridExtra)
 
#setwd("/home/adminrig/workspace.min/AFFX/Axiom_KORV1.0/Analysis/Concordance")
df<-read.table("GenoMatchResult.txt", header=T)
melt_df<-melt(df, id=1)
colnames(melt_df)[1]<-c("id")
 

img_col<-10
img_row<-10
default_h<-30
default_w<-200

height_v <- ceiling( length( levels(melt_df$variable) )/img_col ) * default_h
width_v <- default_w * img_col
#floor(102.5)
#ceiling(102.5)

#g00<-ggplot(melt_df, aes(variable, id, fill=value)) + geom_raster()
#g01<-ggplot(melt_df, aes(variable, id, fill=value)) + geom_raster() + scale_fill_gradient2(midpoint=0.5, mid="grey70", limits=c(0,1)) +  theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5)) + xlab("Sample ID") + ylab("TaqMan Marker")
#g1<-ggplot(melt_df, aes(variable, id, fill=value)) + geom_raster() + scale_fill_gradient2(midpoint=0.5, mid="grey70", limits=c(0,1)) +  theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5)) + xlab("Sample ID") + ylab("TaqMan Marker") + facet_wrap(~id, ncol=1, scale="free_y") # ok per marker
g2<-ggplot(melt_df, aes(id,variable, fill=value)) + geom_raster() + scale_fill_gradient2(midpoint=0.5, low = muted("red"), high = muted("blue"), mid="white", limits=c(0,1)) +  theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5)) + xlab("Sample ID") + ylab("TaqMan Marker") + facet_wrap(~variable, ncol=img_col, scale="free_y") + theme(axis.text.y = element_blank())# ok per sample



#g3<-ggplot(melt_df, aes(id, variable, fill=value)) + geom_raster() + scale_fill_gradient2(midpoint=0.5, mid="grey70", limits=c(0,1)) +  theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5)) + xlab("Sample ID") + ylab("TaqMan Marker") + facet_wrap(~variable, nrow=10, scale="free_y")
#g4<-ggplot(melt_df, aes(variable, id, fill=value)) + geom_raster() + scale_fill_gradient2(midpoint=0.5, mid="grey70", limits=c(0,1)) +  theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5)) + xlab("Sample ID") + ylab("TaqMan Marker") + facet_wrap(~variable, nrow=10, scale="free") # ok per sample marker


png("Concordance.png", width=width_v, height=height_v+300)
g2
dev.off()



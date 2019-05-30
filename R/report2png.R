args <- commandArgs(TRUE)

library(ggplot2)

# Multiple plot function
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
    require(grid)
    
    # Make a list from the ... arguments and plotlist
    plots <- c(list(...), plotlist)
    
    numPlots = length(plots)
    
    # If layout is NULL, then use 'cols' to determine layout
    if (is.null(layout)) {
        # Make the panel
        # ncol: Number of columns of plots
        # nrow: Number of rows needed, calculated from # of cols
        layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                         ncol = cols, nrow = ceiling(numPlots/cols))
    }
    
    if (numPlots==1) {
        print(plots[[1]])
        
    } else {
        # Set up the page
        grid.newpage()
        pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
        
        # Make each plot, in the correct location
        for (i in 1:numPlots) {
            # Get the i,j matrix positions of the regions that contain this subplot
            matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
            
            print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                            layout.pos.col = matchidx$col))
        }
    }
}





#tt <- read.delim(args[1], header=T, sep="\t")
tt <- read.table(args[1], header=T, sep="\t")
tt$plate=factor(tt$plate, labels=sort(unique(tt$plate)) )


##p1<-ggplot(tt, aes(plate, call_rate, col=plate))+geom_jitter()+geom_boxplot() + ggtitle("call rate")
##p2<-ggplot(tt, aes(plate, het_rate, col=plate))+geom_jitter()+geom_boxplot() + ggtitle("het rate")
##p3<-ggplot(tt, aes(plate, hom_rate, col=plate))+geom_jitter()+geom_boxplot() + ggtitle("hom rate")
##p4<-ggplot(tt, aes(plate, total_hom_rate, col=plate))+geom_jitter()+geom_boxplot() + ggtitle("total hom rate")
##p5<-ggplot(tt, aes(plate, cluster_distance_mean, col=plate))+geom_jitter()+geom_boxplot() + ggtitle("cluster distance mean")
##p6<-ggplot(tt, aes(plate, cluster_distance_stdev, col=plate))+geom_jitter()+geom_boxplot() + ggtitle("cluster distance stdev")
##p7<-ggplot(tt, aes(plate, allele_summarization_mean, col=plate))+geom_jitter()+geom_boxplot() + ggtitle("allele summarization mean")
##p8<-ggplot(tt, aes(plate, allele_summarization_stdev, col=plate))+geom_jitter()+geom_boxplot() + ggtitle("allele summarization stdev")
##p9<-ggplot(tt, aes(plate, allele_deviation_mean, col=plate))+geom_jitter()+geom_boxplot() + ggtitle("allele deviation mean")
##p10<-ggplot(tt, aes(plate, allele_deviation_stdev, col=plate))+geom_jitter()+geom_boxplot() + ggtitle("allele deviation stdev")
##p11<-ggplot(tt, aes(plate, allele_mad_residuals_mean, col=plate))+geom_jitter()+geom_boxplot() + ggtitle("allele mad residuals mean")
##p12<-ggplot(tt, aes(plate, allele_mad_residuals_stdev, col=plate))+geom_jitter()+geom_boxplot() + ggtitle("allele mad residuals stdev")


p1<-ggplot(tt, aes(plate, call_rate, col=plate))+geom_jitter()+geom_boxplot() + opts(title = "call rate")
p2<-ggplot(tt, aes(plate, het_rate, col=plate))+geom_jitter()+geom_boxplot() + opts(title = "het rate")
p3<-ggplot(tt, aes(plate, hom_rate, col=plate))+geom_jitter()+geom_boxplot() + opts(title = "hom rate")
p4<-ggplot(tt, aes(plate, total_hom_rate, col=plate))+geom_jitter()+geom_boxplot() + opts(title = "total hom rate")
p5<-ggplot(tt, aes(plate, cluster_distance_mean, col=plate))+geom_jitter()+geom_boxplot() + opts(title = "cluster distance mean")
p6<-ggplot(tt, aes(plate, cluster_distance_stdev, col=plate))+geom_jitter()+geom_boxplot() + opts(title = "cluster distance stdev")
p7<-ggplot(tt, aes(plate, allele_summarization_mean, col=plate))+geom_jitter()+geom_boxplot() + opts(title = "allele summarization mean")
p8<-ggplot(tt, aes(plate, allele_summarization_stdev, col=plate))+geom_jitter()+geom_boxplot() + opts(title = "allele summarization stdev")
p9<-ggplot(tt, aes(plate, allele_deviation_mean, col=plate))+geom_jitter()+geom_boxplot() + opts(title = "allele deviation mean")
p10<-ggplot(tt, aes(plate, allele_deviation_stdev, col=plate))+geom_jitter()+geom_boxplot() + opts(title = "allele deviation stdev")
p11<-ggplot(tt, aes(plate, allele_mad_residuals_mean, col=plate))+geom_jitter()+geom_boxplot() + opts(title = "allele mad residuals mean")
p12<-ggplot(tt, aes(plate, allele_mad_residuals_stdev, col=plate))+geom_jitter()+geom_boxplot() + opts(title = "allele mad residuals stdev")

filename <- paste(args[1], "png", sep=".")
png(filename, width=1920, height=1178)
multiplot(p1, p2, p3, p4, p5,p6,p7,p8,p9,p10,p11,p12,cols=3)

dev.off()

write( as.vector( tt$cel_file[tt$het_rate>4] ), "sampFile.Het4")
write( as.vector( tt$cel_file[tt$het_rate>5] ), "sampFile.Het5")
write( as.vector( tt$cel_file[tt$call_rate<97] ), "sampFile.CR97")
write( as.vector( tt$cel_file[tt$call_rate<95] ), "sampFile.CR95")

 ## > str(tt)
 ## 'data.frame':   956 obs. of  18 variables:
 ## $ plate                     : int  1 1 1 1 1 1 1 1 1 1 ...
 ## $ batch                     : Factor w/ 1 level "./AxiomGT1.report.txt": 1 1 1 1 1 1 1 1 1 1 ...
 ## $ cel_files                 : Factor w/ 956 levels "Axiom_soya_1_1-1_G07.CEL",..: 1 2 3 4 5 6 7 8 105 106 ...
 ## $ computed_gender           : Factor w/ 1 level "unknown": 1 1 1 1 1 1 1 1 1 1 ...
 ## $ call_rate                 : num  99.8 99.8 99.1 99.2 99.6 ...
 ## $ total_call_rate           : num  99.8 99.8 99.1 99.2 99.6 ...
 ## $ het_rate                  : num  0.486 0.547 1.162 0.885 0.608 ...
 ## $ total_het_rate            : num  0.486 0.547 1.162 0.885 0.608 ...
 ## $ hom_rate                  : num  99.3 99.3 97.9 98.3 99 ...
 ## $ total_hom_rate            : num  99.3 99.3 97.9 98.3 99 ...
 ## $ cluster_distance_mean     : num  0.735 0.695 0.826 0.841 0.739 ...
 ## $ cluster_distance_stdev    : num  0.554 0.526 0.646 0.643 0.568 ...
 ## $ allele_summarization_mean : num  10.1 10.1 10.1 10.1 10.1 ...
 ## $ allele_summarization_stdev: num  1.29 1.29 1.28 1.28 1.29 ...
 ## $ allele_deviation_mean     : num  0.373 0.363 0.387 0.384 0.373 ...
 ## $ allele_deviation_stdev    : num  0.518 0.515 0.514 0.515 0.516 ...
 ## $ allele_mad_residuals_mean : num  0.126 0.122 0.166 0.166 0.147 ...
 ## $ allele_mad_residuals_stdev: num  0.132 0.118 0.186 0.201 0.15 ...


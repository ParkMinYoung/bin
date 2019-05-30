args <- commandArgs(TRUE)

# R CMD BATCH --no-save --no-restore '--args Summary.txt.Batch' Summary.Batch.Review.R"

library(ggplot2)
library(gridExtra)


df<-read.table(args[1], header=T, sep="\t" )
png_out = paste(args[1], "SummaryReview.png", sep=".")

summary(df)
df$batch<-factor(df$batch)


# http://stackoverflow.com/questions/19876505/boxplot-show-the-value-of-mean

fun_mean <- function(x){
  return( data.frame(y=mean(x), label=round(mean(x, na.rm=T),2) ) )
}

fun_count <- function(x){
  return( data.frame(y=mean(x), label=length(x) ) )
}

# http://stackoverflow.com/questions/15660829/how-to-add-a-number-of-observations-per-group-and-use-group-mean-in-ggplot2-boxp

fun_count <- function(x){
  return( data.frame(y=0, label=length(x) ) )
}



cols_to_plot <- colnames(df)[c(5,8,9)]
plot_list=list()


for (i in cols_to_plot) {
  
  batch <-ggplot(df, aes_string("batch", i, fill="batch" )) + 
    geom_boxplot() + 
    #ylim(c(50, 100))
    stat_summary(fun.y = mean, geom="point", colour="darkred", size=2) + 
    stat_summary(fun.data = fun_mean, geom="text", vjust=-.7, colour="red") + 
    stat_summary(fun.data = fun_count, geom="text", vjust=-1.4)

  
  batch_set<- ggplot(df, aes_string("set", i, fill="batch" )) + 
    geom_boxplot() + 
    #ylim(c(50, 100))
    stat_summary(fun.y = mean, geom="point", colour="darkred", size=2) + 
    stat_summary(fun.data = fun_mean, geom="text", vjust=-.7, colour="red") + 
    stat_summary(fun.data = fun_count, geom="text", vjust=-1.4) +
    theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5)) + 
    facet_grid( . ~ batch , scale="free", space="free")
  
    plot_list = c(plot_list, list(batch, batch_set))
	#http://stackoverflow.com/questions/29425892/how-do-i-loop-through-column-names-and-make-a-ggplot-scatteplot-for-each-one
	#print(batch)
   	#Sys.sleep(2)
  
} 


XYratio_PerGender<- ggplot(df, aes(cn.probe.chrXY.ratio_gender_meanX,cn.probe.chrXY.ratio_gender_meanY, color=apt_probeset_genotype_gender )) + 
  geom_point() +
  facet_grid( . ~ apt_probeset_genotype_gender, margin=T )



XYratio_PerBatch<- ggplot(df, aes(cn.probe.chrXY.ratio_gender_meanX,cn.probe.chrXY.ratio_gender_meanY)) + 
  geom_point(aes(colour = factor(apt_probeset_genotype_gender))) +
  scale_colour_manual(values=c("blue", "green", "red")) +
  facet_grid( . ~ batch )



XYratio_PerBatch_hetvalue<- ggplot(df, aes(cn.probe.chrXY.ratio_gender_meanX,cn.probe.chrXY.ratio_gender_meanY, colour=het_rate)) + 
  geom_point() +
  scale_colour_gradient2(high = "blue", low="red", mid="green", midpoint=16.5) + 
  facet_grid( . ~ batch )



Xratio_PerBatch<- ggplot(df, aes(batch,cn.probe.chrXY.ratio_gender_meanX, colour=batch)) + geom_boxplot() + geom_jitter() 
Yratio_PerBatch<- ggplot(df, aes(batch,cn.probe.chrXY.ratio_gender_meanY, colour=batch)) + geom_boxplot() + geom_jitter() 



#ggplot(df, aes(batch,het_rate, colour=set)) + geom_jitter() + geom_boxplot() 
#ggplot(df, aes(set,het_rate, colour=set)) + geom_jitter() + geom_boxplot() 



Xratio_PerSet<- ggplot(df, aes(set,cn.probe.chrXY.ratio_gender_meanX, colour=batch)) + geom_boxplot() + geom_jitter()  + theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5)) + 
  facet_grid(. ~ batch, space="free_x", scales="free")

Yratio_PerSet<- ggplot(df, aes(set,cn.probe.chrXY.ratio_gender_meanY, colour=batch)) + geom_boxplot() + geom_jitter()  + theme(axis.text.x = element_text(angle=90, hjust=1, vjust=.5)) + 
  facet_grid(. ~ batch, space="free_x", scales="free")


plot_list = c(plot_list, list(XYratio_PerGender, XYratio_PerBatch,  Xratio_PerBatch, Xratio_PerSet, Yratio_PerBatch,  Yratio_PerSet  ))





png(png_out, width=2400, height=4800)
# http://stackoverflow.com/questions/20531579/plotting-multiple-graphs-in-r-ggplot2-and-saving-the-result
do.call(grid.arrange, c(plot_list, list(ncol=2, widths=c(1,3))))
dev.off()





























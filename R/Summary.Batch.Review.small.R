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

#fun_count <- function(x){
#  return( data.frame(y=0, label=length(x) ) )
#}



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




png(png_out, width=1200, height=1200)
# http://stackoverflow.com/questions/20531579/plotting-multiple-graphs-in-r-ggplot2-and-saving-the-result
do.call(grid.arrange, c(plot_list, list(ncol=2, widths=c(1,3))))
dev.off()





























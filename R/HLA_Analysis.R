setwd("/home/adminrig/workspace.min/HLA.Analysis/KNIH.35K/HLA/Analysis/KORV1_0-v1")
library(pacman)
p_load(dplyr, ggplot2, tidyr, gridExtra)

plot_list=list()

files <- list.files(pattern = "^HLA_4dig")
#filenames <- Sys.glob("*.dbf")
#files <- list.files()
#dbf.files <- files[-grep(".xml", files, fixed=T)]

#i=files[1]
for (i in files) {
  #print(i)
  gene<-sub("HLA_4dig_(.+).txt", "\\1", i,perl=TRUE)
  print(gene)

#gene<-sub("HLA_4dig_(.+).txt", "\\1", files[1],perl=TRUE)


df<-read.table( i, header =T, sep="\t", colClasses=c("character", "factor", "numeric", "factor", "numeric", "factor", "numeric"))
#head(df)
#str(df)

title_str <- paste("HLA", gene, "\n","(Top 20)", sep=" ")

A<-
df %>%
  group_by(AB) %>%
  summarise(n = n()) %>%
  mutate(percent = n/sum(n) * 100) %>%
  arrange(desc(n) ) %>%
  head(20)

AB_type<-
  ggplot(A, aes(reorder(AB, n), percent, fill=AB)) + 
    geom_bar(stat="identity") + 
    geom_text( aes(y=percent, label=comma(sprintf("%1.2f%%", percent))), colour="blue") +
    annotate("text", x=-Inf, y=Inf, label=paste0("Discovered types : ", length(unique(df$AB))), size=4, hjust=-0.1, vjust=1, colour="red") + 
    theme(legend.position="none") +
    labs(title = title_str, x="HLA Type", y="Percent (%)")


dff<-
  df %>%
    select(probeset_id, QScore, X1_QScore, X2_QScore, X1, X2) %>%
    gather( "allele", "type", 5:6 ) 

B<-
  dff %>%
    group_by(type) %>%
    summarise(n = n()) %>%
    mutate(percent = n/sum(n) * 100) %>%
    arrange(desc(n) ) %>%
    head(20)

A_type<-
  ggplot(B, aes(reorder(type, n), percent, fill=type)) + 
    geom_bar(stat="identity") + 
    geom_text( aes(y=percent, label=comma(sprintf("%1.2f%%", percent))), colour="blue") +
    annotate("text", x=-Inf, y=Inf, label=paste0("Discovered types : ", length(unique(dff$type))), size=4, hjust=-0.1, vjust=1, colour="red") + 
    theme(legend.position="none") +
    labs(title = title_str, x="HLA Type", y="Percent (%)")

plot_list = c(plot_list,list(AB_type,A_type))


}
# 
 png("HLA.gene.png", width=1200, height=4400)
# # http://stackoverflow.com/questions/20531579/plotting-multiple-graphs-in-r-ggplot2-and-saving-the-result
# 
 do.call(grid.arrange, c(plot_list, list(ncol=1) ) )
 #do.call(grid.arrange, c(plot_list, list(ncol=nplot)))
 dev.off()

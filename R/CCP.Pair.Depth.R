setwd("/home/adminrig/workspace.min/SNUH_JangInjin_CCP_KJI/BAM")

library(pacman)

p_load(ggplot2,dplyr,tidyr,scales)

df<-read.table("DepthCov", header=T, sep="\t")

df$KJI_WB_Norm<-df$KJI_WB/mean(df$KJI_WB)
df$KJI_Tumor_Norm<-df$KJI_Tumor/mean(df$KJI_Tumor)

head(df)
dff<-
  gather(df, "sample", "norm", 7:8 ) 
head(dff)

png("CCP.AmpliconDP_MeanDP.png")
ggplot(dff, aes(norm, fill=sample)) + 
  geom_histogram(position="identity", alpha=.4, binwidth=1) 
  #xlim(c(-1000, 5000))  
  #facet_grid(sample ~., margins=T)
  #theme(axis.text.x=element_blank())
dev.off()

pool<-
  dff %>%
  group_by(Pool) %>%
  summarise(WB=mean(KJI_WB), Tumor=mean(KJI_Tumor) ) %>%
  gather("sample", "depth", 2:3)

png("CCP.PoolDepth.png")

sample_mean_depth<-
pool %>%
  group_by(sample) %>%
  summarise(mean_dp = mean(depth))

ggplot(pool, aes(as.factor(Pool), depth, fill=as.factor(Pool))) +
  geom_bar(stat="identity", position="dodge") + 
  geom_hline(data=sample_mean_depth, aes(yintercept=mean_dp, colour=mean_dp) ) +
  #geom_text(data=sample_mean_depth, aes(y=mean_dp, label=mean_dp, colour=mean_dp) ) +
  geom_text( aes(y=depth, label=comma(sprintf("%1.2f",depth) ) ) ) + 
  labs(title="Mean Depth per Pool", x="Pool", y="Mean Depth") + 
  facet_grid(.~sample) 

dev.off()

gene_mean<-
df %>%
  filter(Gene == "ABL1") %>%
  group_by(Gene) %>%
  summarise(WB= mean(KJI_WB_Norm), Tumor=mean(KJI_Tumor_Norm)) 
  

df %>%
  filter(Gene == "ABL1") %>%
  ggplot( aes(KJI_WB_Norm, KJI_Tumor_Norm)) + 
  geom_point() + 
  geom_point(data=gene_mean, aes(WB, Tumor), colour="red") + 
  geom_text(data=gene_mean, aes(x=Inf-1, y=0, label=round(WB,2) ) ) +
  geom_text(data=gene_mean, aes(x=0, y=Inf-1, label=round(Tumor,2) ) ) + 
  geom_smooth() + 
  facet_grid(Gene ~., scale="free" )

  gather("sample", "norm", 7:8) %>%
  ggplot( aes() )



# http://stackoverflow.com/questions/33335454/ggplot2-add-facet-grid-panel-means-as-text-and-hline
# library(dplyr) 
# 
# meanData = df %>% group_by(JGene, DGene) %>%
#   summarise(meanCDR = sum(Sum*cdr3_len)/sum(Sum)) %>%
#   left_join(df %>% group_by(JGene) %>%
#               summarise(ypos = 0.9*max(Sum)))
# 
#   
#   ggplot(df,aes(x=cdr3_len, y=Sum)) +
#   geom_vline(data=meanData, aes(xintercept=meanCDR), colour="red", lty=3) +
#   geom_line() +
#   geom_text(data=meanData, 
#             aes(label=round(meanCDR,1), x=40, y=ypos), colour="red",
#             hjust=1) +
#   xlim(c(1,42)) + 
#   facet_grid(JGene~DGene,scales="free_y")


  
gene<-
dff %>% 
  select( Amplicon, Gene, KJI_Tumor, KJI_WB) %>%
#  filter(Gene %in% head( unique(dff$Gene), 10) )  %>%
  gather( "sample", "depth", 3:4)

png("CCP.gene.depth.png", width=4000, height = 4000 )
ggplot(gene, aes(Amplicon, depth, fill=sample) ) +
  #geom_bar(stat="identity") +
  geom_bar(stat="identity", position="identity", alpha=.4) +
  facet_wrap(~Gene, ncol=20, scales="free" ) + 
  theme(axis.text.x=element_blank())

dev.off()
  
  
  
  

#  summary(BRCA2)

png("BRCA1.png", width=1800, height=900)

ggplot(BRCA1, aes(Amplicon, depth, fill=sample)) + 
  geom_bar(stat="identity") + 
  facet_grid(sample~Num,space="free", scales="free_x" ) + 
  theme(axis.text.x=element_blank()) + 
  labs(title="BRCA1")

dev.off()


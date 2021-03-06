library(dplyr)
library(ComplexHeatmap)
library(circlize)
library(colorspace)
library(GetoptLong)


df<-read.table("DepthofCov.txt.GeneLabel", header=T, na.strings = "NaN")
df[is.na(df)]<-0

#str(df)
#View(df)



## mean depth per gene
mean_df_gene <-df %>%
  dplyr::select(-probeset_id) %>%
  group_by(Gene) %>% 
  summarise_each(funs(mean))

#  View(mean_df_gene)



dp <-  mean_df_gene[,-1] 

#names(as.data.frame(mean_df_gene))

rownames(dp)<- mean_df_gene$Gene
dp <- as.matrix(dp)


#dp[dp>1000]<-1000

#head(dp)
#str(dp)
#dimnames(dp)

dpp<-dp
dpp<-sweep(dpp, 2, colMeans(dpp), '/')


## annotation

ha_boxplot=HeatmapAnnotation(boxplot=anno_boxplot(dpp))

mean_dp<-df %>%
  dplyr::select(-probeset_id, -Gene) %>%
  summarise_each(funs(mean))

	#ha_top<-HeatmapAnnotation(df=data.frame(type=substr(colnames(dpp), 1,4)))


	#ha_bottom<-HeatmapAnnotation(
         #                    barplot=anno_barplot(mean_dp, gp=gpar(col="red", fill="green")),
         #                    boxplot=anno_boxplot(dpp, gp=gpar(col="blue")),
	 #		     #violin = anno_density(dpp, type = "line", gp = gpar(fill="green")),
         #                    #heatmap = anno_density(dpp, type = "heatmap"),
         #                    )






ha_bottom<-HeatmapAnnotation(
                             barplot=anno_barplot(mean_dp, gp=gpar(col="red", fill="green")),
                             boxplot=anno_boxplot(dpp, gp=gpar(col="blue")),
                             df=data.frame(type=substr(colnames(dpp), 1,4)),
			     #violin = anno_density(dpp, type = "line", gp = gpar(fill="green")),
                             #heatmap = anno_density(dpp, type = "heatmap"),
			     annotation_height = c(1, 2, 2)
                             )

dpp[dpp>2000]<-2000

## annotation
#png("CCP.MeanDepthPerGene.All.BigSize.png", width=2400, height=3600)
pdf("CCP.MeanDepthPerGene.All.BigSize.MaxDP2K.pdf", width=30, height=40)
Heatmap(dpp, 
        name="CCP",
        km=4,
        #show_row_names = FALSE,
        #show_row_hclust = FALSE,
        #cluster_rows = FALSE, # remove option, to do depth cluster 

        column_title_gp = gpar(fontsize = 20, fontface = "bold"),
#        column_hclust_height = unit(4, "cm"),
        column_dend_height = unit(4, "cm"),
        gap = unit(5, "mm"),

        column_title = "CCP DepthCovergae", 
        column_title_side = "top",
        column_names_side = "top",

#        top_annotation= ha_top,
        top_annotation= ha_bottom,
        top_annotation_height= unit(8, "cm"),

        )

seekViewport("annotation_type")
#grid.text("type", unit(1, "npc") + unit(2, "mm"), 0.5, default.units = "npc", just = "left")
grid.text("Sample Type", 1/100, 8/10, default.units = "npc", just = "left")

seekViewport("annotation_boxplot")
#grid.text("Mean Depth boxplot per Gene", unit(0, "npc") - unit(2, "mm"), 0.5, default.units = "npc", just = "right")
grid.text("Mean Depth boxplot per Gene", 1/100, 9/10, default.units = "npc", just = "left")
seekViewport("annotation_barplot")
grid.text("Mean Depth barplot", 1/100, 9/10, default.units = "npc", just = "left")



dev.off()




## depth per amplicon
Ncol<-ncol(df)
Gene<-df$Gene
mat<-as.matrix( df[,c(-1,-Ncol )] )

mat[mat>200]<-200

#png("Amplicon.png", width=2000, height=24400)
#pdf("Amplicon.pdf", width=30, height=320)
pdf("Amplicon.MaxDP200.pdf", width=30, height=700)
Heatmap(mat, 
        name="CCP", 
        split=Gene,
        show_row_names = FALSE,
        show_row_hclust = FALSE,
        column_hclust_height = unit(8, "cm"),
        #cluster_rows = FALSE, # remove option, to do depth cluster 
        column_title = "CCP DepthCovergae", 
        column_title_side = "top",
        column_names_side = "top",
        column_title_gp = gpar(fontsize = 20, fontface = "bold"),
        gap = unit(20, "mm"),

#        top_annotation= ha_top,
        top_annotation= ha_bottom,
        top_annotation_height= unit(8, "cm"),
        )

seekViewport("annotation_type")
#grid.text("type", unit(1, "npc") + unit(2, "mm"), 0.5, default.units = "npc", just = "left")
grid.text("Sample Type", 1/100, 8/10, default.units = "npc", just = "left")

seekViewport("annotation_boxplot")
#grid.text("Mean Depth boxplot per Gene", unit(0, "npc") - unit(2, "mm"), 0.5, default.units = "npc", just = "right")
grid.text("Mean Depth boxplot per Gene", 1/100, 9/10, default.units = "npc", just = "left")
seekViewport("annotation_barplot")
grid.text("Mean Depth barplot", 1/100, 9/10, default.units = "npc", just = "left")


dev.off()

q()

row_names_gp
# row_hclust_side = "right")
# column_hclust_height = unit(2, "cm"))
# clustering_method_rows = "single")
# row_names_side = "left"
# row_hclust_side = "right", 
# column_names_side = "top"
# column_hclust_side = "bottom"
# row_names_gp = gpar(fontsize = 20))
# 


#################################################################################################################3########################################################3########################################################3
########################################################3########################################################3########################################################3########################################################3
















library(cluster)
pa = pam(dpp, k = 4)


worst<-data.frame(name=names(pa$clustering), cluster=pa$clustering) %>%
  filter(cluster==4) %>%
  dplyr::select(name)

##############################################

worst_gene<-mean_df_gene %>%
  filter( Gene %in% worst$name )
  


dp <-  worst_gene[,-1] 

rownames(dp)<- worst_gene$Gene
dp <- as.matrix(dp)

Heatmap(dp, 
        name="CCP",
        #show_row_names = FALSE,
        #show_row_hclust = FALSE,
        #cluster_rows = FALSE, # remove option, to do depth cluster 
        column_title = "CCP Mean DepthCovergae\n clustger 1", 
        column_title_side = "top",
        column_title_gp = gpar(fontsize = 20, fontface = "bold"),
        bottom_annotation= ha_bottom,
        bottom_annotation_height= unit(2, "cm"),
        #gap = unit(5, "mm"),
)




worst<-data.frame(name=names(pa$clustering), cluster=pa$clustering) %>%
  filter(cluster==2) %>%
  select(name)

##############################################

worst_gene<-mean_df_gene %>%
  filter( Gene %in% worst$name )



dp <-  worst_gene[,-1] 

rownames(dp)<- worst_gene$Gene
dp <- as.matrix(dp)

Heatmap(dp, 
        name="CCP",
        #show_row_names = FALSE,
        #show_row_hclust = FALSE,
        #cluster_rows = FALSE, # remove option, to do depth cluster 
        column_title = "CCP Mean DepthCovergae\n clustger 2", 
        column_title_side = "top",
        column_title_gp = gpar(fontsize = 20, fontface = "bold"),
        bottom_annotation= ha_bottom,
        bottom_annotation_height= unit(2, "cm"),
        #gap = unit(5, "mm"),
)







## depth per amplicon
Ncol<-ncol(df)
mat<-as.matrix( df[,c(-1,-Ncol )] )
mat[mat>1000]<-1000


worst<-data.frame(name=names(pa$clustering), cluster=pa$clustering) %>%
  filter(cluster==2) %>%
  select(name)

##############################################

worst_gene<-mean_df_gene %>%
  filter( Gene %in% worst$name )



dp <-  worst_gene[,-1] 

rownames(dp)<- worst_gene$Gene
dp <- as.matrix(dp)

Heatmap(dp, 
        name="CCP",
        #show_row_names = FALSE,
        #show_row_hclust = FALSE,
        #cluster_rows = FALSE, # remove option, to do depth cluster 
        column_title = "CCP Mean DepthCovergae\n clustger 2", 
        column_title_side = "top",
        column_title_gp = gpar(fontsize = 20, fontface = "bold"),
        bottom_annotation= ha_bottom,
        bottom_annotation_height= unit(2, "cm"),
        #gap = unit(5, "mm"),
)





#get.gpar()
#combined_name




#dimnames(mat)
#str(df)
#View(df)









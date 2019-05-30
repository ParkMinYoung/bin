args <- commandArgs(TRUE)
		
library(ComplexHeatmap)
library(GetoptLong)

#setwd("/home/adminrig/workspace.min/Motie.WES.SomaticAnalysis.CancerTreatmentProfile")
mat = read.table(args[1], header = TRUE,stringsAsFactors=FALSE, sep = "\t")
#colnames(mat)
#mat[1,]
mat[is.na(mat)] = ""
rownames(mat) = mat[, 1]
mat = mat[, -1]
#mat=  mat[, -ncol(mat)]
mat = t(as.matrix(mat))

sample_order = scan("SampleOrder", what = "character")
mat = mat[, sample_order]
#dimnames(mat)
#ncol(mat)
#nrow(mat)

mat_origin = mat
mat = mat[, !apply(mat, 2, function(x) all(grepl("^\\s*$", x)))]


altered = ncol(mat)/ncol(mat_origin)
alteredgene <- mat[!apply(mat, 1, function(x) all(grepl("^\\s*$", x))), ]
gene <- nrow(alteredgene)/nrow(mat)

#table(mat[, "041_NT_TT"])



#type_col = c("AMP" = "red", "HOMDEL"= "blue", "MUT" = "#008000")
type_col = c("MISSENSE" = "yellow", "NONSENSE"= "blue", "FRAMESIFT" = "red", "SPLICE"="purple")
type_name = c("MISSENSE" = "MISSENSE", "NONSENSE"= "NONSENSE", "FRAMESIFT" = "FRAME SIFT", "SPLICE"="SPLICE SITE")


add_oncoprint = function(type, x, y, width, height) {
  if(any(type %in% "")) {
    grid.rect(x, y, width - unit(0.5, "mm"), height - unit(1, "mm"), gp = gpar(col = NA, fill = "#CCCCCC"))
  }
  if(any(type %in% "SPLICE")) {
    grid.rect(x, y, width - unit(0.5, "mm"), height - unit(1, "mm"), gp = gpar(col = NA, fill = type_col["SPLICE"]))
  }
  if(any(type %in% "FRAMESIFT")) {
    grid.rect(x, y, width - unit(0.5, "mm"), height*(1/2), gp = gpar(col = NA, fill = type_col["FRAMESIFT"]))
  }
  if(any(type %in% "NONSENSE")) {
    grid.rect(x, y, width - unit(0.5, "mm"), height*(1/3), gp = gpar(col = NA, fill = type_col["NONSENSE"]))
  }
  if(any(type %in% "MISSENSE")) {
    grid.rect(x, y, width - unit(0.5, "mm"), height*(1/5), gp = gpar(col = NA, fill = type_col["MISSENSE"]))
  }
}

# 
# Missense
# Nonsense
# Frame shift
# Splice sites


#####################################################################
# row annotation which shows percent of mutations in all samples
anno_pct = function(index) {
  n = length(index)
  pct = apply(mat_origin[index, ], 1, function(x) sum(!grepl("^\\s*$", x))/length(x))*100
  pct = paste0(round(pct),"%")
  pushViewport(viewport(xscale = c(0, 1), yscale = c(0.5, n + 0.5)))
  grid.text(pct, x = 1, y = seq_along(index), default.units = "native", just = "right", gp = gpar(fontsize = 10))
  upViewport()
}

ha_pct = HeatmapAnnotation(pct = anno_pct, width = grobWidth(textGrob("100%", gp = gpar(fontsize = 10))), which = "row")



#####################################################################
# row annotation which is a barplot
anno_row_bar = function(index) {
  n = length(index)
  tb = apply(mat[index, ], 1, function(x) {
    x = unlist(strsplit(x, ";"))
    x = x[!grepl("^\\s*$", x)]
    x = sort(x)
    table(x)
  })
  max_count = max(sapply(tb, sum))
  pushViewport(viewport(xscale = c(0, max_count*1.1), yscale = c(0.5, n + 0.5)))
  for(i in seq_along(tb)) {
    if(length(tb[[i]])) {
      x = cumsum(tb[[i]])
      grid.rect(x, i, width = tb[[i]], height = 0.8, default.units = "native", just = "right", gp = gpar(col = NA, fill = type_col[names(tb[[i]])]))
    }
  }
  breaks = grid.pretty(c(0, max_count))
  grid.xaxis(at = breaks, label = breaks, main = FALSE, gp = gpar(fontsize = 10))
  upViewport()
}

ha_row_bar = HeatmapAnnotation(row_bar = anno_row_bar, width = unit(4, "cm"), which = "row")

###################################################################
# column annotation which is also a barplot
anno_column_bar = function(index) {
  n = length(index)
  tb = apply(mat[, index], 2, function(x) {
    x = unlist(strsplit(x, ";"))
    x = x[!grepl("^\\s*$", x)]
    x = sort(x)
    table(x)
  })
  max_count = max(sapply(tb, sum))
  pushViewport(viewport(yscale = c(0, max_count*1.1), xscale = c(0.5, n + 0.5)))
  for(i in seq_along(tb)) {
    if(length(tb[[i]])) {
      y = cumsum(tb[[i]])
      grid.rect(i, y, height = tb[[i]], width = 0.8, default.units = "native", just = "top", gp = gpar(col = NA, fill = type_col[names(tb[[i]])]))
    }
  }
  breaks = grid.pretty(c(0, max_count))
  grid.yaxis(at = breaks, label = breaks, gp = gpar(fontsize = 10))
  upViewport()
}

ha_column_bar = HeatmapAnnotation(df = data.frame(Group = substr(colnames(mat), 0,10)),
#                                  col=list(type=c("Normal"="green", "Tumor"="darkorange")), 
                                  column_bar = anno_column_bar, 
                                  which = "column",
                                  #annotation_height = unit.c(unit(1, "cm"), unit(1, "null"), unit(3, "cm")),
                                  annotation_height = c(1, 2),
)



#####################################################################
# the main matrix
ht = Heatmap(mat, rect_gp = gpar(type = "none"), cell_fun = function(j, i, x, y, width, height, fill) {
  if(grepl("^\\s*$", mat[i, j])) {
    type = ""
  } else {
    type = unique(strsplit(mat[i, j], ";")[[1]])
  }
  #example(setequal)
  if(setequal(type, "MISSENSE")) {
    type = c("MISSENSE", "")
  }
  if(setequal(type, "NONSENSE")) {
    type = c("NONSENSE", "")
  }
  if(setequal(type, "SPLICE")) {
    type = c("SPLICE", "")
  }
  
  add_oncoprint(type, x, y, width, height)
}, row_names_gp = gpar(fontsize = 10), 
show_column_names = TRUE, 
column_names_side = "top",
show_heatmap_legend = FALSE,
top_annotation = ha_column_bar, top_annotation_height = unit(2, "cm"))



ht_list = ha_pct + ht + ha_row_bar

#########################################################
# legend
legend = legendGrob(labels = type_name[names(type_col)], pch = 15, gp = gpar(col = type_col), nrow = 1)

output<-paste0(args[1],".oncoprint.pdf")
pdf(output, width = 10, height = 40)
draw(ht_list, newpage = FALSE, annotation_legend_side = "bottom", 
     annotation_legend_list = list(legend), 
     column_title = qq("Somatic Analysis OncoPrint for Bile Duct Cancer\nAltered in @{ncol(mat)}/@{ncol(mat_origin)} (@{round(altered*100)}% of samples)\nAltered in @{nrow(alteredgene)}/@{nrow(mat)} (@{round(gene*100)}% of genes)"), column_title_gp = gpar(fontsize = 12, fontface = "bold"))


dev.off()
#draw(ht_list)


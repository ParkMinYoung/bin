args <- commandArgs(TRUE)
		                

library(ComplexHeatmap)
library(GetoptLong)

#mat = read.table("OncoPrint.input.txt", header = TRUE,stringsAsFactors=FALSE, sep = "\t")
mat = read.table(args[1], header = TRUE,stringsAsFactors=FALSE, sep = "\t")

#colnames(mat)
#mat[1,]
mat[is.na(mat)] = ""
rownames(mat) = mat[, 1]
mat = mat[, -1]
#mat=  mat[, -ncol(mat)]
mat = t(as.matrix(mat))

#mat = mat[, sample_order]

mat_origin = mat
mat = mat[, !apply(mat, 2, function(x) all(grepl("^\\s*$", x)))]

altered = ncol(mat)/ncol(mat_origin)
alteredgene <- mat[!apply(mat, 1, function(x) all(grepl("^\\s*$", x))), ]
gene <- nrow(alteredgene)/nrow(mat)


alter_fun_list = list(
  background = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"), h-unit(0.5, "mm"), gp = gpar(fill = "#CCCCCC", col = NA))
  },
  SPLICE = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"), h-unit(0.1, "mm"), gp = gpar(fill = "purple", col = NA))
  },
  FRAMESIFT = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"), h-unit(0.8, "mm"), gp = gpar(fill = "red", col = NA))
  },
    NONSENSE = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"), h*0.5, gp = gpar(fill = "#008000", col = NA))
  },
    MISSENSE = function(x, y, w, h) {
    grid.rect(x, y, w-unit(0.5, "mm"), h*0.25, gp = gpar(fill = "yellow", col = NA))
  }
)

col = c("FRAMESIFT" = "red", "SPLICE" = "purple", "MISSENSE" = "yellow", "NONSENSE"="#008000")

#sample_order = scan(paste0(system.file("extdata", package = "ComplexHeatmap"), "/sample_order.txt"), what = "character")

gene_order = as.character( (read.table(file="Gene"))[,1])
sample_order = scan("SampleOrder", what = "character")

#row_gene[!(row_gene %in% gene_order)] 
#gene_order[ grep("RP",gene_order ) ]

#pdf("oncoPrintForPancreaseCancer.pdf", width = 10, height = 80)
output<-paste0(args[1],".oncoprint.AlphaSortGene.pdf")
pdf(output, width = 10, height = 80)

oncoPrint(mat, 
          get_type = function(x) strsplit(x, ";")[[1]],
          alter_fun_list = alter_fun_list, col = col, 
          show_column_names = TRUE,
		  row_order = NULL,
		  column_order = sample_order,
          column_title = qq("OncoPrint for Pancrease Cancer\nAltered in @{ncol(mat)}/@{ncol(mat_origin)} (@{round(altered*100)}% of samples)\nAltered in @{nrow(alteredgene)}/@{nrow(mat)} (@{round(gene*100)}% of genes)"),
          heatmap_legend_param = list(title = "Alternations", at = c("FRAMESIFT", "SPLICE", "NONSENSE", "MISSENSE"), 
            labels = c("FRAMESIFT", "SPLICE","NONSENSE", "MISSENSE")
            )
          )

#qq("OncoPrint for Pancrease Cancer\nAltered in @{ncol(mat)}/@{ncol(mat_origin)} (@{round(altered*100)}% of samples)\nAltered in @{nrow(alteredgene)}/@{nrow(mat)} (@{round(gene*100)}% of genes)")


dev.off()




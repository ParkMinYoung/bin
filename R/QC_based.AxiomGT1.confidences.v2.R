
library(dplyr)
library(tidyr)

df<-read.table("AxiomGT1.confidences.txt", header=TRUE, comment.char = "#", sep="\t")



rownames(df)<-df$probeset_id
df<-df[-1]
dim(df)

out<-apply( df, 1, function(row){ table( cut(row, breaks=c(-1, 0, 0.0005, 0.001, 0.005, 0.01, 0.05, 0.1, 0.15, 1), labels = c( 0, 0.0005, 0.001, 0.005, 0.01, 0.05, 0.1, 0.15, 1)  ))  } )

#out[,1:6]
out<-t(out)
#out[1:6,]

out <- apply( out , 1, function(row){ round( row /sum(row) * 100, 2) } )

out<-t(out)



final<-
out %>% 
  data.frame() %>%
  mutate(probeset_id=rownames(.)) %>% 
  select(probeset_id, 1:X1) %>% 
  mutate(Fail=ifelse(X0.005 > 2 & X0.05 >2, "Y", "N")) 

write.table(final, "QC_based.AxiomGT1.confidences.txt", sep="\t", row.names = FALSE, col.names = TRUE, quote=FALSE)



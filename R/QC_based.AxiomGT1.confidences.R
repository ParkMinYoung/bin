
library(dplyr)
library(tidyr)

df<-read.table("AxiomGT1.confidences.txt", header=TRUE, comment.char = "#", sep="\t")

df1<-
  gather(df, "sample", "conf", 2:dim(df)[2]) %>%
  with( table( list(probeset_id,  cut(conf, breaks=c(-1,0, 0.0005, 0.001, 0.005, 0.01, 0.05, 0.1, 0.15, 1 ))  ))) %>% 
  as.data.frame() %>% 
  rename(marker=X.1, Range=X.2, Count=Freq) %>% 
  group_by(marker) %>% 
  mutate(Percent=round(Count/sum(Count)*100,2), range= paste0( "R", sub(".+,(.+)]", "\\1", Range, perl=TRUE)) ) %>%
  select(marker, range, Percent) %>% 
  spread(range, Percent) %>% 
  mutate(Fail=ifelse(R0.005 > 2 & R0.05 >2, "Y", "N")) 
  

write.table(df1, "QC_based.AxiomGT1.confidences.txt", sep="\t", row.names = FALSE, col.names = TRUE, quote=FALSE)


value_hist <-
function(df, format, max_format){
  
  # format : DP, GQ, ALT_F
  # max_format : 300, 100, 100
  
  theme_set( theme_grey())
  
  #format="DP"
  #max_format=300
  label_format=seq(0,max_format,length.out =21)
  breaks_format=c(-1, label_format)

  select_list = c("Pair", "Match", format, "GenoMatch", "GenoMatchDetail")
  
  
  df %>% 
    select_(.dots = select_list) %>% 
    separate_(format, sep=",", into=c("A", "B")) %>% 
    mutate(
      Seq=as.numeric(gsub(".+_(\\d+)M_.+", "\\1", Pair, perl=T)) * 200000000, 
      SeqGb=factor(Gbp(Seq), levels=c("3 ","5 ","10 ","15 ","20 "), ordered = TRUE),
      A=ifelse(as.numeric(A)>max_format, max_format, as.numeric(A)) ,
      B=ifelse(as.numeric(B)>max_format, max_format, as.numeric(B)),
      A_range = factor( cut(A, breaks = breaks_format, labels = label_format ), 
                        levels = as.character(label_format), ordered = T),
      B_range = factor( cut(B, breaks = breaks_format, labels = label_format ), 
                        levels = as.character(label_format), ordered = T)
          ) %>% 
    select(SeqGb, A, B) %>% 
    gather("Sample", "Value", -1) %>% 
    ggplot(aes(Value,fill=Sample)) + 
    geom_histogram(bins = 30) + 
    facet_grid(SeqGb~Sample) + 
    labs(x=format)
  
}

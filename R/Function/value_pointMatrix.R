value_pointMatrix <-
function(df, format, max_format, cutoff=0){
  
  # format : DP, GQ, ALT_F
  # max_format : 300, 100, 100
  
  theme_set( theme_grey())
  
  #format="DP"
  #max_format=300
  label_format=seq(0,max_format,length.out =21)
  breaks_format=c(-1, label_format)

  select_list = c("Pair", "Match", format, "GenoMatch", "GenoMatchDetail")
  
  
  df_tmp<-
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
    filter(Match != "F") %>% 
    group_by(SeqGb, A_range, B_range, Match) %>% 
    #select(SeqGb, A_range, B_range, Match ) %>% 
    summarise(Count=n()) %>% 
    ungroup() %>% 
    spread(Match, Count) %>% 
    group_by(SeqGb, A_range, B_range) %>% 
    mutate(sum=sum(N,Y, na.rm = T), 
           Conc=ifelse(is.na(Y), 1, Y/sum) )
  
  if( cutoff > 0){
    df_tmp %>% 
      filter( sum >= cutoff) ->df_tmp
  }
  
  df_tmp %>%   
    ggplot( aes( A_range, B_range, col=Conc, size=sum)) + 
    geom_point() + 
    geom_point(data=filter(df_tmp, Conc<0.8), col="red",shape=21, size=3) + 
    facet_wrap(~SeqGb,ncol = 2) + 
    scale_color_gradientn(colours = cols) + 
    theme(axis.text.x = element_text(angle = 90))
}

conc_plot <-
function(conc){

  conc %>% 
    ggplot( aes(A, B, fill=ConcordantRate)) + 
    theme_bw() +
    geom_tile(col="grey") + 
    scale_fill_gradientn(colours=rev(cols)) + 
    geom_text(aes(label=ConcordantRate), col="darkblue", size=4) + 
    theme(axis.text.x = element_text(angle=90),
          legend.position = "bottom")
    
}

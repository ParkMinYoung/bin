
data_status <- function() {
  require(gdata)
  ll()[rev(order(ll()$KB)),]
}


pkg_clean <- function(){
  pacman::p_unload(pacman::p_loaded(), character.only = TRUE)
  .rs.restartR()
}





FunctionDump <-function(funs){
  
  funs_file = paste(funs, "R", sep=".")
  target_dir = "/home/adminrig/src/short_read_assembly/bin/R/Function"
  cmd = paste("mv -f", funs_file, target_dir, sep=" ")
  
  dump(eval(funs), file=funs_file)
  system(cmd)
  #print(cmd) 
}



require(scales)
Kbp <- unit_format(unit = "K", scale = 1e-3, digits = 2)
Mbp <- unit_format(unit = "M", scale = 1e-6, digits = 2)
Gbp <- unit_format(unit = "G", scale = 1e-9, digits = 2)
Pct <- unit_format(unit = "%", scale = 100, digits = 4)



value_down <- function(value,percent=10){
	return( min(value) - min(value)*percent/100  )
}

value_up <- function(value,percent=10){
	return( min(value) + min(value)*percent/100  )
}


require(ggplot2)

min_theme_black<-
theme(   panel.background = element_rect(fill = "black",
                                colour = "lightblue",
                                size = 0.5, linetype = "solid"),
         strip.text.x = element_text(size=12, color="blue",
                                     face="bold.italic"),
         strip.text.y = element_text(size=12, color="red",
                                     face="bold.italic"),
         strip.background = element_rect(colour="black", fill="white", 
                                      size=1.5, linetype="solid"),
         axis.text.x = element_text(face="bold", color="#993333", 
                           size=14, angle=0),
         axis.text.y = element_text(face="bold", color="#993333", 
                           size=14, angle=0),
         axis.title = element_text(face="bold", color="black", 
                           size=16, angle=0),
		 panel.grid.major = element_line(size = 0.5, linetype = 'solid',
					                                 colour = "white"), 
	     panel.grid.minor = element_line(size = 0.25, linetype = 'solid',
					                                   colour = "white")

         
)




show_datatable <- function(df, file_name)
{
  require(DT)
  filename_dt=file_name
  datatable(df,
            extensions = c('Scroller', 'Buttons'),
            options = list(
            #autoWidth = TRUE,
            deferRender = TRUE,
            scrollX = TRUE,
            scrollY = 200,
            scroller = TRUE,
            dom = 'Bfrtip',
            buttons = list('copy',
                       list(extend='excel',filename=filename_dt),
                       list(extend='csv',filename=filename_dt)),
            lengthMenu = c( 10, 15, 20, 100),
            columnDefs = list(list(width = '1000px', targets = "_all", className = 'dt-center')
              )
  
            )
  )

}



#https://stackoverflow.com/questions/36067533/why-is-using-list-critical-for-dots-setnames-uses-in-dplyr

funs_groups_cols<- function (df, funs, grps, cols){

  dots<-
    paste0(funs, "(", cols, ")") %>% as.list 
  
  nms<-
    paste0(cols,"_", funs) %>% as.list 
  
  
  df %>% 
  group_by_( .dots = grps ) %>% 
    summarise_( .dots = setNames(dots, nms) )

}





stat_using_funs <- function(df, funs, round_num=2){
  
  require(purrr)
  require(dplyr)
  # funs <- c("min", "max", "mean")
  funs %>% 
    map( match.fun ) %>% 
    map_dfc( ~ df %>% 
               map_dbl(.x) %>% 
               round(round_num) %>% 
               as.data.frame  
    ) -> sumdf
    
  rownames(sumdf) <- colnames(df)
  colnames(sumdf) <- functionlist
  return(sumdf)
}




add_margins <- function(x){
  
  x<-A
  var<-colnames(x)[1]
  colnames(x)[1] <- "var"

  
  x[,-1] %>% 
    as.matrix() %>% 
    addmargins(.) %>% 
    as.data.frame() -> y

  row.names(y) <- NULL
  
  x<- 
    bind_cols( bind_rows( x[1], data.frame(var="Sum",stringsAsFactors=FALSE)), y) 
  colnames(x)[1] <- var
  return(x)
}




venn <- function(df, key, id){
  
  require(UpSetR)
  
  model <-
    df %>% 
    select_(.dots = c(key, id)) %>% 
    table() %>% 
    as.data.frame.matrix()
  
  #png("Pembro.upset.png", width = 900, height = 900)
  upset(model, sets = names(model)[colSums(model)>0], mb.ratio = c(0.55, 0.45), order.by = "freq", text.scale = 2)
  #dev.off()
}



venn_table <- function(df, key, ID  ){

  require(dplyr)  
  cmd <-paste0("paste(",ID, ", collapse= ':')")

  df %>% 
     group_by_(.dots = key) %>% 
     summarise_( .dots = setNames(cmd, "type")) %>% 
   ungroup() %>% 
   count(type) -> model_count

  show_datatable(model_count, "model_count")
  
}


# create normalization function
normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}


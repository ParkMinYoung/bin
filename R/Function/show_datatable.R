show_datatable <-
function(df, file_name)
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

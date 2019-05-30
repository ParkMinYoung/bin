#http://timelyportfolio.blogspot.kr/2012/04/piggybacking-and-hopefully-publicizing.html
#http://blog.revolutionanalytics.com/2009/11/charting-time-series-as-calendar-heat-maps-in-r.html
#https://www.r-bloggers.com/ggplot2-time-series-heatmaps/


setwd("/home/adminrig/workspace.min/AFFX/Axiom_KORV1.1/Analysis/Analysis.CEL_Info.20161014")

library(pacman)
p_load( dplyr, ggplot2, tidyr, lattice, chron, grid)

df<-read.table("CELfile_Information.Summary.txt", header=T, sep="\t", na.strings="")

#tbl_df(df)
#str(df)

df$time<-as.Date(df$access_time, format = "%Y-%m-%d")


KORV1_1<-
df %>%
  group_by(time) %>%
  summarise(call_rate=mean(call_rate), het_rate=mean(het_rate), DQC=mean(axiom_dishqc_DQC), n=n())
  

$str(KORV1_1)
source("http://blog.revolutionanalytics.com/downloads/calendarHeat.R")
# Plot as calendar heatmap
calendarHeat(KORV1_1$time, KORV1_1$call_rate, 
             varname="KORV1_1 Call Rate")





stock <- "MSFT"
start.date <- "2012-01-01"
end.date <- Sys.Date()
quote <- paste("http://ichart.finance.yahoo.com/table.csv?s=",
               stock,
               "&a=", substr(start.date,6,7),
               "&b=", substr(start.date, 9, 10),
               "&c=", substr(start.date, 1,4), 
               "&d=", substr(end.date,6,7),
               "&e=", substr(end.date, 9, 10),
               "&f=", substr(end.date, 1,4),
               "&g=d&ignore=.csv", sep="")             
stock.data <- read.csv(quote, as.is=TRUE)
stock.data$Date <- as.Date(stock.data$Date)
## Uncomment the next 3 lines to install the developer version of googleVis
# install.packages(c("devtools","RJSONIO", "knitr", "shiny", "httpuv"))
# library(devtools)
# install_github("mages/googleVis")
library(googleVis)
plot( 
  gvisCalendar(data=stock.data, datevar="Date", numvar="Adj.Close",
               options=list(
                 title="Calendar heat map of MSFT adjsuted close",
                 calendar="{cellSize:10,
                                 yearLabel:{fontSize:20, color:'#444444'},
                                 focusedCellColor:{stroke:'red'}}",
                 width=590, height=620),
               chartid="Calendar")
)




KORV1_1<-
  df %>%
  group_by(time) %>%
  summarise(call_rate=mean(call_rate), het_rate=mean(het_rate), DQC=round(mean(axiom_dishqc_DQC), 2), n=n())




plot( 
  gvisCalendar(data=KORV1_1, datevar="time", numvar="DQC",
               options=list(
                 title="Calendar heat map of CR",
                 calendar="{cellSize:10,
                                 yearLabel:{fontSize:20, color:'#444444'},
                                 focusedCellColor:{stroke:'red'}}",
                 width=590, height=620),
               chartid="Calendar")
)




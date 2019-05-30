setwd("/home/adminrig/workspace.min/CMD")
df<-read.table("timePerIP", head=T, sep="\t")

library(ggplot2)
library(dplyr)
library(scales)


df$date<-as.POSIXct(df$date)

## time interval by date
png("TypingTime.png",,width=1200, height =1000)
ggplot(df, aes(date, ip, col=id)) + 
  geom_point() + 
  labs(title="Typing Time Per IP/ID", x="Week", y="IP Address")
#ggplot(df, aes(date, ip, col=id)) + geom_line()
dev.off()




ip_hour_freq <- as.data.frame( table(list(df$ip, cut(df$date, breaks="10 mins"))) )
#data.frame(table(cut(MyDates, breaks = "30 mins")))
colnames(ip_hour_freq)<-c("ip", "date", "count")
#ip_hour_freq$ip<-gsub("211.174.205.", "", ip_hour_freq$ip)
ip_hour_freq$date <- as.POSIXct(ip_hour_freq$date)

## raster
R<-ggplot(ip_hour_freq, aes(date, ip, fill=count)) + geom_raster()

#head(ip_hour_freq)
#ip_hour_freq<-ip_hour_freq %>% filter(count > 0)



#ggplot(ip_hour_freq, aes(date, count, col=ip)) + geom_line() + facet_grid(ip~.)
#ggplot(ip_hour_freq, aes(date, count, col=ip)) + geom_point() + facet_grid(ip~.)
## barplot
png("TypingFreqPerTime.png",width=1200, height =1000)
ggplot(ip_hour_freq, aes(date, count, fill=ip)) + 
  geom_bar(stat="identity") + 
  facet_grid(ip~.) +
  labs(title="Typing Frequency Per IP Address", x="Week", y="Command Typing Count")
dev.off()



ip_hour_freq$day<- as.Date(ip_hour_freq$date)
ip_hour_freq$day_str <- as.factor(ip_hour_freq$day)

ip_hour_freq$time<-as.POSIXct( sprintf('%s %s:%s', Sys.Date(), format(ip_hour_freq$date, '%H:%M'), '00'))

ip_hour_freq$ip<-gsub("211.174.205.", "", ip_hour_freq$ip)

# http://stackoverflow.com/questions/28251267/r-ggplot-group-by-date-and-plot-time-in-the-x-axis-from-the-same-datetime
png("TypingFreqPerDay.png", width=1200, height=1000)
ggplot(ip_hour_freq, aes(x=time, y=count, group=day, col=day))+ 
  geom_line() +
  scale_x_datetime(breaks=date_breaks('1 hour'), labels=date_format('%H:%M')) +
  facet_grid(ip~.) + 
  theme_light() +
  labs(title="Typing Frequency", x="Day", y="Command Typing Count")
dev.off()


# ggplot(ip_hour_freq, aes(x=time, y=count, group=day, col=day_str, size=count))+ geom_point() +
#   scale_x_datetime(breaks=date_breaks('1 hour'), labels=date_format('%H:%M')) +
#   facet_grid(ip~.)






#!/bin/sh

source ~/.bash_function

if [ $# -gt 0 ];then

	NIB_DIR=/home/adminrig/Genome/Chicken/galGal3
	IP=211.174.205.70
	PORT=9001
	
	# server start  
	gfServer start 211.174.205.70 9001 $NIB_DIR/*.nib -log=gfServer_9001_galGal3.log &
 

	sleep 100	
	# query excute

	for i in $@
		do
		gfClient 211.174.205.70 9001 '' $i $i.psl
	done
	
	# server stop
	gfServer stop $IP $PORT

else
	usage "xxx.fa yyy.fa zzz.fa ..."
fi

 

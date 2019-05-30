#!/bin/bash

if [ -f "$1" ] & [ $# -eq 2 ];then

		# excute time : 2018-01-31 14:29:37 : split
		split -l $2 $1 -d -a 3 


		# excute time : 2018-01-31 14:31:29 : make script
		for i in x???; do IGV.batch.sh $i $(ls *bed | grep -e raw -e sort | sort) $i > $i.script.all; done 


		for i in x???.script.all; do /home/adminrig/src/IGV/IGV_2.3.49/igv.sh -b $i; done 



		mkdir Gene.all && mv *.png Gene.all && rm -rf x???*

else
		usage "target_file line_num"
fi


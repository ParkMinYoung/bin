#!/bin/bash

. ~/.bash_function

if [ -f "$1" ];then

		# excute time : 2017-10-16 10:49:34 : space 2 tab
		PlinkOut2Tab.sh $1


		# excute time : 2017-10-16 10:48:54 : tab 2 hethom
		grep all $1.tab | cut -f6,10,13-24,28 | grep -v -w all > $1.table

		rm -rf $1.tab

		# excute time : 2017-10-16 10:53:00 : xlxs
		TAB2XLSX.sh $1.table

else	
		usage "XXX.vareval.report"
fi


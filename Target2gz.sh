#!/bin/sh

LINE=$(perl -le'print "="x80')

echo $LINE
echo "## Target File compressed to gz count : $#"
echo $LINE
echo "## File List ##"
ls -l $@

echo $LINE
echo "Total File Size : "$(ls -l $@ | awk '{s+=$5}END{print s}'| perl -nle'while(s/(\d+)(\d{3})/$1,$2/g){};print')

SUB=/home/adminrig/src/short_read_assembly/bin/sub
GZIP=$(which gzip)

for i in $@
	do 
	echo -e "qsub -N Target2gz $SUB $GZIP $i\nsleep 10"
done | sh
		
#ls $@ |  perl -nle'++$c;`qsub -N Target2gz.$c $SUB $GZIP $_\nsleep 20`'
# gzip -c $i > $i.gz : get commpressed file and preserve original file
# gunzip -l *.gz : get commpressed ratio 
# Target2gz.sh `find -type f | egrep "(trimed|single)" | sort `

echo $LINE

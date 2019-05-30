#!/bin/sh

LINE=$(perl -le'print "="x80')

echo $LINE
echo "## Target File compressed to gz count : $#"
echo $LINE
echo "## File List ##"
ls -l $@

echo $LINE
echo "Total File Size : "$(ls -l $@ | awk '{s+=$5}END{print s}'| perl -nle'while(s/(\d+)(\d{3})/$1,$2/g){};print')

ls $@ |  perl -nle'++$c;`qsub -N Target2xgz.$c ~/src/short_read_assembly/bin/sub gunzip $_\nsleep 20`'
# gzip -c $i > $i.gz : get commpressed file and preserve original file
# gunzip -l *.gz : get commpressed ratio 

echo $LINE

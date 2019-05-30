#!/bin/sh

LINE=$(perl -le'print "="x80')

echo $LINE
echo "## Target File compressed to bz2 count : $#"
echo $LINE
echo "## File List ##"
ls -l $@

echo $LINE
echo "Total File Size : "$(ls -l $@ | awk '{s+=$5}END{print s}'| perl -nle'while(s/(\d+)(\d{3})/$1,$2/g){};print')

ls $@ |  perl -nle'++$c;`qsub -N Target2bz.$c ~/src/short_read_assembly/bin/sub tar cvjf $_.bz2 $_\nsleep 20`'

echo $LINE

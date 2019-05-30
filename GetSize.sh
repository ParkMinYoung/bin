#!/bin/sh

LINE=$(perl -le'print "="x80')

echo $LINE
echo "## Total File count : $#"
echo $LINE
echo "## File List ##"
ls -l $@

echo $LINE
echo "Total File Size : "$(ls -l $@ | awk '{s+=$5}END{print s}'| perl -nle'while(s/(\d+)(\d{3})/$1,$2/g){};print')

echo $LINE

#!/bin/sh

. ~/.bash_function

perl -sle'
BEGIN{
@file = qw/
refFlat.txt.gz
refGene.txt.gz
refLink.txt.gz
refSeqStatus.txt.gz
refSeqSummary.txt.gz
/;

$url = "http://hgdownload.soe.ucsc.edu/goldenPath/mm10/database";
}
map { print "$url/$_" } @file;

' > refgenes.url  


DIR=UCSC.$(date +%Y%m%d)

wget -i refgenes.url -P $DIR -a refgenes.log
#wget -i refgenes.url -P $DIR  -b -a refgenes.log
cd $DIR
for i in *gz; do gunzip $i;done




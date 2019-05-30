#!/bin/sh

. ~/.bash_function

perl -le'
BEGIN{
@file = qw/
snpArrayAffy5.sql
snpArrayAffy5.txt.gz
snpArrayAffy6.sql
snpArrayAffy6.txt.gz
snpArrayAffy6SV.sql
snpArrayAffy6SV.txt.gz
snpArrayAffy250Nsp.sql
snpArrayAffy250Nsp.txt.gz
snpArrayAffy250Sty.sql
snpArrayAffy250Sty.txt.gz
snpArrayIllumina1M.sql
snpArrayIllumina1M.txt.gz
snpArrayIllumina1MRaw.sql
snpArrayIllumina1MRaw.txt.gz
snpArrayIllumina300.sql
snpArrayIllumina300.txt.gz
snpArrayIllumina550.sql
snpArrayIllumina550.txt.gz
snpArrayIllumina650.sql
snpArrayIllumina650.txt.gz
snpArrayIlluminaHuman660W_Quad.sql
snpArrayIlluminaHuman660W_Quad.txt.gz
snpArrayIlluminaHuman660W_QuadRaw.sql
snpArrayIlluminaHuman660W_QuadRaw.txt.gz
snpArrayIlluminaHumanCytoSNP_12.sql
snpArrayIlluminaHumanCytoSNP_12.txt.gz
snpArrayIlluminaHumanCytoSNP_12Raw.sql
snpArrayIlluminaHumanCytoSNP_12Raw.txt.gz
snpArrayIlluminaHumanOmni1_Quad.sql
snpArrayIlluminaHumanOmni1_Quad.txt.gz
snpArrayIlluminaHumanOmni1_QuadRaw.sql
snpArrayIlluminaHumanOmni1_QuadRaw.txt.gz
snpArrayIlluminaHumanOmni1_QuadRaw.txt.gz
/;

$url = "http://hgdownload.soe.ucsc.edu/goldenPath/hg19/database";
}
map { print "$url/$_" } @file;

' > chip.url  


DIR=Chip.$(date +%Y%m%d)

wget -i chip.url -P $DIR -a chip.log

cd $DIR
for i in *gz; do gunzip $i;done






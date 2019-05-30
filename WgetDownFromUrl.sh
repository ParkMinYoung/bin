#!/bin/sh


# wget http://www.bioconductor.org/help/course-materials/2011/CSAMA/
rm -rf index.html

wget $1
perl -snle'if( /href="(.+\.(pdf|pptx?|r|txt|gz|md5|tbi|bam|bai|txt|readme))">?/ ){ $link=$1; $www = $link =~/(http|ftp):/ ? $link : "$l/$link"; print $www } ' -- -l=$1 index.html > downlist

#wget -x -i downlist -b ## backupground
wget -x -i downlist
# curl -O ftp://ftp.ncbi.nih.gov/snp/organisms/cow_9913/VCF/vcf_chr_1.vcf.gz
mv wget-log wget-log.$$ 

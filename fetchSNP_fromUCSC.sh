#!/bin/bash


while read A B C
	do 
	echo "mysql --user=genome --host=genome-mysql.cse.ucsc.edu -A -D hg19 -e 'select * from snp150 where chrom=\"$A\" and chromStart >=$B and chromEnd <=$C' > $1.snp"  
done < $1 | sh 

sed -i -n '2,$'p $1.snp


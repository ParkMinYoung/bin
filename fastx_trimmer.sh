


#!/bin/bash


END_LEN=51
zcat $1 | fastx_trimmer -o $1.$END_LEN.gz -z -t $END_LEN -Q33

# 1x50
# for i in *.fastq;do echo "fastx_trimmer -i $i -o $i.gz -z -t 14 &";done
# 1x36 , -t 14


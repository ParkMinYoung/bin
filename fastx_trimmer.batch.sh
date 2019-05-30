


#!/bin/bash

END=$1
shift

# 1x50

for i in $@;do echo "fastx_trimmer -i $i -o $i.gz -z -t $END &";done
# for i in *.fastq;do echo "fastx_trimmer -i $i -o $i.gz -z -t 14 &";done
# 1x36 , -t 14


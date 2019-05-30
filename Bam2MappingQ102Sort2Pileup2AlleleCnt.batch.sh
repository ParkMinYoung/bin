#!/bin/sh

# $@ : bam file list

for i in $@;do echo "Bam2MappingQ102Sort2Pileup2AlleleCnt.sh $i >& $i.log &";done

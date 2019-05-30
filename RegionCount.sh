#!/bin/bash -x

#$1 = s_1.bam.sorted.bam.pileup.AlleleCnt.var.bed 

# usage 
# sh RegionCount.sh $1 

SURE=/home/adminrig/Genome/SureSelect/SureSelect_All_Exon_G3362_with_names.v2.bed
REF=~/Genome/RefFlat/refFlat.bed


intersectBed -a $1 -b $SURE -wa -u> $1.inRs
intersectBed -a $1 -b $SURE -wa -v> $1.OutRs
wc -l $1 $1.inRs $1.OutRs

intersectBed -a $1.inRs -b $REF -wa -wb > $1.inRs.inGene
intersectBed -a $1.inRs -b $REF -wa -u > $1.inRs.inGene.list
intersectBed -a $1.inRs -b $REF -wa -v > $1.inRs.OutGene.list
wc -l $1.inRs $1.inRs.inGene.list $1.inRs.OutGene.list


intersectBed -a $1.OutRs -b $REF -wa -wb > $1.OutRs.inGene
intersectBed -a $1.OutRs -b $REF -wa -u > $1.OutRs.inGene.list
intersectBed -a $1.OutRs -b $REF -wa -v > $1.OutRs.OutGene.list
wc -l $1.OutRs $1.OutRs.inGene.list $1.OutRs.OutGene.list

## total depth >=30  var rate >= 30%
perl -F'\t' -anle'@a=split " \/ ",$F[3];print if $a[-1] >= 30 & $a[2]>=30' $1.OutRs.inGene > $1.OutRs.inGene.Candi

echo -n "Uniq Candidate list "
cut -f1-4 $1.OutRs.inGene.Candi | sort |uniq > $1.OutRs.inGene.Candi.uniq


## cluster

# find | grep bed$ | perl -nle'/s_\d/;print "qsub -N $& -o $_.log ~/src/short_read_assembly/bin/sub ./RegionCount.sh $_"'


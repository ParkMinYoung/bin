#!/bin/sh 

source ~/.bash_function

IN=$1
Depth=$2
GenotypeQ=$3
SampleCountFilter=$4

DP=${Depth:=10}
GQ=${GenotypeQ:=50}
SCF=${SampleCountFilter:=0}

if [ -f "$IN" ];then
perl -F'\t' -MList::MoreUtils=firstidx,natatime,uniq,all,indexes -MList::Compare -asnle'
if(/^#/){print}
else{
	@info=@F[0..4];
	@data=@F[9..$#F];
	@l=split ":",$F[8];

	$in_DP=firstidx { $_ eq "DP" } @l;
	$in_GQ=firstidx { $_ eq "GQ" } @l;

	@DPs=  map{ ${[split ":", $_]}[$in_DP] } @data;
	@GQs=  map{ ${[split ":", $_]}[$in_GQ] } @data;
	
	$dp=@dp_idx = indexes { $_ >= $d } @DPs;
	$gq=@gq_idx = indexes { $_ >= $q } @GQs;

	$lc = List::Compare->new(\@dp_idx, \@gq_idx);
	$num = $lc->get_intersection;
	print if $num>=$Count;

}'  -- -d=$DP -q=$GQ -Count=$SCF $1

else
        usage "XXX.vcf Depth[10] GQ[50] SampleCountFilter[0]"
fi


########################################## 
# vcf format description
########################################## 

# chr
# pos
# rs
# ref
# var

# per row (x sample count)
# Allele genotype
# number genotype
# depth
# genotype quality
# genotype ref, var count 


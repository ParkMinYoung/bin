#!/bin/sh 

source ~/.bash_function

IN=$1
Depth=$2
GenotypeQ=$3
SampleCountFilter=$4

DP=${Depth:=10}
GQ=${GenotypeQ:=50}
SCF=${SampleCountFilter:=7}

if [ -f "$IN" ];then

perl -F"\t" -MList::Compare -MList::MoreUtils=natatime,indexes,uniq -asnle'print "$_\tDP_pass\tGQ_pass\tBoth_pass" if $.==1;
$line=$_;
@data=@F[5 .. $#F];
$sam=@data/5;
@geno=();
$it = natatime $sam, @data;
while (@vals = $it->()){
	push @geno, [@vals]
}
$dp=@dp_idx = indexes { $_ >= $DP } @{$geno[2]};
$gq=@gq_idx = indexes { $_ >= $GQ } @{$geno[3]};

$lc = List::Compare->new(\@dp_idx, \@gq_idx);
$num = $lc->get_intersection;
if($num>=$Count){
	print "$line\t$dp\t$gq\t$num";
} ' -- -DP=$DP -GQ=$GQ -Count=$SCF $IN

else
	usage "XXX.vcf.tab Depth[10] GQ[50] SampleCountFilter[7]"
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





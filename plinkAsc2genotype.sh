#!/bin/sh

. ~/.bash_function

if [ -f "$1" ];then

DIR=$(dirname $1)
FILE=$(basename $1 .ped)

PLINK=$DIR/$FILE


perl -F'\t' -MList::MoreUtils=natatime -anle'
if($ARGV=~/map$/){
    #($snp) = split "\:", $F[1];
	$snp = $F[1];
    push @snps, $snp;
}elsif($ARGV=~/ped$/){
    if(++$c==1){
        print join "\t", "", @snps;
    }

    @F=split " ", $_;
        
    @genotype=();
    $it = natatime 2, @F[6..$#F];
    while( @val = $it->()){
        $geno = join "", @val;
        if(length($geno)>2){
             $geno=join "\/",@val
        }elsif($geno=~/00/){
             $geno="NN";
        }
        push @genotype, $geno;
	}
	print join "\t", @F[0], @genotype;
    
}' $FILE.map $1 >  $PLINK.Genotype

else
	usage "XXX.ped"
fi



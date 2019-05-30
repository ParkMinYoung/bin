#!/bin/sh

. ~/.bash_function

if [ -f "$1" ];then

DIR=$(dirname $1)
FILE=$(basename $1 .tped)

PLINK=$DIR/$FILE


perl -F'\s' -MList::MoreUtils=natatime -anle'
if($ARGV=~/tfam$/){
    #($snp) = split "\:", $F[1];
	$sam = $F[1];
    push @sam, $sam;
}elsif($ARGV=~/tped$/){
    if(++$c==1){
		print join "\t", qw/Chr BP AFFXID/, @sam;
    }

    @genotype=();
    $it = natatime 2, @F[4..$#F];
    while( @val = $it->()){
        $geno = join "", @val;
        if(length($geno)>2){
             $geno=join "\/",@val
        }elsif($geno=~/00/){
             $geno="NN";
        }
        push @genotype, $geno;
	}
	print join "\t", @F[0,3,1], @genotype;
    
}' $FILE.tfam $1 >  $PLINK.Genotype

else
	usage "XXX.tped"
fi



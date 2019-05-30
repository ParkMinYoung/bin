#!/bin/sh

. ~/.bash_function

if [ -f "$1" ] & [ -d "$2" ];then

Imputation_Info_DIR=/home/adminrig/Genome/1000Genomes/20130502/ChoSunUniv.2015/imputation

RSLIST=$1
Imputation_Info_DIR=$2

DIR=impute2genotype.tmp
if [ ! -d $DIR ];then
mkdir $DIR
fi  


perl -MMin -snle'
if($ARGV=~/rslist/){
    $h{$_}++;
}elsif($ARGV=~/info$/ && /^snp_id/){
	print localtime()."$ARGV";
}elsif($ARGV=~/info$/ && /(rs\d+)/ && $h{$1} ){

    $ARGV=~/(chr\w+?)_/;
    $chr=$1;
    
	$info{$chr}="snp_id rs_id position a0 a1 exp_freq_a1 info certainty type info_type0 concord_type0 r2_type0\n" if !$info{$chr};

    $info{$chr} .= "$_\n";
}

}{ 

map { Write_file($info{$_}, "$dir/$_.info")  } sort keys %info
#map { print join "\n", $_, $info{$_}  } sort keys %info
' -- -dir=$DIR $RSLIST $Imputation_Info_DIR/*info

#' rslist ../chr10*infoi

else
	usage "rslist ../*info"
fi



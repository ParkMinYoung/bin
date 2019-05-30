#!/bin/sh

. ~/.bash_function

if [ -f "$1" ];then

F1=$1
D=$2
G=$3

DP=${D:=10}
GQ=${G:=50}

DIR=concordance.DP$DP.GQ$GQ
IN=1st.vcf

TMP=queue.log
SUB=/home/adminrig/src/short_read_assembly/bin/sub.93

mkdir -p $DIR/$TMP 
ln -s $(readlink -f $F1) $DIR/$IN

cd $DIR




for i in $(head -1000 1st.vcf | grep ^#CHR | cut -f10- | tr "\t" "\n");do echo -e "qsub -N extract -q utl.q -j y -o $TMP/ $SUB $src/vcftools.extract.sample.sh $IN $i $DP $GQ\nsleep 2";done > 01.vcftools.extract

sh 01.vcftools.extract
waiting extract

perl -i.bak -ple's/FORMAT\t.+$/FORMAT\tA/ if /^#CHR/' `find -type f | grep vcf$` 

		
else 
	usage "XXX.vcf DP[10] GQ[50]"
fi


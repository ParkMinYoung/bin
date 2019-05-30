#!/bin/sh

source ~/.bash_function

if [ -f "$1" ] && [ -f "$2" ];then
	for i in `cat $1`
		do for j in `cut -f1 $2`
			do echo bam2subBam.sh $i $j
		done
	done > bam2subBam.batch.sh
	sh bam2subBam.batch.sh

perl -F'\t' -MMin -sanle'BEGIN{%h=h($site,"2,3",1)}
if($h{"$F[0]\t$F[1]"}){
    print "$ARGV\t$_"
}' -- -site=$2 `find chr* | grep AlleleCnt$` > ExtractAlleleCntFromSubBam

perl -F'\t' -anle'$F[0]=~s/:/-/; 
@l=`find $F[0] | grep AlleleCnt\$ | sort | xargs grep $F[2]`;
chomp @l;
map{s/.+(s_\d)\.bam.+Cnt:/$1\t/g;print}@l
' $2 > $2.AlleleCnt

else
	usage "bam.list sites.snp"
fi


# bam.list [1 col]
# 31880N.bam
# 31880T.bam
# 32221N.bam
# 32221T.bam

# sites.snp [3 col]
# chr1:39549989-39550190  chr1    39550090
# chr1:39806412-39806613  chr1    39806513
# chr11:45880245-45880446 chr11   45880346
# chr11:45891967-45892168 chr11   45892068
# chr12:42512743-42512944 chr12   42512844

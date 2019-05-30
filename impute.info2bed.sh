# ls *info | xargs -P20 -n1 impute.info2bed.sh 
perl -F'\s+' -anle'BEGIN{$ARGV[0]=~/(chr\w+?)_/; $chr=$1} print join "\t" , $chr, $F[2]-1, $F[2], $F[1] if $.>1 ' $1 > $1.bed

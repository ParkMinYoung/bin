perl -F'\t' -anle'if(@ARGV){$h{$_}++}else{ if(++$c==1){print}elsif($h{$F[0]}){print} }' $1 $2 > $1.$2
#x00 ClusterSignal.txt > x00.ClusterSignal.txt


#!/bin/sh

. ~/.bash_function
. ~/.perl

if [ $# -ge 2 ];then 

OUT=$1
shift


perl -F'\t' -MMin -asne'
chomp@F;  
 
if(! $file{$ARGV}++ ){
	@head = @F;
}else{
	$row = "$F[0]-$ARGV";
	map { $h{$row}{$head[$_]} = $F[$_] } 1..$#F;
	
}
}{
mmfss("$out", %h)' -- -out=$OUT $@ 


else
	echo "MatrixMerge.sh RNASeq.Merge.count \`find | grep RNASeq.count.txt$\`"
	echo "MatrixMerge.sh MappedReads.Merge \`find | grep MappedReads.txt$\`"
	echo "grep ^Sequence \`find -type f | grep fastqc_data.txt \`| sort  > ReadLength"
	usage "output_prefix xxx yyy [zzz..]"
fi

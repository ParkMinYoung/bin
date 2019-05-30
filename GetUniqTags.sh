#!/bin/sh

. ~/.bash_function

if [ -f "$1" ];then

perl -nle'
s/^\s*//;
@F=split /\s+/, $_;

if($F[7] eq "NONE"){
	print join "\t", @F;
}else{
	$flag = 0;
	$sum = 0;

	@list = split /\|/, $F[7];
	#print "@list ";
	for( $F[0], @list){
		$sum += $out{$_};
	}

	$flag++ if $sum == 0;

	if( $flag ){
		$tag{ $F[0] }++;
		map { $out{$_}++ } @list, $F[0];
		print join "\t", @F;
	}
}
' $1 > $1.UniqTags

else
	echo "plink --file test.plink --r2 --ld-window 999999 --show-tags all --tag-r2 0.8 --tag-kb 1000 --noweb ";
	usage "Plink.tags.list"
fi


## this script is wrong
## must be fixed.
## 20150609


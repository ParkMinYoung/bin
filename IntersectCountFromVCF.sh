#!/bin/sh

. ~/.bash_function

if [ -f "$1" ] & [ -f "$2" ];then


perl -F'\t' -anle'
if(@ARGV){
	if(/^#/){
		print
	}else{
		$F[2]="."; 
		$k=join "\t", @F; 
		push @{$h{$k}}, $ARGV 
	}
}else{
	
	if(!/^#/){
		$F[2]=".";
		$k=join "\t", @F;
		push @{$h{$k}}, $ARGV;
	}
} 
}{ 
map { print join "\t", $_, ( join ";", @{$h{$_}} ) } sort keys %h
' $1 $2 > intersect.vcf
#' extraSNV.3917.Start2End.tab.vcf uniquely.merged.variant.txt.144658.Start2End.tab.vcf > out

wc intersect.vcf
grep -v ^# intersect.vcf | cut -f9 | sort | uniq -c > intersect.vcf.count

cat intersect.vcf.count


SNV.count.sh intersect.vcf
cat SNV.count.txt

else
	usage "XXX.vcf YYY.vcf"
fi


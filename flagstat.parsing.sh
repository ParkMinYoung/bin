#!/bin/sh

source ~/.bash_function

if [ $# -gt 0 ];then

perl -MMin -ne'
if(/^(\d+) \+ \d (.+)\s*\(?/){
	$p="";
	($n,$id)=($1,$2);
	if($id=~/(.+)\s*\((\d+\.\d+)\%/){
#		print "$1,$2,$3,$&\n";
		$p=$2;
		$id=$1;
		$h{$id}{"Percent.$ARGV"}=$p;
	}
#print join "\t", $n,$id,$p,"\n"
	
	$h{$id}{$ARGV}=$n;
}
}{ mmfss("flagstats",%h)' $@

else
	echo "./flagstat.parsing.sh \`find | grep flagstats$\`"
	usage "XXXX.flagstat YYYY.flagstat ZZZZ.flagstat ..."

fi


# 159060650 + 0 in total (QC-passed reads + QC-failed reads)
# 0 + 0 duplicates
# 128670737 + 0 mapped (80.89%:nan%)
# 159060650 + 0 paired in sequencing
# 79530325 + 0 read1
# 79530325 + 0 read2
# 120917628 + 0 properly paired (76.02%:nan%)
# 124983652 + 0 with itself and mate mapped
# 3687085 + 0 singletons (2.32%:nan%)
# 3043173 + 0 with mate mapped to a different chr
# 1830920 + 0 with mate mapped to a different chr (mapQ>=5)

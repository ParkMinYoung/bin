#!/bin/sh

source ~/.bash_function 


if [ -f "$1" ] & [ -f "$2" ];then


DIR=summary.`date +%Y%m%d`
mkdir $DIR 


perl -F'\t' -MMin -ane'
chomp@F;
if(/>>END_MODULE/){
	$flag="";	
}elsif(/>>(Basic Statistics)/){
	$id=$1;
	$id=~s/\s+//g;
	$flag++;
}elsif(/>>(Per .+)\t/){
	$id=$1;
	$id=~s/\s+//g;
	$flag++;
}elsif($flag){
	$file = $ARGV;
	$h{$id}{$F[0]}{$file}=$F[1];
}

}{
	map { %tmp = %{$h{$_}}; mmfsn($_,%tmp); } sort keys %h
' $@ 
#../../KNIH.ExpDirList.20111006.summary set*.txt
#set1.VP02226.R1.ACAGTG.L001.txt

for i in PerbaseGCcontent.txt PerbaseNcontent.txt Perbasesequencecontent.txt Perbasesequencequality.txt PersequenceGCcontent.txt Persequencequalityscores.txt;
	do 
		fastqc.summary.grouping.sh $i
done

mv Per* BasicStatistics.txt $DIR 

else
	usage "../../KNIH.ExpDirList.20111006.summary set*.txt"
fi


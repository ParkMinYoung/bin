#!/bin/sh

source ~/.bash_function 


if [ -f "$1" ] & [ -f "$2" ];then


perl -F'\t' -MMin -ane'
chomp@F;
if($ARGV =~/Alignment/){
	$key = join ".",@F[3,6,5,2],"txt";
	$value = join "\/",@F[0,4,6,2,3];
	$name{$key}=$value;
#print "$key\t$value\n";
}else{
		if(/>>END_MODULE/){
			$flag="";	
		}elsif(/>>(Basic Statistics)/){
			print "$ARGV\n";
			$id=$1;
			$id=~s/\s+//g;
			$flag++;
		}elsif(/>>(Per .+)\t/){
			$id=$1;
			$id=~s/\s+//g;
			$flag++;
		}elsif($flag){
			$file = $name{$ARGV};
			$h{$id}{$F[0]}{$file}=$F[1];
		}
}

}{
	map { %tmp = %{$h{$_}}; mmfsn($_,%tmp); } sort keys %h
' $@ 
#../../KNIH.ExpDirList.20111006.summary set*.txt
#set1.VP02226.R1.ACAGTG.L001.txt


for i in PerbaseGCcontent.txt PerbaseNcontent.txt Perbasesequencecontent.txt Perbasesequencequality.txt PersequenceGCcontent.txt Persequencequalityscores.txt;
	do 
		fastc_data.merge.summary.output.grouping.sh $i
done

else
	usage "../../KNIH.ExpDirList.20111006.summary set*.txt"
fi

## Po1-2.R2.GCCAAT.L005.txt

## 0       batch   batch
## 1       set     set
## 2       L005    L005
## 3       ChoiHaO ChoiHaO
## 4       project project
## 5       ATCACG  ATCACG
## 6       R1      R1
## 7       fastq.gz        bam
## 8       2.8G    6.5G
## 

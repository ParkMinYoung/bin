#!/bin/sh

source ~/.bash_function

if [ -f "$1" ] & [ -f "$2" ];then


perl -F'\t' -anle'
if(@ARGV){
		$mid{$F[0]}=$F[2]
}
else{
	if(++$w==1 || $F[0] =~ /NO/ ){
		print "FCID,Lane,SampleID,SampleRef,Index,Description,Control,Recipe,Operator,SampleProject";
		next
	}
	next if $F[0] !~ /\d/;

	$desc= join ".", "KNIH",@F[4,5,7,8];
	print join ",", "batch",@F[9,1],"hg19",$mid{$F[2]},$desc,"N","R1","MinYoung","KNIH.$F[7]";
}
' $1 $2 > $2.csv 

else
	usage "SolexaMID KNIH.A11.No1.20110915"
fi


#11      Index11 GGCTAC
#12      Index12 CTTGTA
#NO      Tube Name       Index   Lapchip PLT ID  Well    5nM. dilution(2ul)      Set     RunID   Lane
#2       VP03160 2       10.1    20110621        B01     2.0     set1    A10     1
#4       VP05268 4       7.8     20110621        D01     1.1     set1    A10     1
#5       VP02226 5       8.8     20110621        E01     1.5     set1    A10     1
#6       VP04173 6       11.5    20110621        F01     2.6     set1    A10     1


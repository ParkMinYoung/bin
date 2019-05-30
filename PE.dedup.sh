#!/bin/sh
source ~/.bash_function

if [ $# -eq 2 ] && [ -f "$1" ] && [ -f "$2" ];then
FILE1=$1
FILE2=$2

paste $FILE1 $FILE2 | \
sed -n '2~4p' | \
perl -F'\t' -anle'$str=substr($F[0], 0, 14).substr($F[1], 0, 14);
$h{$str}++ }{ 
map{print "$_\t$h{$_}" if $h{$_}>1} keys %h' > $FILE1.dedup


paste $FILE1 $FILE2 | \
perl -F'\t' -MMin -asnle'BEGIN{%h=h($file,1,2);
open $P1,">$p1.rmdup"; 
open $P2,">$p2.rmdup"}
push @p1, $F[0];
push @p2, $F[1];
if($.%4==0){
	$str=substr($p1[1], 0, 14).substr($p2[1], 0, 14);
	if(!$h{$str}){
		print $P1 join "\n",@p1;
		print $P2 join "\n",@p2;
	}
@p1=(); @p2=();
}
}{ close $P1; close $P2' -- -file=$FILE1.dedup -p1=$FILE1 -p2=$FILE2


wc -l $FILE1 $FILE2 $FILE1.rmdup $FILE2.rmdup | \
perl -snle'/(\d+)\s+(.+)/;$h{$2}=$1/4
}{ map { $p1_rmdup="$_.rmdup";print "$_\t$h{$_}\t$h{$p1_rmdup}\t",(1-$h{$p1_rmdup}/$h{$_})*100 } ($p1,$p2)' -- -p1=$FILE1 -p2=$FILE2 > $FILE1.dedup.stat

Q30Trim.sh $FILE1.rmdup $FILE2.rmdup

fastqc $FILE1.rmdup --extract
fastqc $FILE2.rmdup --extract
fastqc $FILE1.rmdup.Q30Trim --extract
fastqc $FILE2.rmdup.Q30Trim --extract

else 
	usage "fastq1 fastq2"
fi


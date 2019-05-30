##!/bin/sh

source ~/.bash_function

if [ -f "$1" ] ;then

#RS=/home/adminrig/Genome/dbSNP/dbSNP135/snp135.txt
RS=/home/adminrig//Genome/dbSNP/dbSNP137/snp137.txt
RS=/home/adminrig//Genome/dbSNP/dbSNP138/snp138.txt
RS=/home/adminrig/Genome/dbSNP/dbSNP142/snp142.txt
perl -F'\t' -anle'
if(@ARGV){
	$h{$F[0]}++
}else{
		print $_ if $h{$F[4]}
}' $1 $RS > $1.output

rs2RefAlt.sh $1.output

perl -F'\t' -anle'if(@ARGV){$h{$F[4]}++}elsif(!$h{$_}){print}' $1.output $1 > $1.NotFound
perl -F'\t' -MMin -alne'$h{$F[11]}++;$h{Total}++}{h1c(%h)' $1.output > $1.output.type.count
#perl -F'\t' -anle'print join "\t", @F[1..3], (join ";",@F[4..$#F])' $1.output > $1.output.bed
perl -F'\t' -anle'print join "\t", @F[1..4]' $1.output > $1.output.bed
cut -f5 $1.output | sort | uniq -c | awk '{print $2,"\t",$1}' | sort -nr -k 2  > $1.output.rs.count
perl -F'\t' -anle'$id="$F[1]:$F[2]-$F[3]";push @{$h{$id}},$F[4]}{ map { $c=@{$h{$_}};print "$_\t$c\t@{$h{$_}}"} sort keys %h' $1.output  > $1.output.pos.count
else
	usage "rslist"
fi


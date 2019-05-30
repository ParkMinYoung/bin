#!/bin/sh

source $HOME/.bash_function

if [ $# != 2 ];then
usage 3.set34.bam.sorted.bam.Q34.nonsyn QualityScore[34]
fi


perl -F'\t' -MList::Util=sum -asnle'@A=qw/A C G T N/; map{$h{$_}=0} @A; @a=split ",",$F[21]; @s=split ",", $F[22]; map{ $h{$a[$_]}++ if $s[$_] >= $q }0..$#s; $c = join "\t", @h{@A}, sum @h{@A}; print "$_\t$c"' -- -q=34 $1 > $1.Q34
perl -F'\t' -MMin -anle'$h{$F[20]}++ }{ hist(%h)' $1.Q34 > $1.Q34.VarDist
perl -F'\t' -MMin -anle'%h=();@n=split ",",$F[12], @c=split ",", $F[13]; map {$h{$n[$_]} = $c[$_]} 0..$#n; $fre = sprintf "%2.1f",$h{$F[5]}/$F[19]*100; $f{$fre}++ }{ histf(%f)' $1.Q34 > $1.Q34.VarPerHist
perl -F'\t' -MMin -anle'%h=();@n=split ",",$F[12], @c=split ",", $F[13]; map {$h{$n[$_]} = $c[$_]} 0..$#n; $fre = sprintf "%2.1f",$h{$F[5]}/$F[19]*100;if($fre >= 0.5 && $h{$F[5]} > 2 ){ print "$_\t$h{$F[5]}\t$fre" }' $1.Q34 | cut -f1-21,24-31 > $1.Q34.VarPerHist.Candi


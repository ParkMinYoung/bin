# excute time : 2017-11-13 14:23:46 : coverage
DOG=/home/adminrig/workspace.krc/20170927_SNU_ChoJeyeol/Alignment/bymin/dogexome.bed.NUM.bed
bedtools coverage -b $1 -a $DOG -hist > $1.Coverage 

bedtools bamtobed -i $1 | bedtools merge -i stdin -c 1  -o count > $1.uniq.bed
bedtools intersect -a $1.uniq.bed -b $DOG -wao > $1.uniq.bed.OvelapTarget.bed


# excute time : 2017-11-13 20:12:38 : idstats
samtools idxstats $1 > $1.idxstats &


# excute time : 2017-11-13 20:22:57 : get Length per chr
perl -F'\t' -anle' $h{$F[0]} += $F[2]-$F[1]+2 if $F[0]!~/NW/ }{ map { print join "\t", $_, $h{$_} } sort {$a<=>$b} keys %h'  $1.uniq.bed > $1.uniq.bed.LenByChr



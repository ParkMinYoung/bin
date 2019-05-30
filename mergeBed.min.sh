sort -k1,1 -k2,3n $1 | \
bedops -p - | \
intersectBed -a $1 -b stdin -wa -wb | \
perl -F'\t' -anle'
next if $F[0]=~/_/;
$F[5]++; # start + 1 

next if $F[5] == $F[6]; # err if 0-based bed in GATK -L option

$k=join "\t", @F[4,5,6]; 
push @{$h{$k}}, $F[3] 
}{ 
	map { print join "\t", $_, (join ";", @{$h{$_}}) } sort keys %h
' | sortBed -i stdin > $1.merged.bed
## created : 1-based bed file 

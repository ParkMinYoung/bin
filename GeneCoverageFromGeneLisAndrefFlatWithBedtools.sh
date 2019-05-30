

GENELIST=$1
grep -w -f $GENELIST refFlat.txt | \
perl -F'\t' -anle'@s=split ",",$F[9]; @e=split ",",$F[10]; map { print join "\t", $F[2],$s[$_],$e[$_],$F[0], $_, $F[3] } 0..$#s; print STDERR join "\t", $F[2], @F[6,7,0], "CDS",$F[3]' > Exon.bed 2> CDS.bed

#grep -w -e COL4A3 -e COL4A4 refFlat.txt | perl -F'\t' -anle'@s=split ",",$F[9]; @e=split ",",$F[10]; map { print join "\t", $F[2],$s[$_],$e[$_],$F[0], $_, $F[3] } 0..$#s; print STDERR join "\t", $F[2], @F[6,7,0], "CDS",$F[3]' > Exon.bed 2> CDS.bed


## get CDS Exon Bed File
bedtools intersect -a Exon.bed -b CDS.bed > CDSExon.bed


## CDS 
/home/adminrig/src/bedtools/bedtools-2.17.0/bin/bedtools coverage -b CDSExon.bed -a Sureselect_V5_Regions.bed  > CDSExon.bed.coverage.bed


perl -F'\t' -MMin -ane'$h{$F[3]}{Total}+=$F[8]; $h{$F[3]}{Cov}+=$F[7] }{ map { $h{$_}{CovRate}= sprintf "%0.2f", $h{$_}{Cov}/$h{$_}{Total}*100 } sort keys %h; mmfss("CDSCoverage",%h)' CDSExon.bed.coverage.bed


## Exon
/home/adminrig/src/bedtools/bedtools-2.17.0/bin/bedtools coverage -b Exon.bed -a Sureselect_V5_Regions.bed  > Exon.bed.coverage.bed


perl -F'\t' -MMin -ane'$h{$F[3]}{Total}+=$F[8]; $h{$F[3]}{Cov}+=$F[7] }{ map { $h{$_}{CovRate}= sprintf "%0.2f", $h{$_}{Cov}/$h{$_}{Total}*100 } sort keys %h; mmfss("ExonCoverage",%h)' Exon.bed.coverage.bed

cat *Coverage.txt > Coverage.txt
TAB2XLSX.sh Coverage.txt



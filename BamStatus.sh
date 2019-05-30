find Sample_* -type f | grep bam$ | perl -MMin -ane'if(/\/(.+).(mergelanes..*).bam$/){ $h{$1}{$2}++ }elsif(/\/(.+)_\w{6,8}_L.+(sort.*).bam$/){ $h{$1}{$2}++ } }{ @col=("sort", "sort.rg", "mergelanes.dedup", "mergelanes.dedup.realign");mmfss_ctitle("bam_matrix", \%h, \@col)'

cat bam_matrix.txt
echo ""

perl -F'\t' -anle' if($.>1){ $k=join "\t", @F[1..$#F]; push @{ $h{$k} }, $F[0] } }{ map { @l=@{$h{$_}}; print join "\t", (@l+0).":", $_, (join ",", @l)   } keys %h ' bam_matrix.txt

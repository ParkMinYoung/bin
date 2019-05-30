
perl -F'\t' -anle'if($.==1){$header=$_;next
}else{ $h{$F[0]}=join "\t",@F[1..$#F]}
}{ print $header;for $i( qw/INDEL SNP/){ map { $k="$i $_";print "$k\t$h{$k}" } ("CDS non-syn", "CDS syn"),qw/Splice ONLY_INTRON UPstream DWstream 5UTR 3UTR NonGenic/ }' region.count.txt


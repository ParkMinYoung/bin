perl -F'\t' -anle'
($peak, @anno)= split ";", @F[3];
$k=join "\t",@F[0..2], $peak;


if(/# Chromo/){
    print join "\t", @F[0..2], "MACS id", "Region", "DetailRegion / Interval Betwen Genes / Codon change / distance to transcript", "transcript ID", "ExonTypeBefore", "Gene", "ExonTypeAfter", "Score";
}elsif( @anno ){
	for $i ( @anno ){
		$i =~ s/\|/\t/g;
		if( $i =~ s/Gene/Gene\t\t\t/ ){
			print join "\t", $k, $i, $F[$#F];
		}elsif( $i =~ s/Intergenic/Intergenic\t/ ){
			print join "\t", $k, $i, "", "\t\t$F[$#F]";
		}else{
			print "$k\t$i\t$F[$#F]"
		}
	}
}' $1 > $1.tab

perl -F'\t' -anle'print if $F[4] =~ /\w+/' $1.tab > $1.tab.bak
rm -rf $1.tab 
mv $1.tab.bak $1.tab

perl -F'\t' -i  -anle'if($.==1){print join "\t", qw/Chrom Start End Width Region DetailRegion Transcript BioType Gene/}else{print join "\t", @F[0..8]} ' $1.tab
perl -F'\t' -anle'$k=join ":", @F[0..3]; if(!$h{$k}++){print}' $1.tab  > $1.tab.uniq


cut -f5  $1.tab | sort | uniq -c | grep -v Effect | awk '{print $2"\t"$1}' >  $1.tab.EffectCount

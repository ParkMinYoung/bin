perl -F'\t' -anle'
BEGIN{
	$delim=";";
}
if(@ARGV){
	$k= join "\t", @F[0..3];
	$k= join "\t", @F[0..3];
	for (@F[4..$#F]){
		($id,$counts) = split ":", $_;
		$h{$k}{$id} = $_ if $counts =~ /\d+/;
	}
}else{
	$k= join "\t", @F[0,1,3,4];
	if(++$c == 1){
		print join "\t", $_, "#GT_0/0", "#GT_0/1", "#GT_1/1", "#GT_ETC";
	}else{
		
		$GT_AA  = $F[43] ? counts($k, $F[43]) : "";
		$GT_AB  = $F[44] ? counts($k, $F[44]) : "";
		$GT_BB  = $F[45] ? counts($k, $F[45]) : "";
		$GT_ETC = $F[47] ? counts($k, $F[47]) : "";

		print join "\t", $_, $GT_AA,$GT_AB,$GT_BB,$GT_ETC;

		sub counts {
			($key, $sample_list) = @_;
			@samples = split $delim, $sample_list;

			@counts= ();
			map { push @counts, $h{$key}{$_} if $h{$key}{$_} } @samples;

			return (join ";", @counts);
		}
	}
}' $1 $2
#merge.vcf.gz.AleleCountPerStrand merge.vcf.sort.annotated.snpeff.dbNSFP2.vcf.out.freq.final.txt.GT
#}' merge.vcf.gz.AleleCountPerStrand merge.vcf.sort.annotated.snpeff.dbNSFP2.vcf.out.freq.final.txt.GT

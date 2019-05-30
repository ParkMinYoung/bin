
find simulation.1/ -type f | grep vcf.concordance.summary$ | xargs grep "# comparable" | \
perl -F'\t' -anle'
BEGIN{
	$type{1} = "SNP";
	$type{2} = "INSERTION";
	$type{3} = "DELETION";
	$type{4} = "SNV";
}

/Hiseq.vcf.DP(\d+).GQ(\d+).vcf.IonProton.vcf.DP\d+.GQ(\d+)/;

$h{$F[0]}++;
$cnt = $h{$F[0]};
$key = join "\t", $1,$2,$3;
$SNV = $type{$cnt};
$h{$key}{$SNV}{Total} = $F[3];
$h{$key}{$SNV}{Mis} = $F[2];
$h{$key}{$SNV}{Noref} = $F[4];
$h{$key}{$SNV}{Dis} = $F[2]/$F[3];

$h{$key}{SNV}{Total} += $F[3];
$h{$key}{SNV}{Mis} += $F[2];
$h{$key}{SNV}{Noref} += $F[4];
$h{$key}{SNV}{Dis} = $h{$key}{SNV}{Mis}/$h{$key}{SNV}{Total};

}{
print join "\t", qw/DP HGQ IGQ Type N_CMP N_MIS P_MIS NOREF/;
for $i ( sort keys %h ){
	for $snp ( sort keys %{$h{$i}} ){
		print join "\t", $i,$snp, $h{$i}{$snp}{Total}, $h{$i}{$snp}{Mis},$h{$i}{$snp}{Dis},$h{$i}{$snp}{Noref};
	}
}' 


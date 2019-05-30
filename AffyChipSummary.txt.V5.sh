
perl -F'\t' -MMin -ane'
chomp@F;
next if /^(#|cel_files)/;
if($ARGV=~/apt-geno-qc.txt$/){
    $h{$F[0]}{"qc-call-rate-all"} = $F[1];
#    $h{$F[0]}{em-cluster-chrX-het-contrast_gender} = $F[5];

#    $F[0]=~/_(\d+)_(\w{3})_(.+)\.CEL/;
    $F[0] =~ /Genomewide\d.0_(.+)\.CEL/;
	$id = $1;

## add line 20150113
	$id =~ s/_(2|3)$//;
## add line

    $h{$F[0]}{id}   = $id;

}else{
    $h{$F[0]}{computed_gender} = $F[1];
    $h{$F[0]}{call_rate} = $F[2];
    $h{$F[0]}{het_rate} = $F[4];

    $h{$F[0]}{"hom_rate"} = $F[6];
    $h{$F[0]}{"em-cluster-chrX-het-contrast_gender"} = $F[16];
    $h{$F[0]}{"em-cluster-chrX-het-contrast_gender_chrX_het_rate"} = $F[17];

}
}{

mmfss("Summary", %h )' ` find Analysis/* -type f | grep -e report.txt$ -e apt-geno-qc.txt$`


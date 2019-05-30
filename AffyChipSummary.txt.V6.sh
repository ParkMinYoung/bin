
perl -F'\t' -MMin -ane'
chomp@F;
next if /^(#|cel_files)/;
if($ARGV=~/apt-geno-qc.txt$/){
    $h{$F[0]}{axiom_dishqc_DQC} = $F[1];
    $h{$F[0]}{apt_geno_qc_gender} = $F[5];

#    $F[0]=~/_(\d+)_(\w{3})_(.+)\.CEL/;
        $F[0]=~/.+_(\w+\d+)_(\w{2,3})_(.+)\.CEL/;
    ($set, $well, $id) = ($1,$2,$3);

## add line 20150113
	$id =~ s/_(2|3)$//;
## add line

    $h{$F[0]}{set}  = "DL$set";
    $h{$F[0]}{well} = $well;
    $h{$F[0]}{id}   = $id;

}else{
#   $h{$F[0]}{computed_gender} = $F[1];
    $h{$F[0]}{call_rate} = $F[2];
    $h{$F[0]}{het_rate} = $F[4];

    $h{$F[0]}{"cn-probe-chrXY-ratio_gender_meanX"} = $F[18];
    $h{$F[0]}{"cn-probe-chrXY-ratio_gender_meanY"} = $F[19];
    $h{$F[0]}{"cn-probe-chrXY-ratio_gender_ratio"} = $F[20];
    $h{$F[0]}{apt_probeset_genotype_gender} = $F[21];

}
}{

mmfss("Summary", %h )' ` find Analysis/* -type f | grep -e report.txt$ -e apt-geno-qc.txt$`


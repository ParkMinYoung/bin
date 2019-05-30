
perl -F'\t' -MMin -ane'
chomp@F;
next if /^(#|cel_files)/;
if($ARGV=~/apt-geno-qc.txt$/){
#next if $F[17] < 0.82;

    $h{$F[0]}{axiom_dishqc_DQC} = $F[17];
    $h{$F[0]}{apt_geno_qc_gender} = $F[26];

#    $F[0]=~/_(\d+)_(\w{3})_(.+)\.CEL/;
# Axiom_031_PNH_BD424_D05.CEL
        $F[0]=~/Axiom_(.+)_(.+)_(\w{3}).CEL/;
        #$F[0]=~/.+_(\w+\d+)_(\w{2,3})_(.+)\.CEL/;
    ($set, $well, $id) = ($1,$3,$2);

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
    $h{$F[0]}{apt_probeset_genotype_gender} = $F[19];
}
}{

@title=qw/id set well axiom_dishqc_DQC apt_geno_qc_gender apt_probeset_genotype_gender call_rate het_rate/;
mmfss_ctitle("Summary", \%h, \@title )' ` find -type f | grep -e report.txt$ -e apt-geno-qc.txt$`


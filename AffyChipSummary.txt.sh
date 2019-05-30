
DefaultDir=Analysis
DIR=${1:-$DefaultDir}


perl -F'\t' -MMin -ane'
chomp@F;
next if /^(#|cel_files)/;
if($ARGV=~/apt-geno-qc.txt$/){
    $h{$F[0]}{axiom_dishqc_DQC} = $F[17];
    $h{$F[0]}{apt_geno_qc_gender} = $F[26];

		#$F[0]=~/.+_(\d{6}|\w+\d+)_(\w{2,3})_(.+)\.CEL/;
        $F[0]=~/.+_(\d{6})_(\w{2,3})_(.+)\.CEL/;
		#Axiom_KORV1_001033_F04_M6_2.CEL
    ($set, $well, $id) = ($1,$2,$3);

## add line 20150113
	$id =~ s/_(2|3|4|5)$//;
## add line

    $h{$F[0]}{set}  = "DL$set";
    $h{$F[0]}{well} = $well;
    $h{$F[0]}{id}   = $id;

}else{
#   $h{$F[0]}{computed_gender} = $F[1];
    $h{$F[0]}{call_rate} = $F[2];
    $h{$F[0]}{het_rate} = $F[4];

    $h{$F[0]}{"cn-probe-chrXY-ratio_gender_meanX"} = $F[16];
    $h{$F[0]}{"cn-probe-chrXY-ratio_gender_meanY"} = $F[17];
    $h{$F[0]}{"cn-probe-chrXY-ratio_gender_ratio"} = $F[18];
    $h{$F[0]}{apt_probeset_genotype_gender} = $F[19];

}
}{

@title=qw/id set well axiom_dishqc_DQC apt_geno_qc_gender apt_probeset_genotype_gender call_rate het_rate cn-probe-chrXY-ratio_gender_meanX cn-probe-chrXY-ratio_gender_meanY cn-probe-chrXY-ratio_gender_ratio/;
mmfss_ctitle("Summary", \%h, \@title )' ` find $DIR | grep -e report.txt$ -e apt-geno-qc.txt$ | sort`

#R CMD BATCH --no-save --no-restore /home/adminrig/src/short_read_assembly/bin/R/AffyChipSummary.R

. ~/.bashrc
. ~/.bash_function

COLLECT_HOME=/home/adminrig/workspace.min/DNALink/AffyChip
OUPUT_DIR=AnalysisResult

#SCRIPT
TAB2XLSX=/home/adminrig/src/short_read_assembly/bin/TAB2XLSX.sh
AFFY_CHIP_SUMMARY_R=/home/adminrig/src/short_read_assembly/bin/R/AffyChipSummary.R

if [ -f "config" ];then
    . config
fi


if [ ! -d "$OUPUT_DIR" ];then
    mkdir $OUPUT_DIR
fi


perl -F'\t' -MMin -ane'
chomp@F;
next if /^(#|cel_files)/;
if($ARGV=~/apt-geno-qc.txt$/){
    $h{$F[0]}{axiom_dishqc_DQC} = $F[17];
    $h{$F[0]}{apt_geno_qc_gender} = $F[26];

#    $F[0]=~/_(\d+)_(\w{3})_(.+)\.CEL/;
	$F[0]=~/.+_(\w+\d+)_(\w{2,3})_(.+)\.CEL/;
    ($set, $well, $id) = ($1,$2,$3);
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
mmfss_ctitle("Summary", \%h, \@title )' ` find  -type f | grep -e report.txt$ -e apt-geno-qc.txt$`


# create Summary.txt.xlsx
$TAB2XLSX Summary.txt

# create *png
R CMD BATCH --no-save --no-restore $AFFY_CHIP_SUMMARY_R 

mv -f Summary.txt* *png $OUPUT_DIR
\cp -f $OUPUT_DIR/* $COLLECT_HOME



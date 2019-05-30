#!/bin/bash

. ~/.bashrc
. ~/.bash_function

COLLECT_HOME=/home/adminrig/workspace.min/DNALink/AffyChip
OUTPUT_DIR=AnalysisResult

#SCRIPT
TAB2XLSX=/home/adminrig/src/short_read_assembly/bin/TAB2XLSX.sh
AFFY_CHIP_SUMMARY_R=/home/adminrig/src/short_read_assembly/bin/R/AffyChipSummary.R
AFFY_CHIP_SCAN_R=/home/adminrig/src/short_read_assembly/bin/R/AffyChipScanStatus.R
AFFY_CHIP_CR_GRID_R=/home/adminrig/src/short_read_assembly/bin/R/CR.grid.R
AFFY_CHIP_CR_WELL_R=/home/adminrig/src/short_read_assembly/bin/R/CR.Well.R
AFFY_CHIP_GENDER_WELL_R=/home/adminrig/src/short_read_assembly/bin/R/GenderMatchWell.R

if [ -f "config" ];then
    source $PWD/config
fi


if [ ! -d "$OUTPUT_DIR" ];then
    mkdir $OUTPUT_DIR
fi

AffyChipSummary.txt.sh

# create Summary.txt.xlsx
$TAB2XLSX Summary.txt

# create *png
R CMD BATCH --no-save --no-restore $AFFY_CHIP_SUMMARY_R 
R CMD BATCH --no-save --norestore "--args $PWD check.sh" $AFFY_CHIP_SCAN_R 
R CMD BATCH --no-save --no-restore $AFFY_CHIP_CR_GRID_R
R CMD BATCH --no-save --no-restore $AFFY_CHIP_CR_WELL_R



## Match
perl -F'\t' -anle'
BEGIN{
$sex{F}="female";
$sex{M}="male"
}
$gender=$F[6];
if(@ARGV){
    $h{$F[0]}=$sex{$F[3]}
}else{
    if(/probeset_id/){
        print "$_\tgender\tgender_match" ;
    }elsif( $h{$F[1]} ){
        $match ="3";
                if( $gender eq "unknown" ){
                $match = 4;
                }elsif( $gender eq $h{$F[1]} ){
                    $match = 1;
                }elsif( $gender ne $h{$F[1]} ){
            $match = 2;
                }
        print "$_\t$h{$F[1]}\t$match" ;
    }
}' ClinicalInfo Summary.txt  > Summary.Gender.txt

/home/adminrig/src/short_read_assembly/bin/SummaryParsing.CountPerSet.sh Summary.txt

if [ -f "ClinicalInfo" ] & [ -f "Summary.Gender.txt" ];then

TAB2XLSX.sh Summary.Gender.txt
R CMD BATCH --no-save --no-restore $AFFY_CHIP_GENDER_WELL_R

fi


#rm -rf *.Rout
rm -rf $OUTPUT_DIR/Summary*
\mv -f Summary* *.png $OUTPUT_DIR
\cp -f $OUTPUT_DIR/*.png $OUTPUT_DIR/Summary.txt $OUTPUT_DIR/Summary*xlsx $COLLECT_HOME



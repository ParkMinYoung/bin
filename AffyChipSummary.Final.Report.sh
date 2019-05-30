. ~/.bashrc
. ~/.bash_function

COLLECT_HOME=/home/adminrig/workspace.min/DNALink/AffyChip
OUPUT_DIR=AnalysisResult

#SCRIPT
TAB2XLSX=/home/adminrig/src/short_read_assembly/bin/TAB2XLSX.sh
AFFY_CHIP_SUMMARY_R=/home/adminrig/src/short_read_assembly/bin/R/AffyChipSummary.R
AFFY_CHIP_SCAN_R=/home/adminrig/src/short_read_assembly/bin/R/AffyChipScanStatus.R
AFFY_CHIP_CR_GRID_R=/home/adminrig/src/short_read_assembly/bin/R/CR.grid.R

if [ -f "config" ];then
    . config
fi


if [ ! -d "$OUPUT_DIR" ];then
    mkdir $OUPUT_DIR
fi



# create Summary.txt.xlsx
$TAB2XLSX Summary.txt

# create *png
R CMD BATCH --no-save --no-restore $AFFY_CHIP_SUMMARY_R 
R CMD BATCH --no-save --no-restore $AFFY_CHIP_CR_GRID_R

mv -f Summary.txt* *png $OUPUT_DIR
\cp -f $OUPUT_DIR/* $COLLECT_HOME


R CMD BATCH --no-save --norestore '--args $PWD check.sh' $AFFY_CHIP_SCAN_R 

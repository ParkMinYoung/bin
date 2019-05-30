#!/bin/sh

. ~/.bash_function 
## Excutable File
BIN=/home/adminrig/src/short_read_assembly/bin
PLINK_SPLIT=$BIN/plink.SplitByChr.SGE.sh
SHAPEIT_SCRIPT=$BIN/shapeit.SGE.sh
IMPUTE2_SCRIPT=$BIN/impute2.SGE.sh
IMPUTE2_SUBSCRIPT=$BIN/impute2.analysis.SGE.sh
LOG_SCRIT=$BIN/date.SGE.sh

## File
RM_DupMarker=/home/adminrig/workspace.min/AFFX/untested_library_files/KOR.RemoveMarker



if [ -f "$1.bim" ] ;then

		PLINK=$1
		#PLINK=AxiomGT1.calls.txt.extract.plink_fwd.gender
		OUT=step1.RM-redun-Marker


		## QC 1 : remove redundant marker
		/home/adminrig/src/PLINK/plink-1.09-x86_64/plink --bfile $PLINK --exclude $RM_DupMarker --make-bed --out $OUT --allow-no-sex --threads 10
		#for i in $PLINK.*;do ln -s $i $OUT.${i##*.}; done
		qsub -N plink $LOG_SCRIT "plink" "remove dup marker" plink


		## split plink by chr
		JID=`qsub -N SplitByChr -terse -e $TMP_DIR/SplitByChr -t 1-22 $PLINK_SPLIT $OUT`
		JID=$(echo $JID | cut -d. -f1)
		qsub -N log -hold_jid $JID $LOG_SCRIT "plink" "plink split" $JID

		## shapeit analysis
		JID=`qsub -N shapeit -hold_jid_ad $JID -terse -e $TMP_DIR/shapeit -t 1-22 $SHAPEIT_SCRIPT`
		JID=$(echo $JID | cut -d. -f1)
		qsub -N log -hold_jid $JID $LOG_SCRIT "shapeit" "shapeit analysis" $JID

		[ ! -d "$BED_DIR" ] && mkdir $BED_DIR

		## impute2 analysis
		JID=`qsub -N impute2 -hold_jid_ad $JID -terse -o $TMP_DIR/impute2 -e $TMP_DIR/impute2 -t 1-22 $IMPUTE2_SCRIPT`
		JID=$(echo $JID | cut -d. -f1)
		qsub -N log -sync y -hold_jid $JID $LOG_SCRIT "impute2" "imputation analysis" $JID

		## manual 
		#  qsub -N impute2  -terse -o $TMP_DIR/impute2 -e $TMP_DIR/impute2 -t 1-22 $IMPUTE2_SCRIPT
else
		usage "PLINK"
fi




#qsub -N wait -hold_jid $JID date.SGE.sh "plink-shapeit" "array" $JID
#qsub -N wait -sync y -hold_jid $JID date.SGE.sh

## shapeit check
#JID=`qsub -N shapeit_check -terse -t 1-22 shapeit.Check.SGE.sh`
#JID=$(echo $JID | cut -d. -f1)
#qsub -N wait -hold_jid $JID ./date.SGE.sh "shapeit" "shapeit check" $JID

## shapeit analysis
#JID=`qsub -N shapeit -terse -t 1-22 shapeit.SGE.sh`
#JID=$(echo $JID | cut -d. -f1)
#qsub -N wait -hold_jid $JID date.SGE.sh "shapeit" "shapeit analysis" $JID


#!/bin/bash

. ~/.bash_function

if [ -f "$1" ];then

###########################################################################################################
## step 1: setting 
###########################################################################################################

## log script
LOG_SCRIT=~/src/short_read_assembly/bin/date.SGE.sh
 
## cel file path
CEL_DIR=$PWD

## output dir path
Analysis=Simulation

## config file path
if [ ! -f "config" ];then

	#Config=/home/adminrig/workspace.min/AFFX/Axiom_KORV1.0/config
	Config=/home/adminrig/workspace.min/AFFX/Axiom_KORV1.1/config
	echo "setting config file : $Config"
else
	Config=config
fi


## main script
APT=/home/adminrig/src/short_read_assembly/bin/SGE.APT_Batch.sh

## For KORV1_1 : 20170309 
if [ -f "$2" ];then
	APT=$2
fi


plink2=/home/adminrig/src/PLINK/plink-1.09-x86_64/plink
Freq=/home/adminrig/workspace.pyg/1000genome/1000genome_asian_kchip1.0_frequency.input.txt
KOR1_0=/home/adminrig/workspace.pyg/GWAS/annotation/common/1.0vs1000/1.0

## argument
CEL_MATRIX=$1


###########################################################################################################
## step 2: Structure setting 
###########################################################################################################
#rm -rf $Analysis

perl -F'\t' -asnle'if($.==1){@header=@F}else{ map { push @{ $h{$header[$_]}{$F[$_]} }, $F[0] } 1..$#F } }{ for $batch ( @header ){  map { $dir="$cwd/$anlaysis/$batch/$_"; print "mkdir -p $dir; (cd $CEL_DIR && ls @{ $h{$batch}{$_} } | xargs -n 100 -i ln {} $dir)" } sort keys %{ $h{$batch} } } ' -- -CEL_DIR=$CEL_DIR -cwd=$PWD -anlaysis=$Analysis $CEL_MATRIX | sh


## list dir paths will bed excuted
find $Analysis -maxdepth 2 -mindepth 2 -type d | sort > Target_Dir_List






###########################################################################################################
## step 3: APT using SGE
###########################################################################################################

rm -rf TMP
TMP=TMP
[ ! -d $TMP ] && mkdir $TMP

TASK=$(wc -l Target_Dir_List)
T=( $TASK )

JID=$(qsub -N APT-geno -j y -e $TMP -o $TMP -t 1-${T[0]} -terse $APT Target_Dir_List $Config)

JID=$(echo $JID | cut -d. -f1)
qsub -N log -sync y -hold_jid $JID $LOG_SCRIT "APT" "genotyping using SGE" $JID "Extra Comment ....."






###########################################################################################################
## step 4: Summary per Batch
###########################################################################################################
MainDIR=$PWD
BATCH=$(find $Analysis -maxdepth 1 -mindepth 1 -type d)
#while read i;do (cd $i && AffyChipSummary.txt.sh $PWD );done < Target_Dir_List

for i in $BATCH
do
		cd $i 
       
		rm -rf Summary.txt

		Summary=$(find -name "Summary.txt" | sort | sed 's/\.\///' | tr "\n" " ")
		Label=$(find -name "Summary.txt" | sort | xargs -i dirname {} | sed 's/\.\///' | tr "\n" " ")


		AddRow.sh -o Summary.txt -f "$Summary" -l "$Label"
        sed -i  '1s/LABEL/batch/' Summary.txt

        # make batch review png : Summary.txt.SummaryReview.png 
        R CMD BATCH --no-save --no-restore '--args Summary.txt' /home/adminrig/src/short_read_assembly/bin/R/Summary.Batch.Review.small.R
        

        find -name "AxiomGT1.calls.txt.extract.plink_fwd.gender.bim" | sort | sed 's/\.bim//' > folder.list
        
		
		find | grep combine.txt | xargs rm
		
		while read line
        do
        	CWD=$PWD
        	cd $(dirname $line)
        
	        line=$(basename $line)
        
    	    plink --bfile $line --extract $KOR1_0 --make-bed --out extractM --noweb
        	plink --bfile ./extractM --hardy --out ./$line.hardy --noweb
        
	        grep -v "AFF" ./$line.hardy.hwe | sed '1d' | awk '{print $1"\t"$2"\t"$4"\t"$5"\t"$6}' | awk -F "/" '{print $1"\t"$2"\t"$3}' > ./$line.txt
    	    paste ./$line.txt $Freq | awk '$2==$9' | awk '$3!=$10' > ./diff
        	paste ./$line.txt $Freq | awk '$2==$9' | awk '$3==$10' > ./same
        
	        awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"($5+$6+$7)*2"\t"$9"\t"$10"\t"$11"\t"$12"\t"$13"\t"$14"\t"($12+$13+$14)*2}' diff > 1
    	    awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"($5+$6+$7)*2"\t"$9"\t"$10"\t"$11"\t"$12"\t"$13"\t"$14"\t"($12+$13+$14)*2}' same > 2
        
        	rm -rf diff same
	        mv 1 diff
    	    mv 2 same
        
        	perl /home/adminrig/workspace.pyg/script/compair_frequency.pl
	        cat > combine.txt same_frq.txt diff_frq.txt

			SNPolisher.sh $PWD
    	    cd $CWD

        done < folder.list
		
		
        # make combine.txt
        for i in `find | grep combine.txt$`; do AddHeader.noheader.sh $i $i.head Chip TG; done 
        AddRow.sh -o combine.txt  -f "$(find | grep head$ | sort | tr "\n" " ")" -l "$( find | grep head$ | sort | replace "/Analysis/combine.txt.head"  "" | sed 's/\.\///g' | tr "\n" " " )"
		
		# make Ps.performance.txt
		Ps.performance.Merge.sh `find | grep ce.txt$ | sort`

		cd $MainDIR

done


(cd $Analysis && find | grep w.png$ | perl -nle'/\/(\w+)\/Sum/; print "cp $_ $1.png"' | sh)



###########################################################################################################
## step 5: To do
###########################################################################################################

else
	usage "CEL_MATRIX [ /home/adminrig/src/short_read_assembly/bin/SGE.APT_Batch.KORV1_1.sh ]"
fi





   


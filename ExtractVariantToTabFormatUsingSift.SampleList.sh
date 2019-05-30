#!/bin/bash

. ~/.bash_function

if [ -f "$1" ] && [ $# -ge 3 ];
then 

	snpsift='java -Xmx32g -jar  /home/adminrig/src/SNPEFF/snpEff_4_3/SnpSift.jar'

	VCF=$1
	shift
	Group=$1
	shift
	
	for i in $@; 
		do
		stringGT="$stringGT GEN[$i].GT";
	done

	for i in $@; 
		do
		stringDP="$stringDP GEN[$i].DP";
	done

	for i in $@; 
		do
		stringAD="$stringAD GEN[$i].AD";
	done
	



	cat $VCF |  $snpsift extractFields  -s "," -e "." - CHROM POS ID REF ALT $stringGT $stringDP $stringAD ANN[*].EFFECT ANN[*].IMPACT ANN[*].GENE ANN[*].GENEID ANN[*].FEATURE ANN[*].FEATUREID ANN[*].BIOTYPE ANN[*].RANK ANN[*].HGVS_C ANN[*].HGVS_P ANN[*].CDNA_POS ANN[*].CDNA_LEN ANN[*].CDS_POS ANN[*].CDS_LEN ANN[*].AA_POS ANN[*].AA_LEN ANN[*].DISTANCE > $VCF.$Group.tab
 
	snpeff_reheader.sh $VCF.$Group.tab

else

cat << EOF

============================================================

${BLUE}inputVCF [GroupID]SP_100 [Samplist]SPNT_100 SPTT_100 SPX0_100 SPX1_100 SPX2_100${NORM}

============================================================
EOF


	usage "VCF Group[Group] Samplist[A B C D...]"

fi



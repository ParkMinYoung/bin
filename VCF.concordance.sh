#!/bin/sh

#F1=./1st/Call.snp.raw.vcf
#F2=./2nd/Call.snp.raw.vcf

F1=$1
F2=$2

mkdir -p concordance/{1st,2nd}
ln -s $(readlink -f $F1) concordance/1st.vcf
ln -s $(readlink -f $F2) concordance/2nd.vcf

cd concordance


#vcftools --vcf 1st.vcf --indv 17 --out 1st/17 --recode
for i in $(head -1000 1st.vcf | grep ^#CHR | cut -f10- | tr "\t" "\n");do vcftools --vcf 1st.vcf --indv $i --remove-filtered-all --minGQ 90 --minDP 10 --maxDP 10000 --out 1st/$i --recode ;done >& 1st.log
for i in $(head -1000 2nd.vcf | grep ^#CHR | cut -f10- | tr "\t" "\n");do vcftools --vcf 2nd.vcf --indv $i --remove-filtered-all --minGQ 90 --minDP 10 --maxDP 10000 --out 2nd/$i --recode ;done >& 2nd.log

perl -i.bak -ple's/FORMAT\t.+$/FORMAT\tA/ if /^#CHR/' `find 1st 2nd -type f | grep vcf$`

 for i in $(find 1st -type f | grep vcf$)
	do 
	for j in $(find 2nd -type f | grep vcf$)
		do 
		I=$(basename $i .recode.vcf)
		J=$(basename $j .recode.vcf)
		
		F="compare/$I---$J"
		OUT=$F/$I---$J
		mkdir -p $F
		
		echo "`date` start $I $J"
		vcftools --vcf $i --diff $j --diff-site-discordance --diff-indv-discordance --diff-discordance-matrix --remove-indels --remove-filtered-all --minGQ 90 --minDP 10 --maxDP 10000 --out $OUT --bed /home/adminrig/Genome/SureSelect/SureSelect_All_Exon_50mb_with_annotation_hg19_bed.exceptChrUn.merged.NumChr.bed >& /dev/null
		

	done 
done


grep ^A `find compare/ | grep indv$` | sort -nr -k4,4 > Concordance


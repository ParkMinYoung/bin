#!/bin/bash

. ~/.bash_function


GOI=${2:-"GOI"}

if [ -f "$1" ] && [ -f "$GOI" ]; then


		# execute time : 2019-02-25 21:08:57 : link
		ln -s $1 ./


		# execute time : 2019-02-25 21:14:10 : create vcf by gene id
		snpeff_extract_genelist.sh $1 $GOI 


		# execute time : 2019-02-25 21:14:10 : create vcf by gene id
		snpsift="java -Xmx512g -jar /home/adminrig/src/SNPEFF/snpEff_4_2/SnpSift.jar"


		if [ $(grep -v ^$ $GOI | wc -l) -gt 1 ]; then

			$snpsift split -j $(parallel -k -a $GOI echo {}.vcf  | tr "\n" " ") | vcf-sort -c -t ./ > GOI.vcf

		else
			
			cp $(parallel --no-run-if-empty -k -a $GOI echo {}.vcf  | tr "\n" " ") GOI.vcf

		fi


		# execute time : 2019-02-25 21:14:10 : cleanup vcf by gene 
		mkdir byGene && mv $(parallel --no-run-if-empty -k -a $GOI echo {}.vcf  | tr "\n" " ") byGene


		# execute time : 2019-02-25 21:27:26 : 
		cat GOI.vcf | $snpsift filter "(ANN[*].IMPACT has 'HIGH') || (ANN[*].IMPACT has 'MODERATE') " > GOI.vcf.filter.vcf


		# execute time : 2019-02-25 21:37:27 : get info
		#cat GOI.vcf.filter.vcf | $snpsift extractFields -s "," -e "." - CHROM POS ID REF ALT AC AF DP VARTYPE "ANN[*].IMPACT" "ANN[*].EFFECT" "ANN[*].HGVS_C" "ANN[*].HGVS_P" "ANN[*].CDNA_POS" "ANN[*].CDS_POS" "ANN[*].CDNA_LEN" "ANN[*].CDS_LEN" "ANN[*].AA_LEN" > GOI.vcf.filter.vcf.info


		# execute time : 2019-02-25 21:37:57 : get geno
		#cat GOI.vcf.filter.vcf | $snpsift extractFields - GEN[*].GT > GOI.vcf.filter.vcf.geno


		# execute time : 2019-02-25 21:41:26 : reheader
		#AddHeader.sh GOI.vcf.filter.vcf.geno GOI.vcf.filter.vcf.geno.reheader $(grep ^#C  GOI.vcf | cut -f10-)



		# execute time : 2019-02-25 22:01:57 : create vcf per sample (using GATK3.selectvariants.sh GOI.vcf.filter.vcf SPX0_276)
		VCF2EachSamplesVCF.sh GOI.vcf.filter.vcf 


		# execute time : 2019-02-25 22:22:12 : convert vcf to tab
		parallel --bar -k VCF2TAB.sh ::: $(find -type f | grep vcf$ | grep -v -e GOI -e byGene) 


		# execute time : 2019-02-25 22:33:49 : reheader (remove #(GEN.+|ANN.+))
		parallel snpeff_reheader.sh ::: *.tab 


		# execute time : 2019-02-25 22:35:44 : create Genotype file using *vcf.tab files
		AddRow.w.sh Genotype '(.+).vcf.tab' ID $(ls *.tab.header)  | grep Add | sh  


		# execute time : 2019-02-25 22:41:31 : alternative count >= 1 
		tblmutate -e '$AC > 0' -l GOI Genotype > Genotype.GOI_mut


		# execute time : 2019-02-26 15:36:05 : include unique one SNV on each line and add id list and number of samples # step1
		creat only unSNVs information line by line
		_addKeyCol.sh Genotype.GOI_mut "1,2,3,4,5,9,10,11,12,13,14,15,16,17,18" key "|"  | datamash --sort -H  -g 24 collapse 22 count 22  |hsort - -k3,3 -nr | tr "|" "\t" > Genotype.GOI_mut.count


		# execute time : 2019-02-26 15:38:38 : include unique one SNV on each line and add id list and number of samples # step2
		AddHeader.sh Genotype.GOI_mut.count Genotype.Count $(head -1 Genotype.GOI_mut | cut  -f1,2,3,4,5,9,10,11,12,13,14,15,16,17,18) Samples NumOfSamp

		# execute time : 2019-03-04 16:24:11 : 
		ln -s Genotype.GOI_mut SNVs.bySample


		# execute time : 2019-03-04 16:24:26 : 
		ln -s Genotype.Count SNVs.byVars


		# execute time : 2019-03-04 16:33:00 : make xlsx
		#TABList2XLSX.v2.sh "1..23" SNVs.bySample SNVs.byVars 


		# execute time : 2019-03-04 16:33:21 : rename
		#mv TABList2.xlsx APC.xlsx 

else
	echo -e "\n\n$0 904.selectsample.snpeff.dbNSFP.vartype.gwas.vcf GOI"	
	usage "XXX.vcf [GOI]"

fi

